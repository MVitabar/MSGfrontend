@echo off
REM Script COMPLETO para limpiar TODO y verificar espacio
echo 🚨 LIMPIEZA TOTAL DEL SISTEMA - Liberando espacio para Flutter...
echo.

REM ========================================
REM ELIMINAR CACHÉ GLOBAL DE GRADLE
REM ========================================
echo 🗑️  Eliminando caché global de Gradle...
if exist "%USERPROFILE%\.gradle" (
    for /f "tokens=*" %%i in ('dir "%USERPROFILE%\.gradle" /s /b 2^>nul') do (
        echo Eliminando: %%i
        del /f /q "%%i" 2>nul
    )
    rmdir /s /q "%USERPROFILE%\.gradle" 2>nul
    echo ✅ Caché global de Gradle eliminada
)

REM ========================================
REM ELIMINAR CACHÉS DE FLUTTER GLOBALES
REM ========================================
echo 🗑️  Eliminando cachés de Flutter globales...
if exist "%USERPROFILE%\.pub-cache" (
    rmdir /s /q "%USERPROFILE%\.pub-cache" 2>nul
    echo ✅ Caché de pub eliminada
)

REM ========================================
REM LIMPIAR TEMPORALES DEL SISTEMA
REM ========================================
echo 🧹 Limpiando archivos temporales del sistema...

REM Limpiar %TEMP%
if exist "%TEMP%" (
    for /f "delims=" %%i in ('dir "%TEMP%" /b /ad 2^>nul') do (
        rmdir /s /q "%TEMP%\%%i" 2>nul
    )
    echo ✅ Archivos temporales de usuario limpiados
)

REM Limpiar Windows Temp
if exist "C:\Windows\Temp" (
    for /f "delims=" %%i in ('dir "C:\Windows\Temp" /b /ad 2^>nul') do (
        rmdir /s /q "C:\Windows\Temp\%%i" 2>nul
    )
    echo ✅ Archivos temporales de Windows limpiados
)

REM ========================================
REM VERIFICAR ESPACIO LIBERADO
REM ========================================
echo.
echo 📊 VERIFICANDO ESPACIO EN DISCO...
echo ========================================

wmic logicaldisk where "DeviceID='C:'" get size,freespace,caption

echo.
echo ========================================
echo ✅ LIMPIEZA COMPLETADA
echo ========================================
echo.
echo 💡 PRÓXIMOS PASOS:
echo.
echo 1️⃣  Ejecuta la limpieza de disco de Windows:
echo    - Win + R → cleanmgr → Enter
echo    - Selecciona todas las opciones disponibles
echo.
echo 2️⃣  Vacía la papelera de reciclaje
echo.
echo 3️⃣  Elimina descargas antiguas
echo.
echo 4️⃣  Después de tener 3-4GB libres:
echo    flutter build apk --debug
echo.
echo ========================================
echo.

pause
