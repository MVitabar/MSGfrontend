@echo off
REM Script rápido para probar la construcción del APK
echo 🚀 Probando construcción del APK
echo ================================
echo.

REM Verificar que la configuración esté lista
echo 🔍 Verificando configuración...

REM Verificar desugaring
findstr "isCoreLibraryDesugaringEnabled" "android/app/build.gradle.kts" >nul
if errorlevel 1 (
    echo ❌ Desugaring no está configurado
    echo 💡 Ejecuta: build-apk-desugar.bat primero
    pause
    exit /b 1
)

REM Verificar versión de desugar
findstr "desugar_jdk_libs:2.1.4" "android/app/build.gradle.kts" >nul
if errorlevel 1 (
    echo ❌ Versión de desugar incorrecta
    echo 💡 Ejecuta: build-apk-desugar.bat primero
    pause
    exit /b 1
)

echo ✅ Configuración OK
echo.

REM Limpiar y construir
echo 🧹 Limpiando...
flutter clean

echo 📦 Dependencias...
flutter pub get

echo 🔨 Construyendo APK...
flutter build apk --release

if errorlevel 1 (
    echo ❌ Error en la construcción
    echo 💡 Revisa la configuración y las dependencias
    pause
    exit /b 1
)

echo.
echo ✅ ¡APK generado exitosamente!
echo 📁 Archivo: build\app\outputs\flutter-apk\app-release.apk
echo 📱 Listo para instalar o distribuir
echo.

pause
