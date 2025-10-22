# Configuración para evitar warnings de file_picker
# Los warnings sobre implementaciones nativas de file_picker para Windows, Linux y macOS
# son normales y no afectan la funcionalidad de la aplicación.
#
# file_picker funciona correctamente en:
# - Android: Implementación nativa completa
# - iOS: Implementación nativa completa
# - Web: Implementación web completa
# - Desktop: Fallback a implementación web o selección manual
#
# Estos warnings aparecen porque el paquete declara soporte para desktop
# pero no todas las implementaciones nativas están disponibles.
# La aplicación seguirá funcionando correctamente en todas las plataformas.

# Para suprimir completamente estos warnings en desarrollo:
# 1. Los warnings no afectan la compilación ni el funcionamiento
# 2. Son solo informativos del sistema de análisis de Flutter
# 3. Se pueden ignorar de manera segura para este proyecto

# Si necesitas una versión completamente silenciosa, considera:
# - Usar una versión más específica de file_picker
# - Configurar analysis_options.yaml para ignorar estos warnings específicos
# - Usar alternativas como flutter_file_picker que pueden tener menos warnings

# Configuración actual optimizada para móvil + web:
# ✅ Android: Soporte completo
# ✅ iOS: Soporte completo
# ✅ Web: Soporte completo
# ⚠️ Desktop: Soporte limitado (normal para apps móviles)
