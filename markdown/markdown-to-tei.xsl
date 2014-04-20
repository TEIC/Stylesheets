<xsl:stylesheet 
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei xs">

  <xsl:import href="../common/common_makeTEIStructure.xsl"/>

  <xsl:param name="input-encoding" select="'UTF-8'" as="xs:string"/>
  <xsl:param name="input-uri" select="README.md"/>
 
<xsl:output omit-xml-declaration="yes" indent="yes"/>

 <xsl:template name="main">
   <TEI>
     <teiHeader>
       <fileDesc>
	 <titleStmt>
           <title></title>
	 </titleStmt>
	 <publicationStmt>
           <p>from markdown</p>
	 </publicationStmt>
	 <sourceDesc>
           <p>new born </p>
      </sourceDesc>
       </fileDesc>
     </teiHeader>
     <xsl:for-each select="unparsed-text($input-uri, $input-encoding)">
       <xsl:call-template name="convertStructure"/>
     </xsl:for-each>
   </TEI>
 </xsl:template>

 <xsl:template name="gatherText">
     <xsl:for-each select="tokenize(., '\n')">
       <xsl:sequence select="tei:parse-line(.)"/>
     </xsl:for-each>
 </xsl:template>

 <xsl:function name="tei:parse-line" as="element()*">
  <xsl:param name="vLine" as="xs:string*"/>
    <xsl:choose>
      <xsl:when test="string-length(normalize-space($vLine))=0"/>
      <xsl:when test="starts-with($vLine, '# ')">
	<xsl:variable name="depth">
	  <xsl:analyze-string select="$vLine" regex="(#+).*">
	    <xsl:matching-substring>
	      <xsl:value-of select="string-length(regex-group(1))"/>
	    </xsl:matching-substring>
	    <xsl:non-matching-substring>
	      <xsl:text>1</xsl:text>
	    </xsl:non-matching-substring>
	  </xsl:analyze-string>
	</xsl:variable>
        <HEAD level="{$depth}">
	  <xsl:sequence select="substring($vLine,$depth+2)"/>
	</HEAD>
      </xsl:when>
      <xsl:when test="starts-with($vLine, '- ') or starts-with($vLine, '* ')">
          <ITEM n="item">
            <xsl:sequence select="tei:parse-string(substring($vLine, 3))"/>
          </ITEM>
       </xsl:when>
      <xsl:when test="matches($vLine,'[0-9]\. ')">
          <NITEM n="item">
            <xsl:sequence select="tei:parse-string(substring($vLine, 3))"/>
          </NITEM>
       </xsl:when>
       <xsl:otherwise>
        <p>
          <xsl:sequence select="tei:parse-string($vLine)"/>
        </p>
       </xsl:otherwise>
      </xsl:choose>
 </xsl:function>

 <xsl:function name="tei:parse-string" as="node()*">
  <xsl:param name="pS" as="xs:string"/>

  <xsl:analyze-string select="$pS" flags="x" regex=
  '(_(.*?)_)
  |
   (\*(.*?)\*)
  |
   ("(.*?)"\[(.*?)\])

  '>
   <xsl:matching-substring>
    <xsl:choose>
     <xsl:when test="regex-group(1)">
        <hi>
          <xsl:sequence select="tei:parse-string(regex-group(2))"/>
	</hi>
     </xsl:when>
     <xsl:when test="regex-group(3)">
        <seg>
          <xsl:sequence select="tei:parse-string(regex-group(4))"/>
        </seg>
     </xsl:when>
     <xsl:when test="regex-group(5)">
      <ref target="{regex-group(7)}">
       <xsl:sequence select="regex-group(6)"/>
      </ref>
     </xsl:when>
    </xsl:choose>
   </xsl:matching-substring>
   <xsl:non-matching-substring>
    <xsl:value-of select="."/>
   </xsl:non-matching-substring>
  </xsl:analyze-string>
 </xsl:function>


</xsl:stylesheet> 
