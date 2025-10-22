@echo off
REM Script para limpiar completamente y reinstalar dependencias
REM Soluciona problemas de compilación avanzados

echo 🧹 Limpieza completa del proyecto Flutter
echo ======================================

REM Detener cualquier proceso de Flutter
echo Deteniendo procesos de Flutter...
taskkill /f /im dart.exe 2>nul
taskkill /f /im flutter.exe 2>nul

echo.
echo 🗑️  Eliminando archivos temporales...
flutter clean

echo.
echo 🗑️  Eliminando cache de pub...
flutter pub cache clean

echo.
echo 📦 Obteniendo dependencias actualizadas...
flutter pub get

echo.
echo 🔍 Verificando análisis...
flutter analyze

echo.
echo ✅ Limpieza completada exitosamente!
echo.
echo 🚀 Para ejecutar la aplicación:
echo 1. Ejecuta: run.bat
echo 2. Elige opción 1 (Chrome) para mejor compatibilidad
echo.
echo 💡 Si aún tienes problemas:
echo - Usa: flutter run -d chrome (recomendado para Windows)
echo - Verifica: WINDOWS_README.md para más detalles
echo.

pause
