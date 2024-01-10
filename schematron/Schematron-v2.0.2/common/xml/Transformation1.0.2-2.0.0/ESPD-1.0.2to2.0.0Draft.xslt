<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="urn:X-test:UBL:Pre-award:QualificationApplicationRequest" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:cev="urn:isa:names:specification:ubl:schema:xsd:CEV-CommonAggregateComponents-1" xmlns:espd-cac="urn:grow:names:specification:ubl:schema:xsd:ESPD-CommonAggregateComponents-1" xmlns:cbc-old="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:espd="urn:com:grow:espd:02.00.00" xmlns:cev-cbc="urn:isa:names:specification:ubl:schema:xsd:CEV-CommonBasicComponents-1" xmlns:cac-old="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cac="urn:X-test:UBL:Pre-award:CommonAggregate" xmlns:espd-req="urn:grow:names:specification:ubl:schema:xsd:ESPDRequest-1" xmlns:ccv="urn:isa:names:specification:ubl:schema:xsd:CCV-CommonAggregateComponents-1" xmlns:ccv-cbc="urn:isa:names:specification:ubl:schema:xsd:CCV-CommonBasicComponents-1" xmlns:util="java:java.util.UUID" xmlns:cbc="urn:X-test:UBL:Pre-award:CommonBasic">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- Include the core elements of the each file (RootElements etc) -->
	<xsl:include href="./inc/REGULATED-RootElements-Annotated.xslt"/>
	<xsl:include href="./inc/ContractingAuthorityData1.xslt"/>
	<xsl:template name="TenderingCriterionPropertyEmptyCaption">
				<cac:TenderingCriterionProperty>
					<cbc:ID schemeID="CriteriaTaxonomy" schemeAgencyID="EU-COM-GROW" schemeVersionID="02.00.00"><xsl:value-of select="util:toString(util:randomUUID())"/></cbc:ID>
					<cbc:Description>[Additional information; e.g. no evidences online]</cbc:Description>
					<cbc:TypeCode listID="CriterionElementType" listAgencyID="EU-COM-GROW" listVersionID="02.00.00">CAPTION</cbc:TypeCode>
					<cbc:ValueDataTypeCode listID="ResponseDataType" listAgencyID="EU-COM-GROW" listVersionID="02.00.00">NONE</cbc:ValueDataTypeCode> 
				</cac:TenderingCriterionProperty>
	</xsl:template>
	<xsl:template match="espd-req:ESPDRequest">
		<!-- Transform the root node to 2.0.0 Mapping structure  -->
		<QualificationApplicationRequest xmlns:cac="urn:X-test:UBL:Pre-award:CommonAggregate" xmlns:cbc="urn:X-test:UBL:Pre-award:CommonBasic" xmlns:cev-cbc="urn:isa:names:specification:ubl:schema:xsd:CEV-CommonBasicComponents-1" xmlns:ccv-cbc="urn:isa:names:specification:ubl:schema:xsd:CCV-CommonBasicComponents-1" xmlns:espd="urn:com:grow:espd:02.00.00" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:util="java:java.util.UUID" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<xsl:call-template name="createRootElements"/>
			<xsl:call-template name="createContractingAuthority"/>
			<!-- Since we add the root elements externally, start to apply templates from ccv:Criterion -->
			<xsl:apply-templates select="ccv:Criterion"/>
			<!-- AdditionalDocumentReference implementation-->
			<xsl:if test="cac-old:AdditionalDocumentReference">
				<xsl:for-each select="cac-old:AdditionalDocumentReference">
					<cac:AdditionalDocumentReference>
						<cbc:ID>
							<xsl:attribute name="schemeAgencyID">EU-COM-OP</xsl:attribute>
							<xsl:value-of select="cbc-old:ID"/>
						</cbc:ID>
						<cbc:DocumentTypeCode>
							<xsl:attribute name="listID">DocRefContentType</xsl:attribute>
							<xsl:attribute name="listAgencyID">EU-COM-GROW</xsl:attribute>
							<xsl:attribute name="listVersionID">02.00.00</xsl:attribute>
							<xsl:value-of select="cbc-old:DocumentTypeCode"/>
						</cbc:DocumentTypeCode>
						<xsl:if test="cac-old:Attachment">
						<cac:Attachment>
							<cac:ExternalReference>
								<cbc:FileName>
									<xsl:value-of select="cac-old:Attachment/cac-old:ExternalReference/cbc-old:FileName"/>
								</cbc:FileName>
								<cbc:Description>
									<xsl:apply-templates select="cac-old:Attachment/cac-old:ExternalReference/cbc-old:Description[1]"/>
								</cbc:Description>
								<cbc:Description>
									<xsl:apply-templates select="cac-old:Attachment/cac-old:ExternalReference/cbc-old:Description/following-sibling::node()"/>
								</cbc:Description>
							</cac:ExternalReference>
						</cac:Attachment>
						</xsl:if>
					</cac:AdditionalDocumentReference>
				</xsl:for-each>
			</xsl:if>
		</QualificationApplicationRequest>
	</xsl:template>
	<!-- Match with each elements to apply the mapping changes and create a structure to copy or recreate the values-->
	<xsl:template match="ccv:Criterion/cbc-old:ID">
		<cbc:ID>
			<!-- Adding desired attributes for the version 2.0.0-->
			<xsl:attribute name="schemeID">CriteriaTaxonomy</xsl:attribute>
			<xsl:attribute name="schemeAgencyID">EU-COM-GROW</xsl:attribute>
			<xsl:attribute name="schemeVersionID">02.00.00</xsl:attribute>
			<!-- Select the values from v1.0.2 and apply them into 2.0.0 -->
			<xsl:apply-templates select="node()"/>
		</cbc:ID>
	</xsl:template>
	<xsl:template match="ccv:Criterion/cbc-old:TypeCode">
		<cbc:CriterionTypeCode>
			<!-- Adding desired attributes for the version 2.0.0-->
			<xsl:attribute name=" listID">CriteriaTypeCode</xsl:attribute>
			<xsl:attribute name="listAgencyID">EU-COM-GROW</xsl:attribute>
			<xsl:attribute name="listVersionID">02.00.00</xsl:attribute>
			<xsl:apply-templates select="node()"/>
		</cbc:CriterionTypeCode>
	</xsl:template>
	<!-- Select the values from v1.0.2 and apply them into 2.0.0 -->
	<xsl:template match="ccv:Criterion/cbc-old:Name">
		<cbc:Name>
			<xsl:apply-templates select="node()"/>
		</cbc:Name>
	</xsl:template>
	<!-- Select the values from v1.0.2 and apply them into 2.0.0 -->
	<xsl:template match="ccv:Criterion/cbc-old:Description">
		<cbc:Description>
			<xsl:apply-templates select="node()"/>
		</cbc:Description>
	</xsl:template>
	<!-- Select the values from v1.0.2 and apply them into 2.0.0 -->
	<xsl:template match="ccv:LegislationReference">
		<cac:Legislation>
			<cbc:ID>
				<xsl:attribute name="schemeID">CriteriaTaxonomy</xsl:attribute>
				<xsl:attribute name="schemeAgencyID">EU-COM-GROW</xsl:attribute>
				<xsl:attribute name="schemeVersionID">02.00.00</xsl:attribute>
				<xsl:value-of select="util:toString(util:randomUUID())"/>
			</cbc:ID>
			<xsl:apply-templates/>
		</cac:Legislation>
	</xsl:template>
	<xsl:template match="ccv:LegislationReference/ccv-cbc:Title">
		<cbc:Title>
			<xsl:apply-templates select="node()"/>
		</cbc:Title>
	</xsl:template>
	<xsl:template match="ccv:LegislationReference/cbc-old:Description">
		<cbc:Description>
			<xsl:apply-templates select="node()"/>
		</cbc:Description>
	</xsl:template>
	<xsl:template match="ccv:LegislationReference/ccv-cbc:JurisdictionLevelCode">
		<cbc:JurisdictionLevel>
			<xsl:apply-templates select="node()"/>
		</cbc:JurisdictionLevel>
	</xsl:template>
	<xsl:template match="ccv:LegislationReference/ccv-cbc:Article">
		<cbc:Article>
			<xsl:apply-templates select="node()"/>
		</cbc:Article>
	</xsl:template>
	<xsl:template match="ccv:LegislationReference/cbc-old:URI">
		<cbc:URI>
			<xsl:apply-templates select="node()"/>
		</cbc:URI>
	</xsl:template>
	<xsl:template match="ccv:Criterion">
		<cac:TenderingCriterion>
			<xsl:apply-templates/>
		</cac:TenderingCriterion>
	</xsl:template>
	<xsl:template match="ccv:RequirementGroup">
		<cac:TenderingCriterionPropertyGroup>
			<xsl:apply-templates select="node()"/>
			<!--
			<xsl:if test="ccv:Requirement">
	<xsl:call-template name="TenderingCriterionPropertyEmptyCaption"/>
		</xsl:if>
				-->
		</cac:TenderingCriterionPropertyGroup>
	</xsl:template>
	<xsl:template match="ccv:RequirementGroup[@pi]/ccv:RequirementGroup">
		<cac:SubsidiaryTenderingCriterionPropertyGroup>
			<xsl:apply-templates select="node()"/>
		</cac:SubsidiaryTenderingCriterionPropertyGroup>
	</xsl:template>
	<xsl:template match="ccv:RequirementGroup/cbc-old:ID">
		<cbc:ID>
			<xsl:attribute name="schemeID">CriteriaTaxonomy</xsl:attribute>
			<xsl:attribute name="schemeAgencyID">EU-COM-GROW</xsl:attribute>
			<xsl:attribute name="schemeVersionID">02.00.00</xsl:attribute>
			<xsl:apply-templates select="node()"/>
		</cbc:ID>
			<xsl:if test="not(following-sibling::ccv:Requirement)">
			<xsl:call-template name="TenderingCriterionPropertyEmptyCaption"/>
			</xsl:if>
	</xsl:template>
	<xsl:template match="ccv:Requirement">
		<cac:TenderingCriterionProperty>
			<xsl:apply-templates select="node()"/>
		</cac:TenderingCriterionProperty>
	</xsl:template>
	<xsl:template match="ccv:Requirement/cbc-old:ID">
		<cbc:ID>
			<!-- Adding java.util for the auto generated UUID's-->
			<xsl:attribute name="schemeID">CriteriaTaxonomy</xsl:attribute>
			<xsl:attribute name="schemeAgencyID">EU-COM-GROW</xsl:attribute>
			<xsl:attribute name="schemeVersionID">02.00.00</xsl:attribute>
			<xsl:value-of select="util:toString(util:randomUUID())"/>
		</cbc:ID>
	</xsl:template>
	<xsl:template match="ccv:Requirement/cbc-old:Description">
		<cbc:Description>
			<xsl:apply-templates select="node()"/>
		</cbc:Description>
	</xsl:template>
	<!-- Select the values from v1.0.2 and apply them into 2.0.0 -->
	<xsl:template match="ccv:RequirementGroup[@pi]">
		<cac:SubsidiaryTenderingCriterionPropertyGroup>
			<xsl:apply-templates select="node()"/>
		</cac:SubsidiaryTenderingCriterionPropertyGroup>
	</xsl:template>
	<!-- Select the values from v1.0.2 and apply them into 2.0.0 -->
	<xsl:template match="ccv:RequirementGroup[@pi]/cbc-old:ID">
		<cbc:ID>
			<xsl:attribute name="schemeID">CriteriaTaxonomy</xsl:attribute>
			<xsl:attribute name="schemeAgencyID">EU-COM-GROW</xsl:attribute>
			<xsl:attribute name="schemeVersionID">02.00.00</xsl:attribute>
			<xsl:value-of select="util:toString(util:randomUUID())"/>
		</cbc:ID>
	</xsl:template>
</xsl:stylesheet>
