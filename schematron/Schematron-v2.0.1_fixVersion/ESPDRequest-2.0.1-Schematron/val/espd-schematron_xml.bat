@echo off 

set xml_test="..\..\common\xml\ESPD_Request_Ankoe - correct.xml"
set xsd_test="..\..\common\xsdrt\maindoc\UBL-QualificationApplicationRequest-2.2-Pre-award.xsd"

set one_filename_xsl="output\xsl\ESPD-codelist-values.xsl"
set two_filename_xsl="output\xsl\02 ESPD Req Cardinality BR.xsl"
set three_filename_xsl="output\xsl\03 ESPD Common Other BR.xsl"
set four_filename_xsl="output\xsl\04 ESPD Req Procurer BR.xsl"
set five_filename_xsl="output\xsl\04 ESPD Req Other BR.xsl"
set six_filename_xsl="output\xsl\03 ESPD Common Criterion BR.xsl"

set xsd_output="output\result-xsd.xml"
set one_output="output\ESPD-codelist-values.xml"
set two_output="output\02 ESPD Req Cardinality BR.xml"
set three_output="output\03 ESPD Common Other BR.xml"
set four_output="output\04 ESPD Req Procurer BR.xml"
set five_output="output\04 ESPD Req Other BR.xml"
set six_output="output\03 ESPD Common Criterion BR.xml"

rem
rem  ESPD validation using Schematron
rem
rem  $Id: espd-schematron,v 1.00 2016/03/14 $
rem

echo Precondition validation...
echo.

echo Validating XSDs existance...
if not exist %xsd_test% goto :nofile

call bat\w3cschema %xsd_test% %xml_test% >%xsd_output%
echo.
echo XSD model version...
echo.


echo.
echo Testing ESPD XML Samples...
echo.
echo   bat\xslt %xml_test% %one_filename_xsl% :: output\logs\05-XML_Validation.txt
call bat\xslt %xml_test% %one_filename_xsl% %one_output% >output\logs\05-XML_Validation.txt
echo Result: %errorlevel%
if %errorlevel% neq 0 goto :error
type output\logs\05-XML_Validation.txt
echo.

echo.
echo   bat\xslt %xml_test% %two_filename_xsl% :: output\logs\05-XML_Validation.txt
call bat\xslt %xml_test% %two_filename_xsl% %two_output% >output\logs\05-XML_Validation.txt
echo Result: %errorlevel%
if %errorlevel% neq 0 goto :error
type output\logs\05-XML_Validation.txt
echo.

echo.
echo   bat\xslt %xml_test% %three_filename_xsl% :: output\logs\06-XML_Validation.txt
call bat\xslt %xml_test% %three_filename_xsl% %three_output% >output\logs\06-XML_Validation.txt
echo Result: %errorlevel%
if %errorlevel% neq 0 goto :error
type output\logs\06-XML_Validation.txt
echo.

echo.
echo   bat\xslt %xml_test% %four_filename_xsl% :: output\logs\07-XML_Validation.txt
call bat\xslt %xml_test% %four_filename_xsl% %four_output% >output\logs\07-XML_Validation.txt
echo Result: %errorlevel%
if %errorlevel% neq 0 goto :error
type output\logs\07-XML_Validation.txt
echo.

echo.
echo   bat\xslt %xml_test% %five_filename_xsl% :: output\logs\08-XML_Validation.txt
call bat\xslt %xml_test% %five_filename_xsl% %five_output% >output\logs\08-XML_Validation.txt
echo Result: %errorlevel%
if %errorlevel% neq 0 goto :error
type output\logs\08-XML_Validation.txt
echo.

echo.
echo   bat\xslt %xml_test% %six_filename_xsl% :: output\logs\09-XML_Validation.txt
call bat\xslt %xml_test% %six_filename_xsl% %six_output% >output\logs\09-XML_Validation.txt
echo Result: %errorlevel%
if %errorlevel% neq 0 goto :error
type output\logs\09-XML_Validation.txt
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
