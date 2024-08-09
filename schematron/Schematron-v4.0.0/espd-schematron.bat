@echo off 

rem +----------------------------------+
rem | ESPD validation using Schematron |
rem | espd-schematron, v4.0.0 2024/07  |
rem +----------------------------------+

rem setup all files
setlocal EnableDelayedExpansion
rem PAHSE 0
set gcxsd="common\xsd\genericode.xsd"
set gclog="logs\gc\01-GC_Files.txt"

rem PHASE 1 - Request
set cva_filename="common\cva\01-ESPD-codelist-values.cva"
set xslt_cva2sch="common\xsl\Crane-cva2schXSLT.xsl"

set sch_xsl_filename_req="logs\ESPDRequest\output\01-ESPD-codelist-values.xsl"
set sch_filename_req="ESPDRequest\sch\01-ESPD-codelist-values.sch"
set cva2schlog_req="logs\ESPDRequest\01-CVAtoSCH.txt"
rem PHASE 1 - Response
set sch_xsl_filename_res="logs\ESPDResponse\output\01-ESPD-codelist-values.xsl"
set sch_filename_res="ESPDResponse\sch\01-ESPD-codelist-values.sch"
set cva2schlog_res="logs\ESPDResponse\01-CVAtoSCH.txt"

rem PAHSE 2 - Request
set xslt_sch2xslt="common\xsl\iso_svrl_for_xslt2.xsl"
set schtoxsllog_req="logs\ESPDRequest\02-SCHtoXSL.txt"
set schtoxsllog_res="logs\ESPDResponse\02-SCHtoXSL.txt"

set ph2req[0].sch="ESPDRequest\sch\01-ESPD-codelist-values.sch"
set ph2req[0].xsl="ESPDRequest\xsl\01-ESPD-codelist-values.xsl"
set ph2req[1].sch="ESPDRequest\sch\02-ESPD-req-cardinality-br.sch"
set ph2req[1].xsl="ESPDRequest\xsl\02-ESPD-req-cardinality-br.xsl"
set ph2req[2].sch="common\sch\04-ESPD-common-other-br.sch"
set ph2req[2].xsl="ESPDRequest\xsl\04-ESPD-common-other-br.xsl"
set ph2req[3].sch="ESPDRequest\sch\05-ESPD-req-procurer-br.sch"
set ph2req[3].xsl="ESPDRequest\xsl\05-ESPD-req-procurer-br.xsl"
set ph2req[4].sch="ESPDRequest\sch\04-ESPD-req-other-br.sch"
set ph2req[4].xsl="ESPDRequest\xsl\04-ESPD-req-other-br.xsl"
set ph2req[5].sch="common\sch\03-ESPD-common-criterion-br.sch"
set ph2req[5].xsl="ESPDRequest\xsl\03-ESPD-common-criterion-br.xsl"
set ph2req[6].sch="ESPDRequest\sch\03-ESPD-req-criterion-br.sch"
set ph2req[6].xsl="ESPDRequest\xsl\03-ESPD-req-criterion-br.xsl"
set ph2req[7].sch="common\sch\01-ESPD-common-cl-attributes.sch"
set ph2req[7].xsl="ESPDRequest\xsl\01-ESPD-common-cl-attributes.xsl"
set ph2req[8].sch="ESPDRequest\sch\05-ESPD-req-specific-br.sch"
set ph2req[8].xsl="ESPDRequest\xsl\05-ESPD-req-specific-br.xsl"
set ph2req[9].sch="common\sch\01-ESPD-common-cl-values-restrictions.sch"
set ph2req[9].xsl="ESPDRequest\xsl\01-ESPD-common-cl-values-restrictions.xsl"

