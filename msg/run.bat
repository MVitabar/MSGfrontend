@echo off
REM Script para ejecutar MSG en Windows
REM Este script maneja automáticamente la configuración para Windows

echo 🚀 Aplicación de Mensajería MSG para Windows
echo ===========================================
echo.

REM Verificar si Flutter está disponible
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Flutter no está instalado o no está en el PATH
    echo 💡 Instala Flutter desde: https://flutter.dev/docs/get-started/install/windows
    pause
    exit /b 1
)

echo ✅ Flutter detectado
echo.

REM Verificar dispositivos
echo 📱 Dispositivos disponibles:
flutter devices
echo.

echo 🔧 Opciones de ejecución:
echo [1] Chrome (Web) - Recomendado ⭐
echo [2] Edge (Web) - Alternativo
echo [3] Windows nativo - Requiere CMake 3.23+
echo [4] Solo instalar dependencias
echo [5] Limpiar y reinstalar todo (si hay errores)
echo.

set /p choice="Elige una opción (1-5): "

if "%choice%"=="1" (
    echo 🌐 Ejecutando en Chrome...
    flutter run -d chrome
) else if "%choice%"=="2" (
    echo 🌐 Ejecutando en Edge...
    flutter run -d edge
) else if "%choice%"=="3" (
    echo 💻 Ejecutando en Windows nativo...
    echo ⚠️  Asegúrate de tener CMake 3.23+ instalado
    echo 📖 Verifica: WINDOWS_README.md para más detalles
    flutter run -d windows
) else if "%choice%"=="4" (
    echo 📦 Instalando dependencias...
    flutter pub get
    echo ✅ Dependencias instaladas correctamente
    echo 💡 Ahora puedes ejecutar la aplicación con:
    echo    run.bat (este script)
    echo    flutter run -d chrome (recomendado)
) else if "%choice%"=="5" (
    echo 🧹 Limpiando y reinstalando todo...
    flutter clean
    flutter pub get
    echo ✅ Limpieza completada
    echo 💡 Reinicia run.bat y elige opción 1 para ejecutar
) else (
    echo ❌ Opción no válida
    echo 💡 Ejecuta run.bat nuevamente y elige una opción válida
)

echo.
pause
