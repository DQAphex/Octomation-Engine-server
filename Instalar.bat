@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ============================================================
:: CONFIGURACION
:: ============================================================

cd /d "%~dp0"

set "ROOT=%~dp0"
set "VENV=%ROOT%venv"
set "PYTHON=%VENV%\Scripts\python.exe"
set "REQUIREMENTS=%ROOT%requirements.txt"

echo.
echo ============================================================
echo        INSTALADOR DE LA APLICACION
echo ============================================================
echo.
echo Directorio:
echo %ROOT%
echo.

:: ============================================================
:: 1. VERIFICAR PYTHON
:: ============================================================

echo [1/4] Verificando Python...

where python >nul 2>&1

if errorlevel 1 (
    echo.
    echo [ERROR] Python no fue encontrado en el PATH.
    echo.
    echo Este equipo necesita Python instalado y agregado al PATH.
    echo.
    echo Puedes comprobarlo ejecutando:
    echo.
    echo     python --version
    echo.
    pause
    exit /b 1
)

python --version

if errorlevel 1 (
    echo.
    echo [ERROR] El comando Python existe, pero no puede ejecutarse.
    echo.
    pause
    exit /b 1
)

echo [OK] Python encontrado.
echo.

:: ============================================================
:: 2. VERIFICAR REQUIREMENTS.TXT
:: ============================================================

echo [2/4] Verificando requirements.txt...

if not exist "%REQUIREMENTS%" (
    echo.
    echo [ERROR] No se encontro:
    echo %REQUIREMENTS%
    echo.
    echo Asegurate de que requirements.txt este junto a este .bat.
    echo.
    pause
    exit /b 1
)

echo [OK] requirements.txt encontrado.
echo.

:: ============================================================
:: 3. CREAR ENTORNO VIRTUAL
:: ============================================================

echo [3/4] Preparando entorno virtual...

if not exist "%VENV%\Scripts\python.exe" (

    echo Creando entorno virtual...
    echo.

    python -m venv "%VENV%"

    if errorlevel 1 (
        echo.
        echo ============================================================
        echo [ERROR] No fue posible crear el entorno virtual.
        echo ============================================================
        echo.
        echo Se ejecuto:
        echo python -m venv "%VENV%"
        echo.
        echo Verifica que tu instalacion de Python incluya el modulo venv.
        echo.
        pause
        exit /b 1
    )

    echo [OK] Entorno virtual creado.

) else (

    echo [OK] El entorno virtual ya existe.

)

echo.

:: ============================================================
:: 4. INSTALAR DEPENDENCIAS
:: ============================================================

echo [4/4] Instalando dependencias...
echo.

if not exist "%PYTHON%" (
    echo.
    echo [ERROR] No se encontro el Python del entorno virtual:
    echo %PYTHON%
    echo.
    pause
    exit /b 1
)

echo Actualizando pip...
"%PYTHON%" -m pip install --upgrade pip

if errorlevel 1 (
    echo.
    echo [ERROR] No fue posible actualizar pip.
    echo.
    pause
    exit /b 1
)

echo.
echo Instalando requirements.txt...
echo.

"%PYTHON%" -m pip install -r "%REQUIREMENTS%"

if errorlevel 1 (
    echo.
    echo ============================================================
    echo [ERROR] Fallo la instalacion de dependencias.
    echo ============================================================
    echo.
    pause
    exit /b 1
)

:: ============================================================
:: FINALIZADO
:: ============================================================

echo.
echo ============================================================
echo       INSTALACION COMPLETADA EXITOSAMENTE
echo ============================================================
echo.
echo Entorno virtual:
echo %VENV%
echo.
echo Python:
echo %PYTHON%
echo.
echo Ahora puedes ejecutar:
echo INICIAR.bat
echo.
echo ============================================================

pause
exit /b 0