rem PAHSE 2 - Response
set ph2res[0].sch="ESPDResponse\sch\01-ESPD-codelist-values.sch"
set ph2res[0].xsl="ESPDResponse\xsl\01-ESPD-codelist-values.xsl"
set ph2res[1].sch="ESPDResponse\sch\02-ESPD-resp-cardinality-br.sch"
set ph2res[1].xsl="ESPDResponse\xsl\02-ESPD-resp-cardinality-br.xsl"
set ph2res[2].sch="common\sch\04-ESPD-common-other-br.sch"
set ph2res[2].xsl="ESPDResponse\xsl\04-ESPD-common-other-br.xsl"
set ph2res[3].sch="ESPDResponse\sch\05-ESPD-resp-eo-br.sch"
set ph2res[3].xsl="ESPDResponse\xsl\05-ESPD-resp-eo-br.xsl"
set ph2res[4].sch="ESPDResponse\sch\04-ESPD-resp-other-br.sch"
set ph2res[4].xsl="ESPDResponse\xsl\04-ESPD-resp-other-br.xsl"
set ph2res[5].sch="common\sch\03-ESPD-common-criterion-br.sch"
set ph2res[5].xsl="ESPDResponse\xsl\03-ESPD-common-criterion-br.xsl"
set ph2res[6].sch="ESPDResponse\sch\05-ESPD-resp-role-br.sch"
set ph2res[6].xsl="ESPDResponse\xsl\05-ESPD-resp-role-br.xsl"
set ph2res[7].sch="ESPDResponse\sch\03-ESPD-resp-criterion-br.sch"
set ph2res[7].xsl="ESPDResponse\xsl\03-ESPD-resp-criterion-br.xsl"
set ph2res[8].sch="ESPDResponse\sch\05-ESPD-resp-qualification-br.sch"
set ph2res[8].xsl="ESPDResponse\xsl\05-ESPD-resp-qualification-br.xsl"
set ph2res[9].sch="ESPDResponse\sch\05-ESPD-resp-specific-br.sch"
set ph2res[9].xsl="ESPDResponse\xsl\05-ESPD-resp-specific-br.xsl"
set ph2res[10].sch="common\sch\01-ESPD-common-cl-attributes.sch"
set ph2res[10].xsl="ESPDResponse\xsl\01-ESPD-common-cl-attributes.xsl"
set ph2res[11].sch="common\sch\01-ESPD-common-cl-values-restrictions.sch"
set ph2res[11].xsl="ESPDResponse\xsl\01-ESPD-common-cl-values-restrictions.xsl"

rem PAHSE 3 - Request
set xml_test_req="common\xml\ESPD-Request-BASE.xml"
set xsd_test_req="common\xsdrt\maindoc\UBL-QualificationApplicationRequest-2.3.xsd"
set xsd_output_req="logs\ESPDRequest\output\result-xsd.xml"
set log_req="logs\ESPDRequest\03-validation.txt"

set ph3req[0].xsl="ESPDRequest\xsl\01-ESPD-codelist-values.xsl"
set ph3req[1].xsl="ESPDRequest\xsl\02-ESPD-req-cardinality-br.xsl"
set ph3req[2].xsl="ESPDRequest\xsl\04-ESPD-common-other-br.xsl"
set ph3req[3].xsl="ESPDRequest\xsl\05-ESPD-req-procurer-br.xsl"
set ph3req[4].xsl="ESPDRequest\xsl\04-ESPD-req-other-br.xsl"
set ph3req[5].xsl="ESPDRequest\xsl\03-ESPD-common-criterion-br.xsl"
set ph3req[6].xsl="ESPDRequest\xsl\03-ESPD-req-criterion-br.xsl"
set ph3req[7].xsl="ESPDRequest\xsl\01-ESPD-common-cl-attributes.xsl"
set ph3req[8].xsl="ESPDRequest\xsl\05-ESPD-req-specific-br.xsl"
set ph3req[9].xsl="ESPDRequest\xsl\01-ESPD-common-cl-values-restrictions.xsl"

