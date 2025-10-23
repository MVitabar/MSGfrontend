@echo off
REM Script para generar APK con desugaring habilitado
echo 🚀 Generando APK con desugaring habilitado
echo ==========================================
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

REM Limpiar completamente
echo 🧹 Limpieza completa...
flutter clean
flutter pub cache clean

REM Obtener dependencias
echo 📦 Obteniendo dependencias...
flutter pub get

REM Verificar si desugaring está configurado
echo 🔍 Verificando configuración de desugaring...
findstr "isCoreLibraryDesugaringEnabled" "android/app/build.gradle.kts" >nul
if errorlevel 1 (
    echo ⚠️  Configuración de desugaring no encontrada
    echo 💡 Configurando desugaring automáticamente...

    REM Agregar desugaring a build.gradle.kts
    powershell -Command "
    $content = Get-Content 'android/app/build.gradle.kts' -Raw
    $content = $content -replace 'compileOptions \{(.*?)\}', 'compileOptions {`$1`n        isCoreLibraryDesugaringEnabled = true`n    }'
    $content = $content -replace 'buildTypes \{(.*?)\}(.*?)}', 'buildTypes {`$1`}`n}`n`ndependencies {`n    coreLibraryDesugaring(`"com.android.tools:desugar_jdk_libs:2.1.4`")`n}'
    Set-Content -Path 'android/app/build.gradle.kts' -Value $content
    "
    echo ✅ Desugaring configurado
) else (
    echo ✅ Desugaring ya está configurado
)

echo.
echo 🔨 Construyendo APK...
flutter build apk --release

if errorlevel 1 (
    echo ❌ Error durante la construcción
    echo 💡 Soluciones posibles:
    echo 1. Verifica que Android SDK esté actualizado
    echo 2. Asegúrate de tener Java 11 o superior
    echo 3. Revisa: https://developer.android.com/studio/write/java8-support
    echo.
    echo 🔄 Ejecutando diagnóstico...
    flutter doctor
    pause
    exit /b 1
)

echo.
echo ✅ ¡APK generado exitosamente!
echo 📁 Ubicación: build\app\outputs\flutter-apk\app-release.apk
echo 📱 Tamaño aproximado: 25-60 MB (con desugaring)
echo.
echo 🚀 Instalación:
echo 1. Conecta dispositivo Android via USB
echo 2. Ejecuta: flutter install
echo    O copia el APK manualmente
echo.
echo ✅ Características incluidas:
echo - Core library desugaring habilitado
echo - Compatible con Java 8+ APIs
echo - Optimizado para notificaciones push
echo - Listo para Google Play Store
echo.

pause
