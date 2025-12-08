# espd-validation-schematron
ESPD validation tool based on Schematron rules

[![EUPL Licence](https://img.shields.io/badge/Licence-EUPL%20v1.2-blue.svg)](https://eupl.eu/1.2/en)

**Audience**

This is a technical repository and is intended to be used as a tool that has as input:
- Code Lists,
- ESPD Request and ESPD Response, and
- UBL
- Schematron rules specific to ESPD business rules

and produces the XSL files that can be used to either validate locally any ESPD Request and/or ESPD Response or as the online service on [ISAITB testbed site](https://www.itb.ec.europa.eu/espd/upload). You can see the validation files on the associated [GitHub repository](https://github.com/ISAITB/validator-resources-espd).


## Description

This repository is a processing tool that implements ESPD business rules in Schematron format in order to validate ESPD Request and ESPD Response files in XML format. ESPD is based on UBL with a couple of extra business rules. Thus the validation of an ESPD document is based on UBL Documents `QualificationApplicationRequest` for ESPD Request and `QualificationApplicationResponse` for ESPD Response.
All ESPD-specific business rules are described in terms of Schematron rules. Those rules are processed and transformed into XSL files.

## Install

### Prerequisites

The `espd-schematron.bat` file which is used to generate the schematron and XSL validation files is a Windows Batch file, and can only be run in a Windows environment.

You need to have installed the following tools on your machine before starting to use the ESPD Validation tool:
- Git client (GitBash or GitHub Desktop on Windows, native on OSX and Linux)
- Java JDK v1.8 or higher, you can use OpenJDK
- IDE tool of your choice (e.g. Visual Studio Code)

### Getting started
Get the current repository on your local computer:

```
git clone https://github.com/OP-TED/espd-validation-schematron.git
```
This will create the folder `espd-validation-schematron` on your local computer. You may use your preferred IDE to edit the specific files. You need a Windows terminal, either the Windows Command Prompt, or in an IDE, to run the commands and tools.

### Repository structure

The folder structure is standard and contains:
- `espd-schematron-gc.bat` a Windows batch executable that is present in the root of the folder
- `ESPDRequest` the folder containing the necessary input and output files for ESPD Request validation
- `ESPDResponse` the folder containing the necessary input and output files for ESPD Response validation
- `common` the folder containing all common artefacts, libraries, and XSD files necessary to validate and produce extra validators
- `gc` the folder contains all Code List files
- the `logs` folder contains the output of the execution of internal pipelines and should be checked for errors. If any errors occur during processing they are in the log files after each execution.

## Documentation

This tool is provided as is and is intended to be used as an intermediary step in the entire chain of the ESPD validation process. Any contributions, suggestions and improvements are more than welcome. Please feel free to open a [GitHub issue](https://github.com/OP-TED/espd-validation-schematron/issues) for your feedback.

### Data preparation

The tool will validate:
- Code Lists
- ESPD Request
- ESPD Response

all files are in XML format.

**External data sources**

Please update the files in the [ESPD-EDM](https://github.com/OP-TED/ESPD-EDM) repository first and then proceed.

The following files should be copied from the [ESPD-EDM](https://github.com/OP-TED/ESPD-EDM) repository

| from ESPD-EDM | to espd-validation-schematron | _comments_ |
| --- | --- | --- |
| `codelists/gc`| `gc`| Update both external and technical Code Lists in ESPD-EDM and then copy the content of the folder to espd-validation-schematron |
| `xml-examples/ESPD-criterion.xml` | `ESPDRequest/xsl` and `ESPDResponse/xsl` | This is the same file as ESPD-Request.xml from ESPD-EDM repository. Copy the same file to 2 different folders |
| `xml-examples/ESPD-Request.xml` | `common/xml/ESPD-Request-BASE.xml` and `common/xml/validation_samples/ESPD-Request.xml` | Copy the same file to 2 different folders |
| `xml-examples/ESPD-Response.xml` | `common/xml/ESPD-Response-BASE.xml` and `common/xml/validation_samples/ESPD-Response.xml` | Copy the same file to 2 different folders |
| `ubl-2.4/xsdrt` | `common/xsdrt` | Update the UBL distribution file in ESPD-EDM and then copy the content of the folder to espd-validation-schematron |

External Code Lists are provided by EU Vocabularies. The ESPD example files are generated from the Excel Criterion file or from the ESPD Demo site. The UBL files are directly downloaded from the UBL distribution site.
Once the external files are in place we can proceed to modifying the internal files.

**Internal files**

Please use only relative paths inside the files so that the pipelines can be run independently on the local file location specific to the user's computer.

The following internal files must be updated after all external files have been copied:
- `common/cva/01-ESPD-codelist-values.cva` contains the updated list with all codelist files, see `gc` folder for a complete list of codelist files, and ESPD-specific business rules associated to each codelist.
-  `common/lib` contains all Java libraries. Please update the libraries so that the version are mutually compatible with both the JDK installed version and each other.
- `common/sch` contains the Schematron rules specific to the ESPD. Those rules must be updated according to changes implemented in the ESPD model.
  - `01-ESPD-common-cl-attributes.sch` contains the common criterion business rules for attributes that get their values from codelists.
  - `01-ESPD-common-cl-values-restrictions.sch` contains the restrictions for common criterion business rules for attributes that get their values from codelists - no restrictions for the moment.
  - `03-ESPD-common-criterion-br.sch` contains the set of rules associated to the `cac:TenderingCriterion` element for both ESPD Request and ESPD Response.
  - `04-ESPD-common-other-br.sch` contains the cardinality constraints and other general business rules
- `common/xml` contains the base examples that will be used as input for validation. Specific examples can be found in subfolder `validation_samples` and can be used for specific validation. This has to be configured manually. Only the base example files are used in the processing chain.
- `common/xsd` contains the general XSD files used for XML validation.
  - `ContextValueAssociation.xsd` is currently not used, but could be used to validate the `.cva` files.
  - `genericode.xsd` is used to validate Code Lists from `gc`
  - `xml.xsd` is used by the above `.xsd` files to validate the XML namespace.
- `common/xsdrt` contains the XSD run-time files for UBL documents validation. ESPD documents are based on UBL Documents `QualificationApplicationRequest` for Request and `QualificationApplicationResponse` for Response
- `common/xsl/` contains generic XSL transformation tools used to transform schematron files, cva files and for internal pipelines. Those files should be updated only if necessary.
  - `Crane-cva2schXSLT.xsl` - used to transform the CVA to SCH
  - `Crane-Constraints2SchematronXSLT.xsl` - used by `Crane-cva2schXSLT.xsl`
  - `Crane-genericode-CodeList.xsl` - used by `Crane-cva2schXSLT.xsl`
  - `Message-Schematron-terminator.xsl` - not used
  - `iso_svrl_for_xslt2.xsl` - used to transform Schematron `.sch` files into XSLT `.xsl` files
  - `iso_schematron_skeleton_for_saxon.xsl` - used by `iso_svrl_for_xslt2.xsl` when using the Saxon library
  - `iso_schematron_skeleton_for_xslt1.xsl` - not used
- `ESPDRequest` contains ESPD Request validation related files.
  - `sch` contains Schematron business rules that have to be considered for full validation of the ESPD Request. Some of the files are generated automatically, some are managed manually
  - `xsl` contains the result of transforming Schematron files to XSL. The `criterionList.xml` file is maintained manually and `ESPD-criterion.xml` is from ESPD-EDM.
  - `output` contains the results produced by the steps within the internal pipelines. Those files are automatically generated.
- `ESPDResponse` contains ESPD Response validation related files.
  - `sch` contains Schematron business rules that have to be considered for full validation of the ESPD Response. Some of the files are generated automatically, some are managed manually.
  - `xsl` contains the result of transfoming Schmematron files to XSL. The `criterionList.xml` file is maintained manually and `ESPD-criterion.xml` is from ESPD-EDM.
  - `output` contains the results produced by the steps within the internal pipelines. Those files are automatically generated.

### How to use the tool

The 3 `.bat` files which comprised the tool in previous releases have been combined into one `espd-schematron.bat` file in the root folder. You must have a Java environment (JAVA_HOME, Path) set up for the command line execution.
This bat file uses the `common/lib/xjparse.jar` and `common/lib/saxon9he.jar` libraries.

The order of execution of the bat files in previous releases was: all phases for the ESPD Request, then all phases for the ESPD Response. This order has been changed in the single bat file in this release to be per phase, with both ESPD Request and ESPD Response processed in some phases.

**Phase 0 - Code List XML validation against the Genericode schema**

All Code List files `*.gc` are parsed against the Genericode schema `common\xsd\genericode.xsd` using `common\lib\xjparse-app-3.0.0.jar`, output is sent to `logs\gc\00-GC_Files.txt`.

**Phase 1 - Code List schematron generation**

This phase converts the codelist value constraints document into schematron files  (one each for ESPDRequest and ESPDResponse). For each ESPD, the file `common\cva\01-ESPD-codelist-values.cva` is converted into an XSLT document using `common\xsl\Crane-cva2schXSLT.xsl`. Then the XSLT documents is run against itself to produce the schematron `ESPDRequest\sch\01-ESPD-codelist-values.sch` and `ESPDResponse\sch\01-ESPD-codelist-values.sch` files.

**Phase 1: ESPD Request / ESPD Response codelist value schematron generation**

1. | | |
   | --- | --- |
   | **source**    | `common/cva/01-ESPD-codelist-values.cva` |
   | **transform** | `common/xsl/Crane-cva2schXSLT.xsl` |
   | **output**    | `logs/ESPDRequest/output/01-ESPD-codelist-values.xsl` |
   | **log**       | `logs/ESPDRequest/01-CVAtoSCH.txt` |
1. | | |
   | --- | --- |
   | **source**    | `logs/ESPDRequest/output/01-ESPD-codelist-values.xsl` |
   | **transform** | `logs/ESPDRequest/output/01-ESPD-codelist-values.xsl` |
   | **output**    | `ESPDRequest/sch/01-ESPD-codelist-values.sch` |
   | **log**       | `logs/ESPDRequest/01-CVAtoSCH.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/cva/01-ESPD-codelist-values.cva` |
   | **transform** | `common/xsl/Crane-cva2schXSLT.xsl` |
   | **output**    | `logs/ESPDResponse/output/01-ESPD-codelist-values.xsl` |
   | **log**       | `logs/ESPDResponse/01-CVAtoSCH.txt` |
1. | | |
   | --- | --- |
   | **source**    | `logs/ESPDResponse/output/01-ESPD-codelist-values.xsl` |
   | **transform** | `logs/ESPDResponse/output/01-ESPD-codelist-values.xsl` |
   | **output**    | `ESPDResponse/sch/01-ESPD-codelist-values.sch` |
   | **log**       | `logs/ESPDResponse/01-CVAtoSCH.txt` |

**Phase 2: ESPD Request transform SCH to XSL**

1. | | |
   | --- | --- |
   | **source**    | `ESPDRequest/sch/01-ESPD-codelist-values.sch` |
   | **transform** | `common/xsl/iso_svrl_for_xslt2.xsl` |
   | **output**    | `ESPDRequest/xsl/01-ESPD-codelist-values.xsl` |
   | **log**       | `logs/ESPDRequest/02-SCHtoXSL.txt` |
1. | | |
   | --- | --- |
   | **source**    | `ESPDRequest/sch/02-ESPD-req-cardinality-br.sch` |
   | **transform** | `common/xsl/iso_svrl_for_xslt2.xsl` |
   | **output**    | `ESPDRequest/xsl/02-ESPD-req-cardinality-br.xsl` |
   | **log**       | `logs/ESPDRequest/02-SCHtoXSL.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/sch/04-ESPD-common-other-br.sch` |
   | **transform** | `common/xsl/iso_svrl_for_xslt2.xsl` |
   | **output**    | `ESPDRequest/xsl/04-ESPD-common-other-br.xsl` |
   | **log**       | `logs/ESPDRequest/02-SCHtoXSL.txt` |
1. | | |
   | --- | --- |
   | **source**    | `ESPDRequest/sch/05-ESPD-req-procurer-br.sch` |
   | **transform** | `common/xsl/iso_svrl_for_xslt2.xsl` |
   | **output**    | `ESPDRequest/xsl/05-ESPD-req-procurer-br.xsl` |
   | **log**       | `logs/ESPDRequest/02-SCHtoXSL.txt` |
1. | | |
   | --- | --- |
   | **source**    |  `ESPDRequest/sch/04-ESPD-req-other-br.sch` |
   | **transform** | `common/xsl/iso_svrl_for_xslt2.xsl` |
   | **output**    | `ESPDRequest/xsl/04-ESPD-req-other-br.xsl` |
   | **log**       | `logs/ESPDRequest/02-SCHtoXSL.txt` |
1. | | |
   | --- | --- |
   | **source**    |  `common/sch/03-ESPD-common-criterion-br.sch` |
   | **transform** | `common/xsl/iso_svrl_for_xslt2.xsl` |
   | **output**    | `ESPDRequest/xsl/03-ESPD-common-criterion-br.xsl` |
   | **log**       | `logs/ESPDRequest/02-SCHtoXSL.txt` |
1. | | |
   | --- | --- |
   | **source**    | `ESPDRequest/sch/03-ESPD-req-criterion-br.sch` |
   | **transform** | `common/xsl/iso_svrl_for_xslt2.xsl` |
   | **output**    | `ESPDRequest/xsl/03-ESPD-req-criterion-br.xsl` |
   | **log**       | `logs/ESPDRequest/02-SCHtoXSL.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/sch/01-ESPD-common-cl-attributes.sch` |
   | **transform** | `common/xsl/iso_svrl_for_xslt2.xsl` |
   | **output**    | `ESPDRequest/xsl/01-ESPD-common-cl-attributes.xsl` |
   | **log**       | `logs/ESPDRequest/02-SCHtoXSL.txt` |
1. | | |
   | --- | --- |
   | **source**    | `ESPDRequest/sch/05-ESPD-req-specific-br.sch` |
   | **transform** | `common/xsl/iso_svrl_for_xslt2.xsl` |
   | **output**    | `ESPDRequest/xsl/05-ESPD-req-specific-br.xsl` |
   | **log**       | `logs/ESPDRequest/02-SCHtoXSL.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/sch/01-ESPD-common-cl-values-restrictions.sch` |
   | **transform** | `common/xsl/iso_svrl_for_xslt2.xsl` |
   | **output**    | `ESPDRequest/xsl/01-ESPD-common-cl-values-restrictions.xsl` |
   | **log**       | `logs/ESPDRequest/02-SCHtoXSL.txt` |

**Phase 3: ESPD Response transform SCH to XSL**

1. | | |
   | --- | --- |
   | **source**    | `ESPDResponse/sch/01-ESPD-codelist-values.sch` |
   | **transform** | `common/xsl/iso_svrl_for_xslt2.xsl` |
   | **output**    | `ESPDResponse/xsl/01-ESPD-codelist-values.xsl`  |
   | **log**       | `logs/ESPDResponse/02-SCHtoXSL.txt` |
1. | | |
   | --- | --- |
   | **source**    | `ESPDResponse/sch/02-ESPD-resp-cardinality-br.sch` |
   | **transform** | `common/xsl/iso_svrl_for_xslt2.xsl` |
   | **output**    | `ESPDResponse/xsl/02-ESPD-resp-cardinality-br.xsl`  |
   | **log**       | `logs/ESPDResponse/02-SCHtoXSL.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/sch/04-ESPD-common-other-br.sch` |
   | **transform** | `common/xsl/iso_svrl_for_xslt2.xsl` |
   | **output**    | `ESPDResponse/xsl/04-ESPD-common-other-br.xsl`  |
   | **log**       | `logs/ESPDResponse/02-SCHtoXSL.txt` |
1. | | |
   | --- | --- |
   | **source**    | `ESPDResponse/sch/05-ESPD-resp-eo-br.sch` |
   | **transform** | `common/xsl/iso_svrl_for_xslt2.xsl` |
   | **output**    | `ESPDResponse/xsl/05-ESPD-resp-eo-br.xsl`  |
   | **log**       | `logs/ESPDResponse/02-SCHtoXSL.txt` |
1. | | |
   | --- | --- |
   | **source**    | `ESPDResponse/sch/04-ESPD-resp-other-br.sch` |
   | **transform** | `common/xsl/iso_svrl_for_xslt2.xsl` |
   | **output**    | `ESPDResponse/xsl/04-ESPD-resp-other-br.xsl`  |
   | **log**       | `logs/ESPDResponse/02-SCHtoXSL.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/sch/03-ESPD-common-criterion-br.sch` |
   | **transform** | `common/xsl/iso_svrl_for_xslt2.xsl` |
   | **output**    | `ESPDResponse/xsl/03-ESPD-common-criterion-br.xsl`  |
   | **log**       | `logs/ESPDResponse/02-SCHtoXSL.txt` |
1. | | |
   | --- | --- |
   | **source**    | `ESPDResponse/sch/05-ESPD-resp-role-br.sch` |
   | **transform** | `common/xsl/iso_svrl_for_xslt2.xsl` |
   | **output**    | `ESPDResponse/xsl/05-ESPD-resp-role-br.xsl`  |
   | **log**       | `logs/ESPDResponse/02-SCHtoXSL.txt` |
1. | | |
   | --- | --- |
   | **source**    | `ESPDResponse/sch/03-ESPD-resp-criterion-br.sch` |
   | **transform** | `common/xsl/iso_svrl_for_xslt2.xsl` |
   | **output**    | `ESPDResponse/xsl/03-ESPD-resp-criterion-br.xsl`  |
   | **log**       | `logs/ESPDResponse/02-SCHtoXSL.txt` |
1. | | |
   | --- | --- |
   | **source**    | `ESPDResponse/sch/05-ESPD-resp-qualification-br.sch` |
   | **transform** | `common/xsl/iso_svrl_for_xslt2.xsl` |
   | **output**    | `ESPDResponse/xsl/05-ESPD-resp-qualification-br.xsl`  |
   | **log**       | `logs/ESPDResponse/02-SCHtoXSL.txt` |
1. | | |
   | --- | --- |
   | **source**    | `ESPDResponse/sch/05-ESPD-resp-specific-br.sch` |
   | **transform** | `common/xsl/iso_svrl_for_xslt2.xsl` |
   | **output**    | `ESPDResponse/xsl/05-ESPD-resp-specific-br.xsl`  |
   | **log**       | `logs/ESPDResponse/02-SCHtoXSL.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/sch/01-ESPD-common-cl-attributes.sch` |
   | **transform** |  `common/xsl/iso_svrl_for_xslt2.xsl` |
   | **output**    | `ESPDResponse/xsl/01-ESPD-common-cl-attributes.xsl`  |
   | **log**       | `logs/ESPDResponse/02-SCHtoXSL.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/sch/01-ESPD-common-cl-values-restrictions.sch` |
   | **transform** | `common/xsl/iso_svrl_for_xslt2.xsl` |
   | **output**    | `ESPDResponse/xsl/01-ESPD-common-cl-values-restrictions.xsl` |
   | **log**       | `logs/ESPDResponse/02-SCHtoXSL.txt` |

**Phase 3: ESPD Response validation vs UBL and XSL**

1. | | |
   | --- | --- |
   | **source**    |  `common/xml/ESPD-Request-BASE.xml` |
   | **transform** | `common/xsdrt/maindoc/UBL-QualificationApplicationRequest-2.3.xsd` |
   | **output**    | `logs/ESPDRequest/output/result-xsd.xml` |
   | **log**       | `logs/ESPDRequest/03-validation.txt` |
1. | | |
   | --- | --- |
   | **source**    |  `common/xml/ESPD-Request-BASE.xml` |
   | **transform** | `ESPDRequest/xsl/01-ESPD-codelist-values.xsl` |
   | **output**    | `logs/ESPDRequest/output/01-ESPD-codelist-values.xml` |
   | **log**       | `logs/ESPDRequest/03-validation.txt` |
1. | | |
   | --- | --- |
   | **source**    |  `common/xml/ESPD-Request-BASE.xml`|
   | **transform** | `ESPDRequest/xsl/02-ESPD-req-cardinality-br.xsl` |
   | **output**    |  `logs/ESPDRequest/output/02-ESPD-req-cardinality-br.xml` |
   | **log**       | `logs/ESPDRequest/03-validation.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/xml/ESPD-Request-BASE.xml` |
   | **transform** | `ESPDRequest/xsl/04-ESPD-common-other-br.xsl` |
   | **output**    | `logs/ESPDRequest/output/04-ESPD-common-other-br.xml` |
   | **log**       | `logs/ESPDRequest/03-validation.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/xml/ESPD-Request-BASE.xml` |
   | **transform** | `ESPDRequest/xsl/05-ESPD-req-procurer-br.xsl` |
   | **output**    | `logs/ESPDRequest/output/05-ESPD-req-procurer-br.xml` |
   | **log**       | `logs/ESPDRequest/03-validation.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/xml/ESPD-Request-BASE.xml` |
   | **transform** | `ESPDRequest/xsl/04-ESPD-req-other-br.xsl` |
   | **output**    | `logs/ESPDRequest/output/04-ESPD-req-other-br.xml`  |
   | **log**       | `logs/ESPDRequest/03-validation.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/xml/ESPD-Request-BASE.xml` |
   | **transform** | `ESPDRequest/xsl/03-ESPD-common-criterion-br.xsl` |
   | **output**    | `logs/ESPDRequest/output/03-ESPD-common-criterion-br.xml` |
   | **log**       | `logs/ESPDRequest/03-validation.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/xml/ESPD-Request-BASE.xml` |
   | **transform** | `ESPDRequest/xsl/03-ESPD-req-criterion-br.xsl` |
   | **output**    | `logs/ESPDRequest/output/03-ESPD-req-criterion-br.xml`  |
   | **log**       | `logs/ESPDRequest/03-validation.txt`|
1. | | |
   | --- | --- |
   | **source**    | `common/xml/ESPD-Request-BASE.xml` |
   | **transform** | `ESPDRequest/xsl/01-ESPD-common-cl-attributes.xsl` |
   | **output**    | `logs/ESPDRequest/output/01-ESPD-common-cl-attributes.xml` |
   | **log**       | `logs/ESPDRequest/03-validation.txt`|
1. | | |
   | --- | --- |
   | **source**    | `common/xml/ESPD-Request-BASE.xml` |
   | **transform** | `ESPDRequest/xsl/05-ESPD-req-specific-br.xsl` |
   | **output**    | `logs/ESPDRequest/output/05-ESPD-req-specific-br.xml`  |
   | **log**       | `logs/ESPDRequest/03-validation.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/xml/ESPD-Request-BASE.xml` |
   | **transform** | `ESPDRequest/xsl/01-ESPD-common-cl-values-restrictions.xsl` |
   | **output**    | `logs/ESPDRequest/output/01-ESPD-common-cl-values-restrictions.xml`  |
   | **log**       | `logs/ESPDRequest/03-validation.txt`|

**Phase 3: ESPD Response validation vs UBL and XSL**

1. | | |
   | --- | --- |
   | **source**    | `common/xml/ESPD-Response-BASE.xml` |
   | **transform** | `ESPDResponse/xsl/01-ESPD-codelist-values.xsl` |
   | **output**    | `logs/ESPDResponse/output/01-ESPD-codelist-values.xml` |
   | **log**       | `logs/ESPDResponse/03-validation.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/xml/ESPD-Response-BASE.xml` |
   | **transform** | `ESPDResponse/xsl/02-ESPD-resp-cardinality-br.xsl` |
   | **output**    | `logs/ESPDResponse/output/02-ESPD-resp-cardinality-br.xml` |
   | **log**       | `logs/ESPDResponse/03-validation.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/xml/ESPD-Response-BASE.xml` |
   | **transform** | `ESPDResponse/xsl/04-ESPD-common-other-br.xsl` |
   | **output**    | `logs/ESPDResponse/output/04-ESPD-common-other-br.xml` |
   | **log**       | `logs/ESPDResponse/03-validation.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/xml/ESPD-Response-BASE.xml` |
   | **transform** | `ESPDResponse/xsl/05-ESPD-resp-eo-br.xsl` |
   | **output**    | `logs/ESPDResponse/output/05-ESPD-resp-eo-br.xml` |
   | **log**       | `logs/ESPDResponse/03-validation.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/xml/ESPD-Response-BASE.xml` |
   | **transform** | `ESPDResponse/xsl/04-ESPD-resp-other-br.xsl` |
   | **output**    | `logs/ESPDResponse/output/04-ESPD-resp-other-br.xml` |
   | **log**       | `logs/ESPDResponse/03-validation.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/xml/ESPD-Response-BASE.xml` |
   | **transform** | `ESPDResponse/xsl/03-ESPD-common-criterion-br.xsl` |
   | **output**    | `logs/ESPDResponse/output/03-ESPD-common-criterion-br.xml` |
   | **log**       | `logs/ESPDResponse/03-validation.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/xml/ESPD-Response-BASE.xml` |
   | **transform** | `ESPDResponse/xsl/05-ESPD-resp-role-br.xsl` |
   | **output**    | `logs/ESPDResponse/output/05-ESPD-resp-role-br.xml` |
   | **log**       | `logs/ESPDResponse/03-validation.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/xml/ESPD-Response-BASE.xml` |
   | **transform** | `ESPDResponse/xsl/03-ESPD-resp-criterion-br.xsl` |
   | **output**    | `logs/ESPDResponse/output/03-ESPD-resp-criterion-br.xml` |
   | **log**       | `logs/ESPDResponse/03-validation.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/xml/ESPD-Response-BASE.xml` |
   | **transform** | `ESPDResponse/xsl/05-ESPD-resp-qualification-br.xsl` |
   | **output**    | `logs/ESPDResponse/output/05-ESPD-resp-qualification-br.xml` |
   | **log**       | `logs/ESPDResponse/03-validation.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/xml/ESPD-Response-BASE.xml` |
   | **transform** | `ESPDResponse/xsl/05-ESPD-resp-specific-br.xsl` |
   | **output**    | `logs/ESPDResponse/output/05-ESPD-resp-specific-br.xml` |
   | **log**       | `logs/ESPDResponse/03-validation.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/xml/ESPD-Response-BASE.xml` |
   | **transform** | `ESPDResponse/xsl/01-ESPD-common-cl-attributes.xsl` |
   | **output**    | `logs/ESPDResponse/output/01-ESPD-common-cl-attributes.xml` |
   | **log**       | `logs/ESPDResponse/03-validation.txt` |
1. | | |
   | --- | --- |
   | **source**    | `common/xml/ESPD-Response-BASE.xml` |
   | **transform** | `ESPDResponse/xsl/01-ESPD-common-cl-values-restrictions.xsl` |
   | **output**    | `logs/ESPDResponse/output/01-ESPD-common-cl-values-restrictions.xml` |
   | **log**       | `logs/ESPDResponse/03-validation.txt` |

### Errors and debugging

- for Code List files validation errors please check `logs/gc/00-GC_Files.txt`
- for ESPD Request validation errors please check: `logs/ESPDRequest/output` files for each step in the pipeline
- for ESPD Response validation errors please check: `logs/ESPDResponse/output` files for each step in the pipeline

Please consult the input source file and the transformation file in order to fix the errors.

### How to use the results

Once the validation is executed successfully (check for any errors in the log files, especially validation errors), we can use the files produced in `ESPDRequest` and `ESPDResponse` folders to copy to the ESPD-EDM repository `validation` folder. The files from the ESPD-EDM repository should be copied to validation-resources-espd repository.

| from espd-validation-schematron | to ESPD-EDM |
| --- | --- |
| `ESPDRequest/sch/` | `validation/ESPDRequest/sch/` |
| `ESPDRequest/xsl/`| `validation/ESPDRequest/xsl/` |
| `ESPDResponse/sch/` | `validation/ESPDResponse/sch/` |
| `ESPDResponse/xsl/` | `validation/ESPDResponse/xsl/` |
| `common/cva/` | `validation/common/cva/` |
| `common/sch/` | `validation/common/sch/` |

| from ESPD-EDM | to validator-resources-espd |
| --- | --- |
| `validation/ESPDRequest/xsl/` | `resources/vX.X.X/ESPDRequest/` |
| `validation/ESPDResponse/xsl/` | `resources/vX.X.X/ESPDResponse/` |
| `codelists/gc/` | `resources/vX.X.X/gc/` |
| `ubl-2.3/xsdrt/` | `resources/vX.X.X/xsdrt/` |

## Licence
The project is developed and distributed under the [European Union Public Licence (EUPL) version 1.2](https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12).