set ph3req[0].output="logs\ESPDRequest\output\01-ESPD-codelist-values.xml"
set ph3req[1].output="logs\ESPDRequest\output\02-ESPD-req-cardinality-br.xml"
set ph3req[2].output="logs\ESPDRequest\output\04-ESPD-common-other-br.xml"
set ph3req[3].output="logs\ESPDRequest\output\05-ESPD-req-procurer-br.xml"
set ph3req[4].output="logs\ESPDRequest\output\04-ESPD-req-other-br.xml"
set ph3req[5].output="logs\ESPDRequest\output\03-ESPD-common-criterion-br.xml"
set ph3req[6].output="logs\ESPDRequest\output\03-ESPD-req-criterion-br.xml"
set ph3req[7].output="logs\ESPDRequest\output\01-ESPD-common-cl-attributes.xml"
set ph3req[8].output="logs\ESPDRequest\output\05-ESPD-req-specific-br.xml"
set ph3req[9].output="logs\ESPDRequest\output\01-ESPD-common-cl-values-restrictions.xml"

rem PAHSE 3 - Response
set xml_test_res="common\xml\ESPD-Response-BASE.xml"
set xsd_test_res="common\xsdrt\maindoc\UBL-QualificationApplicationResponse-2.3.xsd"
set xsd_output_res="logs\ESPDResponse\output\result-xsd.xml"
set log_res="logs\ESPDResponse\03-validation.txt"

set ph3res[0].xsl="ESPDResponse\xsl\01-ESPD-codelist-values.xsl"
set ph3res[1].xsl="ESPDResponse\xsl\02-ESPD-resp-cardinality-br.xsl"
set ph3res[2].xsl="ESPDResponse\xsl\04-ESPD-common-other-br.xsl"
set ph3res[3].xsl="ESPDResponse\xsl\05-ESPD-resp-eo-br.xsl"
set ph3res[4].xsl="ESPDResponse\xsl\04-ESPD-resp-other-br.xsl"
set ph3res[5].xsl="ESPDResponse\xsl\03-ESPD-common-criterion-br.xsl"
set ph3res[6].xsl="ESPDResponse\xsl\05-ESPD-resp-role-br.xsl"
set ph3res[7].xsl="ESPDResponse\xsl\03-ESPD-resp-criterion-br.xsl"
set ph3res[8].xsl="ESPDResponse\xsl\05-ESPD-resp-qualification-br.xsl"
set ph3res[9].xsl="ESPDResponse\xsl\05-ESPD-resp-specific-br.xsl"
set ph3res[10].xsl="ESPDResponse\xsl\01-ESPD-common-cl-attributes.xsl"
set ph3res[11].xsl="ESPDResponse\xsl\01-ESPD-common-cl-values-restrictions.xsl"

set ph3res[0].output="logs\ESPDResponse\output\01-ESPD-codelist-values.xml"
set ph3res[1].output="logs\ESPDResponse\output\02-ESPD-resp-cardinality-br.xml"
set ph3res[2].output="logs\ESPDResponse\output\04-ESPD-common-other-br.xml"
set ph3res[3].output="logs\ESPDResponse\output\05-ESPD-resp-eo-br.xml"
set ph3res[4].output="logs\ESPDResponse\output\04-ESPD-resp-other-br.xml"
set ph3res[5].output="logs\ESPDResponse\output\03-ESPD-common-criterion-br.xml"
set ph3res[6].output="logs\ESPDResponse\output\05-ESPD-resp-role-br.xml"
set ph3res[7].output="logs\ESPDResponse\output\03-ESPD-resp-criterion-br.xml"
set ph3res[8].output="logs\ESPDResponse\output\05-ESPD-resp-qualification-br.xml"
set ph3res[9].output="logs\ESPDResponse\output\05-ESPD-resp-specific-br.xml"
set ph3res[10].output="logs\ESPDResponse\output\01-ESPD-common-cl-attributes.xml"
set ph3res[11].output="logs\ESPDResponse\output\01-ESPD-common-cl-values-restrictions.xml"


