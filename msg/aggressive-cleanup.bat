@echo off
REM Script AGRESIVO para limpiar completamente Gradle y Flutter
echo 🔪 LIMPIEZA AGRESIVA - Eliminando cachés corruptas...
echo.

REM ========================================
REM PASO 1: MATAR PROCESOS GRADLE/JAVA
REM ========================================
echo 🛑 Matando procesos Gradle y Java...

REM Matar procesos de Gradle
taskkill /f /im "gradle.exe" 2>nul
taskkill /f /im "java.exe" 2>nul
taskkill /f /im "kotlin-compiler-daemon.exe" 2>nul
taskkill /f /im "flutter.exe" 2>nul
taskkill /f /im "dart.exe" 2>nul

echo ✅ Procesos terminados

REM ========================================
REM PASO 2: ELIMINAR CACHÉS DE GRADLE
REM ========================================
echo 🗑️  Eliminando cachés de Gradle...

REM Eliminar caché de Gradle del proyecto
if exist "android\.gradle" (
    rmdir /s /q "android\.gradle" 2>nul
    echo ✅ Eliminada caché de Gradle del proyecto
)

REM Eliminar caché global de Gradle
if exist "%USERPROFILE%\.gradle" (
    rmdir /s /q "%USERPROFILE%\.gradle" 2>nul
    echo ✅ Eliminada caché global de Gradle
)

REM ========================================
REM PASO 3: LIMPIAR FLUTTER
REM ========================================
echo 🧹 Limpiando Flutter...

REM Eliminar archivos de Flutter
if exist "build" rmdir /s /q "build" 2>nul
if exist ".flutter-plugins-dependencies" del /q ".flutter-plugins-dependencies" 2>nul
if exist ".dart_tool" rmdir /s /q ".dart_tool" 2>nul
if exist ".packages" del /q ".packages" 2>nul
if exist "pubspec.lock" del /q "pubspec.lock" 2>nul

echo ✅ Archivos de Flutter eliminados

REM ========================================
REM PASO 4: LIMPIAR ANDROID
REM ========================================
echo 📱 Limpiando Android...

REM Eliminar archivos de Android build
if exist "android\app\build" rmdir /s /q "android\app\build" 2>nul
if exist "android\.gradle" rmdir /s /q "android\.gradle" 2>nul

REM Eliminar archivos problemáticos de recursos
if exist "android\app\src\main\res\mipmap-hdpi\*-*" (
    del /q "android\app\src\main\res\mipmap-hdpi\*-*"
    echo ✅ Archivos problemáticos eliminados de mipmap-hdpi
)

if exist "android\app\src\main\res\mipmap-mdpi\*-*" (
    del /q "android\app\src\main\res\mipmap-mdpi\*-*"
    echo ✅ Archivos problemáticos eliminados de mipmap-mdpi
)

REM ========================================
REM PASO 5: ESPERAR Y LIMPIAR FLUTTER
REM ========================================
echo ⏳ Esperando que se liberen archivos...
timeout /t 3 /nobreak >nul

echo 🔄 Limpiando Flutter...
flutter clean

echo 📦 Obteniendo dependencias...
flutter pub get

echo.
echo ✅ ¡LIMPIEZA AGRESIVA COMPLETADA!
echo 🚀 Ahora puedes generar el APK:
echo.
echo 📱 PRUEBA 1 (Debug):
echo    flutter build apk --debug
echo.
echo 📱 PRUEBA 2 (Release):
echo    flutter build apk --release
echo.
echo 💡 Si aún hay problemas, reinicia tu computadora y vuelve a intentar
echo.

pause
