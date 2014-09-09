<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
    xmlns="http://www.tei-c.org/ns/1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
  <xsl:output indent="yes"/>

<xsl:variable name="special-nodes" select="//div/head"/>

  <xsl:template match="*" mode="iden">
    <xsl:copy>
      <xsl:apply-templates
	  select="@*|*|processing-instruction()|comment()|text()"  mode="iden"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()|@*|processing-instruction()|text()" mode="iden">
    <xsl:copy-of select="."/>
  </xsl:template>

<xsl:template match="*[. intersect $special-nodes]" mode="iden">
  <xsl:copy>
    <xsl:attribute name="special">highlight</xsl:attribute>
      <xsl:apply-templates
	  select="@*|*|processing-instruction()|comment()|text()"  mode="iden"/>
  </xsl:copy>
</xsl:template>


  <xsl:template match="/">
    <xsl:variable name="deco">
      <xsl:apply-templates mode="iden"/>
    </xsl:variable>
    <xsl:for-each select="$deco//body">
<TEI xmlns="http://www.tei-c.org/ns/1.0">
  <teiHeader type="text">
    <fileDesc>
      <titleStmt>
        <title type="main">tree</title>
      </titleStmt>
      <publicationStmt>
        <p>Stylesheets test file</p>
      </publicationStmt>
      <sourceDesc>
        <p>Transcribed from the 1893 reprint of the first edition by Lou Burnard.</p>
      </sourceDesc>
    </fileDesc>
  </teiHeader>
  <text>
    <body>
      <p>
	  <xsl:call-template name="subtree"/>
      </p>
    </body>
  </text>
</TEI>
    </xsl:for-each></xsl:template>


  <xsl:template name="subtree">
    <xsl:choose>
      <xsl:when test="*">
	<eTree>
	  <xsl:call-template name="label"/>
	  <xsl:for-each select="*">
	    <xsl:call-template name="subtree"/>
	  </xsl:for-each>
	</eTree>
      </xsl:when>
      <xsl:otherwise>
	<eLeaf>
	  <xsl:call-template name="label"/>
	</eLeaf>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="label">    
    <label>
      <xsl:if test="@special">
	<xsl:attribute name="rend" select="@special"/>
      </xsl:if>
      <xsl:value-of select="name()"/>
      <xsl:for-each select="@*[not(name()='special')]">
	<xsl:text> </xsl:text>
	<xsl:value-of select="name()"/>
	<xsl:text>="</xsl:text>
	<xsl:value-of select="."/>
	<xsl:text>"</xsl:text>
      </xsl:for-each>
    </label>
  </xsl:template>

</xsl:stylesheet>