rem [- START PROCESSING -]

call :banner PHASE 0
echo Precondition validation ...
rem check logs and output folders
if exist logs rmdir /S /Q logs
mkdir logs\gc logs\ESPDRequest\output logs\ESPDResponse\output
call :msg logs folder OK

echo Validating Code Lists in gc folder ...

echo ------------------------------------------- >  %gclog%
echo Phase 0: Validating Code Lists in gc folder >> %gclog%
echo ------------------------------------------- >> %gclog%

for %%f in (gc\*.gc) do (
    echo Processing file %%f >> %gclog%
    call :xjparse %gcxsd% %%f %gclog%
    if %errorlevel% neq 0 goto :error_gc
)

echo.
call :msg Done successfully checking Code Lists.

rem --- End of Phase 0 ---

call :banner PHASE 1
echo CVA to XLS transformation ...
del /F /Q logs\ESPDRequest\output\*.* logs\ESPDResponse\output\*.* %sch_filename_req% %sch_filename_res%

echo ------------------------------------------------- >  %cva2schlog_req%
echo Phase 1: ESPD Request transform CVA to XSL to SCH >> %cva2schlog_req%
echo ------------------------------------------------- >> %cva2schlog_req%
echo Processing %cva_filename% %xslt_cva2sch% %sch_xsl_filename_req% >> %cva2schlog_req%
call :saxonica %cva_filename% %xslt_cva2sch% %sch_xsl_filename_req% %cva2schlog_req%
if %errorlevel% neq 0 goto :error_cva2sch

echo Processing %sch_xsl_filename_req% %sch_xsl_filename_req% %sch_filename_req% >> %cva2schlog_req%
call :saxonica %sch_xsl_filename_req% %sch_xsl_filename_req% %sch_filename_req% %cva2schlog_req%
if %errorlevel% neq 0 goto :error_cva2sch

echo -------------------------------------------------- >  %cva2schlog_res%
echo Phase 1: ESPD Response transform CVA to XSL to SCH >> %cva2schlog_res%
echo -------------------------------------------------- >> %cva2schlog_res%
echo Processing %cva_filename% %xslt_cva2sch% %sch_xsl_filename_res% >> %cva2schlog_res%
call :saxonica %cva_filename% %xslt_cva2sch% %sch_xsl_filename_res% %cva2schlog_res%
if %errorlevel% neq 0 goto :error_cva2sch

echo Processing %sch_xsl_filename_res% %sch_xsl_filename_res% %sch_filename_res% >> %cva2schlog_res%
call :saxonica %sch_xsl_filename_res% %sch_xsl_filename_res% %sch_filename_res% %cva2schlog_res%
if %errorlevel% neq 0 goto :error_cva2sch

echo.
call :msg Done successfully transforming CVA to XSL to SCH

rem --- End of Phase 1 ---

call :banner PHASE 2
echo SCH to XSL transformation ...

echo ------------------------------------------ >  %schtoxsllog_req%
echo Phase 2: ESPD Request transform SCH to XSL >> %schtoxsllog_req%
echo ------------------------------------------ >> %schtoxsllog_req%

for /L %%i in (0 1 9) do (
  echo Processing !ph2req[%%i].sch! %xslt_sch2xslt% !ph2req[%%i].xsl! >> %schtoxsllog_req%
  call :saxonica %%ph2req[%%i].sch%% %xslt_sch2xslt% %%ph2req[%%i].xsl%% %schtoxsllog_req%
  if %errorlevel% neq 0 goto :error_sch2xs
)

echo ------------------------------------------- >  %schtoxsllog_res%
echo Phase 2: ESPD Response transform SCH to XSL >> %schtoxsllog_res%
echo ------------------------------------------- >> %schtoxsllog_res%

