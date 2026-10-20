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


### Restricted publication-reference content types in the ESPD Request

* Added business rule BR-ESPD-DOCREF-01 (fatal) in `ESPDRequest/sch/04-ESPD-req-other-br.sch`
  rejecting the DocRefContentType codes `ESPD_REQUEST` and `epo-acc-espd-request` on
  `cac:AdditionalDocumentReference/cbc:DocumentTypeCode`. These codes designate the ESPD
  Request document itself, not a published notice, so they are not valid as a publication
  reference. The generic code-list-values binding still accepts the full EU vocabulary;
  this rule narrows it for the ESPD Request context only.
* Regenerated `ESPDRequest/xsl/04-ESPD-req-other-br.xsl` accordingly.


## Bug fixes

* Manual fix to ESPDRequest/xsl/criterionList.xml and ESPDResponse/xsl/criterionList.xml to remove space for code value "service-perform"
