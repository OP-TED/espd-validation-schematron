@echo off 

set xslt_sch2xslt="..\..\common\xsl\iso_svrl_for_xslt2.xsl"

set six_filename_sch="..\..\common\sch\Testing.sch"
set six_filename_xsl="output\criterion\03 ESPD Common Criterion BR.xsl"
set six_output="output\criterion\03 ESPD Common Criterion BR.xml"

set xml_test="..\..\common\xml\REGULATED-ESPDRequest-02.00.01.xml"


rem
rem  ESPD validation using Schematron
rem
rem  $Id: espd-schematron,v 1.00 2016/03/14 $
rem

echo.
echo   bat\xslt %six_filename_sch% %xslt_sch2xslt% :: %six_filename_xsl%
call bat\xslt %six_filename_sch% %xslt_sch2xslt% %six_filename_xsl% >output\logs\09-SCHtoXSLT.txt
if %errorlevel% neq 0 goto :error
type output\logs\09-SCHtoXSLT.txt
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
