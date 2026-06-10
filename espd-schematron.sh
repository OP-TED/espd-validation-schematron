#!/bin/sh
# script name: espd-schematron.sh

# This script implements the MS DOS Batch script espd-schematron.bat
#    as a Unix shell script

# +----------------------------------+
# | ESPD validation using Schematron |
# | espd-schematron, v5.0.0 2026/07  |
# +----------------------------------+

# ESPD Dcoument valiation error
function error_validation () {
echo
echo -e "\e[101m" ! "\e[0m" Error validating ESPD Document; process terminated!
exit 1;
}

# Code Lists validation error
function error_gc () {
echo
echo -e "\e[101m" ! "\e[0m" Error validating Code Lists; process terminated!
exit 1;
}

# CVA to SCH transformation error
function error_cva2sch () {
echo
echo -e "\e[101m" ! "\e[0m" Error transforming CVA to XSL to SCH; process terminated!
exit 1;
}

# SCH to XSL transformation error
function error_sch2xsl () {
echo
echo -e "\e[101m" ! "\e[0m" Error transforming SCH to XSL; process terminated!
exit 1;
}

# Checking UBL XSD files
function nofile () {
echo
echo -e "\e[101m" ! "\e[0m" Error UBL XSD file not found
exit 1;
}

# XJPARSE local function
# <param> - the XSD file for validation
# <param> - the XML file to be validated
# <param> - the log file
function xjparse () {
echo xjparse "$*"
java -jar "common/lib/xjparse-app-3.0.0.jar" -S $1 $2 2>&1 >> $3
}

# SAXON XSLT transformation local function
# <param> - the input file 
# <param> - the XSL transfomer file
# <param> - the output file
# <param> - the log file
function saxonica () {
echo saxon $3 $1 $2 $4
java -jar "common/lib/saxon-he-12.5.jar" -o:$3 $1 $2 2>&1 >> $4
}

# Auxiliary message display function
function msg () {
echo
echo -e "\e[1m""\e[32m"[X]"\e[0m" "$*"
echo
}

# Auxiliary banner display function
function banner () {
echo
echo -e "\e[7m" +++ "$*" +++ "\e[0m"
echo
}

# setup all files
# PHASE 0
gcxsd="common/xsd/genericode.xsd"
gclog="logs/gc/00-GC_Files.txt"

# PHASE 1 - Request
cva_filename="common/cva/01-ESPD-codelist-values.cva"
xslt_cva2sch="common/xsl/Crane-cva2schXSLT.xsl"

sch_xsl_filename_req="logs/ESPDRequest/output/01-ESPD-codelist-values.xsl"
sch_filename_req="ESPDRequest/sch/01-ESPD-codelist-values.sch"
cva2schlog_req="logs/ESPDRequest/01-CVAtoSCH.txt"
# PHASE 1 - Response
sch_xsl_filename_res="logs/ESPDResponse/output/01-ESPD-codelist-values.xsl"
sch_filename_res="ESPDResponse/sch/01-ESPD-codelist-values.sch"
cva2schlog_res="logs/ESPDResponse/01-CVAtoSCH.txt"

# PHASE 2 - Request
xslt_sch2xslt="common/xsl/iso_svrl_for_xslt2.xsl"
schtoxsllog_req="logs/ESPDRequest/02-SCHtoXSL.txt"
schtoxsllog_res="logs/ESPDResponse/02-SCHtoXSL.txt"

ph2req_sch[0]="ESPDRequest/sch/01-ESPD-codelist-values.sch"
ph2req_xsl[0]="ESPDRequest/xsl/01-ESPD-codelist-values.xsl"
ph2req_sch[1]="ESPDRequest/sch/02-ESPD-req-cardinality-br.sch"
ph2req_xsl[1]="ESPDRequest/xsl/02-ESPD-req-cardinality-br.xsl"
ph2req_sch[2]="common/sch/04-ESPD-common-other-br.sch"
ph2req_xsl[2]="ESPDRequest/xsl/04-ESPD-common-other-br.xsl"
ph2req_sch[3]="ESPDRequest/sch/05-ESPD-req-procurer-br.sch"
ph2req_xsl[3]="ESPDRequest/xsl/05-ESPD-req-procurer-br.xsl"
ph2req_sch[4]="ESPDRequest/sch/04-ESPD-req-other-br.sch"
ph2req_xsl[4]="ESPDRequest/xsl/04-ESPD-req-other-br.xsl"
ph2req_sch[5]="common/sch/03-ESPD-common-criterion-br.sch"
ph2req_xsl[5]="ESPDRequest/xsl/03-ESPD-common-criterion-br.xsl"
ph2req_sch[6]="ESPDRequest/sch/03-ESPD-req-criterion-br.sch"
ph2req_xsl[6]="ESPDRequest/xsl/03-ESPD-req-criterion-br.xsl"
ph2req_sch[7]="common/sch/01-ESPD-common-cl-attributes.sch"
ph2req_xsl[7]="ESPDRequest/xsl/01-ESPD-common-cl-attributes.xsl"
ph2req_sch[8]="ESPDRequest/sch/05-ESPD-req-specific-br.sch"
ph2req_xsl[8]="ESPDRequest/xsl/05-ESPD-req-specific-br.xsl"
ph2req_sch[9]="common/sch/01-ESPD-common-cl-values-restrictions.sch"
ph2req_xsl[9]="ESPDRequest/xsl/01-ESPD-common-cl-values-restrictions.xsl"

