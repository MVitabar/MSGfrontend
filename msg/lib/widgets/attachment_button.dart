import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/message.dart';
import '../providers/auth_provider.dart';
import '../services/file_service.dart';

class AttachmentButton extends StatelessWidget {
  final VoidCallback? onFileSelected;
  final String token;
  final String chatId;

  const AttachmentButton({
    super.key,
    this.onFileSelected,
    required this.token,
    required this.chatId,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // En web usamos un enfoque diferente para evitar problemas de posicionamiento
      return _buildWebAttachmentButton(context);
    }

    return PopupMenuButton<MessageType>(
      icon: const Icon(Icons.attach_file),
      tooltip: 'Compartir archivos',
      position: PopupMenuPosition.over,
      offset: const Offset(0, -10),
      constraints: const BoxConstraints(
        minWidth: 240,
        maxWidth: 280,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: 8,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: MessageType.image,
          child: _buildElegantMenuItem(
            context,
            icon: Icons.image_outlined,
            iconColor: const Color(0xFF4CAF50),
            title: 'Imágenes',
            subtitle: 'Fotos y galerías',
            gradient: const LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        PopupMenuItem(
          value: MessageType.video,
          child: _buildElegantMenuItem(
            context,
            icon: Icons.videocam_outlined,
            iconColor: const Color(0xFFFF5722),
            title: 'Videos',
            subtitle: 'Grabaciones y películas',
            gradient: const LinearGradient(
              colors: [Color(0xFFFF5722), Color(0xFFFF7043)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        PopupMenuItem(
          value: MessageType.audio,
          child: _buildElegantMenuItem(
            context,
            icon: Icons.mic_none_outlined,
            iconColor: const Color(0xFFFF9800),
            title: 'Audio',
            subtitle: 'Mensajes de voz',
            gradient: const LinearGradient(
              colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        PopupMenuItem(
          value: MessageType.file,
          child: _buildElegantMenuItem(
            context,
            icon: Icons.insert_drive_file_outlined,
            iconColor: const Color(0xFF2196F3),
            title: 'Documentos',
            subtitle: 'PDF, DOC, TXT, ZIP',
            gradient: const LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ],
    );
  }

  /// Botón especial para web con mejor control de posicionamiento
  Widget _buildWebAttachmentButton(BuildContext context) {
    return InkWell(
      onTap: () => _showWebFileDialog(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.attach_file,
          color: Colors.blue,
        ),
      ),
    );
  }

  /// Mostrar diálogo personalizado para web
  void _showWebFileDialog(BuildContext context) async {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.of(context).size;

    // Dimensiones del diálogo (más altas para evitar scroll)
    final dialogWidth = screenSize.width > 400 ? 260.0 : screenSize.width * 0.8;
    final dialogHeight = 240.0; // Más alto para evitar scroll

    // Calcular posición óptima considerando límites de pantalla
    double left = offset.dx - dialogWidth / 2; // Centrado horizontalmente
    double top;

    // Calcular espacio disponible arriba y abajo
    final spaceAbove = offset.dy;
    final spaceBelow = screenSize.height - (offset.dy + size.height);

    // Si hay más espacio abajo, abrir hacia abajo
    if (spaceBelow >= dialogHeight + 20) {
      top = offset.dy + size.height + 20; // Abajo con margen
    }
    // Si hay más espacio arriba, abrir hacia arriba
    else if (spaceAbove >= dialogHeight + 20) {
      top = offset.dy - dialogHeight - 20; // Arriba con margen
    }
    // Si no cabe en ninguno, usar el que tenga más espacio
    else if (spaceBelow > spaceAbove) {
      top = screenSize.height - dialogHeight - 20; // Pegado al borde inferior con margen
    } else {
      top = 20; // Pegado al borde superior con margen
    }

    // Asegurar que no se salga de los límites horizontales
    if (left < 10) left = 10; // Margen mínimo
    if (left + dialogWidth > screenSize.width - 10) {
      left = screenSize.width - dialogWidth - 10; // Margen mínimo
    }

    final position = Offset(left, top);

    await showDialog<MessageType>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            left: position.dx,
            top: position.dy,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: dialogWidth,
                constraints: const BoxConstraints(
                  maxHeight: 240, // Altura máxima más grande para evitar scroll
                  minHeight: 180, // Altura mínima ajustada
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Opciones directamente sin header ni scroll
                    Column(
                      children: [
                        _buildWebMenuItem(
                          context,
                          icon: Icons.image_outlined,
                          title: 'Imágenes',
                          subtitle: 'Fotos y galerías',
                          gradient: const LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)]),
                          onTap: () => Navigator.pop(context, MessageType.image),
                        ),
                        _buildWebMenuItem(
                          context,
                          icon: Icons.videocam_outlined,
                          title: 'Videos',
                          subtitle: 'Grabaciones y películas',
                          gradient: const LinearGradient(colors: [Color(0xFFFF5722), Color(0xFFFF7043)]),
                          onTap: () => Navigator.pop(context, MessageType.video),
                        ),
                        _buildWebMenuItem(
                          context,
                          icon: Icons.mic_none_outlined,
                          title: 'Audio',
                          subtitle: 'Mensajes de voz',
                          gradient: const LinearGradient(colors: [Color(0xFFFF9800), Color(0xFFFFB74D)]),
                          onTap: () => Navigator.pop(context, MessageType.audio),
                        ),
                        _buildWebMenuItem(
                          context,
                          icon: Icons.insert_drive_file_outlined,
                          title: 'Documentos',
                          subtitle: 'PDF, DOC, TXT, ZIP',
                          gradient: const LinearGradient(colors: [Color(0xFF2196F3), Color(0xFF42A5F5)]),
                          onTap: () => Navigator.pop(context, MessageType.file),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ).then((selectedType) {
      if (selectedType != null) {
        _handleFileSelection(context, selectedType);
      }
    });
  }

  /// Elemento de menú para web con diseño elegante
  Widget _buildWebMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), // Padding ultra-compacto
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 1), // Márgenes mínimos
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4), // Padding mínimo
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 14, color: Colors.white), // Icono aún más pequeño
            ),
            const SizedBox(width: 6), // Espacio mínimo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12, // Tamaño más pequeño
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 9, // Tamaño muy pequeño
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 10, color: Colors.white), // Flecha mínima
          ],
        ),
      ),
    );
  }

  /// Construir elemento elegante del menú dropdown (solo móvil)
  Widget _buildElegantMenuItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Gradient gradient,
  }) {
    return Container(
      width: 260,
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleFileSelection(BuildContext context, MessageType type) async {
    try {
      print('📎 Seleccionando archivo tipo: ${type.name}');

      final fileService = MediaService();

      // Usar el flujo completo directamente
      final message = await fileService.sendMultimediaMessageWithType(
        token: token,
        chatId: chatId,
        type: type,
      );

      if (message != null && context.mounted) {
        print('✅ Archivo multimedia enviado exitosamente');

        // Notificar que se seleccionó un archivo
        if (onFileSelected != null) {
          onFileSelected!();
        }
      }

    } catch (e) {
      print('❌ Error seleccionando archivo: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
