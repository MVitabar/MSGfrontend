import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/message.dart';
import '../config/app_config.dart';
import 'chat_service.dart';

/// Wrapper para manejar tanto File como XFile
class WebFileWrapper {
  final dynamic file; // File o XFile
  final bool isWebFile;

  WebFileWrapper(this.file, this.isWebFile);

  String get name => isWebFile ? (file as XFile).name : (file as File).path.split('/').last;
  Future<int> get length async {
    if (isWebFile) {
      return (await (file as XFile).readAsBytes()).length;
    } else {
      return (file as File).lengthSync();
    }
  }

  Future<List<int>> readAsBytes() async {
    if (isWebFile) {
      return (file as XFile).readAsBytes();
    } else {
      return (file as File).readAsBytes();
    }
  }
}

class MediaService {
  static const String baseUrl = AppConfig.baseUrl;
  final ImagePicker _imagePicker = ImagePicker();

  /// Solicitar permisos necesarios
  Future<bool> requestPermissions() async {
    try {
      // En web no necesitamos permisos del sistema - el navegador los maneja
      if (kIsWeb) {
        print('🌐 Plataforma web detectada - permisos del navegador manejados automáticamente');
        return true;
      }

      // Solicitar permisos de cámara, almacenamiento y micrófono en móvil/desktop
      final cameraPermission = await Permission.camera.request();
      final storagePermission = await Permission.storage.request();
      final audioPermission = await Permission.microphone.request();

      return cameraPermission.isGranted &&
             storagePermission.isGranted &&
             audioPermission.isGranted;
    } catch (e) {
      print('❌ Error solicitando permisos: $e');
      return false;
    }
  }

