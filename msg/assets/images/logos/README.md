# Logos de la Aplicación

Esta carpeta contiene los logos de la aplicación de mensajería.

## Archivos recomendados:

- `app_logo.png` - Logo principal de la aplicación
- `app_logo_dark.png` - Versión oscura del logo (para temas oscuros)
- `splash_logo.png` - Logo para la pantalla de carga

## Especificaciones técnicas:

- **Formato recomendado:** PNG con transparencia
- **Tamaños recomendados:**
  - 512x512px para logos principales
  - 1024x1024px para logos de alta resolución
  - Múltiples tamaños para diferentes densidades de pantalla

## Uso en código:

```dart
Image.asset('assets/images/logos/app_logo.png')
```

## Notas:
- Para favicons web, también se necesitan versiones en diferentes tamaños
- Considerar versiones para modo claro/oscuro
