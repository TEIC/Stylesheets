<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="2.0">
  
  <xsl:template match="/">
    <xsl:apply-templates select="node()|@*|comment()|processing-instruction()"/>
  </xsl:template>
  
  <xsl:template match="node()|@*|comment()|processing-instruction()">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*|comment()|processing-instruction()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="xs:any">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:if test="not(@namespace)">
        <xsl:attribute name="namespace">##other</xsl:attribute>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>