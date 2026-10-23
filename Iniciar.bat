@echo off
setlocal enabledelayedexpansion

:: 1. Garantizar que la ruta de ejecucion sea el directorio donde reside el .bat
cd /d "%~dp0"

echo ========================================================
echo         INICIALIZACION Y VERIFICACION DE ENTORNO
echo ========================================================
echo.

:: 2. Verificar existencia de Python global en PATH
where python >nul 2>&1
if %errorlevel% neq 0 (
  echo [ERROR CRITICO] Python no esta detectado en el PATH del sistema.
  echo Reinstale Python asegurandose de marcar 'Add python.exe to PATH'.
  echo.
  pause
  exit /b 1
)

:: 3. Deteccion y correccion automatica de extensiones oculta .txt
if exist "run_server.py.txt" ren "run_server.py.txt" "run_server.py"
if exist "run_server.pyw.txt" ren "run_server.pyw.txt" "run_server.pyw"

:: 4. Validar existencia del script Python objetivo
set "SCRIPT_NAME="
if exist "run_server.pyw" (
  set "SCRIPT_NAME=run_server.pyw"
) else if exist "run_server.py" (
  set "SCRIPT_NAME=run_server.py"
) else (
  echo [ERROR CRITICO] No se encontro 'run_server.py' ni 'run_server.pyw' en el directorio:
  echo %CD%
  echo.
  pause
  exit /b 1
)

:: 5. Autocuracion del entorno virtual (venv)
if not exist "venv\Scripts\python.exe" (
  echo [ADVERTENCIA] Entorno virtual no encontrado o dañado.
  echo [INFO] Creando nuevo entorno virtual en '%CD%\venv'...
  python -m venv venv
  if %errorlevel% neq 0 (
    echo [ERROR CRITICO] No se pudo crear el entorno virtual.
    pause
    exit /b 1
  )
  
  echo [INFO] Actualizando gestor de paquetes pip...
  venv\Scripts\python.exe -m pip install --upgrade pip
  
  if exist "requirements.txt" (
    echo [INFO] Instalando dependencias desde requirements.txt...
    venv\Scripts\pip.exe install -r requirements.txt
  ) else (
    echo [INFO] requirements.txt no encontrado. Instalando paquetes base requeridos...
    venv\Scripts\pip.exe install uvicorn fastapi pydantic jinja2
  )
)

:: 6. Limpiar archivo de log previo si existe
if exist "server_error.log" del /f /q "server_error.log"

:: 7. Lanzamiento de servidor
echo [INFO] Ejecutando !SCRIPT_NAME! mediante entorno virtual...
start "" /b "%~dp0venv\Scripts\pythonw.exe" "%~dp0!SCRIPT_NAME!"

:: Esperar 2 segundos para validar si la aplicacion fallo inmediatamente al arrancar
timeout /t 2 /nobreak >nul

if exist "server_error.log" (
  echo.
  echo ========================================================
  echo [ERROR] SE DETECTO UN FALLO DURANTE EL ARRANQUE
  echo ========================================================
  type "server_error.log"
  echo.
  pause
  exit /b 1
) else (
  echo [EXITO] Servidor iniciado correctamente en segundo plano.
  timeout /t 3 >nul
  exit /b 0
)