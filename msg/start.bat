@echo off
REM Script para ejecutar MSG directamente en Chrome (Windows)
REM Evita el menú de selección de dispositivos

echo 🚀 Iniciando aplicación MSG en Chrome...
echo =====================================

REM Verificar si Flutter está disponible
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Flutter no está instalado o no está en el PATH
    echo 💡 Instala Flutter desde: https://flutter.dev/docs/get-started/install/windows
    pause
    exit /b 1
)

echo ✅ Flutter detectado

REM Detener cualquier proceso anterior
taskkill /f /im dart.exe 2>nul
taskkill /f /im flutter.exe 2>nul

echo.
echo 🌐 Ejecutando en Chrome (Web)...
echo 💡 Esto es lo más compatible para Windows
echo.

flutter run -d chrome

echo.
echo 📖 Si tienes problemas, consulta:
echo - WINDOWS_README.md (instrucciones específicas)
echo - MULTIMEDIA_README.md (funcionalidades)
echo.
echo 💡 Para opciones avanzadas, usa: run.bat

pause