# PHASE 2 - Response
ph2res_sch[0]="ESPDResponse/sch/01-ESPD-codelist-values.sch"
ph2res_xsl[0]="ESPDResponse/xsl/01-ESPD-codelist-values.xsl"
ph2res_sch[1]="ESPDResponse/sch/02-ESPD-resp-cardinality-br.sch"
ph2res_xsl[1]="ESPDResponse/xsl/02-ESPD-resp-cardinality-br.xsl"
ph2res_sch[2]="common/sch/04-ESPD-common-other-br.sch"
ph2res_xsl[2]="ESPDResponse/xsl/04-ESPD-common-other-br.xsl"
ph2res_sch[3]="ESPDResponse/sch/05-ESPD-resp-eo-br.sch"
ph2res_xsl[3]="ESPDResponse/xsl/05-ESPD-resp-eo-br.xsl"
ph2res_sch[4]="ESPDResponse/sch/04-ESPD-resp-other-br.sch"
ph2res_xsl[4]="ESPDResponse/xsl/04-ESPD-resp-other-br.xsl"
ph2res_sch[5]="common/sch/03-ESPD-common-criterion-br.sch"
ph2res_xsl[5]="ESPDResponse/xsl/03-ESPD-common-criterion-br.xsl"
ph2res_sch[6]="ESPDResponse/sch/05-ESPD-resp-role-br.sch"
ph2res_xsl[6]="ESPDResponse/xsl/05-ESPD-resp-role-br.xsl"
ph2res_sch[7]="ESPDResponse/sch/03-ESPD-resp-criterion-br.sch"
ph2res_xsl[7]="ESPDResponse/xsl/03-ESPD-resp-criterion-br.xsl"
ph2res_sch[8]="ESPDResponse/sch/05-ESPD-resp-qualification-br.sch"
ph2res_xsl[8]="ESPDResponse/xsl/05-ESPD-resp-qualification-br.xsl"
ph2res_sch[9]="ESPDResponse/sch/05-ESPD-resp-specific-br.sch"
ph2res_xsl[9]="ESPDResponse/xsl/05-ESPD-resp-specific-br.xsl"
ph2res_sch[10]="common/sch/01-ESPD-common-cl-attributes.sch"
ph2res_xsl[10]="ESPDResponse/xsl/01-ESPD-common-cl-attributes.xsl"
ph2res_sch[11]="common/sch/01-ESPD-common-cl-values-restrictions.sch"
ph2res_xsl[11]="ESPDResponse/xsl/01-ESPD-common-cl-values-restrictions.xsl"

# PHASE 3 - Request
xml_test_req="common/xml/ESPD-Request-BASE.xml"
xsd_test_req="common/xsdrt/maindoc/UBL-QualificationApplicationRequest-2.4.xsd"
xsd_output_req="logs/ESPDRequest/output/result-xsd.xml"
log_req="logs/ESPDRequest/03-validation.txt"

ph3req_xsl[0]="ESPDRequest/xsl/01-ESPD-codelist-values.xsl"
ph3req_xsl[1]="ESPDRequest/xsl/02-ESPD-req-cardinality-br.xsl"
ph3req_xsl[2]="ESPDRequest/xsl/04-ESPD-common-other-br.xsl"
ph3req_xsl[3]="ESPDRequest/xsl/05-ESPD-req-procurer-br.xsl"
ph3req_xsl[4]="ESPDRequest/xsl/04-ESPD-req-other-br.xsl"
ph3req_xsl[5]="ESPDRequest/xsl/03-ESPD-common-criterion-br.xsl"
ph3req_xsl[6]="ESPDRequest/xsl/03-ESPD-req-criterion-br.xsl"
ph3req_xsl[7]="ESPDRequest/xsl/01-ESPD-common-cl-attributes.xsl"
ph3req_xsl[8]="ESPDRequest/xsl/05-ESPD-req-specific-br.xsl"
ph3req_xsl[9]="ESPDRequest/xsl/01-ESPD-common-cl-values-restrictions.xsl"

