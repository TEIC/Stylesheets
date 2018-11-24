<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" 
                
                xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"

                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:teix="http://www.tei-c.org/ns/Examples"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="a fo rng tei teix html"
                version="2.0">
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>
         <p>
    TEI stylesheet
    dealing  with elements from the
    transcr module, making HTML output.
      </p>
         <p>This software is dual-licensed:

1. Distributed under a Creative Commons Attribution-ShareAlike 3.0
Unported License http://creativecommons.org/licenses/by-sa/3.0/ 

2. http://www.opensource.org/licenses/BSD-2-Clause
		


Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

This software is provided by the copyright holders and contributors
"as is" and any express or implied warranties, including, but not
limited to, the implied warranties of merchantability and fitness for
a particular purpose are disclaimed. In no event shall the copyright
holder or contributors be liable for any direct, indirect, incidental,
special, exemplary, or consequential damages (including, but not
limited to, procurement of substitute goods or services; loss of use,
data, or profits; or business interruption) however caused and on any
theory of liability, whether in contract, strict liability, or tort
(including negligence or otherwise) arising in any way out of the use
of this software, even if advised of the possibility of such damage.
</p>
         <p>Author: See AUTHORS</p>
         
         <p>Copyright: 2013, TEI Consortium</p>
      </desc>
   </doc>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] processing source doc</desc>
   </doc>
<xsl:template match="tei:sourceDoc">
  <xsl:apply-templates/>
</xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] lines, surfaces and zones in transcription just turn into divs</desc>
   </doc>

<xsl:template match="tei:surfaceGrp">
  <div>
    <xsl:call-template name="makeRendition"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="tei:surface">
  <div>
    <xsl:call-template name="makeRendition"/>
    <xsl:call-template name="checkfacs"/>
    <xsl:apply-templates select="text()|*[not(self::tei:graphic)]"/>
  </div>
</xsl:template>

<xsl:template match="tei:zone">
  <div>
    <xsl:call-template name="makeRendition"/>
    <xsl:call-template name="checkfacs"/>
    <xsl:apply-templates select="text()|*[not(self::tei:graphic)]"/>
  </div>
</xsl:template>

<xsl:template match="tei:line">
  <div>
    <xsl:call-template name="makeRendition"/>
    <xsl:call-template name="checkfacs"/>
    <xsl:apply-templates select="text()|*[not(self::tei:graphic)]"/>
  </div>
</xsl:template>

<xsl:template name="checkfacs">
  <xsl:choose>
    <xsl:when test="starts-with(@facs,'unknown:')"/>
    <xsl:when test="@facs">
      <div class="facsimage">
	<img src="{@facs}"/>
      </div>
    </xsl:when>
    <xsl:when test="tei:graphic">
      <div class="facsimage">
	<!-- avoid URLs without a file suffix, likely to be dodgy -->
	<xsl:for-each
	    select="tei:graphic[matches(@url,'.*\.[a-z]+$')][1]">
	  <xsl:apply-templates select="."/>
	</xsl:for-each>
      </div>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="tei:damage">
  <span class="damage">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="tei:ex">
  <span class="ex">
    <xsl:apply-templates />
  </span>
</xsl:template>

<xsl:template match="tei:surfaceGrp/tei:desc"/>
<xsl:template match="tei:surface/tei:desc"/>
<xsl:template match="tei:zone/tei:desc"/>
</xsl:stylesheet>
