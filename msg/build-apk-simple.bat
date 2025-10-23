@echo off
REM Script simple para generar APK de MSG
echo 🚀 Generando APK para Android...
echo.

REM Verificar Flutter
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Flutter no está instalado
    pause
    exit /b 1
)

echo ✅ Flutter OK
echo 🔨 Limpiando proyecto...
flutter clean

echo 📦 Obteniendo dependencias...
flutter pub get

echo 🔨 Construyendo APK...
flutter build apk --release

if errorlevel 1 (
    echo ❌ Error en la construcción
    pause
    exit /b 1
)

echo ✅ APK generado exitosamente!
echo 📁 Ubicación: build\app\outputs\flutter-apk\app-release.apk
echo.
echo 📱 Para instalar en dispositivo:
echo - flutter install
echo - O copia el APK a tu dispositivo
echo.

pause
