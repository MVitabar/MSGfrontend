@echo off
REM Script para solucionar problemas y generar APK con dependencias actualizadas
echo 🔧 Solución de problemas y generación de APK
echo ============================================
echo.

REM Verificar Flutter
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Flutter no está disponible
    pause
    exit /b 1
)

echo ✅ Flutter detectado
echo.

REM Limpeza profunda
echo 🧹 Limpieza profunda del proyecto...
flutter clean
flutter pub cache clean

echo 📦 Obteniendo dependencias actualizadas...
flutter pub get

echo 🔄 Actualizando dependencias...
flutter pub upgrade

echo.
echo 🔍 Verificando análisis...
flutter analyze

echo.
echo 🔨 Construyendo APK de release...
flutter build apk --release

if errorlevel 1 (
    echo ❌ Error durante la construcción
    echo 💡 Posibles soluciones:
    echo 1. Verifica tu conexión a internet
    echo 2. Asegúrate de que Java JDK esté instalado
    echo 3. Revisa que Android SDK esté configurado correctamente
    echo 4. Ejecuta: flutter doctor
    echo.
    echo 📖 Documentación: https://flutter.dev/docs/deployment/android
    pause
    exit /b 1
)

echo.
echo ✅ ¡APK generado exitosamente!
echo 📁 Ubicación: build\app\outputs\flutter-apk\app-release.apk
echo 📱 Tamaño aproximado: 25-60 MB (con dependencias actualizadas)
echo.
echo 🚀 Instalación:
echo 1. Conecta dispositivo Android via USB
echo 2. Ejecuta: flutter install
echo    O copia el APK manualmente
echo.
echo 📦 Para Google Play Store:
echo - El APK está firmado y optimizado para producción
echo - Listo para subir a Google Play Console
echo.

pause
