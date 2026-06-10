# espd-validation-schematron 5.0.0-beta Release Notes

This release aligns with EDPD-EDM-v5-beta.

## Main changes

### Update of UBL schema from version 2.3 to version 2.4

* Replaced .xsd files with versions from UBL 2.4
* Updated all references to these files
* Updated UBL version IDs

### Replaced "criterion" code list with "exclusion-ground" and "selection-criterion" code lists

* Replaced criterion codes in example XML files with codes from these new code lists
* Updated schematron files to check for these codes
* Updated generated XSLT files

### Updated version number for ESPD-EDM from "4.0.0" to "5.0.0"

* "listVersionID" and "schemeVersionID" attributes
* <cbc:ProfileExecutionID> element


## Bug fixes

* Manual fix to ESPDRequest/xsl/criterionList.xml and ESPDResponse/xsl/criterionList.xml to remove space for code value "service-perform"
