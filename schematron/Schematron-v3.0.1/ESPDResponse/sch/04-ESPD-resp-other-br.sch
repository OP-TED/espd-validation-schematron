<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<title>ESPD Response Other Business Rules</title>
	
	<ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
	<ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
	<ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
	<ns prefix="espd" uri="urn:oasis:names:specification:ubl:schema:xsd:QualificationApplicationResponse-2"/>
	
<!--
    Start of synthesis of rules from other constraints ESPD Response

    Illustration of procurer constraints - 04-ESPD-resp-other-br.sch
	ESPD Version: 3.0.1
-->
	
	<pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="BR-RESP-OTHER">
		
		<rule context="cbc:CustomizationID">
			<!-- BR-OTH-06 -->
			<!-- For the ESPD we use the value urn:www.cenbii.eu:transaction:biitrdm070:ver3.0 -->
			<assert test="text()='urn:www.cenbii.eu:transaction:biitrdm092:ver3.0'" flag="error" id="BR-OTH-06-01">For the ESPD customization of UBL ('/cbc:CustomizationID') we use the value urn:www.cenbii.eu:transaction:biitrdm092:ver3.0</assert>
			
			<!-- Compulsory use of the value "CEN-BII" for the schemeAgencyID attribute. -->
			<assert test="@schemeAgencyID='CEN-BII'" flag="error" id="BR-OTH-06-02">Compulsory use of the value "CEN-BII" for the schemeAgencyID attribute.</assert>
		</rule>
		
	</pattern>
</schema>
