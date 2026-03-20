# espd-validation-schematron 5.0.0-alpha-2 Release Notes

This release aligns with EDPD-EDM-v5-alpha-2.

## Main changes

A new file "espd-schematron.sh" has been added. This is a Bash shell equivalent of the Windows/MS-DOS batch file "espd-schematron.bat". Thus the validation of the code lists and generation of schematron and XSLT files can now be done either in a Windows/MS-DOS shell or a Unix Bash shell.

### Code lists
#### Updated all shared code lists from EDPD-EDM-v5-alpha-2:

* AccessRight.gc
* BooleanGUIControlType.gc
* Country.gc
* CriterionElementType.gc
* Currency.gc
* DocRefContentType.gc
* EconomicOperatorSize.gc
* EOIDType.gc
* EoRoleType.gc
* FinancialRatioType.gc
* Language.gc
* Occupation.gc
* ProfileExecutionID.gc
* PropertyGroupType.gc

Note: in ESPD EDM, the code list "Criterion.gc" was replaced with the new code lists "ExclusionGround.gc" and "SelectionCriterion.gc". This change was not made in this repository for this release as it requires too many changes. This change is scheduled for the 5.0.0-beta release.

#### Updated all example XML files with new code values in element attributes from the above code lists.

#### Updated all checks in schematron files with the new code values from the above code lists.

## Bug fixes

* Fixed use of incorrect value "CHECKBOX_TRUE" in XML files to correct code "CHECK_BOX_TRUE" from code list boolean-gui-control-type.

* Fixed references to "EU-COM-GROW" or "EU-COM-OP" in XML files in @schemeAgencyID and @listAgencyID attributes to the correct value "OP"
* For the elements updated above, fixed the value in the @schemeVersionID from "2.0", "3.0.0" and "4.0.0" to "5.0.0"
* For the elements updated above, fixed the value in the @listVersionID from "1.0" and "3.0.0" to "5.0.0"
* Fixed references to "Criterion" in XML files in @schemeAgencyID attributes to the correct value "criterion"
* For the elements updated above, fixed the value in the @schemeVersionID from "3.0.0" to "4.0.0"

