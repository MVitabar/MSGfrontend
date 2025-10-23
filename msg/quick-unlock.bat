@echo off
REM Script rápido para desbloquear archivos Gradle
echo 🔓 DESBLOQUEANDO ARCHIVOS GRADLE...
echo.

REM Matar procesos que bloquean archivos
echo 🛑 Matando procesos...
taskkill /f /im "gradle.exe" 2>nul
taskkill /f /im "java.exe" 2>nul
taskkill /f /im "kotlin-compiler-daemon.exe" 2>nul

echo ⏳ Esperando que se liberen archivos...
timeout /t 2 /nobreak >nul

echo ✅ ¡Desbloqueo completado!
echo 🚀 Ahora intenta: flutter build apk --debug
echo.

pause
