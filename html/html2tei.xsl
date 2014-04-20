<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="tei xs"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns="http://www.tei-c.org/ns/1.0" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    version="2.0" 
    xpath-default-namespace="http://www.w3.org/1999/xhtml">

  <xsl:import href="../common/common_makeTEIStructure.xsl"/>
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="html">
    <TEI>
      <xsl:apply-templates/>
    </TEI>
  </xsl:template>

   <xsl:template match="body">
     <xsl:call-template name="convertStructure"/>
   </xsl:template>

  <xsl:template match="head">
    <teiHeader>
      <fileDesc>
        <titleStmt>
          <title>
            <xsl:value-of select="title"/>
          </title>
          <author>
            <xsl:value-of select="meta[@name='dc.Creator']/@content"/>
          </author>
        </titleStmt>
        <publicationStmt>
	  <p></p>
        </publicationStmt>
      </fileDesc>
    </teiHeader>
  </xsl:template>


  <xsl:template match="h1|h2|h3|h4|h5|h6|h7">
    <HEAD level="{substring(local-name(),2,1)}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </HEAD>
  </xsl:template>
		
  <xsl:template match="tei:p[not(node())]"
		mode="pass1"/>

  <xsl:template match="br">
    <lb/>
  </xsl:template>

  <xsl:template match="a">
    <xsl:choose>
      <xsl:when test="@href">
        <ref target="{@href}">
          <xsl:apply-templates/>
        </ref>
      </xsl:when>
      <xsl:when test="@name">
        <anchor>
          <xsl:attribute name="xml:id" select="@name"/>
        </anchor>
        <xsl:apply-templates/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="li">
    <item>
      <xsl:apply-templates/>
    </item>
  </xsl:template>

  <xsl:template match="div">
      <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="link">
</xsl:template>

  <xsl:template match="meta">
</xsl:template>

  <xsl:template match="p">
    <p>
      <xsl:apply-templates select="*|@*|text()|comment()"/>
    </p>
  </xsl:template>
  <xsl:template match="p[@class='note']">
    <note>
      <xsl:apply-templates select="*|@*|text()|comment()"/>
    </note>
  </xsl:template>
  <xsl:template match="title">
</xsl:template>
  <xsl:template match="ul">
    <list type="unordered">
      <xsl:apply-templates/>
    </list>
  </xsl:template>
  <xsl:template match="ol">
    <list type="ordered">
      <xsl:apply-templates/>
    </list>
  </xsl:template>
  <xsl:template match="em">
    <hi rend="italic">
      <xsl:apply-templates/>
    </hi>
  </xsl:template>
  <xsl:template match="img">
    <graphic url="{@src}">
      <xsl:for-each select="@width">
        <xsl:attribute name="width">
          <xsl:value-of select="."/>
          <xsl:analyze-string select="." regex="^[0-9]+$">
            <xsl:matching-substring>
              <xsl:text>px</xsl:text>
            </xsl:matching-substring>
          </xsl:analyze-string>
        </xsl:attribute>
      </xsl:for-each>
      <xsl:for-each select="@height">
        <xsl:attribute name="height">
          <xsl:value-of select="."/>
          <xsl:analyze-string select="." regex="^[0-9]+$">
            <xsl:matching-substring>
              <xsl:text>px</xsl:text>
            </xsl:matching-substring>
          </xsl:analyze-string>
        </xsl:attribute>
      </xsl:for-each>
    </graphic>
  </xsl:template>

  <xsl:template match="pre">
    <eg>
      <xsl:apply-templates/>
    </eg>
  </xsl:template>

  <xsl:template match="strong">
    <hi rend="bold">
      <xsl:apply-templates/>
    </hi>
  </xsl:template>

  <xsl:template match="sup">
    <hi rend="sup">
      <xsl:apply-templates/>
    </hi>
  </xsl:template>

  <xsl:template match="@class">
    <xsl:attribute name="rend" select="."/>
  </xsl:template>

  <xsl:template match="@id">
    <xsl:attribute name="xml:id" select="."/>
  </xsl:template>

  <xsl:template match="@title"/>

  <xsl:template match="@*|comment()|text()">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="span">
    <hi>
      <xsl:if test="@class">
	<xsl:attribute name="rend" select="@class"/>
      </xsl:if>
      <xsl:apply-templates select="@*|*|text()"/>
    </hi>
  </xsl:template>

  <xsl:template match="b">
    <hi rend="bold">
      <xsl:apply-templates select="@*|*|text()"/>
    </hi>
  </xsl:template>

  <xsl:template match="i">
    <hi rend="italic">
      <xsl:apply-templates select="@*|*|text()"/>
    </hi>
  </xsl:template>

  <xsl:template match="font">
      <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="blockquote">
    <quote>
      <xsl:apply-templates select="@*|*|text()"/>
    </quote>
  </xsl:template>

  <xsl:template match="tt">
    <code>
      <xsl:apply-templates select="@*|*|text()"/>
    </code>
  </xsl:template>

  <xsl:template match="code">
    <eg>
      <xsl:apply-templates select="@*|*|text()"/>
    </eg>
  </xsl:template>

  <xsl:template match="table">
    <table>
      <xsl:apply-templates select="@*|*|text()"/>
    </table>
  </xsl:template>

  <xsl:template match="td">
    <cell>
      <xsl:apply-templates select="@*|*|text()"/>
    </cell>
  </xsl:template>

  <xsl:template match="tr">
    <row>
      <xsl:apply-templates select="@*|*|text()"/>
    </row>
  </xsl:template>

  <xsl:template match="hr"/>

  <xsl:template match="*">
    <xsl:message>UNKNOWN TAG <xsl:value-of select="name()"/></xsl:message>
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
