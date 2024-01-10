<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 	        xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias"
	        xmlns:sch="http://www.ascc.net/xml/schematron"
	        xmlns:iso="http://purl.oclc.org/dsdl/schematron"
			xmlns:cva="http://docs.oasis-open.org/codelist/ns/ContextValueAssociation/1.0/"
			xmlns:cac="urn:X-test:UBL:Pre-award:CommonAggregate" 
			xmlns:cbc="urn:X-test:UBL:Pre-award:CommonBasic" 
			xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" 
			xmlns:espd-req="urn:X-test:UBL:Pre-award:QualificationApplicationRequest" 
			xmlns:espd-resp="urn:X-test:UBL:Pre-award:QualificationApplicationResponse" 
	        xmlns:svrl="http://purl.oclc.org/dsdl/svrl" 
                version="2.0">
<!--
     This specializes iso-schematron-skeleton.xsl to analyze all assertions
     and abort with a message of all violations.

 $Id: Message-Schematron-terminator.xsl,v 1.5 2008/04/15 08:12:11 G. Ken Holman Exp $

 Copyright (C) - Crane Softwrights Ltd.
               - http://www.CraneSoftwrights.com/links/res-dev.htm
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.
 - The name of the author may not be used to endorse or promote products
   derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
 NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 Note: for your reference, the above is the "Modified BSD license", this text
     was obtained 2003-07-26 at http://www.xfree86.org/3.3.6/COPYRIGHT2.html#5
-->

<!--specialize the published Schematron reference implementation-->
<xsl:import href="iso_schematron_skeleton_for_xslt1.xsl"/>

<xsl:param name="diagnose" >true</xsl:param>
<xsl:param name="generate-paths" >true</xsl:param>
<xsl:param name="terminate" >false</xsl:param>

<!--augment with methodology-specific process additions-->
<xsl:template match="node()" mode="stylesheetbody">
  <xsl:comment>Importing stylesheet additions</xsl:comment>
  <axsl:output method="xml"/>

  <!--create the reference portion of the stylesheet-->
  <xsl:apply-imports/>
</xsl:template>

<xsl:template name="tokenize">
        <xsl:param name="text" select="."/>
        <xsl:param name="separator" select="'Value supplied'"/>
        <xsl:choose>
            <xsl:when test="not(contains($text, $separator))">
                <result>
                    <xsl:value-of select="normalize-space($text)"/>
                </result>
            </xsl:when>
            <xsl:otherwise>
                <result>
                    <xsl:value-of select="normalize-space(substring-before($text, $separator))"/>
                </result>
                <xsl:call-template name="tokenize">
                    <xsl:with-param name="text" select="substring-after($text, $separator)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
<!--this overrides the skeleton handling the root node-->
<xsl:template name="process-root">
	<xsl:param name="title"/>
	<xsl:param name="contents" />
	<xsl:param name="queryBinding" >xslt1</xsl:param>
	<xsl:param name="schemaVersion" />
	<xsl:param name="id" />
	<xsl:param name="version"/>
	<!-- "Rich" parameters -->
	<xsl:param name="fpi" />
	<xsl:param name="icon" />
	<xsl:param name="lang" />
	<xsl:param name="see" />
	<xsl:param name="space" />
	
  <!--xsl:comment>Root node processing collects all assertions</xsl:comment>
  <axsl:variable name="result">
    <xsl:copy-of select="$contents"/>
  </axsl:variable>
   
   <results>
		  <result><axsl:value-of select="string($result)"/></result>
    </results>
        
  <axsl:if test="normalize-space(string($result))">
    <axsl:message terminate="yes">
      <axsl:value-of select="string($result)" disable-output-escaping="yes"/>
    </axsl:message>
  </axsl:if-->
  	<svrl:schematron-output title="{$title}" schemaVersion="{$schemaVersion}" >
		<xsl:if test=" string-length( normalize-space( $phase )) &gt; 0 and 
		not( normalize-space( $phase ) = '#ALL') ">
			<axsl:attribute name="phase">
				<xsl:value-of select=" $phase " />
			</axsl:attribute>
		</xsl:if>
		<xsl:if test=" $allow-foreign = 'true'">
		</xsl:if>
		  <xsl:if  test=" $allow-foreign = 'true'">
	
		<xsl:call-template name='richParms'>
			<xsl:with-param name="fpi" select="$fpi" />
			<xsl:with-param name="icon" select="$icon"/>
			<xsl:with-param name="lang" select="$lang"/>
			<xsl:with-param name="see"  select="$see" />
			<xsl:with-param name="space"  select="$space" />
		</xsl:call-template>
	</xsl:if>
		 
		 <axsl:comment><axsl:value-of select="$archiveDirParameter"/>  &#xA0;
		 <axsl:value-of select="$archiveNameParameter"/> &#xA0;
		 <axsl:value-of select="$fileNameParameter"/> &#xA0;
		 <axsl:value-of select="$fileDirParameter"/></axsl:comment> 
		 
		
		<xsl:apply-templates mode="do-schema-p" />
		<xsl:copy-of select="$contents" />
	</svrl:schematron-output>