ph3req_output[0]="logs/ESPDRequest/output/01-ESPD-codelist-values.xml"
ph3req_output[1]="logs/ESPDRequest/output/02-ESPD-req-cardinality-br.xml"
ph3req_output[2]="logs/ESPDRequest/output/04-ESPD-common-other-br.xml"
ph3req_output[3]="logs/ESPDRequest/output/05-ESPD-req-procurer-br.xml"
ph3req_output[4]="logs/ESPDRequest/output/04-ESPD-req-other-br.xml"
ph3req_output[5]="logs/ESPDRequest/output/03-ESPD-common-criterion-br.xml"
ph3req_output[6]="logs/ESPDRequest/output/03-ESPD-req-criterion-br.xml"
ph3req_output[7]="logs/ESPDRequest/output/01-ESPD-common-cl-attributes.xml"
ph3req_output[8]="logs/ESPDRequest/output/05-ESPD-req-specific-br.xml"
ph3req_output[9]="logs/ESPDRequest/output/01-ESPD-common-cl-values-restrictions.xml"

# PHASE 3 - Response
xml_test_res="common/xml/ESPD-Response-BASE.xml"
xsd_test_res="common/xsdrt/maindoc/UBL-QualificationApplicationResponse-2.4.xsd"
xsd_output_res="logs/ESPDResponse/output/result-xsd.xml"
log_res="logs/ESPDResponse/03-validation.txt"

ph3res_xsl[0]="ESPDResponse/xsl/01-ESPD-codelist-values.xsl"
ph3res_xsl[1]="ESPDResponse/xsl/02-ESPD-resp-cardinality-br.xsl"
ph3res_xsl[2]="ESPDResponse/xsl/04-ESPD-common-other-br.xsl"
ph3res_xsl[3]="ESPDResponse/xsl/05-ESPD-resp-eo-br.xsl"
ph3res_xsl[4]="ESPDResponse/xsl/04-ESPD-resp-other-br.xsl"
ph3res_xsl[5]="ESPDResponse/xsl/03-ESPD-common-criterion-br.xsl"
ph3res_xsl[6]="ESPDResponse/xsl/05-ESPD-resp-role-br.xsl"
ph3res_xsl[7]="ESPDResponse/xsl/03-ESPD-resp-criterion-br.xsl"
ph3res_xsl[8]="ESPDResponse/xsl/05-ESPD-resp-qualification-br.xsl"
ph3res_xsl[9]="ESPDResponse/xsl/05-ESPD-resp-specific-br.xsl"
ph3res_xsl[10]="ESPDResponse/xsl/01-ESPD-common-cl-attributes.xsl"
ph3res_xsl[11]="ESPDResponse/xsl/01-ESPD-common-cl-values-restrictions.xsl"

ph3res_output[0]="logs/ESPDResponse/output/01-ESPD-codelist-values.xml"
ph3res_output[1]="logs/ESPDResponse/output/02-ESPD-resp-cardinality-br.xml"
ph3res_output[2]="logs/ESPDResponse/output/04-ESPD-common-other-br.xml"
ph3res_output[3]="logs/ESPDResponse/output/05-ESPD-resp-eo-br.xml"
ph3res_output[4]="logs/ESPDResponse/output/04-ESPD-resp-other-br.xml"
ph3res_output[5]="logs/ESPDResponse/output/03-ESPD-common-criterion-br.xml"
ph3res_output[6]="logs/ESPDResponse/output/05-ESPD-resp-role-br.xml"
ph3res_output[7]="logs/ESPDResponse/output/03-ESPD-resp-criterion-br.xml"
ph3res_output[8]="logs/ESPDResponse/output/05-ESPD-resp-qualification-br.xml"
ph3res_output[9]="logs/ESPDResponse/output/05-ESPD-resp-specific-br.xml"
ph3res_output[10]="logs/ESPDResponse/output/01-ESPD-common-cl-attributes.xml"
ph3res_output[11]="logs/ESPDResponse/output/01-ESPD-common-cl-values-restrictions.xml"

