@echo off
REM Establece el archivo log
set LOGFILE=output.log

REM Configura color (azul: fondo negro, texto verde)
color 0A

REM Mensaje inicial con ASCII art
@echo off
type ascii_art.txt> %LOGFILE%
echo: >> %LOGFILE%

@echo off
type ascii_art.txt
echo:



REM Ejecutar comandos y guardar en el log
echo Ejecutando mvn test >> %LOGFILE%
echo Ejecutando mvn test

REM Echo de la ruta actual concatenada con /target/reports/surefire.html
set REPORT_PATH=%CD%/target/reports/surefire.html
echo Ruta completa del reporte: %REPORT_PATH% >> %LOGFILE%
echo Ruta completa del reporte: %REPORT_PATH%


mvn test -Dtest=RunnerTest >> %LOGFILE% 2>&1

echo Ejecutando mvn surefire-report:report-only >> %LOGFILE%
echo Ejecutando mvn surefire-report:report-only
mvn surefire-report:report-only >> %LOGFILE% 2>&1

REM Mensaje de finalización
echo Finalizado. >> %LOGFILE%
echo Finalizado.

REM Pausar para mantener la ventana abierta
pause
