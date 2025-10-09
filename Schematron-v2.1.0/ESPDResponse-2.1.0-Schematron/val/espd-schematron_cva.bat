@echo off 

set cva_filename="..\..\common\cva\01 ESPD-codelist-values.cva"
set xslt_cva2sch="..\..\common\xsl\Crane-cva2schXSLT.xsl"
set sch_xsl_filename="output\xsl\01 ESPD-codelist-values.sch.xsl"
set sch_filename="output\sch\01 ESPD-codelist-values.sch"

rem
rem  ESPD validation using Schematron
rem
rem  $Id: espd-schematron,v 1.00 2016/03/14 $
rem



echo.
echo Preparing code list rules...
echo.
echo Translating CVA to SCH...
echo  bat\xslt %cva_filename% %xslt_cva2sch% :: %sch_xsl_filename%
call bat\xslt %cva_filename% %xslt_cva2sch% %sch_xsl_filename% >output\logs\01-CVAtoXSL.txt
if %errorlevel% neq 0 goto :error
type output\logs\01-CVAtoXSL.txt

echo  bat\xslt %sch_xsl_filename% %sch_xsl_filename% %sch_filename%
call bat\xslt %sch_xsl_filename% %sch_xsl_filename% %sch_filename% >output\logs\02-XSLtoSCH.txt
if %errorlevel% neq 0 goto :error
type output\logs\02-XSLtoSCH.txt
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
