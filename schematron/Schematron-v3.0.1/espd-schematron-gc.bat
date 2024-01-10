@echo off 


rem
rem  ESPD validation using Schematron
rem
rem  $Id: espd-schematron,v 3.0.1 2022/02 $
rem

echo Precondition validation...
echo.


echo.
echo Validating code lists...
echo   common\bat\w3cschema common\xsd\genericode.xsd "gc\*.gc"
call common\bat\w3cschema common\xsd\genericode.xsd "gc\access-right.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\BooleanGUIControlType.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\country.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\criterion.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\CriterionElementType.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\currency.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\DocRefContentType.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\EconomicOperatorSize.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\EOIDType.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\eo-role-type.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\FinancialRatioType.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\language.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\occupation.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\ProfileExecutionID.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\PropertyGroupType.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\ResponseDataType.gc" 2>&1 >logs\1-GC_Files.txt

if %errorlevel% neq 0 goto :error


echo.
echo Done.
goto :done

:nofile
echo.
echo Document model for constraints not found: %xsd_test%
goto :done

:error
echo.
echo Error; process terminated!
goto :done

:done
