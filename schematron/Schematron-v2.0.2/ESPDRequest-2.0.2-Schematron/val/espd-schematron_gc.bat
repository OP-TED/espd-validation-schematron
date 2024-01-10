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
echo   bat\w3cschema xsd\genericode.xsd "..\..\common\gc\*.gc"
call bat\w3cschema xsd\genericode.xsd "..\..\common\gc\BidType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\common\gc\ConfidentialityLevel-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\common\gc\CountryCodeIdentifier-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\common\gc\CriterionElementType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\common\gc\CurrencyCode-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\common\gc\DocRefContentType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\common\gc\EOIDType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\common\gc\EOIndustryClassificationCode-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\common\gc\EORoleType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\common\gc\EULanguageCode-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\common\gc\EvaluationMethodType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\common\gc\FinancialRatioType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\common\gc\LegislationType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\common\gc\PeriodMeasureType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\common\gc\ProcedureType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\common\gc\ProfileExecutionID-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\common\gc\ProjectType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\common\gc\PropertyGroupType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\common\gc\QualificationApplicationType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\common\gc\ResponseDataType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\common\gc\ServicesProjectSubType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
call bat\w3cschema xsd\genericode.xsd "..\..\common\gc\TechnicalCapabilityType-CodeList.gc" 2>&1 >output\logs\1-GC_Files.txt
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
