@echo off

echo Cerrando procesos Python...

taskkill /F /IM python.exe >nul 2>&1
taskkill /F /IM pythonw.exe >nul 2>&1

echo.
echo Procesos Python cerrados.
echo Puerto 8000 liberado.
echo.

pause