</xsl:template>

<!--process a message generated by a failed assertion-->
<xsl:template name="process-message">
  <!--express the message information-->
  <xsl:apply-templates mode="text"/>
  <!--follow it with an XPath address-->
  <axsl:text>: </axsl:text>
  <axsl:apply-templates select="." mode="schematron-get-full-path-3"/>
  <axsl:text xml:space="preserve">
</axsl:text>
</xsl:template>


<xsl:template name="process-assert">
	<xsl:param name="test"/>
	<xsl:param name="diagnostics" />
	<xsl:param name="id" />
	<xsl:param name="flag" />
	<!-- "Linkable" parameters -->
	<xsl:param name="role"/>
	<xsl:param name="subject"/>
	<!-- "Rich" parameters -->
	<xsl:param name="fpi" />
	<xsl:param name="icon" />
	<xsl:param name="lang" />
	<xsl:param name="see" />
	<xsl:param name="space" />
	<svrl:failed-assert test="{$test}" >
		<xsl:if test="string-length( $id ) &gt; 0">
			<axsl:attribute name="id">
				<xsl:value-of select=" $id " />
			</axsl:attribute>
		</xsl:if>
		<xsl:if test=" string-length( $flag ) &gt; 0">
			<axsl:attribute name="flag">
				<xsl:value-of select=" $flag " />
			</axsl:attribute>
		</xsl:if>
		<!-- Process rich attributes.  -->
		<xsl:call-template name="richParms">
			<xsl:with-param name="fpi" select="$fpi"/>
			<xsl:with-param name="icon" select="$icon"/>
			<xsl:with-param name="lang" select="$lang"/>
			<xsl:with-param name="see" select="$see" />
			<xsl:with-param name="space" select="$space" />
		</xsl:call-template>
		<xsl:call-template name='linkableParms'>
			<xsl:with-param name="role" select="$role" />
			<xsl:with-param name="subject" select="$subject"/>
		</xsl:call-template>
		<xsl:if test=" $generate-paths = 'true' or $generate-paths= 'yes' ">
			<!-- true/false is the new way -->
			<axsl:attribute name="location">
				<axsl:apply-templates select="." mode="schematron-get-full-path"/>
			</axsl:attribute>
		</xsl:if>
		  
		<svrl:text>
			<xsl:apply-templates mode="text" />
	
		</svrl:text>
		    <xsl:if test="$diagnose = 'yes' or $diagnose= 'true' ">
			<!-- true/false is the new way -->
				<xsl:call-template name="diagnosticsSplit">
					<xsl:with-param name="str" select="$diagnostics"/>
				</xsl:call-template>
			</xsl:if>
	</svrl:failed-assert>
	
	
		<xsl:if test=" $terminate = 'yes' or $terminate = 'true' ">
		   <axsl:message terminate="yes">TERMINATING</axsl:message>
		</xsl:if>
	    <xsl:if test=" $terminate = 'assert' ">
		   <axsl:message terminate="yes">TERMINATING</axsl:message>
		</xsl:if>
</xsl:template>

