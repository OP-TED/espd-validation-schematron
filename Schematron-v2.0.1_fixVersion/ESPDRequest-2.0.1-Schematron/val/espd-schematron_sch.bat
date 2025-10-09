@echo off 

set xslt_sch2xslt="..\..\common\xsl\iso_svrl_for_xslt2.xsl"

set one_filename_sch="output\sch\ESPD-codelist-values.sch"
set one_filename_xsl="output\xsl\ESPD-codelist-values.xsl"
set two_filename_sch="sch\02 ESPD Req Cardinality BR.sch"
set two_filename_xsl="output\xsl\02 ESPD Req Cardinality BR.xsl"
set three_filename_sch="..\..\common\sch\03 ESPD Common Other BR.sch"
set three_filename_xsl="output\xsl\03 ESPD Common Other BR.xsl"
set four_filename_sch="sch\04 ESPD Req Procurer BR.sch"
set four_filename_xsl="output\xsl\04 ESPD Req Procurer BR.xsl"
set five_filename_sch="sch\04 ESPD Req Other BR.sch"
set five_filename_xsl="output\xsl\04 ESPD Req Other BR.xsl"
set six_filename_sch="..\..\common\sch\03 ESPD Common Criterion BR.sch"
set six_filename_xsl="output\xsl\03 ESPD Common Criterion BR.xsl"


rem
rem  ESPD validation using Schematron
rem
rem  $Id: espd-schematron,v 1.00 2016/03/14 $
rem

echo.
echo Translating SCH into validation XSL-T...
echo   bat\xslt %one_filename_sch% %xslt_sch2xslt% :: %one_filename_xsl%
call bat\xslt %one_filename_sch% %xslt_sch2xslt% %one_filename_xsl% >output\logs\04-SCHtoXSLT.txt
if %errorlevel% neq 0 goto :error
type output\logs\04-SCHtoXSLT.txt
echo.

echo.
echo   bat\xslt %two_filename_sch% %xslt_sch2xslt% :: %two_filename_xsl%
call bat\xslt %two_filename_sch% %xslt_sch2xslt% %two_filename_xsl% >output\logs\05-SCHtoXSLT.txt
if %errorlevel% neq 0 goto :error
type output\logs\05-SCHtoXSLT.txt
echo.

echo.
echo   bat\xslt %three_filename_sch% %xslt_sch2xslt% :: %three_filename_xsl%
call bat\xslt %three_filename_sch% %xslt_sch2xslt% %three_filename_xsl% >output\logs\06-SCHtoXSLT.txt
if %errorlevel% neq 0 goto :error
type output\logs\06-SCHtoXSLT.txt
echo.

echo.
echo   bat\xslt %four_filename_sch% %xslt_sch2xslt% :: %four_filename_xsl%
call bat\xslt %four_filename_sch% %xslt_sch2xslt% %four_filename_xsl% >output\logs\07-SCHtoXSLT.txt
if %errorlevel% neq 0 goto :error
type output\logs\07-SCHtoXSLT.txt
echo.

echo.
echo   bat\xslt %five_filename_sch% %xslt_sch2xslt% :: %five_filename_xsl%
call bat\xslt %five_filename_sch% %xslt_sch2xslt% %five_filename_xsl% >output\logs\08-SCHtoXSLT.txt
if %errorlevel% neq 0 goto :error
type output\logs\08-SCHtoXSLT.txt
echo.

echo.
echo   bat\xslt %six_filename_sch% %xslt_sch2xslt% :: %six_filename_xsl%
call bat\xslt %six_filename_sch% %xslt_sch2xslt% %six_filename_xsl% >output\logs\09-SCHtoXSLT.txt
if %errorlevel% neq 0 goto :error
type output\logs\09-SCHtoXSLT.txt
echo.


echo.
echo Done.
goto :done

:nofile
echo.
echo Document model for constraints not found: %xsd_test%
goto :done

:error
type test-constraints.txt
echo.
echo Error; process terminated!
goto :done

:done
