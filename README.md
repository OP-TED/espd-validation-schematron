# espd-validation-schematron
ESPD validation tool based on Schematron rules 

[![EUPL License](https://img.shields.io/badge/License-EUPL%20v1.2-blue.svg)](https://eupl.eu/1.2/en)

**Audience** 

This is a technical repository and is intended to be used as a tool that has as input: 
- Code Lists, 
- ESPD Request and ESPD Response, and 
- UBL
- Schematron rules specific to ESPD business rules

and produces the XSL files that can be used to either validate locally any ESPD Request and/or ESPD Response or as online service on [ISAITB testbed site](https://www.itb.ec.europa.eu/espd/upload). You can see the validation files on associated [GitHub repository](https://github.com/ISAITB/validator-resources-espd).


## Description

This repository is a processing tool that implements ESPD business rules in Schematron format in order to validate ESPD Request and ESPD Respose files in XML format. ESPD is based on UBL with a couple of extra business rules. Thus the validation of an ESPD document is based on UBL `QualificationApplicationRequest` for ESPD Request and `QualificationApplicationResponse` for ESPD Response.  
All ESPD specific business rules are described in terms of Schematron rules. Those rules are processed and transformed into XSL files.

## Install

### Pre-requsites  

You need to have installed the following tools on your machine before starting to use the ESPD Validation tool:
- Git client (GitBash or GitHub Desktop on Windows, native on OSX and Linux)
- Java JDK v1.8 or higher, you can use OpenJDK
- IDE tool of your choice (Visual Studio Code, vi, Notepad++)

### Getting started
Get the current repository on your local computer:

```
git clone https://github.com/OP-TED/espd-validation-schematron.git
```
This will create the folder `espd-validation-schematron` on your local computer. You may use your prefered IDE to edit the specfic files. You need a terminal, also available via the IDE, to run the commands and tools.

### Repository structure

`mock-ups` contains Microsoft Viso UI mock-ups of the various ESPD criterion and the exporterd version in PNG format. Those files are used for user visualisation and demonstration of possible look of the ESPD criteria. This folder is not maintained and is provided as is.

`schematron` contains the validation rules for each version of ESPD, starting with version 2.0.1. (e.g. `schematron/Schematron-v3.3.0`). All the activity will take place in one of those folders.  
For maintaining an existring release use the corresponding folder. For a new version make a copy of the latest version of ESPD and rename according to the new version (e.g. copy `schematron/Schematron-v3.3.0` to folder `schematron/Schematron-v4.0.0` to create the structure for a new version).

`schematron/Schematron-vX.X.X` folder structure is standard and contains:
- `espd-schematron-gc.bat` an Windows executable that is present in the root of the folder
- `ESPDReqeust` the folder containing the necessary input and output files for ESPD Request validation
- `ESPDResponse` the folder containing the necessary input and output files for ESPD Response validation
- `common` the folder contains all common artefacts, libraries, and XSD files necessary to validate and produce extra validators
- `gc` the folders contains all Code List files of that specific ESPD version
- all `logs` folders contain the output of the execution of internal pipelines and should be checked for errors in the log files after each execution. 

## Documentation

This tool is provided as is and is inteded to be used as intermediary step in the entire chain of ESPD validation process. Any contributions, suggestions and improvements are more than welcome. Please feel free to open [GitHub issue](https://github.com/OP-TED/espd-validation-schematron/issues) for your feedback.

### Data preparation

The tool will validate:
- Code Lists
- ESPD Request
- ESPD Response  

all files are in XML format.

**External data sources**

Please update the files in ESPD-EDM repository first and then proceed.

The following files are copied from [ESPD-EDM](https://github.com/OP-TED/ESPD-EDM) repository

| from ESPD-EDM | to espd-validation-schematron | _comments_ |
| --- | --- | --- |
| `codelists/gc`| `schmatron/Schematron-vX.X.X/gc`| update both external and technical Code Lists in ESPD-EDM and then copy the content of the folder to espd-validation-schmeatron |
| `xml-examples/ESPD-criterion.xml` | `schematron/Schematron-vX.X.X/ESPDRequest/xsl` and `schematron/Schematron-vX.X.X/ESPDResponse/xsl` | this is the same file as ESPD-Request.xml from ESPD-EDM repository. copy the same file in 2 diferent folders |
| `xml-examples/ESPD-Request.xml` | `schematron/Schematron-vX.X.X/common/xml/ESPD-Request-BASE.xml` and `schematron/Schematron-vX.X.X/common/xml/validation_samples/ESPD-Request.xml` | copy the same file in 2 diferent folders |
| `xml-examples/ESPD-Response.xml` | `schematron/Schematron-vX.X.X/common/xml/ESPD-Response-BASE.xml` and `schematron/Schematron-vX.X.X/common/xml/validation_samples/ESPD-Response.xml` | copy the same file in 2 diferent folders |
| `ubl-2.3/xsdrt` | `schematron/Schematron-vX.X.X/common/xsdrt` | update the UBL distribution file in ESPD-EDM and then copy the content of the folder to espd-validation-schematron |

External Code Lists are provided by EU Vocabularies. The ESPD example files are generated from Excel Criterion file or from ESPD Demo site. The UBL files are directly downloaded from UBL distribution site.  
Once the external files are in place we can proceed to modifying internal files.

**Internal files**

Please use only relative paths inside the files so that the pipelines can be run independent on the local file location specific to user computer.

The following internal files must be updated after all external files have been copied:
- `schematron/Schematron-vX.X.X/common/cva/01-ESPD-codelist-values.cva` contains the updated list with all codelist files, see `schematron/Schematron-vX.X.X/gc` folder for a complete list of codelist files, and ESPD specific business rules associated to each codelist.
-  `schematron/Schematron-vX.X.X/common/lib` contains all Java libraries. Please update the libraries so that the version are mutually compatible with both JDK installed version and with each other.
- `schematron/Schematron-vX.X.X/common/sch` contains the Schematron rules specific the ESPD. Those rules must be updated according to changes implemented in ESPD model.
  - `01-ESPD-codelist-values.sch` contains the actual values for each codelist
  - `01-ESPD-common-cl-attributes.sch` contains the common criterion business rules for attributed that get their values from codelists
  - `01-ESPD-common-cl-values-restrictions.sch` contains the restrictions for common criterion business rules for attributes that get their values from codelists - no restrictions for the moment
  - `03-ESPD-common-criterion-br.sch` contains the set of rules associated to `cac:TenderingCriterion` element for both ESPD Request and ESPD Response
  - `04-ESPD-common-other-br.sch` contains the cardinality constraints, other general business rules
- `schematron/Schematron-vX.X.X/common/xml` contains the base examples that will be used as input for validation. Specifi examples can be found in subfolder `validation_samples` and can be used for specific validation. This has to be configured manually. Only the base example files are used in the processing chain.
- `schematron/Schematron-vX.X.X/common/xsd` contains the general XSD files used for XML validation.
  - `ContextValueAssociation.xsd` is used to validate ???
  - `genericode.xsd` is used to validate Code Lists from `schematron\Schematron-vX.X.X\gc`
  - `xml.xsd` is used to validate ???
- `schematron/Schematron-vX.X.X/common/xsdrt` contains the XSD run time files for UBL documents validation. ESPD documents are based on UBL `QualificationApplicationRequest` for Request and `QualificationApplicationResponse` for Response
- `schematron/Schematron-vX.X.X/common/xsl/` contains generic XSL tranforamtion tools used to tansform schematron files, cva files and for internal pipelines. Those files should be updated if necessary only.
  - `Crane-Constraints2SchematronXSLT.xsl`
  - `Crane-cva2schXSLT.xsl`
  - `Crane-genericode-CodeList.xsl`
  - `Message-Schematron-terminator.xsl`
  - `iso_schematron_skeleton_for_saxon.xsl`
  - `iso_schematron_skeleton_for_xslt1.xsl`
  - `iso_svrl_for_xslt2.xsl`
- `schematron/Schematron-vX.X.X/ESPDRequest` contains ESPD Request validation related files
  - `sch` contains Schematron business rules that have to considered for full validation of ESPD Request. Some of the files are generated automatically some are managed manually
  - `xsl` contains the result of transfoming Schmematron files to XSL. The `criterionList.xml` file is maintained manually and `ESPD-criterion.xml` is from external sources.
  - `output` folder contains the results produced by the steps inside internal pipelines. Those files are automatically generated.  
- `schematron/Schematron-vX.X.X/ESPDResponse` contains ESPD Response validation related files
  - `sch` contains Schematron business rules that have to considered for full validation of ESPD Response. Some of the files are generated automatically some are managed manually
  - `xsl` contains the result of transfoming Schmematron files to XSL. The `criterionList.xml` file is maintained manually and `ESPD-criterion.xml` is from external sources.
  - `output` folder contains the results of steps inside internal pipelines. Those files are automatically generated.  

### How to use the tool

The tool has 3 main parts each consisting of executing `.bat` files from the terminal. You must have setup Java enviroment (JAVA_HOME, Path) for the command line execution.  
The auxiliary bat file `schematron/Schematron-vX.X.X/common/bat/w3schema.bat` uses `schematron/Schematron-vX.X.X/common/lib/xjparse.jar` library, and `schematron/Schematron-vX.X.X/common/bat/xslt.bat` uses `schematron/Schematron-vX.X.X/common/lib/saxon9he.jar` library.

**Phase I - Code List validation**

Run file `schematron/Schematron-vX.X.X/espd-schematron-gc.bat` this will validate all Code Lists files `schematron/Schematron-vX.X.X/*.gc` using `schematron/Schematron-vX.X.X/common/sdx/genericode.xsd` and the validation log can be found in `schematron/Schematron-vX.X.X/logs/1-GC-Files.txt`.

**Phase II - ESPD Request validation**

Run files in this order:
- `schematron/Schematron-vX.X.X/ESPDRequest/01-espd-schematron-cva.bat`
    | source | trasform | output | log |
    | --- | --- | --- | --- |
    | `schematron/Schematron-vX.X.X/common/cva/01-ESPD-codelist-values.cva` | `schematron/Schematron-vX.X.X/common/xsl/Crane-cva2schXSLT.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/output/01-ESPD-codelist-values.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/output/logs/01-CVAtoXSL.txt`|
    | `schematron/Schematron-vX.X.X/ESPDRequest/output/01-ESPD-codelist-values.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/output/01-ESPD-codelist-values.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/sch/01-ESPD-codelist-values.sch` | `schematron/Schematron-vX.X.X/ESPDRequest/output/logs/02-XSLtoSCH.txt`|
- `schematron/Schematron-vX.X.X/ESPDRequest/02-espd-schematron-sch.bat`  
    | source | trasform | output | log |
    | --- | --- | --- | --- |
    | `schematron/Schematron-vX.X.X/ESPDRequest/sch/01-ESPD-codelist-values.sch` | `schematron/Schematron-vX.X.X/common/xsl/iso_svrl_for_xslt2.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/xsl/01-ESPD-codelist-values.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/output/logs/04-SCHtoXSLT.txt` |
    | `schematron/Schematron-vX.X.X/ESPDRequest/sch/02-ESPD-req-cardinality-br.sch` | `schematron/Schematron-vX.X.X/common/xsl/iso_svrl_for_xslt2.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/xsl/02-ESPD-req-cardinality-br.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/output/logs/05-SCHtoXSLT.txt` |
    | `schematron/Schematron-vX.X.X/common/sch/04-ESPD-common-other-br.sch` | `schematron/Schematron-vX.X.X/common/xsl/iso_svrl_for_xslt2.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/xsl/04-ESPD-common-other-br.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/output/logs/06-SCHtoXSLT.txt` |
    | `schematron/Schematron-vX.X.X/ESPDRequest/sch/05-ESPD-req-procurer-br.sch` | `schematron/Schematron-vX.X.X/common/xsl/iso_svrl_for_xslt2.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/xsl/05-ESPD-req-procurer-br.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/output/logs/07-SCHtoXSLT.txt` |
    | `schematron/Schematron-vX.X.X/ESPDRequest/sch/04-ESPD-req-other-br.sch` | `schematron/Schematron-vX.X.X/common/xsl/iso_svrl_for_xslt2.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/xsl/04-ESPD-req-other-br.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/output/logs/08-SCHtoXSLT.txt` |
    | `schematron/Schematron-vX.X.X/common/sch/03-ESPD-common-criterion-br.sch` | `schematron/Schematron-vX.X.X/common/xsl/iso_svrl_for_xslt2.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/xsl/03-ESPD-common-criterion-br.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/output/logs/09-SCHtoXSLT.txt` |
    | `schematron/Schematron-vX.X.X/ESPDRequest/sch/03-ESPD-req-criterion-br.sch` | `schematron/Schematron-vX.X.X/common/xsl/iso_svrl_for_xslt2.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/xsl/03-ESPD-req-criterion-br.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/output/logs/10-SCHtoXSLT.txt` |    
    | `schematron/Schematron-vX.X.X/common/sch/01-ESPD-common-cl-attributes.sch` | `schematron/Schematron-vX.X.X/common/xsl/iso_svrl_for_xslt2.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/xsl/01-ESPD-common-cl-attributes.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/output/logs/11-SCHtoXSLT.txt` |
    | `schematron/Schematron-vX.X.X/ESPDRequest/sch/05-ESPD-req-specific-br.sch` | `schematron/Schematron-vX.X.X/common/xsl/iso_svrl_for_xslt2.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/xsl/05-ESPD-req-specific-br.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/output/logs/12-SCHtoXSLT.txt` |
    | `schematron/Schematron-vX.X.X/common/sch/01-ESPD-common-cl-values-restrictions.sch` | `schematron/Schematron-vX.X.X/common/xsl/iso_svrl_for_xslt2.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/xsl/01-ESPD-common-cl-values-restrictions.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/output/logs/13-SCHtoXSLT.txt` |
- `schematron/Schematron-vX.X.X/ESPDRequest/03-espd-schematron-xml.bat`  
    | source | trasform | output | log |
    | --- | --- | --- | --- |
    | `schematron/Schematron-vX.X.X/common/xml/ESPD-Request-BASE.xml` | `schematron/Schematron-vX.X.X/common/xsdrt/maindoc/UBL-QualificationApplicationRequest-2.3.xsd` | `schematron/Schematron-vX.X.X/ESPDRequest/output/result-xsd.xml`  | on screen direct log. ESPD Request document validation agains UBL 2.3. XSD |
    | `schematron/Schematron-vX.X.X/common/xml/ESPD-Request-BASE.xml` | `schematron/Schematron-vX.X.X/ESPDRequest/xsl/01-ESPD-codelist-values.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/output/01-ESPD-codelist-values.xml`  | `schematron/Schematron-vX.X.X/ESPDRequest/output/logs/05-XML-validation.txt` |
    | `schematron/Schematron-vX.X.X/common/xml/ESPD-Request-BASE.xml` | `schematron/Schematron-vX.X.X/ESPDRequest/xsl/02-ESPD-req-cardinality-br.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/output/02-ESPD-req-cardinality-br.xml`  | `schematron/Schematron-vX.X.X/ESPDRequest/output/logs/05-XML-validation.txt` |
    | `schematron/Schematron-vX.X.X/common/xml/ESPD-Request-BASE.xml` | `schematron/Schematron-vX.X.X/ESPDRequest/xsl/04-ESPD-common-other-br.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/output/04-ESPD-common-other-br.xml`  | `schematron/Schematron-vX.X.X/ESPDRequest/output/logs/06-XML-validation.txt` |
    | `schematron/Schematron-vX.X.X/common/xml/ESPD-Request-BASE.xml` | `schematron/Schematron-vX.X.X/ESPDRequest/xsl/05-ESPD-req-procurer-br.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/output/05-ESPD-req-procurer-br.xml`  | `schematron/Schematron-vX.X.X/ESPDRequest/output/logs/07-XML-validation.txt` |
    | `schematron/Schematron-vX.X.X/common/xml/ESPD-Request-BASE.xml` | `schematron/Schematron-vX.X.X/ESPDRequest/xsl/04-ESPD-req-other-br.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/output/04-ESPD-req-other-br.xml`  | `schematron/Schematron-vX.X.X/ESPDRequest/output/logs/08-XML-validation.txt` |
    | `schematron/Schematron-vX.X.X/common/xml/ESPD-Request-BASE.xml` | `schematron/Schematron-vX.X.X/ESPDRequest/xsl/03-ESPD-common-criterion-br.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/output/03-ESPD-common-criterion-br.xml`  | `schematron/Schematron-vX.X.X/ESPDRequest/output/logs/09-XML-validation.txt` |
    | `schematron/Schematron-vX.X.X/common/xml/ESPD-Request-BASE.xml` | `schematron/Schematron-vX.X.X/ESPDRequest/xsl/03-ESPD-req-criterion-br.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/output/03-ESPD-req-criterion-br.xml`  | `schematron/Schematron-vX.X.X/ESPDRequest/output/logs/10-XML-validation.txt` |
    | `schematron/Schematron-vX.X.X/common/xml/ESPD-Request-BASE.xml` | `schematron/Schematron-vX.X.X/ESPDRequest/xsl/01-ESPD-common-cl-attributes.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/output/01-ESPD-common-cl-attributes.xml`  | `schematron/Schematron-vX.X.X/ESPDRequest/output/logs/11-XML-validation.txt` |
    | `schematron/Schematron-vX.X.X/common/xml/ESPD-Request-BASE.xml` | `schematron/Schematron-vX.X.X/ESPDRequest/xsl/05-ESPD-req-specific-br.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/output/05-ESPD-req-specific-br.xml`  | `schematron/Schematron-vX.X.X/ESPDRequest/output/logs/12-XML-validation.txt` |
    | `schematron/Schematron-vX.X.X/common/xml/ESPD-Request-BASE.xml` | `schematron/Schematron-vX.X.X/ESPDRequest/xsl/01-ESPD-common-cl-values-restrictions.xsl` | `schematron/Schematron-vX.X.X/ESPDRequest/output/01-ESPD-common-cl-values-restrictions.xml`  | `schematron/Schematron-vX.X.X/ESPDRequest/output/logs/12-XML-validation.txt` |
    
**Phase III - ESPD Response validation**

Run files in this order:
- `schematron/Schematron-vX.X.X/ESPDResponse/01-espd-schematron-cva.bat`
    | source | trasform | output | log |
    | --- | --- | --- | --- |
    | `schematron/Schematron-vX.X.X/common/cva/01-ESPD-codelist-values.cva` | `schematron/Schematron-vX.X.X/common/xsl/Crane-cva2schXSLT.xsl` | `schematron/Schematron-vX.X.X/ESPDResponse/output/01-ESPD-codelist-values.xsl` | `schematron/Schematron-vX.X.X/ESPDResponse/output/logs/01-CVAtoXSL.txt`|
    | `schematron/Schematron-vX.X.X/ESPDResponse/output/01-ESPD-codelist-values.xsl` | `schematron/Schematron-vX.X.X/ESPDResponse/output/01-ESPD-codelist-values.xsl` | `schematron/Schematron-vX.X.X/ESPDResponse/sch/01-ESPD-codelist-values.sch` | `schematron/Schematron-vX.X.X/ESPDResponse/output/logs/02-XSLtoSCH.txt`|
- `schematron/Schematron-vX.X.X/ESPDResponse/02-espd-schematron-sch.bat`  
    | source | trasform | output | log |
    | --- | --- | --- | --- |
    | `schematron/Schematron-vX.X.X/ESPDResponse/sch/01-ESPD-codelist-values.sch` | `schematron/Schematron-vX.X.X/common/xsl/iso_svrl_for_xslt2.xsl` | `schematron/Schematron-vX.X.X/ESPDResponse/xsl/01-ESPD-codelist-values.xsl`  | `schematron/Schematron-vX.X.X/ESPDResponse/output/logs/04-SCHtoXSLT.txt` |
    | `schematron/Schematron-vX.X.X/ESPDResponse/sch/02-ESPD-resp-cardinality-br.sch` | `schematron/Schematron-vX.X.X/common/xsl/iso_svrl_for_xslt2.xsl` | `schematron/Schematron-vX.X.X/ESPDResponse/xsl/02-ESPD-resp-cardinality-br.xsl`  | `schematron/Schematron-vX.X.X/ESPDResponse/output/logs/05-SCHtoXSLT.txt` |
    | `schematron/Schematron-vX.X.X/common/sch/04-ESPD-common-other-br.sch` | `schematron/Schematron-vX.X.X/common/xsl/iso_svrl_for_xslt2.xsl` | `schematron/Schematron-vX.X.X/ESPDResponse/xsl/04-ESPD-common-other-br.xsl`  | `schematron/Schematron-vX.X.X/ESPDResponse/output/logs/06-SCHtoXSLT.txt` |
    | `schematron/Schematron-vX.X.X/ESPDResponse/sch/05-ESPD-resp-eo-br.sch` | `schematron/Schematron-vX.X.X/common/xsl/iso_svrl_for_xslt2.xsl` | `schematron/Schematron-vX.X.X/ESPDResponse/xsl/05-ESPD-resp-eo-br.xsl`  | `schematron/Schematron-vX.X.X/ESPDResponse/output/logs/07-SCHtoXSLT.txt` |
    | `schematron/Schematron-vX.X.X/ESPDResponse/sch/04-ESPD-resp-other-br.sch` | `schematron/Schematron-vX.X.X/common/xsl/iso_svrl_for_xslt2.xsl` | `schematron/Schematron-vX.X.X/ESPDResponse/xsl/04-ESPD-resp-other-br.xsl`  | `schematron/Schematron-vX.X.X/ESPDResponse/output/logs/08-SCHtoXSLT.txt` |
    | `schematron/Schematron-vX.X.X/common/sch/03-ESPD-common-criterion-br.sch` | `schematron/Schematron-vX.X.X/common/xsl/iso_svrl_for_xslt2.xsl` | `schematron/Schematron-vX.X.X/ESPDResponse/xsl/03-ESPD-common-criterion-br.xsl`  | `schematron/Schematron-vX.X.X/ESPDResponse/output/logs/09-SCHtoXSLT.txt` |
    | `schematron/Schematron-vX.X.X/ESPDResponse/sch/05-ESPD-resp-role-br.sch` | `schematron/Schematron-vX.X.X/common/xsl/iso_svrl_for_xslt2.xsl` | `schematron/Schematron-vX.X.X/ESPDResponse/xsl/05-ESPD-resp-role-br.xsl`  | `schematron/Schematron-vX.X.X/ESPDResponse/output/logs/10-SCHtoXSLT.txt` |
    | `schematron/Schematron-vX.X.X/ESPDResponse/sch/03-ESPD-resp-criterion-br.sch` | `schematron/Schematron-vX.X.X/common/xsl/iso_svrl_for_xslt2.xsl` | `schematron/Schematron-vX.X.X/ESPDResponse/xsl/03-ESPD-resp-criterion-br.xsl`  | `schematron/Schematron-vX.X.X/ESPDResponse/output/logs/11-SCHtoXSLT.txt` |
    | `schematron/Schematron-vX.X.X/ESPDResponse/sch/05-ESPD-resp-qualification-br.sch` | `schematron/Schematron-vX.X.X/common/xsl/iso_svrl_for_xslt2.xsl` | `schematron/Schematron-vX.X.X/ESPDResponse/xsl/05-ESPD-resp-qualification-br.xsl`  | `schematron/Schematron-vX.X.X/ESPDResponse/output/logs/12-SCHtoXSLT.txt` |
    | `schematron/Schematron-vX.X.X/ESPDResponse/sch/05-ESPD-resp-specific-br.sch` | `schematron/Schematron-vX.X.X/common/xsl/iso_svrl_for_xslt2.xsl` | `schematron/Schematron-vX.X.X/ESPDResponse/xsl/05-ESPD-resp-specific-br.xsl`  | `schematron/Schematron-vX.X.X/ESPDResponse/output/logs/13-SCHtoXSLT.txt` |
    | `schematron/Schematron-vX.X.X/common/sch/01-ESPD-common-cl-attributes.sch` | `schematron/Schematron-vX.X.X/common/xsl/iso_svrl_for_xslt2.xsl` | `schematron/Schematron-vX.X.X/ESPDResponse/xsl/01-ESPD-common-cl-attributes.xsl`  | `schematron/Schematron-vX.X.X/ESPDResponse/output/logs/14-SCHtoXSLT.txt` |
    | `schematron/Schematron-vX.X.X/common/sch/01-ESPD-common-cl-values-restrictions.sch` | `schematron/Schematron-vX.X.X/common/xsl/iso_svrl_for_xslt2.xsl` | `schematron/Schematron-vX.X.X/ESPDResponse/xsl/01-ESPD-common-cl-values-restrictions.xsl`  | `schematron/Schematron-vX.X.X/ESPDResponse/output/logs/15-SCHtoXSLT.txt` |
- `schematron/Schematron-vX.X.X/ESPDResponse/3-espd-schematron-xml.bat`  
    | source | trasform | output | log |
    | --- | --- | --- | --- |



### Errors and debugging

- for Code List files validation errors please look in `schematron/Schematron-vX.X.X/logs/1-GC-Files.txt`
- for ESPD Request validation errors please check: `schematron/Schematron-vX.X.X/ESPDRequest/output/logs` files for each step in the pipeline contain the eventual error messages
- for ESPD Response validation errors please check: `schematron/Schematron-vX.X.X/ESPDResponse/output/logs` files for each step in the pipeline contain the eventual error messages

Please consult the input source file and the transfomation file in order to fix the errors.

### How to use the results

Once the 3 main parts are executed without any errors, especially validation errors, we can use the files produced in `find those folders ???` can be copied to ESPD-EDM `validation` folder. The files from `find that folder ???` should be copied to validation-resources-espd repository.

## Licence  
The project is developed and distributed under EUROPEAN UNION PUBLIC LICENCE v. 1.2.