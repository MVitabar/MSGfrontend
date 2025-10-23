@echo off
REM Script completo para generar APK con configuración automática
echo 🚀 Configuración automática y generación de APK para MSG
echo ======================================================
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

REM Crear key store si no existe
if not exist "android/app/msg_keystore.jks" (
    echo 🔐 Creando key store...
    keytool -genkeypair ^
        -alias msg-key ^
        -keyalg RSA ^
        -keysize 2048 ^
        -validity 10000 ^
        -dname "CN=MSG Development, OU=Dev, O=MSG, L=Unknown, ST=Unknown, C=US" ^
        -keystore android/app/msg_keystore.jks ^
        -storepass msg123456 ^
        -keypass msg123456
    echo ✅ Key store creado
) else (
    echo ✅ Key store ya existe
)

REM Crear key.properties si no existe
if not exist "android/key.properties" (
    (
        echo storePassword=msg123456
        echo keyPassword=msg123456
        echo keyAlias=msg-key
        echo storeFile=../app/msg_keystore.jks
    ) > android/key.properties
    echo ✅ key.properties creado
) else (
    echo ✅ key.properties ya existe
)

REM Configurar build.gradle.kts automáticamente
echo 📝 Configurando build.gradle.kts...

REM Agregar signingConfigs si no existe
findstr "signingConfigs" "android/app/build.gradle.kts" >nul
if errorlevel 1 (
    REM Crear respaldo
    copy "android/app/build.gradle.kts" "android/app/build.gradle.kts.backup" >nul

    REM Agregar configuración de firma
    powershell -Command "
    $content = Get-Content 'android/app/build.gradle.kts' -Raw
    $newContent = $content -replace 'android \{(.*?)compileSdk', @'
    signingConfigs {
        create(\"release\") {
            storeFile = file(\"../app/msg_keystore.jks\")
            storePassword = \"msg123456\"
            keyAlias = \"msg-key\"
            keyPassword = \"msg123456\"
        }
    }

    android {
        $1compileSdk'@
    $newContent = $newContent -replace 'buildTypes \{(.*?)release \{(.*?)signingConfig', @'
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName(\"release\")
            minifyEnabled = true
            proguardFiles(getDefaultProguardFile(\"proguard-android.txt\"), \"proguard-rules.pro\")
'@

    if ($newContent -ne $content) {
        Set-Content -Path 'android/app/build.gradle.kts' -Value $newContent
        Write-Host 'Configuracion de firma agregada'
    } else {
        Write-Host 'Configuracion ya existe'
    }
    "
) else (
    echo ✅ Configuración de firma ya existe
)

echo.
REM Limpeza profunda antes de construir
flutter clean
flutter pub cache clean

REM Obtener dependencias actualizadas
flutter pub get
flutter pub upgrade

echo 🔨 Construyendo APK de release...
flutter build apk --release

if errorlevel 1 (
    echo ❌ Error durante la construcción
    echo 💡 Ejecutando diagnóstico...
    flutter doctor
    echo.
    echo 💡 Posibles soluciones:
    echo 1. Ejecuta: fix-and-diagnose.bat
    echo 2. Verifica Java JDK y Android SDK
    echo 3. Revisa conexión a internet
    echo 4. Consulta: https://flutter.dev/docs/deployment/android
    pause
    exit /b 1
)

echo.
echo ✅ ¡APK generado exitosamente!
echo 📁 Ubicación: build\app\outputs\flutter-apk\app-release.apk
echo 📱 Tamaño aproximado: 20-50 MB dependiendo de las dependencias
echo.
echo 🚀 Instalación:
echo 1. Conecta un dispositivo Android via USB
echo 2. Ejecuta: flutter install
echo    O transfiere el APK manualmente
echo.
echo 📦 Para distribución:
echo - Sube el APK a Google Play Console
echo - O compártelo directamente (solo desarrollo)
echo.

pause