  /// Seleccionar imagen desde cámara o galería (web-compatible)
  Future<File?> pickImage({bool fromCamera = false}) async {
    try {
      final hasPermission = await requestPermissions();
      if (!hasPermission) {
        print('❌ Permisos denegados para acceder a imágenes');
        return null;
      }

      final XFile? image = await _imagePicker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        print('✅ Imagen seleccionada: ${image.path}');
        return File(image.path);
      }

      print('⚠️ No se seleccionó ninguna imagen');
      return null;
    } catch (e) {
      print('❌ Error seleccionando imagen: $e');
      return null;
    }
  }

  /// Seleccionar video desde cámara o galería (web-compatible)
  Future<File?> pickVideo({bool fromCamera = false}) async {
    try {
      final hasPermission = await requestPermissions();
      if (!hasPermission) {
        print('❌ Permisos denegados para acceder a videos');
        return null;
      }

      final XFile? video = await _imagePicker.pickVideo(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxDuration: const Duration(minutes: 10),
      );

      if (video != null) {
        print('✅ Video seleccionado: ${video.path}');
        return File(video.path);
      }

      print('⚠️ No se seleccionó ningún video');
      return null;
    } catch (e) {
      print('❌ Error seleccionando video: $e');
      return null;
    }
  }

  /// Seleccionar archivo general (documentos, audio, etc.)
  Future<File?> pickFile({List<String>? allowedExtensions}) async {
    try {
      final hasPermission = await requestPermissions();
      if (!hasPermission) {
        print('❌ Permisos denegados para acceder a archivos');
        return null;
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        print('✅ Archivo seleccionado: ${file.path}');
        return file;
      }

      print('⚠️ No se seleccionó ningún archivo');
      return null;
    } catch (e) {
      print('❌ Error seleccionando archivo: $e');
      return null;
    }
  }

  /// Grabar audio (para mensajes de voz)
  Future<File?> recordAudio() async {
    try {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        print('🎙️ Plataforma desktop detectada - usando selección de archivo de audio');
        return await pickFile(allowedExtensions: ['mp3', 'm4a', 'wav', 'aac']);
      }

      print('🎙️ Plataforma móvil detectada - funcionalidad de grabación disponible');
      return await pickFile(allowedExtensions: ['mp3', 'm4a', 'wav', 'aac']);
    } catch (e) {
      print('❌ Error grabando audio: $e');
      return null;
    }
  }

  /// Comprimir imagen si es necesario (web-compatible)
  Future<File?> compressImage(File imageFile, {int maxSize = 800}) async {
    try {
      // Solo comprimir en plataformas que soporten dart:io completamente
      if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
        print('🖥️ Plataforma desktop - usando imagen original');
        return imageFile;
      }

      // En web y móvil, intentar comprimir usando la librería image
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        print('❌ Error decodificando imagen');
        return imageFile; // Devolver original si no se puede decodificar
      }

      // Redimensionar si es más grande que maxSize
      img.Image resizedImage = image;
      if (image.width > maxSize || image.height > maxSize) {
        resizedImage = img.copyResize(
          image,
          width: maxSize,
          height: maxSize,
          interpolation: img.Interpolation.linear,
        );
      }

      // Comprimir con calidad 85%
      final compressedBytes = img.encodeJpg(resizedImage, quality: 85);

      // Crear archivo comprimido
      if (kIsWeb) {
        // En web, devolver el archivo original ya que no podemos crear nuevos archivos fácilmente
        print('🌐 Web - devolviendo imagen original (compresión limitada en web)');
        return imageFile;
      } else {
        // En móvil/desktop, guardar archivo comprimido
        final tempDir = await getTemporaryDirectory();
        final compressedFile = File('${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await compressedFile.writeAsBytes(compressedBytes);

        print('✅ Imagen comprimida exitosamente');
        return compressedFile;
      }
    } catch (e) {
      print('❌ Error comprimiendo imagen: $e');
      return imageFile; // Devolver original si hay error
    }
  }

  /// Subir archivo al servidor (soporta tanto File como XFile)
  Future<Map<String, dynamic>?> uploadFile(
    File file,
    String token,
    String chatId, {
    String? caption,
  }) async {
    try {
      print('🔄 Subiendo archivo: ${file.path}');

      // Crear request multipart
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload'),
      );

      // Agregar headers de autenticación
      request.headers['Authorization'] = 'Bearer $token';

      // Manejar diferentes tipos de archivo según la plataforma
      if (kIsWeb) {
        // En web, necesitamos leer los bytes del archivo
        final bytes = await file.readAsBytes();

        // Crear multipart file desde bytes
        final multipartFile = http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: 'uploaded_file_${DateTime.now().millisecondsSinceEpoch}',
        );

        request.files.add(multipartFile);
      } else {
        // En móvil/desktop, usar el método tradicional
        final fileStream = http.ByteStream(file.openRead());
        final fileLength = await file.length();

        final multipartFile = http.MultipartFile(
          'file',
          fileStream,
          fileLength,
          filename: file.path.split('/').last,
        );

        request.files.add(multipartFile);
      }

      // Agregar campos adicionales
      request.fields['chatId'] = chatId;
      if (caption != null && caption.isNotEmpty) {
        request.fields['caption'] = caption;
      }

      // Enviar request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('📨 Upload response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(responseBody);
        print('✅ Archivo subido exitosamente: ${data['fileUrl']}');
        return data;
      } else {
        print('❌ Error subiendo archivo: ${response.statusCode} - $responseBody');
        return null;
      }
    } catch (e) {
      print('❌ Excepción subiendo archivo: $e');
      return null;
    }
  }

  /// Crear thumbnail para video o imagen (web-compatible)
  Future<File?> createThumbnail(File file, MessageType type) async {
    try {
      // Solo crear thumbnails en plataformas que soporten dart:io completamente
      if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
        print('🖥️ Plataforma desktop - saltando creación de thumbnail');
        return null;
      }

      if (type == MessageType.image) {
        return await compressImage(file, maxSize: 300);
      } else if (type == MessageType.video) {
        // TODO: Implementar creación de thumbnail para videos
        // Por ahora, usar la primera frame del video
        print('📹 Creando thumbnail para video...');
        return await compressImage(file, maxSize: 300);
      }

      return null;
    } catch (e) {
      print('❌ Error creando thumbnail: $e');
      return null;
    }
  }

  /// Enviar archivo multimedia con tipo específico
  Future<Message?> sendMultimediaMessageWithType({
    required String token,
    required String chatId,
    required MessageType type,
    String? caption,
  }) async {
    try {
      File? selectedFile;
      switch (type) {
        case MessageType.image:
          selectedFile = await pickImage();
          break;
        case MessageType.video:
          selectedFile = await pickVideo();
          break;
        case MessageType.audio:
          selectedFile = await recordAudio();
          break;
        case MessageType.file:
          selectedFile = await pickFile();
          break;
        default:
          return null;
      }

      if (selectedFile == null) return null;

      File? processedFile = selectedFile;
      if (type == MessageType.image) {
        processedFile = await compressImage(selectedFile);
      }

      File? thumbnailFile;
      if (type == MessageType.image || type == MessageType.video) {
        thumbnailFile = await createThumbnail(processedFile!, type);
      }

      final uploadResult = await uploadFile(
        processedFile!,
        token,
        chatId,
        caption: caption,
      );

      if (uploadResult == null) {
        throw Exception('Failed to upload file');
      }

      final messageData = {
        'chatId': chatId,
        'content': caption ?? '',
        'type': type.name,
        'fileUrl': uploadResult['fileUrl'],
        'fileName': uploadResult['fileName'],
        'fileSize': uploadResult['fileSize'],
        'thumbnailUrl': uploadResult['thumbnailUrl'],
      };

      print('📝 Creando mensaje multimedia: $messageData');

      final chatService = ChatService();
      final message = await chatService.sendMultimediaMessage(
        token: token,
        chatId: chatId,
        file: processedFile!,
        caption: caption,
        type: type,
      );

      if (message != null) {
        print('✅ Archivo multimedia enviado exitosamente');
        return message;
      } else {
        throw Exception('Failed to create message');
      }

    } catch (e) {
      print('❌ Error enviando archivo multimedia: $e');
      return null;
    }
  }
}
