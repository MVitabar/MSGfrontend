@echo off
REM Script para limpiar caché global de Gradle y verificar espacio
echo 🧹 LIMPIANDO CACHÉ GLOBAL DE GRADLE...
echo.

REM ========================================
REM ELIMINAR CACHÉ GLOBAL DE GRADLE
REM ========================================
echo 📁 Buscando caché global de Gradle...
if exist "%USERPROFILE%\.gradle" (
    echo 📊 Tamaño de caché Gradle:
    dir "%USERPROFILE%\.gradle" /s | findstr "bytes"
    echo.
    echo 🗑️  Eliminando caché global de Gradle...
    rmdir /s /q "%USERPROFILE%\.gradle"
    echo ✅ Caché global de Gradle eliminada
) else (
    echo ✅ No hay caché global de Gradle
)

echo.
echo 📊 Verificando espacio en disco...
echo Presiona cualquier tecla para verificar el espacio liberado...
pause >nul

REM Verificar espacio en disco
echo ========================================
echo ESPACIO EN DISCO DISPONIBLE:
echo ========================================
wmic logicaldisk where "DeviceID='C:'" get size,freespace
echo.

echo ========================================
echo ✅ LIMPIEZA COMPLETADA
echo ========================================
echo.
echo 💡 ACCIONES RECOMENDADAS:
echo.
echo 1️⃣  Usa la Herramienta de Liberación de Espacio:
echo    - Presiona Win + R
echo    - Escribe: cleanmgr
echo    - Presiona Enter
echo    - Selecciona todas las opciones
echo.
echo 2️⃣  Elimina archivos temporales manualmente:
echo    - %TEMP%
echo    - C:\Windows\Temp
echo    - Archivos de descarga
echo    - Papelera de reciclaje
echo.
echo 3️⃣  Después de liberar espacio (mínimo 3-4GB):
echo    flutter build apk --debug
echo.
echo ========================================
echo.

pause