<xsl:template name="process-report">
	<xsl:param name="id"/>
	<xsl:param name="test"/>
	<xsl:param name="diagnostics"/>
	<xsl:param name="flag" />
	<!-- "Linkable" parameters -->
	<xsl:param name="role"/>
	<xsl:param name="subject"/>
	<!-- "Rich" parameters -->
	<xsl:param name="fpi" />
	<xsl:param name="icon" />
	<xsl:param name="lang" />
	<xsl:param name="see" />
	<xsl:param name="space" />
	<svrl:successful-report test="{$test}" >
		<xsl:if test=" string-length( $id ) &gt; 0">
			<axsl:attribute name="id">
				<xsl:value-of select=" $id " />
			</axsl:attribute>
		</xsl:if>
		<xsl:if test=" string-length( $flag ) &gt; 0">
			<axsl:attribute name="flag">
				<xsl:value-of select=" $flag " />
			</axsl:attribute>
		</xsl:if>
		
		<!-- Process rich attributes.  -->
		<xsl:call-template name="richParms">
			<xsl:with-param name="fpi" select="$fpi"/>
			<xsl:with-param name="icon" select="$icon"/>
			<xsl:with-param name="lang" select="$lang"/>
			<xsl:with-param name="see" select="$see" />
			<xsl:with-param name="space" select="$space" />
		</xsl:call-template>
		<xsl:call-template name='linkableParms'>
			<xsl:with-param name="role" select="$role" />
			<xsl:with-param name="subject" select="$subject"/>
		</xsl:call-template>
		<xsl:if test=" $generate-paths = 'yes' or $generate-paths = 'true' ">
			<!-- true/false is the new way -->
			<axsl:attribute name="location">
				<axsl:apply-templates select="." mode="schematron-get-full-path"/>
			</axsl:attribute>
		</xsl:if>
	 
		<svrl:text>
			<xsl:apply-templates mode="text" />

		</svrl:text>
			<xsl:if test="$diagnose = 'yes' or $diagnose='true' ">
			<!-- true/false is the new way -->
				<xsl:call-template name="diagnosticsSplit">
					<xsl:with-param name="str" select="$diagnostics"/>
				</xsl:call-template>
			</xsl:if>
	</svrl:successful-report>
	
	
		<xsl:if test=" $terminate = 'yes' or $terminate = 'true' ">
		   <axsl:message terminate="yes">TERMINATING</axsl:message>
		</xsl:if>
</xsl:template>

<!-- =========================================================================== -->
<!-- processing rich parameters. -->
<xsl:template name='richParms'>
	<!-- "Rich" parameters -->
	<xsl:param name="fpi" />
	<xsl:param name="icon" />
	<xsl:param name="lang" />
	<xsl:param name="see" />
	<xsl:param name="space" />
	<!-- Process rich attributes.  -->
	<xsl:if  test=" $allow-foreign = 'true'">
	<xsl:if test="string($fpi)"> 
		<axsl:attribute name="fpi">
			<xsl:value-of select="$fpi"/>
		</axsl:attribute>
	</xsl:if>
	<xsl:if test="string($icon)"> 
		<axsl:attribute name="icon">
			<xsl:value-of select="$icon"/>
		</axsl:attribute>
	</xsl:if>
	<xsl:if test="string($see)"> 
		<axsl:attribute name="see">
			<xsl:value-of select="$see"/>
		</axsl:attribute>
	</xsl:if>
	</xsl:if>
	<xsl:if test="string($space)">
		<axsl:attribute name="xml:space">
			<xsl:value-of select="$space"/>
		</axsl:attribute>
	</xsl:if>
	<xsl:if test="string($lang)">
		<axsl:attribute name="xml:lang">
			<xsl:value-of select="$lang"/>
		</axsl:attribute>
	</xsl:if>
</xsl:template>

<!-- processing linkable parameters. -->
<xsl:template name='linkableParms'>
	<xsl:param name="role"/>
	<xsl:param name="subject"/>
	
	<!-- ISO SVRL has a role attribute to match the Schematron role attribute -->
	<xsl:if test=" string($role )">
		<axsl:attribute name="role">
			<xsl:value-of select=" $role " />
		</axsl:attribute>
	</xsl:if>
	<!-- ISO SVRL does not have a subject attribute to match the Schematron subject attribute.
       Instead, the Schematron subject attribute is folded into the location attribute -->
</xsl:template>

</xsl:stylesheet>