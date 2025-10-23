@echo off
REM Script para generar APK de Android para MSG
REM Este script configura automáticamente la firma y genera el APK

echo 🚀 Generador de APK para MSG - Android
echo =====================================
echo.

REM Verificar si Flutter está disponible
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Flutter no está instalado o no está en el PATH
    echo 💡 Instala Flutter desde: https://flutter.dev/docs/get-started/install/windows
    pause
    exit /b 1
)

echo ✅ Flutter detectado correctamente
echo.

REM Verificar si el key store existe, si no, crearlo
if not exist "android/app/msg_keystore.jks" (
    echo 🔐 Creando key store para firma digital...
    echo.
    echo ⚠️  Se creará un key store para desarrollo
    echo 💡 Para producción, considera usar un key store propio
    echo.

    keytool -genkeypair ^
        -alias msg-key ^
        -keyalg RSA ^
        -keysize 2048 ^
        -validity 10000 ^
        -dname "CN=MSG App, OU=Development, O=MSG, L=Unknown, ST=Unknown, C=US" ^
        -keystore android/app/msg_keystore.jks ^
        -storepass msg123456 ^
        -keypass msg123456

    if errorlevel 1 (
        echo ❌ Error creando key store
        echo 💡 Verifica que Java JDK esté instalado
        pause
        exit /b 1
    )

    echo ✅ Key store creado exitosamente
    echo.
) else (
    echo ✅ Key store ya existe
    echo.
)

REM Verificar y configurar key.properties
if not exist "android/key.properties" (
    echo 📝 Configurando key.properties...
    (
        echo storePassword=msg123456
        echo keyPassword=msg123456
        echo keyAlias=msg-key
        echo storeFile=../app/msg_keystore.jks
    ) > android/key.properties
    echo ✅ key.properties configurado
    echo.
) else (
    echo ✅ key.properties ya existe
    echo.
)

REM Verificar configuración en build.gradle
findstr "signingConfigs" "android/app/build.gradle.kts" >nul
if errorlevel 1 (
    echo 📝 Configurando firma en build.gradle.kts...

    REM Leer el archivo actual
    set "build_gradle="
    for /f "delims=" %%i in (android/app/build.gradle.kts) do set "build_gradle=!build_gradle!%%i
"

    REM Agregar configuración de firma antes del bloque android
    set "build_gradle=%build_gradle:    android {=    signingConfigs {%
        create("release") {%
            storeFile = file("../app/msg_keystore.jks")%
            storePassword = "msg123456"%
            keyAlias = "msg-key"%
            keyPassword = "msg123456"%
        }%
    }%
    %
    android {%

    REM Configurar buildTypes para usar la firma
    echo Configurando buildTypes...
    call :replaceInFile "        release {", "        release {%
            signingConfig = signingConfigs.getByName("release")%
            minifyEnabled = true%
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")%
        }%"
) else (
    echo ✅ Configuración de firma ya existe en build.gradle.kts
)

echo.
echo 🔨 Limpiando proyecto...
flutter clean

echo.
echo 📦 Obteniendo dependencias...
flutter pub get

echo.
echo 🔨 Construyendo APK de release...
flutter build apk --release

if errorlevel 1 (
    echo ❌ Error durante la construcción
    echo 💡 Verifica que no haya errores de compilación
    echo 💡 Revisa la documentación: https://flutter.dev/docs/deployment/android
    pause
    exit /b 1
)

echo.
echo ✅ APK generado exitosamente!
echo 📁 Ubicación: build\app\outputs\flutter-apk\app-release.apk
echo.
echo 📱 Para instalar:
echo 1. Conecta un dispositivo Android
echo 2. Ejecuta: flutter install
echo    O copia el APK a tu dispositivo y ejecútalo
echo.
echo 💡 Para distribución:
echo - Comparte el APK desde build\app\outputs\flutter-apk\
echo - Para Google Play Store necesitas configuración adicional
echo.

pause

:replaceInFile
REM Función auxiliar para reemplazar texto en archivos
exit /b 0
