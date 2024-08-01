@echo off 

set xml_test="..\common\xml\ESPD-Request-BASE.xml"

set xsd_test="..\common\xsdrt\maindoc\UBL-QualificationApplicationRequest-2.3.xsd"

set one_filename_xsl="xsl\01-ESPD-codelist-values.xsl"
set two_filename_xsl="xsl\02-ESPD-req-cardinality-br.xsl"
set three_filename_xsl="xsl\04-ESPD-common-other-br.xsl"
set four_filename_xsl="xsl\05-ESPD-req-procurer-br.xsl"
set five_filename_xsl="xsl\04-ESPD-req-other-br.xsl"
set six_filename_xsl="xsl\03-ESPD-common-criterion-br.xsl"
set seven_filename_xsl="xsl\03-ESPD-req-criterion-br.xsl"
set eight_filename_xsl="xsl\01-ESPD-common-cl-attributes.xsl"
set nine_filename_xsl="xsl\05-ESPD-req-specific-br.xsl"
set ten_filename_xsl="xsl\01-ESPD-common-cl-values-restrictions.xsl"

set xsd_output="output\result-xsd.xml"
set one_output="output\01-ESPD-codelist-values.xml"
set two_output="output\02-ESPD-req-cardinality-br.xml"
set three_output="output\04-ESPD-common-other-br.xml"
set four_output="output\05-ESPD-req-procurer-br.xml"
set five_output="output\04-ESPD-req-other-br.xml"
set six_output="output\03-ESPD-common-criterion-br.xml"
set seven_output="output\03-ESPD-req-criterion-br.xml"
set eight_output="output\01-ESPD-common-cl-attributes.xml"
set nine_output="output\05-ESPD-req-specific-br.xml"
set ten_output="output\01-ESPD-common-cl-values-restrictions.xml"

rem
rem  ESPD validation using Schematron
rem
rem  $Id: espd-schematron,v 1.00 2016/03/14 $
rem

echo Precondition validation...
echo.

echo Validating XSDs existance...
if not exist %xsd_test% goto :nofile

java -jar "..\common\lib\xjparse.jar" -c "%~dp0catalog.xml" -S %xsd_test% %xml_test% >%xsd_output%
echo.
echo XSD model version...
echo.


echo.
echo Testing ESPD XML Samples...
echo.
echo   ..\common\bat\xslt %xml_test% %one_filename_xsl% :: output\logs\05-XML-validation.txt
call ..\common\bat\xslt %xml_test% %one_filename_xsl% %one_output% >output\logs\05-XML-validation.txt
echo Result: %errorlevel%
if %errorlevel% neq 0 goto :error
type output\logs\05-XML-validation.txt
echo.

echo.
echo   ..\common\bat\xslt %xml_test% %two_filename_xsl% :: output\logs\05-XML-validation.txt
call ..\common\bat\xslt %xml_test% %two_filename_xsl% %two_output% >output\logs\05-XML-validation.txt
echo Result: %errorlevel%
if %errorlevel% neq 0 goto :error
type output\logs\05-XML-validation.txt
echo.

echo.
echo   ..\common\bat\xslt %xml_test% %three_filename_xsl% :: output\logs\06-XML-validation.txt
call ..\common\bat\xslt %xml_test% %three_filename_xsl% %three_output% >output\logs\06-XML-validation.txt
echo Result: %errorlevel%
if %errorlevel% neq 0 goto :error
type output\logs\06-XML-validation.txt
echo.

echo.
echo   ..\common\bat\xslt %xml_test% %four_filename_xsl% :: output\logs\07-XML-validation.txt
call ..\common\bat\xslt %xml_test% %four_filename_xsl% %four_output% >output\logs\07-XML-validation.txt
echo Result: %errorlevel%
if %errorlevel% neq 0 goto :error
type output\logs\07-XML-validation.txt
echo.

echo.
echo   ..\common\bat\xslt %xml_test% %five_filename_xsl% :: output\logs\08-XML-validation.txt
call ..\common\bat\xslt %xml_test% %five_filename_xsl% %five_output% >output\logs\08-XML-validation.txt
echo Result: %errorlevel%
if %errorlevel% neq 0 goto :error
type output\logs\08-XML-validation.txt
echo.

echo.
echo   ..\common\bat\xslt %xml_test% %six_filename_xsl% :: output\logs\09-XML-validation.txt
call ..\common\bat\xslt %xml_test% %six_filename_xsl% %six_output% >output\logs\09-XML-validation.txt
echo Result: %errorlevel%
if %errorlevel% neq 0 goto :error
type output\logs\09-XML-validation.txt
echo.

echo.
echo   ..\common\bat\xslt %xml_test% %seven_filename_xsl% :: output\logs\10-XML-validation.txt
call ..\common\bat\xslt %xml_test% %seven_filename_xsl% %seven_output% >output\logs\10-XML-validation.txt
echo Result: %errorlevel%
if %errorlevel% neq 0 goto :error
type output\logs\10-XML-validation.txt
echo.

echo.
echo   ..\common\bat\xslt %xml_test% %eight_filename_xsl% :: output\logs\11-XML-validation.txt
call ..\common\bat\xslt %xml_test% %eight_filename_xsl% %eight_output% >output\logs\11-XML-validation.txt
echo Result: %errorlevel%
if %errorlevel% neq 0 goto :error
type output\logs\11-XML-validation.txt
echo.

echo.
echo   ..\common\bat\xslt %xml_test% %nine_filename_xsl% :: output\logs\12-XML-validation.txt
call ..\common\bat\xslt %xml_test% %nine_filename_xsl% %nine_output% >output\logs\12-XML-validation.txt
echo Result: %errorlevel%
if %errorlevel% neq 0 goto :error
type output\logs\12-XML-validation.txt
echo.

echo.
echo   ..\common\bat\xslt %xml_test% %ten_filename_xsl% :: output\logs\13-XML-validation.txt
call ..\common\bat\xslt %xml_test% %ten_filename_xsl% %ten_output% >output\logs\13-XML-validation.txt
echo Result: %errorlevel%
if %errorlevel% neq 0 goto :error
type output\logs\13-XML-validation.txt
echo.


echo.
echo Done.
goto :done

:nofile
echo.
echo Document model for constraints not found: %xsd_test%
goto :done

:error
echo Error; process terminated!
goto :done

:done