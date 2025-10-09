@echo off 


rem
rem  ESPD validation using Schematron
rem
rem  $Id: espd-schematron,v 2.0.0 2017/01 $
rem

echo Precondition validation...
echo.


echo.
echo Validating code lists...
echo   bat\w3cschema xsd\genericode.xsd "..\..\..\..\cl\gc\*.gc"
call bat\w3cschema xsd\genericode.xsd "..\..\..\..\cl\gc\BidType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\..\..\cl\gc\ConfidentialityLevel-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\..\..\cl\gc\CountryCodeIdentifier-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\..\..\cl\gc\CriterionElementType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\..\..\cl\gc\CurrencyCode-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\..\..\cl\gc\DocRefContentType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\..\..\cl\gc\EOIDType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\..\..\cl\gc\EOIndustryClassificationCode-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\..\..\cl\gc\EORoleType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\..\..\cl\gc\EULanguageCode-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\..\..\cl\gc\EvaluationMethodType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\..\..\cl\gc\FinancialRatioType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\..\..\cl\gc\LegislationType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\..\..\cl\gc\PeriodMeasureType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\..\..\cl\gc\ProcedureType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\..\..\cl\gc\ProfileExecutionID-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\..\..\cl\gc\ProjectType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\..\..\cl\gc\PropertyGroupType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\..\..\cl\gc\QualificationApplicationType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\..\..\cl\gc\ResponseDataType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\..\..\cl\gc\ServicesProjectSubType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\..\..\cl\gc\TechnicalCapabilityType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
if %errorlevel% neq 0 goto :error
type output\logs\1-GC_Files.txt


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
