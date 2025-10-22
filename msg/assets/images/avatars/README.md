# Avatares de Usuario

Esta carpeta contiene avatares e imágenes de perfil para usuarios.

## Archivos recomendados:

- `default_avatar.png` - Avatar por defecto para usuarios sin foto
- `user_placeholder.png` - Imagen placeholder para avatares
- `avatar_border.png` - Borde decorativo para avatares (opcional)

## Especificaciones técnicas:

- **Formato recomendado:** PNG con transparencia o JPG
- **Tamaños recomendados:**
  - 40x40px para avatares pequeños (lista de chats)
  - 60x60px para avatares medianos (perfil de usuario)
  - 120x120px para avatares grandes (pantalla completa)
  - Proporciones 1:1 (cuadradas perfectas)

## Uso en código:

```dart
CircleAvatar(
  radius: 20,
  backgroundImage: AssetImage('assets/images/avatars/default_avatar.png'),
)
```

## Notas:
- Siempre tener un avatar por defecto disponible
- Los avatares deben ser apropiados y profesionales
- Considerar versiones para diferentes temas (claro/oscuro)
- Para producción, implementar carga dinámica de avatares desde servidor
