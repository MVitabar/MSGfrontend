@echo off
REM Script rápido para generar APK (después de actualizar dependencias)
echo 🚀 Generación rápida de APK
echo ===========================
echo.

REM Verificar Flutter
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Flutter no disponible
    pause
    exit /b 1
)

echo ✅ Flutter OK
echo 🔨 Limpiando y obteniendo dependencias...
flutter clean
flutter pub get

echo 🔨 Construyendo APK...
flutter build apk --release

if errorlevel 1 (
    echo ❌ Error en construcción
    echo 💡 Usa: fix-and-diagnose.bat para diagnóstico completo
    pause
    exit /b 1
)

echo.
echo ✅ APK generado exitosamente!
echo 📁 Archivo: build\app\outputs\flutter-apk\app-release.apk
echo 📱 Listo para instalar o subir a Play Store
echo.

pause
