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


### Accept the new TED/eForms notice publication number format in BR-COM-10-01

* Extended business rule BR-COM-10-01 in `common/sch/04-ESPD-common-other-br.sch` to accept the
  new eForms/TED publication number scheme `NNNNNNNN-YYYY` (publication number of 1 to 8 digits,
  a hyphen, and the 4-digit year; e.g. `310364-2026`) for a TED notice reference
  (`cac:AdditionalDocumentReference`). The legacy OJ S scheme `YYYY/S NNN-NNNNNN` and the
  temporary placeholder `0000/S 000-000000` remain accepted.
* Extended the rule's scope from `TED_CN` only to both `TED_CN` (Contract Notice) and `TED_PIN`
  (Prior Information Notice) — a PIN uses the same OJ S publication-number scheme.
* Regenerated `ESPDRequest/xsl/04-ESPD-common-other-br.xsl` and
  `ESPDResponse/xsl/04-ESPD-common-other-br.xsl` accordingly.
* Added unit-test fixtures `tests/BR-COM-10-01_{pass,fail}.xml` (TED_CN) and
  `tests/BR-COM-10-01-PIN_{pass,fail}.xml` (TED_PIN).


## Bug fixes

* Manual fix to ESPDRequest/xsl/criterionList.xml and ESPDResponse/xsl/criterionList.xml to remove space for code value "service-perform"
