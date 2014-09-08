<xsl:stylesheet 
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei xs">

 <xsl:output omit-xml-declaration="yes" indent="yes"/>

 <xsl:template match="/">
  <xsl:for-each select="tokenize(., '\n')">
    <xsl:sequence select="tei:parse-line(.)"/>
  </xsl:for-each>
 </xsl:template>

 <xsl:function name="tei:parse-line" as="element()*">
  <xsl:param name="vLine" as="xs:string*"/>
    <xsl:variable name="vLineLength"
		  select="string-length($vLine)"/>
    <xsl:choose>
      <xsl:when test=
		"starts-with($vLine, '#')
		 and
		 ends-with($vLine, '#')
		 ">
        <xsl:variable name="vInnerString"
		      select="substring($vLine, 2, $vLineLength -2)"/>
        <h1>
	  <xsl:sequence select="tei:parse-string($vInnerString)"/>
        </h1>
        <xsl:sequence select=
        "tei:parse-line($pLines, $pLineNum+1, $pTotalLines)"/>
       </xsl:when>
       <xsl:when test=
        "starts-with($vLine, '- ')
       and
         not(starts-with($pLines[$pLineNum -1], '- '))
        ">
        <list>
          <item>
            <xsl:sequence select="tei:parse-string(substring($vLine, 2))"/>
          </item>
          <xsl:sequence select=
           "tei:parse-line($pLines, $pLineNum+1, $pTotalLines)"/>
	</list>
       </xsl:when>
       <xsl:when test="starts-with($vLine, '- ')">
          <item>
            <xsl:sequence select="tei:parse-string(substring($vLine, 2))"/>
          </item>
          <xsl:sequence select=
           "tei:parse-line($pLines, $pLineNum+1, $pTotalLines)"/>
       </xsl:when>
       <xsl:otherwise>
        <p>
          <xsl:sequence select="tei:parse-string($vLine)"/>
        </p>
        <xsl:sequence select=
           "tei:parse-line($pLines, $pLineNum+1, $pTotalLines)"/>
       </xsl:otherwise>
      </xsl:choose>
 </xsl:function>

 <xsl:function name="tei:parse-string" as="node()*">
  <xsl:param name="pS" as="xs:string"/>

  <xsl:analyze-string select="$pS" flags="x" regex=
  '(__(.*?)__)
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