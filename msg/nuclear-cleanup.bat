@echo off
REM Script NUCLEAR para limpiar TODAS las cachés - RUTA CORRECTA
echo 💣 LIMPIEZA NUCLEAR - Proyecto en d:\MSGfrontend\msg
echo.

REM ========================================
REM MATAR PROCESOS
REM ========================================
echo 🛑 Matando procesos Gradle/Java...
taskkill /f /im "gradle.exe" 2>nul
taskkill /f /im "java.exe" 2>nul
taskkill /f /im "kotlin-compiler-daemon.exe" 2>nul

timeout /t 2 /nobreak >nul

REM ========================================
REM ELIMINAR CACHÉ GLOBAL DE GRADLE
REM ========================================
echo 🗑️  Eliminando caché global de Gradle...
if exist "%USERPROFILE%\.gradle" (
    echo 📊 Tamaño antes: & dir "%USERPROFILE%\.gradle" /s | findstr "bytes" | tail -1
    rmdir /s /q "%USERPROFILE%\.gradle" 2>nul
    if exist "%USERPROFILE%\.gradle" (
        echo ⚠️  Intentando método alternativo...
        powershell -Command "Remove-Item -Path '$env:USERPROFILE\.gradle' -Recurse -Force -ErrorAction SilentlyContinue"
    )
    echo ✅ Caché global de Gradle eliminada
)

REM ========================================
REM ELIMINAR CACHÉ DEL PROYECTO
REM ========================================
echo 🗑️  Eliminando caché del proyecto...
if exist "d:\MSGfrontend\msg\android\.gradle" (
    rmdir /s /q "d:\MSGfrontend\msg\android\.gradle" 2>nul
    echo ✅ Caché del proyecto eliminada
)

REM ========================================
REM LIMPIAR ARCHIVOS DE FLUTTER
REM ========================================
echo 🧹 Limpiando Flutter...
if exist "d:\MSGfrontend\msg\build" rmdir /s /q "d:\MSGfrontend\msg\build" 2>nul
if exist "d:\MSGfrontend\msg\.flutter-plugins-dependencies" del /q "d:\MSGfrontend\msg\.flutter-plugins-dependencies" 2>nul
if exist "d:\MSGfrontend\msg\.dart_tool" rmdir /s /q "d:\MSGfrontend\msg\.dart_tool" 2>nul

echo ✅ Archivos de Flutter limpiados

REM ========================================
REM VERIFICAR CONFIGURACIÓN
REM ========================================
echo 🔍 Verificando configuración...
if exist "d:\MSGfrontend\msg\android\settings.gradle.kts" (
    echo ✅ settings.gradle.kts OK
) else (
    echo ❌ settings.gradle.kts NO encontrado
)

if exist "d:\MSGfrontend\msg\android\app\build.gradle.kts" (
    echo ✅ app/build.gradle.kts OK
) else (
    echo ❌ app/build.gradle.kts NO encontrado
)

REM ========================================
REM REGENERAR
REM ========================================
echo ⏳ Esperando liberación de archivos...
timeout /t 3 /nobreak >nul

echo 🔄 Regenerando Flutter...
cd /d "d:\MSGfrontend\msg"
flutter clean
flutter pub get

echo.
echo ========================================
echo ✅ LIMPIEZA NUCLEAR COMPLETADA
echo ========================================
echo.
echo 📍 PROYECTO: d:\MSGfrontend\msg
echo ✅ Caché global de Gradle: Eliminada
echo ✅ Caché del proyecto: Eliminada
echo ✅ Archivos temporales: Eliminados
echo ✅ Configuración: Verificada
echo.
echo 🚀 PRÓXIMOS PASOS:
echo cd /d "d:\MSGfrontend\msg"
echo flutter build apk --debug
echo.
echo 💡 Si aún hay problemas:
echo 1. Reinicia la computadora
echo 2. Asegúrate de tener 3-4GB libres en disco C:
echo 3. Ejecuta como administrador
echo.
echo ========================================
echo.

pause
