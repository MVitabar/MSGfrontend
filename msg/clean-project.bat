@echo off
REM Limpieza completa del proyecto Flutter
echo 🧹 LIMPIEZA COMPLETA - MSG
echo ===========================
echo.

echo 🛑 Deteniendo procesos...
taskkill /f /im dart.exe 2>nul
taskkill /f /im flutter.exe 2>nul

echo 🗑️  Limpiando Flutter...
flutter clean

echo 🗑️  Limpiando cache...
flutter pub cache clean

echo 📦 Dependencias...
flutter pub get

echo ✅ Limpieza completada
pause
