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
echo   common\bat\w3cschema common\xsd\genericode.xsd "gc\*.gc"
call common\bat\w3cschema common\xsd\genericode.xsd "gc\BidType.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\BooleanGUIControlType.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\ConfidentialityLevel.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\CountryCodeIdentifier.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\CPVCodes.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\CriterionElementType.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\CurrencyCode.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\DocRefContentType.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\EOIDType.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\EOIndustryClassificationCode.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\EORoleType.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\ESPD-CriteriaTaxonomy_V2.1.1.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\EULanguageCode.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\EvaluationMethodType.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\FinancialRatioType.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\ProcedureType.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\ProfileExecutionID.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\ProjectType.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\PropertyGroupType.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\QualificationApplicationType.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\ResponseDataType.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\ServicesProjectSubType.gc" 2>&1 >logs\1-GC_Files.txt
call common\bat\w3cschema common\xsd\genericode.xsd "gc\WeightingType.gc" 2>&1 >logs\1-GC_Files.txt
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
