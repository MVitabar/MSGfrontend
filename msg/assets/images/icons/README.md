# Íconos de la Aplicación

Esta carpeta contiene íconos personalizados para la aplicación de mensajería.

## Archivos recomendados:

- `chat_icon.png` - Ícono para chats individuales
- `group_chat_icon.png` - Ícono para chats grupales
- `online_indicator.png` - Indicador de usuario en línea
- `offline_indicator.png` - Indicador de usuario desconectado
- `send_button_icon.png` - Ícono del botón de enviar
- `attachment_icon.png` - Ícono para adjuntos
- `typing_indicator.gif` - Animación de "escribiendo..."

## Especificaciones técnicas:

- **Formato recomendado:** PNG para íconos estáticos, GIF para animaciones
- **Tamaños recomendados:**
  - 24x24px para íconos pequeños
  - 32x32px para íconos medianos
  - 48x48px para íconos grandes
  - Proporciones 1:1 (cuadrados)

## Uso en código:

```dart
Image.asset('assets/images/icons/chat_icon.png', width: 24, height: 24)
```

## Notas:
- Los íconos deben ser simples y reconocibles
- Considerar versiones para diferentes estados (activo/inactivo)
- Para mejor rendimiento, usar íconos pequeños
