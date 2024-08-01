@echo off 

rem +----------------------------------+
rem | ESPD validation using Schematron |
rem | espd-schematron, v4.0.0 2024/07  |
rem +----------------------------------+


echo Precondition validation...
rem check output folders
if exist logs (
    echo logs folder OK
) else (
    mkdir logs
)
if exist ESPDRequest\output\logs\ (
  echo ESPDRequest output log forlders OK 
) else (
  mkdir ESPDRequest\output\logs
)
if exist ESPDResponse\output\logs\ (
  echo ESPDResponse output log forlders OK 
) else (
  mkdir ESPDResponse\output\logs
)
echo.

echo.
echo Validating Code Lists in gc folder...
echo using: common\bat\w3cschema common\xsd\genericode.xsd "gc\*.gc"
del logs\*.txt

for %%f in (gc\*.gc) do (
    echo Processing file %%f >>logs\1-GC_Files.txt
    call common\bat\w3cschema common\xsd\genericode.xsd %%f 2>&1 >>logs\1-GC_Files.txt
)
if %errorlevel% neq 0 goto :error

echo.
echo Done checking Code Lists.
goto :done

:error
echo.
echo Error validating Code Lists; process terminated!
goto :done

:done