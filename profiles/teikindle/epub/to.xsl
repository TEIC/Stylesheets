<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" 
    xmlns:html="http://www.w3.org/1999/xhtml" 
    xmlns:rng="http://relaxng.org/ns/structure/1.0" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:teix="http://www.tei-c.org/ns/Examples" 
    xmlns:xhtml="http://www.w3.org/1999/xhtml" 
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    exclude-result-prefixes="xlink rng tei teix xhtml a html xs xsl" version="3.0">

  <xsl:import href="../../../epub/tei-to-epub.xsl"/>
  <xsl:import href="../../../odds/teiodds.xsl"/>
  <xsl:import href="../../../html/html_oddprocessing.xsl"/>
  <xsl:import href="../../../odds/guidelines.xsl"/>
  <xsl:output method="xml" encoding="utf-8" indent="no"/>
  <xsl:param name="googleAnalytics"/>
  <xsl:param name="outputMethod">xhtml</xsl:param>
  <xsl:param name="lang"/>
  <xsl:param name="doclang"/>
  <xsl:param name="STDOUT">false</xsl:param>
  <xsl:param name="splitLevel">0</xsl:param>
  <xsl:param name="footnoteFile">false</xsl:param>
  <xsl:param name="auto">false</xsl:param>
  <xsl:param name="numberFrontHeadings">true</xsl:param>
  <xsl:param name="displayMode">rnc</xsl:param>
  <xsl:param name="feedbackURL">https://tei-c.org/about/contact/</xsl:param>
  <xsl:param name="homeLabel">TEI P5 Guidelines</xsl:param>
  <xsl:param name="homeWords">TEI P5</xsl:param>
  <xsl:param name="institution">Text Encoding Initiative</xsl:param>
  <xsl:param name="parentURL">http://www.tei-c.org/Consortium/</xsl:param>
  <xsl:param name="parentWords">TEI Consortium</xsl:param>
  <xsl:param name="cssFile">../profiles/tei/epub/guidelines.css</xsl:param>
  <xsl:param name="cssSecondaryFile">../profiles/tei/epub/odd.css</xsl:param>
  <xsl:param name="cssPrintFile">../profiles/tei/epub/guidelines-print.css</xsl:param>

  <xsl:template name="copyrightStatement">Copyright TEI Consortium 2011</xsl:template>
  
  <xsl:template name="epubManifestHook">
    <xsl:for-each select="key('ATTCLASSDOCS',1)">
      <xsl:variable name="me" select="@ident"/>
      <item xmlns="http://www.idpf.org/2007/opf" media-type="application/xhtml+xml" id="ref-{$me}" href="ref-{$me}.html"/>
    </xsl:for-each>
    <xsl:for-each select="key('MODELCLASSDOCS',1)">
      <xsl:variable name="me" select="@ident"/>
      <item xmlns="http://www.idpf.org/2007/opf" media-type="application/xhtml+xml" id="ref-{$me}" href="ref-{$me}.html"/>
    </xsl:for-each>
    <xsl:for-each select="key('MACRODOCS',1)">
      <xsl:variable name="me" select="@ident"/>
      <item xmlns="http://www.idpf.org/2007/opf" media-type="application/xhtml+xml" id="ref-{$me}" href="ref-{$me}.html"/>
    </xsl:for-each>
    <xsl:for-each select="key('ELEMENTDOCS',1)">
      <xsl:variable name="me" select="@ident"/>
      <item xmlns="http://www.idpf.org/2007/opf" media-type="application/xhtml+xml" id="ref-{$me}" href="ref-{$me}.html"/>
      <item xmlns="http://www.idpf.org/2007/opf" media-type="application/xhtml+xml" id="examples-{$me}" href="examples-{$me}.html"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="epubSpineHook">
    <xsl:for-each select="key('ELEMENTDOCS',1)">
      <xsl:variable name="me" select="@ident"/>
      <itemref xmlns="http://www.idpf.org/2007/opf" idref="ref-{$me}" linear="no"/>
      <itemref xmlns="http://www.idpf.org/2007/opf" idref="examples-{$me}" linear="no"/>
    </xsl:for-each>
    <xsl:for-each select="key('ATTCLASSDOCS',1)">
      <itemref xmlns="http://www.idpf.org/2007/opf" idref="ref-{@ident}" linear="no"/>
    </xsl:for-each>
    <xsl:for-each select="key('MODELCLASSDOCS',1)">
      <itemref xmlns="http://www.idpf.org/2007/opf" idref="ref-{@ident}" linear="no"/>
    </xsl:for-each>
    <xsl:for-each select="key('MACRODOCS',1)">
      <itemref xmlns="http://www.idpf.org/2007/opf" idref="ref-{@ident}" linear="no"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="atozHeader">
    <xsl:param name="Key"/>
  </xsl:template>

   <xsl:template name="navInterSep">
      <xsl:text> </xsl:text>
   </xsl:template>

   <xsl:template name="javascriptHook"/>

   <xsl:template
       match="tei:ref[starts-with(@target,'../../readme-')]">
     <xsl:apply-templates/>
   </xsl:template>

</xsl:stylesheet>
