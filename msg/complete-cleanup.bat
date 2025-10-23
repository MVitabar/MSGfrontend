@echo off
REM Script completo para limpiar cachés y liberar espacio en disco
echo 🧹 LIMPIEZA COMPLETA - Liberando espacio en disco...
echo.

REM Verificar espacio en disco
echo 📊 Verificando espacio en disco...
for /f "tokens=3" %%i in ('dir /-c "C:\" 2^>nul ^| findstr /c:"bytes free"') do set "free=%%i"
if "%free%"=="" (
    echo ⚠️  No se pudo verificar el espacio en disco
) else (
    echo ✅ Espacio disponible: %free% bytes
)

echo.
echo 🗑️  Eliminando archivos temporales...

REM Limpiar carpeta build de Flutter
if exist "build" (
    rmdir /s /q "build"
    echo ✅ Eliminada carpeta build
)

REM Limpiar .flutter-plugins-dependencies
if exist ".flutter-plugins-dependencies" (
    del /q ".flutter-plugins-dependencies"
    echo ✅ Eliminado .flutter-plugins-dependencies
)

REM Limpiar archivos temporales de Gradle
if exist "android\.gradle" (
    rmdir /s /q "android\.gradle"
    echo ✅ Eliminada caché de Gradle
)

REM Limpiar archivos temporales comunes
if exist "*.tmp" del /q "*.tmp" 2>nul
if exist "*.temp" del /q "*.temp" 2>nul

echo.
echo 🔄 Limpiando cachés de Flutter...
flutter clean --force

echo.
echo 📦 Actualizando dependencias...
flutter pub cache repair
flutter pub get

echo.
echo ⚡ Limpiando cachés de Gradle globales...
if exist "%USERPROFILE%\.gradle\caches" (
    rmdir /s /q "%USERPROFILE%\.gradle\caches"
    echo ✅ Eliminada caché global de Gradle
)

echo.
echo 📱 Limpiando archivos temporales de Android...
if exist "android\app\build" (
    rmdir /s /q "android\app\build"
    echo ✅ Eliminada carpeta build de Android
)

echo.
echo 🔍 Verificando espacio liberado...
for /f "tokens=3" %%i in ('dir /-c "C:\" 2^>nul ^| findstr /c:"bytes free"') do set "free=%%i"
if "%free%"=="" (
    echo ⚠️  No se pudo verificar el espacio en disco
) else (
    echo ✅ Espacio disponible ahora: %free% bytes
)

echo.
echo ✅ ¡Limpieza completada!
echo 📱 Ahora intenta generar el APK nuevamente:
echo    flutter build apk --debug
echo    flutter build apk --release
echo.

pause
