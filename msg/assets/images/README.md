# Carpeta de Imágenes de la Aplicación

Esta carpeta contiene todos los recursos de imágenes utilizados en la aplicación de mensajería.

## Estructura de carpetas:

```
assets/images/
├── logos/           # Logos de la aplicación
│   ├── app_logo.png
│   └── splash_logo.png
├── icons/           # Íconos personalizados
│   ├── chat_icon.png
│   └── send_button_icon.png
└── avatars/         # Avatares de usuario
    ├── default_avatar.png
    └── user_placeholder.png
```

## Configuración en pubspec.yaml:

```yaml
flutter:
  assets:
    - assets/images/
    - assets/images/logos/
    - assets/images/icons/
    - assets/images/avatars/
```

## Uso general:

```dart
// Para logos
Image.asset('assets/images/logos/app_logo.png')

// Para íconos
Image.asset('assets/images/icons/chat_icon.png')

// Para avatares
CircleAvatar(
  backgroundImage: AssetImage('assets/images/avatars/default_avatar.png'),
)
```

## Mejores prácticas:

1. **Nombres descriptivos:** Usa nombres claros y específicos para cada imagen
2. **Optimización:** Comprime las imágenes para reducir el tamaño de la aplicación
3. **Múltiples resoluciones:** Considera diferentes densidades de pantalla (1x, 2x, 3x)
4. **Tema oscuro:** Crea versiones alternativas para modo oscuro cuando sea necesario
5. **Formato apropiado:** PNG para imágenes con transparencia, JPG para fotos

## Para producción:

- Implementar carga dinámica de imágenes desde servidor
- Usar CDN para distribución global
- Implementar cache inteligente
- Considerar imágenes vectoriales (SVG) para íconos escalables