for /L %%i in (0 1 11) do (
  echo Processing !ph2res[%%i].sch! %xslt_sch2xslt% !ph2res[%%i].xsl! >> %schtoxsllog_res%
  call :saxonica %%ph2res[%%i].sch%% %xslt_sch2xslt% %%ph2res[%%i].xsl%% %schtoxsllog_res%
  if %errorlevel% neq 0 goto :error_sch2xs
)

echo.
call :msg Done successfully transforming SCH to XSL

rem --- End of Phase 2 ---

call :banner PHASE 3
echo ESPD Document validation vs UBL and XSL ...

echo ----------------------------------------------- >  %log_req%
echo Phase 3: ESPD Request validation vs UBL and XSL >> %log_req%
echo ----------------------------------------------- >> %log_req%

echo Checking UBL XSD file ...
if not exist %xsd_test_req% goto :nofile

echo Validating against %xsd_test_req% >> %log_req%
call :xjparse %xsd_test_req% %xml_test_req% %xsd_output_req%
if %errorlevel% neq 0 goto :error_validation

for /L %%i in (0 1 9) do (
  echo Validating against !ph3req[%%i].xsl! >> %log_req%
  call :saxonica %xml_test_req% %%ph3req[%%i].xsl%% %%ph3req[%%i].output%% %log_req%
  if %errorlevel% neq 0 goto :error_validation
)

echo ------------------------------------------------ >  %log_res%
echo Phase 3: ESPD Response validation vs UBL and XSL >> %log_res%
echo ------------------------------------------------ >> %log_res%

echo Checking UBL XSD file ...
if not exist %xsd_test_res% goto :nofile

echo Validating against %xsd_test_res% >> %log_res%
call :xjparse %xsd_test_res% %xml_test_res% %xsd_output_res%
if %errorlevel% neq 0 goto :error_validation

for /L %%i in (0 1 11) do (
  echo Validating against !ph3res[%%i].xsl! >> %log_res%
  call :saxonica %xml_test_res% %%ph3res[%%i].xsl%% %%ph3res[%%i].output%% %log_res%
  if %errorlevel% neq 0 goto :error_validation
)
echo.
call :msg Done successfully validating ESPD Document

rem --- End of Phase 3 ---

goto :done

rem ESPD Dcoument valiation error
:error_validation
echo.
echo [101m(!)[0m Error validating ESPD Document; process terminated!
goto :done

rem Code Lists validation error
:error_gc
echo.
echo [101m(!)[0m Error validating Code Lists; process terminated!
goto :done

rem CVA to SCH transformation error
:error_cva2sch
echo.
echo [101m(!)[0m Error transforming CVA to XSL to SCH; process terminated!
goto :done

rem SCH to XSL transformation error
:error_sch2xsl
echo.
echo [101m(!)[0m Error transforming SCH to XSL; process terminated!
goto :done

rem Checking UBL XSD files
:nofile
echo.
echo [101m(!)[0m Error UBL XSD file not found
goto :done

rem XJPARSE local function
rem <param> - the XSD file for validation
rem <param> - the XML file to be validated
rem <param> - the log file
:xjparse
echo xjparse %*
java -jar "common\lib\xjparse-app-3.0.0.jar" -S %1 %2 2>&1 >> %3
EXIT /B

rem SAXON XSLT transformation local function
rem <param> - the input file 
rem <param> - the XSL transfomer file
rem <param> - the output file
rem <param> - the log file
:saxonica
echo saxon %3 %1 %2 %4
java -jar "common\lib\saxon-he-12.5.jar" -o:%3 %1 %2 2>&1 >> %4
EXIT /B

rem Auxiliary message display function
:msg
echo.
echo [1m[32m[X][0m %*
echo.
EXIT /B

rem Auxiliary banner display function
:banner
echo.
echo [7m +++ %* +++ [0m
echo.
EXIT /B

rem [-THE END-]
:done
endlocal
rem ___________