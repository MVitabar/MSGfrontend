@echo off
REM Script para limpiar archivos problemáticos de recursos Android
echo 🧹 Limpiando archivos problemáticos de recursos Android...
echo.

REM Eliminar archivos con guiones de las carpetas mipmap
if exist "android\app\src\main\res\mipmap-hdpi\android-chrome-192x192.png" (
    del "android\app\src\main\res\mipmap-hdpi\android-chrome-192x192.png"
    echo ✅ Eliminado: android\app\src\main\res\mipmap-hdpi\android-chrome-192x192.png
) else (
    echo ⚠️  No encontrado: android-chrome-192x192.png en mipmap-hdpi
)

if exist "android\app\src\main\res\mipmap-mdpi\favicon-32x32.png" (
    del "android\app\src\main\res\mipmap-mdpi\favicon-32x32.png"
    echo ✅ Eliminado: android\app\src\main\res\mipmap-mdpi\favicon-32x32.png
) else (
    echo ⚠️  No encontrado: favicon-32x32.png en mipmap-mdpi
)

echo.
echo 🔍 Verificando otras carpetas mipmap...

REM Verificar si hay más archivos problemáticos
echo 📁 mipmap-xhdpi:
if exist "android\app\src\main\res\mipmap-xhdpi\*-*" (
    echo ❌ Archivos problemáticos encontrados en mipmap-xhdpi
    dir "android\app\src\main\res\mipmap-xhdpi\*-*" /b
) else (
    echo ✅ mipmap-xhdpi limpio
)

echo 📁 mipmap-xxhdpi:
if exist "android\app\src\main\res\mipmap-xxhdpi\*-*" (
    echo ❌ Archivos problemáticos encontrados en mipmap-xxhdpi
    dir "android\app\src\main\res\mipmap-xxhdpi\*-*" /b
) else (
    echo ✅ mipmap-xxhdpi limpio
)

echo 📁 mipmap-xxxhdpi:
if exist "android\app\src\main\res\mipmap-xxxhdpi\*-*" (
    echo ❌ Archivos problemáticos encontrados en mipmap-xxxhdpi
    dir "android\app\src\main\res\mipmap-xxxhdpi\*-*" /b
) else (
    echo ✅ mipmap-xxxhdpi limpio
)

echo.
echo 🧹 Limpiando completamente el proyecto Flutter...
flutter clean

echo 📦 Obteniendo dependencias actualizadas...
flutter pub get

echo.
echo ✅ ¡Limpieza completada!
echo 🚀 Ahora puedes generar el APK con: flutter build apk --release
echo.

pause