# PHASE 4 - Prepare distribution files
log_dist="logs/dist/04-dist.txt"

# [- START PROCESSING -]

banner PHASE 0
echo Precondition validation ...
# check logs and output folders
[ -d "logs" ] && rm -fr "logs"
mkdir -p logs/gc logs/ESPDRequest/output logs/ESPDResponse/output
msg logs folder OK

echo Validating Code Lists in gc folder ...

echo "-------------------------------------------" >  "${gclog}"
echo "Phase 0: Validating Code Lists in gc folder" >> "${gclog}"
echo "-------------------------------------------" >> "${gclog}"

for f in $(ls gc/*.gc); do
    echo "Processing file ${f}" >> "${gclog}"
    xjparse ${gcxsd} ${f} ${gclog}
    [ $? -ne 0 ] && error_gc
done

echo
msg Done successfully checking Code Lists.

# --- End of Phase 0 ---

banner PHASE 1
echo CVA to XSL transformation ...
rm -f logs/ESPDRequest/output/*.* logs/ESPDResponse/output/*.* ${sch_filename_req} ${sch_filename_res}

echo "-------------------------------------------------" >  "${cva2schlog_req}"
echo "Phase 1: ESPD Request transform CVA to XSL to SCH" >> "${cva2schlog_req}"
echo "-------------------------------------------------" >> "${cva2schlog_req}"
echo "Processing ${cva_filename} ${xslt_cva2sch} ${sch_xsl_filename_req}" >> "${cva2schlog_req}"
saxonica ${cva_filename} "common/xsl/Crane-cva2schXSLT.xsl" ${sch_xsl_filename_req} ${cva2schlog_req}
[ $? -ne 0 ] && error_cva2sch

echo "Processing ${sch_xsl_filename_req} ${sch_xsl_filename_req} ${sch_filename_req}" >> "${cva2schlog_req}"
saxonica ${sch_xsl_filename_req} ${sch_xsl_filename_req} ${sch_filename_req} ${cva2schlog_req}
[ $? -ne 0 ] && error_cva2sch

echo "--------------------------------------------------" >  "${cva2schlog_res}"
echo "Phase 1: ESPD Response transform CVA to XSL to SCH" >> "${cva2schlog_res}"
echo "--------------------------------------------------" >> "${cva2schlog_res}"
echo "Processing ${cva_filename} ${xslt_cva2sch} ${sch_xsl_filename_res}" >> "${cva2schlog_res}"
saxonica ${cva_filename} ${xslt_cva2sch} ${sch_xsl_filename_res} ${cva2schlog_res}
[ $? -ne 0 ] && error_cva2sch

echo "Processing ${sch_xsl_filename_res} ${sch_xsl_filename_res} ${sch_filename_res}" >> "${cva2schlog_res}"
saxonica ${sch_xsl_filename_res} ${sch_xsl_filename_res} ${sch_filename_res} ${cva2schlog_res}
[ $? -ne 0 ] && error_cva2sch

echo
msg Done successfully transforming CVA to XSL to SCH

# --- End of Phase 1 ---

banner PHASE 2
echo SCH to XSL transformation ...

echo "------------------------------------------" >  "${schtoxsllog_req}"
echo "Phase 2: ESPD Request transform SCH to XSL" >> "${schtoxsllog_req}"
echo "------------------------------------------" >> "${schtoxsllog_req}"

for ((i=0; i<=9; i++)); do
  echo "Processing ${ph2req_sch[$i]} ${xslt_sch2xslt} ${ph2req_xsl[$i]}" >> "${schtoxsllog_req}"
  saxonica ${ph2req_sch[$i]} ${xslt_sch2xslt} ${ph2req_xsl[$i]} ${schtoxsllog_req}
  [ $? -ne 0 ] && error_sch2xs
done

echo "-------------------------------------------" >  "${schtoxsllog_res}"
echo "Phase 2: ESPD Response transform SCH to XSL" >> "${schtoxsllog_res}"
echo "-------------------------------------------" >> "${schtoxsllog_res}"

for ((i=0; i<=11; i++)); do
  echo "Processing ${ph2res_sch[$i]} ${xslt_sch2xslt} ${ph2res_xsl[$i]}" >> "${schtoxsllog_res}"
  saxonica ${ph2res_sch[$i]} ${xslt_sch2xslt} ${ph2res_xsl[$i]} ${schtoxsllog_res}
  [ $? -ne 0 ] && error_sch2xs
done

echo
msg Done successfully transforming SCH to XSL

# --- End of Phase 2 ---

banner PHASE 3
echo ESPD Document validation vs UBL and XSL ...

echo "-----------------------------------------------" >  "${log_req}"
echo "Phase 3: ESPD Request validation vs UBL and XSL" >> "${log_req}"
echo "-----------------------------------------------" >> "${log_req}"

echo Checking UBL XSD file for Request ...
[ ! -e "${xsd_test_req}" ] && nofile

echo "Validating against ${xsd_test_req}" >> "${log_req}"
xjparse ${xsd_test_req} ${xml_test_req} ${log_req}
[ $? -ne 0 ] && error_validation

for ((i=0; i<=9; i++)); do
  echo "Validating against ${ph3req_xsl[$i]}" >> "${log_req}"
  saxonica ${xml_test_req} ${ph3req_xsl[$i]} ${ph3req_output[$i]} ${log_req}
  [ $? -ne 0 ] && error_validation
done

echo "------------------------------------------------" >  "${log_res}"
echo "Phase 3: ESPD Response validation vs UBL and XSL" >> "${log_res}"
echo "------------------------------------------------" >> "${log_res}"

echo Checking UBL XSD file for Response ...
[ ! -e "${xsd_test_res}" ] && nofile

echo "Validating against ${xsd_test_res}" >> "${log_res}"
xjparse ${xsd_test_res} ${xml_test_res} ${log_res}
[ $? -ne 0 ] && error_validation

for ((i=0; i<=11; i++)); do
  echo "Validating against ${ph3res_xsl[$i]}" >> "${log_res}"
  saxonica ${xml_test_res} ${ph3res_xsl[$i]} ${ph3res_output[$i]} ${log_res}
  [ $? -ne 0 ] && error_validation
done
echo
msg Done successfully validating ESPD Document

# --- End of Phase 3 ---

banner PHASE 4
echo Build ESPD-EDM and validator-resources-espd distribution ...

[ -d "logs/dist" ] && rm -fr "logs/dist"
mkdir -p logs/dist

echo "----------------------------------------------" >  "${log_dist}"
echo "Phase 4: Making distribution files and folders" >> "${log_dist}"
echo "----------------------------------------------" >> "${log_dist}"

mkdir -p logs/dist/ESPD-EDM/validation/ESPDRequest/sch logs/dist/ESPD-EDM/validation/ESPDRequest/xsl logs/dist/ESPD-EDM/validation/ESPDResponse/sch logs/dist/ESPD-EDM/validation/ESPDResponse/xsl logs/dist/ESPD-EDM/validation/common/cva logs/dist/ESPD-EDM/validation/common/sch logs/dist/validator-resources-espd/resources/v5.0.0/ESPDRequest logs/dist/validator-resources-espd/resources/v5.0.0/ESPDResponse logs/dist/validator-resources-espd/resources/v5.0.0/gc logs/dist/validator-resources-espd/resources/v5.0.0/xsdrt  >> ${log_dist}

cp -v ESPDRequest/sch/*.* "logs/dist/ESPD-EDM/validation/ESPDRequest/sch" >> "${log_dist}"
cp -v ESPDRequest/xsl/*.* "logs/dist/ESPD-EDM/validation/ESPDRequest/xsl" >> "${log_dist}"
cp -v ESPDResponse/sch/*.* "logs/dist/ESPD-EDM/validation/ESPDResponse/sch" >> "${log_dist}"
cp -v ESPDResponse/xsl/*.* "logs/dist/ESPD-EDM/validation/ESPDResponse/xsl" >> "${log_dist}"
cp -v common/cva/*.* "logs/dist/ESPD-EDM/validation/common/cva" >> "${log_dist}"
cp -v common/sch/*.* "logs/dist/ESPD-EDM/validation/common/sch" >> "${log_dist}"

cp -v ESPDRequest/xsl/*.* "logs/dist/validator-resources-espd/resources/v5.0.0/ESPDRequest" >> "${log_dist}"
cp -v ESPDResponse/xsl/*.* "logs/dist/validator-resources-espd/resources/v5.0.0/ESPDResponse" >> "${log_dist}"
cp -v gc/*.* "logs/dist/validator-resources-espd/resources/v5.0.0/gc" >> "${log_dist}"
cp -v -r common/xsdrt/* "logs/dist/validator-resources-espd/resources/v5.0.0/xsdrt" >> "${log_dist}"

msg Distribution available in logs/dist directory

