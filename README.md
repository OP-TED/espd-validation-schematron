# espd-validation-schematron
ESPD validation process based on schematron rules 

**Audience** 

This is a technical repository and is intended to be used as a tool that has as input: 
- Code Lists, 
- ESPD Request and ESPD Response, and 
- UBL
- Schematron rules specific to ESPD business rules
and produces the XSL files that can be used to either validate locally any ESPD Request and/or ESPD Response locally or on [ISAITB testbed site](https://www.itb.ec.europa.eu/espd/upload). You can see the validation files on associated [GitHub repository](https://github.com/ISAITB/validator-resources-espd).

# Description

This repository is a processing tool that implements ESPD business rules in Schematron format in order to validate ESPD Request and ESPD Respose files in XML format. ESPD is based on UBL with a couple of extra business rules. Thus the validation of an ESPD document is based on UBL ```QualificationApplicationRequest``` for ESPD Request and ```QualificationApplicationResponse``` for ESPD Response.  
All ESPD specific business rules are described in terms of Schematron rules. Those rules are processed and transformed into XSL files.

# Install

## Pre-requsites  

You need to have installed the following tools before you start using the ESPD Validation tool:
- Git client (GitBash or GitHub Desktop on Windows, native on OSX and Linux)
- Java JDK v1.8 or higher
- IDE tool (Visual Studio Code, vi, Notepad++)

## Start
Get the current repository on your local computer:

```
git clone https://github.com/OP-TED/espd-validation-schematron.git
```
This will create the folder ```espd-validation-schematron``` on your local computer. You may use your prefered IDE to edit the specfic files. You need a terminal, also available via the IDE, to run the commands and tools.

## Folder structure

```mock-ups``` contains Microsoft Viso UI mock-ups of the various ESPD criterion and the exporterd version in PNG format. Those files are used for user visualisation and demonstration of possible look for the ESPD criteria. This folder is not maintained and is provided as is.

```schematron``` contains the validation rules for each version of ESPD, starting with version 2.0.1. (e.g. ```schematron/Schematron-v3.3.0```). All the activity will take place in one of those folders.  
For maintaining an existring release use the corresponding folder. For a new version make a copy of the latest version of ESPD and rename according to the new version (e.g. copy ```schematron/Schematron-v3.3.0``` to folder ```schematron/Schematron-v4.0.0``` to create the structure for a new version).

```schematron/Schematron-vX.X.X``` folder structure is standard and contains:
- ```espd-schematron-gc.bat``` an Windows executable that is present in the root of the folder
- ```ESPDReqeust``` the folder containing the necessary input and output files for ESPD Request validation
- ```ESPDResponse``` the folder containing the necessary input and output files for ESPD Response validation
- ```common``` the folder contains all common artefacts, libraries, and XSD files necessary to validate and produce extra validators
- ```gc``` the folders contains all Code List files of that specific ESPD version

# Documentation

This set of tools is provided as is and is inteded to be used as intermediary step in the entire chain of ESPD validation process. Any contributions, suggestions and improvements are more than welcome. Please feel free to open [GitHub issue](https://github.com/OP-TED/espd-validation-schematron/issues) for your feedback.

## Data preparation

The tool will validate:
- Code Lists
- ESPD Request
- ESPD Response
all in XML format.

**External data sources**

**Internal files**

## How to use the tool


## What to do in case of errors


## How to use the results


# Licence  
The project is developed and distributed under EUROPEAN UNION PUBLIC LICENCE v. 1.2.