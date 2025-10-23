@echo off
REM Script de diagnóstico y reparación para Flutter
echo 🔍 Diagnóstico y reparación de Flutter
echo ======================================
echo.

REM Verificar Flutter
echo 📱 Verificando Flutter...
flutter --version
if errorlevel 1 (
    echo ❌ Flutter no está instalado correctamente
    pause
    exit /b 1
)

echo.
echo 🔍 Diagnóstico del sistema...
flutter doctor

echo.
echo 🧹 Limpiando cache...
flutter clean
flutter pub cache clean

echo 📦 Reinicializando dependencias...
del pubspec.lock 2>nul
flutter pub get

echo 🔄 Aplicando actualizaciones...
flutter pub upgrade

echo.
echo 🔍 Verificando análisis...
flutter analyze

echo.
echo ✅ Diagnóstico completado
echo 💡 Si ves errores en flutter doctor, resuélvelos antes de continuar
echo 🚀 Para generar APK, ejecuta: build-apk-updated.bat
echo.

pause
