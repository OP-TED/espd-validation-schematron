@echo off 

set xslt_sch2xslt="..\common\xsl\iso_svrl_for_xslt2.xsl"

set one_filename_sch="sch\01-ESPD-codelist-values.sch"
set one_filename_xsl="xsl\01-ESPD-codelist-values.xsl"
set two_filename_sch="sch\02-ESPD-req-cardinality-br.sch"
set two_filename_xsl="xsl\02-ESPD-req-cardinality-br.xsl"
set three_filename_sch="..\common\sch\04-ESPD-common-other-br.sch"
set three_filename_xsl="xsl\04-ESPD-common-other-br.xsl"
set four_filename_sch="sch\05-ESPD-req-procurer-br.sch"
set four_filename_xsl="xsl\05-ESPD-req-procurer-br.xsl"
set five_filename_sch="sch\04-ESPD-req-other-br.sch"
set five_filename_xsl="xsl\04-ESPD-req-other-br.xsl"
set six_filename_sch="..\common\sch\03-ESPD-common-criterion-br.sch"
set six_filename_xsl="xsl\03-ESPD-common-criterion-br.xsl"
set seven_filename_sch="sch\03-ESPD-req-criterion-br.sch"
set seven_filename_xsl="xsl\03-ESPD-req-criterion-br.xsl"
set eight_filename_sch="..\common\sch\01-ESPD-common-cl-attributes.sch"
set eight_filename_xsl="xsl\01-ESPD-common-cl-attributes.xsl"
set nine_filename_sch="sch\05-ESPD-req-specific-br.sch"
set nine_filename_xsl="xsl\05-ESPD-req-specific-br.xsl"
set ten_filename_sch="..\common\sch\01-ESPD-common-cl-values-restrictions.sch"
set ten_filename_xsl="xsl\01-ESPD-common-cl-values-restrictions.xsl"


rem
rem  Transforming SCH to XSL
rem
rem  $Id: espd-schematron,v 1.00 2016/03/14 $
rem

echo.
echo Translating SCH into validation XSL-T...
echo   ..\common\bat\xslt %one_filename_sch% %xslt_sch2xslt% :: %one_filename_xsl%
call ..\common\bat\xslt %one_filename_sch% %xslt_sch2xslt% %one_filename_xsl% >output\logs\04-SCHtoXSLT.txt
if %errorlevel% neq 0 goto :error
type output\logs\04-SCHtoXSLT.txt
echo.

echo.
echo   ..\common\bat\xslt %two_filename_sch% %xslt_sch2xslt% :: %two_filename_xsl%
call ..\common\bat\xslt %two_filename_sch% %xslt_sch2xslt% %two_filename_xsl% >output\logs\05-SCHtoXSLT.txt
if %errorlevel% neq 0 goto :error
type output\logs\05-SCHtoXSLT.txt
echo.

echo.
echo   ..\common\bat\xslt %three_filename_sch% %xslt_sch2xslt% :: %three_filename_xsl%
call ..\common\bat\xslt %three_filename_sch% %xslt_sch2xslt% %three_filename_xsl% >output\logs\06-SCHtoXSLT.txt
if %errorlevel% neq 0 goto :error
type output\logs\06-SCHtoXSLT.txt
echo.

echo.
echo   ..\common\bat\xslt %four_filename_sch% %xslt_sch2xslt% :: %four_filename_xsl%
call ..\common\bat\xslt %four_filename_sch% %xslt_sch2xslt% %four_filename_xsl% >output\logs\07-SCHtoXSLT.txt
if %errorlevel% neq 0 goto :error
type output\logs\07-SCHtoXSLT.txt
echo.

echo.
echo   ..\common\bat\xslt %five_filename_sch% %xslt_sch2xslt% :: %five_filename_xsl%
call ..\common\bat\xslt %five_filename_sch% %xslt_sch2xslt% %five_filename_xsl% >output\logs\08-SCHtoXSLT.txt
if %errorlevel% neq 0 goto :error
type output\logs\08-SCHtoXSLT.txt
echo.

echo.
echo   ..\common\bat\xslt %six_filename_sch% %xslt_sch2xslt% :: %six_filename_xsl%
call ..\common\bat\xslt %six_filename_sch% %xslt_sch2xslt% %six_filename_xsl% >output\logs\09-SCHtoXSLT.txt
if %errorlevel% neq 0 goto :error
type output\logs\09-SCHtoXSLT.txt
echo.

echo.
echo   ..\common\bat\xslt %seven_filename_sch% %xslt_sch2xslt% :: %seven_filename_xsl%
call ..\common\bat\xslt %seven_filename_sch% %xslt_sch2xslt% %seven_filename_xsl% >output\logs\10-SCHtoXSLT.txt
if %errorlevel% neq 0 goto :error
type output\logs\10-SCHtoXSLT.txt
echo.

echo.
echo   ..\common\bat\xslt %eight_filename_sch% %xslt_sch2xslt% :: %eight_filename_xsl%
call ..\common\bat\xslt %eight_filename_sch% %xslt_sch2xslt% %eight_filename_xsl% >output\logs\11-SCHtoXSLT.txt
if %errorlevel% neq 0 goto :error
type output\logs\11-SCHtoXSLT.txt
echo.

echo.
echo   ..\common\bat\xslt %nine_filename_sch% %xslt_sch2xslt% :: %nine_filename_xsl%
call ..\common\bat\xslt %nine_filename_sch% %xslt_sch2xslt% %nine_filename_xsl% >output\logs\12-SCHtoXSLT.txt
if %errorlevel% neq 0 goto :error
type output\logs\12-SCHtoXSLT.txt
echo.

echo.
echo   ..\common\bat\xslt %ten_filename_sch% %xslt_sch2xslt% :: %ten_filename_xsl%
call ..\common\bat\xslt %ten_filename_sch% %xslt_sch2xslt% %ten_filename_xsl% >output\logs\13-SCHtoXSLT.txt
if %errorlevel% neq 0 goto :error
type output\logs\13-SCHtoXSLT.txt
echo.


echo.
echo Done.
goto :done

:error
echo Error; process terminated!
goto :done

:done