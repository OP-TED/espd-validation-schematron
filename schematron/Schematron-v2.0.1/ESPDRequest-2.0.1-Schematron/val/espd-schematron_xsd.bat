@echo off 

set xml_test="..\..\common\xml\REGULATED-ESPDRequest-02.00.00.xml"
set xsd_test="..\..\common\xsdrt\maindoc\UBL-QualificationApplicationRequest-2.2-Pre-award.xsd"

rem
rem  ESPD validation using Schematron
rem
rem  $Id: espd-schematron,v 1.00 2016/03/14 $
rem

echo Precondition validation...
echo.

echo Validating XSDs existance...
if not exist %xsd_test% goto :nofile

call bat\w3cschema %xsd_test% %xml_test% >output\result-xsd.xml 
echo.
echo XSD model version...
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
