# MSG - Modern Messaging Application

Aplicación de mensajería moderna desarrollada con Flutter que incluye soporte completo para multimedia.

## 🚀 Características Principales

✅ **Autenticación completa** - Login y registro con JWT
✅ **Mensajería en tiempo real** - WebSocket para chat instantáneo
✅ **Multimedia completo** - Imágenes, videos, audio y documentos
✅ **Interfaz moderna** - Material Design con modo oscuro/claro
✅ **Multiplataforma** - Android, iOS, Web (y Windows con configuración)

## 📱 Funcionalidades Multimedia

- **📸 Imágenes**: Cámara, galería, compresión automática
- **🎥 Videos**: Reproducción completa con controles
- **🎵 Audio**: Mensajes de voz con visualización
- **📄 Documentos**: PDFs, DOCs, ZIPs con previews
- **🔄 En tiempo real**: Envío y recepción instantánea

## 🏗️ Arquitectura

### **Backend Integration**
- **NestJS** para API REST y WebSocket
- **JWT Authentication** para seguridad
- **File Upload** con Multer
- **Real-time messaging** con Socket.IO

### **Frontend Structure**
```
lib/
├── models/          # Modelos de datos (Message, Chat, User)
├── services/        # Servicios (Auth, Chat, File Upload)
├── widgets/         # Widgets reutilizables multimedia
├── screens/         # Pantallas (Login, Chat, etc.)
└── providers/       # State management con Provider
```

## 🛠️ Instalación y Configuración

### **1. Instalar dependencias:**
```bash
flutter pub get
```

### **2. Configurar backend:**
Asegúrate de que el backend NestJS esté ejecutándose en `localhost:3000`

### **3. Ejecutar la aplicación:**

**Para Windows (Recomendado):**
```bash
flutter run -d chrome  # Web Chrome
# O
flutter run -d edge    # Web Edge
```

**Para móvil:**
```bash
flutter run -d android # Android
flutter run -d ios     # iOS
```

**Para Windows nativo:**
```bash
# Requiere CMake 3.23+
flutter run -d windows
```

## 📖 Documentación Detallada

- **`MULTIMEDIA_README.md`** - Funcionalidades multimedia completas
- **`WINDOWS_README.md`** - Instrucciones específicas para Windows
- **`file_picker_config.md`** - Configuración de dependencias

## 🔧 Tecnologías

- **Flutter** 3.9+ con Material Design 3
- **Provider** para state management
- **Socket.IO** para mensajería en tiempo real
- **HTTP** para API REST
- **Image Picker** para selección de archivos
- **Video Player** para reproducción multimedia
- **Cached Network Images** para optimización

## 📄 Licencia

Este proyecto es para uso personal y educativo.

---

**¡Disfruta tu nueva aplicación de mensajería multimedia!** 🎉📱💬
