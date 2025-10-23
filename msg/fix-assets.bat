@echo off
REM Script para renombrar archivos con guiones en assets para Android
echo 🔧 Renombrando archivos de assets para compatibilidad con Android...
echo.

REM Cambiar al directorio del proyecto
cd /d "%~dp0"

echo 📁 Renombrando archivos en assets/images/logos/...

REM Logos directory
if exist "assets\images\logos\android-chrome-192x192.png" (
    ren "assets\images\logos\android-chrome-192x192.png" "android_chrome_192x192.png"
    echo ✅ android-chrome-192x192.png → android_chrome_192x192.png
) else (
    echo ⚠️  android-chrome-192x192.png no encontrado
)

if exist "assets\images\logos\android-chrome-512x512.png" (
    ren "assets\images\logos\android-chrome-512x512.png" "android_chrome_512x512.png"
    echo ✅ android-chrome-512x512.png → android_chrome_512x512.png
) else (
    echo ⚠️  android-chrome-512x512.png no encontrado
)

if exist "assets\images\logos\favicon-16x16.png" (
    ren "assets\images\logos\favicon-16x16.png" "favicon_16x16.png"
    echo ✅ favicon-16x16.png → favicon_16x16.png
) else (
    echo ⚠️  favicon-16x16.png no encontrado
)

if exist "assets\images\logos\favicon-32x32.png" (
    ren "assets\images\logos\favicon-32x32.png" "favicon_32x32.png"
    echo ✅ favicon-32x32.png → favicon_32x32.png
) else (
    echo ⚠️  favicon-32x32.png no encontrado
)

if exist "assets\images\logos\apple-touch-icon.png" (
    ren "assets\images\logos\apple-touch-icon.png" "apple_touch_icon.png"
    echo ✅ apple-touch-icon.png → apple_touch_icon.png
) else (
    echo ⚠️  apple-touch-icon.png no encontrado
)

echo.
echo 📁 Renombrando archivos en assets/images/icons/...

REM Icons directory
if exist "assets\images\icons\android-chrome-512x512.png" (
    ren "assets\images\icons\android-chrome-512x512.png" "android_chrome_512x512.png"
    echo ✅ android-chrome-512x512.png → android_chrome_512x512.png
) else (
    echo ⚠️  android-chrome-512x512.png no encontrado
)

if exist "assets\images\icons\favicon-16x16.png" (
    ren "assets\images\icons\favicon-16x16.png" "favicon_16x16.png"
    echo ✅ favicon-16x16.png → favicon_16x16.png
) else (
    echo ⚠️  favicon-16x16.png no encontrado
)

if exist "assets\images\icons\apple-touch-icon.png" (
    ren "assets\images\icons\apple-touch-icon.png" "apple_touch_icon.png"
    echo ✅ apple-touch-icon.png → apple_touch_icon.png
) else (
    echo ⚠️  apple-touch-icon.png no encontrado
)

echo.
echo 🧹 Limpiando build de Flutter...
flutter clean

echo.
echo ✅ ¡Archivos renombrados exitosamente!
echo 📱 Ahora puedes generar el APK con: flutter build apk --release
echo.

pause
