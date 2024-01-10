@echo off 

set xml_test="..\..\common\xml\REGULATED-ESPDResponse-02.00.01.xml"

set one_filename_xsl="output\xsl\ESPD-codelist-values.xsl"
set two_filename_xsl="output\xsl\02 ESPD Resp Cardinality BR.xsl"
set three_filename_xsl="output\xsl\03 ESPD Common Other BR.xsl"
set four_filename_xsl="output\xsl\04 ESPD Resp EO BR.xsl"
set five_filename_xsl="output\xsl\04 ESPD Resp Other BR.xsl"
set six_filename_xsl="output\xsl\03 ESPD Common Criterion BR.xsl"
set seven_filename_xsl="output\xsl\05 ESPD Resp Lead BR.xsl"
set eight_filename_xsl="output\xsl\04 ESPD Resp Criterion BR.xsl"

set one_output="output\ESPD-codelist-values.xml"
set two_output="output\02 ESPD Resp Cardinality BR.xml"
set three_output="output\03 ESPD Common Other BR.xml"
set four_output="output\04 ESPD Resp EO BR.xml"
set five_output="output\04 ESPD Resp Other BR.xml"
set six_output="output\03 ESPD Common Criterion BR.xml"
set seven_output="output\05 ESPD Resp Lead BR.xml"
set eight_output="output\04 ESPD Resp Criterion BR.xml"

rem
rem  ESPD validation using Schematron
rem
rem  $Id: espd-schematron,v 1.00 2016/03/14 $
rem


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
echo   bat\xslt %xml_test% %seven_filename_xsl% :: output\logs\10-XML_Validation.txt
call bat\xslt %xml_test% %seven_filename_xsl% %seven_output% >output\logs\10-XML_Validation.txt
echo Result: %errorlevel%
if %errorlevel% neq 0 goto :error
type output\logs\10-XML_Validation.txt
echo.

echo.
echo   bat\xslt %xml_test% %eight_filename_xsl% :: output\logs\11-XML_Validation.txt
call bat\xslt %xml_test% %eight_filename_xsl% %eight_output% >output\logs\11-XML_Validation.txt
echo Result: %errorlevel%
if %errorlevel% neq 0 goto :error
type output\logs\11-XML_Validation.txt
echo.


echo.
echo Done.
goto :done


:error
type test-constraints.txt
echo.
echo Error; process terminated!
goto :done

:done
