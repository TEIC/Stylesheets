<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0">
  <xsl:import href="../common/functions.xsl"/>
  <xsl:output indent="no"/>
  <xsl:template match="/">
    <xsl:for-each select="//body">
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
              <p/>
            </sourceDesc>
          </fileDesc>
        </teiHeader>
        <text>
          <body>
            <p>
              <eTree rend="d3CollapsableTree">
                <label>TEI</label>
                <xsl:for-each select=".//moduleSpec">
                  <xsl:sort select="@ident"/>
                  <eTree>
                    <label>
                      <xsl:value-of select="@ident"/>
                    </label>
                    <xsl:if test="//classSpec[@module=current()/@ident]">
                      <eTree>
                        <label>Classes</label>
                        <xsl:for-each select="//classSpec[@module=current()/@ident]">
                          <xsl:sort select="@ident"/>
                          <xsl:call-template name="innards"/>
                        </xsl:for-each>
                      </eTree>
                    </xsl:if>
                    <xsl:if test="//elementSpec[@module=current()/@ident]">
                      <eTree>
                        <label>Elements</label>
                        <xsl:for-each select="//elementSpec[@module=current()/@ident]">
                          <xsl:sort select="@ident"/>
                          <xsl:call-template name="innards"/>
                        </xsl:for-each>
                      </eTree>
                    </xsl:if>
                    <xsl:if test="//macroSpec[@module=current()/@ident]">
                      <eTree>
                        <label>Macros</label>
                        <xsl:for-each select="//macroSpec[@module=current()/@ident]">
                          <xsl:sort select="@ident"/>
                          <eLeaf>
                            <label>
                              <xsl:value-of select="@ident"/>
                            </label>
                          </eLeaf>
                        </xsl:for-each>
                      </eTree>
                    </xsl:if>
                  </eTree>
                </xsl:for-each>
              </eTree>
            </p>
          </body>
        </text>
      </TEI>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="innards">
    <xsl:element name="{if (attList/attDef) then        'eTree' else 'eLeaf'}">
      <label>
        <xsl:value-of select="@ident"/>
      </label>
      <xsl:if test="attList/attDef">
        <xsl:for-each select="attList/attDef">
          <xsl:sort select="@ident"/>
	  <eTree>
            <label>@<xsl:value-of select="@ident"/></label>
	    <eLeaf>
	      <label rend="desc">
		<xsl:sequence select="tei:makeDescription(.,true())"/>
	      </label>
	    </eLeaf>
	    <eLeaf>
	      <label><xsl:value-of select="if (@usage='opt') then
		'Optional' else 'Mandatory'"/></label>
	    </eLeaf>
	  </eTree>
        </xsl:for-each>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:desc" mode="inLanguage">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

</xsl:stylesheet>
