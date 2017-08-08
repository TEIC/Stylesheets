<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
                xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:teix="http://www.tei-c.org/ns/Examples"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="a rng tei teix"
                version="2.0">
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>
         <p>
    TEI stylesheet
    dealing with elements from the
      textcrit module, making LaTeX output.
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
      <desc>
         <p>Creating an apparatus criticus reading.</p>
      </desc>
   </doc>
   <xsl:template name="makeAppEntry">
     <xsl:param name="lemma"/>
     <xsl:text>\edtext</xsl:text><xsl:text>{</xsl:text><xsl:apply-templates
       select="tei:lem[not(@rend='none')]"/><xsl:text>}{</xsl:text><xsl:if
         test="tei:lem[@rend='none']"><xsl:text>\lemma{</xsl:text><xsl:value-of
           select="tei:lem"/><xsl:text>}</xsl:text></xsl:if><xsl:text>\Afootnote</xsl:text><xsl:if
             test="tei:lem[@rend='none']"><xsl:text>[nosep]</xsl:text></xsl:if><xsl:text>{</xsl:text>
     <xsl:call-template name="appReadings"/>
     <xsl:text>}}</xsl:text>
   </xsl:template>
  
  <xsl:template match="tei:div[@type='edition']/tei:div">
    <xsl:apply-templates select="tei:head"/>

\beginnumbering
\pstart
    <xsl:apply-templates select="tei:head/following-sibling::*"/>
\pend
\endnumbering
  </xsl:template>
  
  
  <xsl:template match="tei:note[parent::tei:app//(tei:l|tei:p)]"/>
  <xsl:template match="tei:witDetail[parent::tei:app//(tei:l|tei:p)]"/>
  <xsl:template match="tei:wit[parent::tei:app//(tei:l|tei:p)]"/>
  <xsl:template match="tei:rdg[parent::tei:app//(tei:l|tei:p)]"/>
  <xsl:template match="tei:rdgGrp[parent::tei:app//(tei:l|tei:p)]"/>
  
  <xsl:template match="tei:abbr[@type='siglum']">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="tei:l[ancestor::tei:app and not(@processed)]">
    <xsl:variable name="self" select="."/>
    <xsl:if test="parent::tei:lem">
      <xsl:variable name="elt">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:attribute name="processed">yes</xsl:attribute>
          <xsl:for-each select="ancestor::tei:app">
            <xsl:if test=".//tei:l[1] = $self">
              <app xmlns="http://www.tei-c.org/ns/1.0">
                <xsl:copy-of select="@*"/>
                <lem rend="none">
                  <xsl:choose>
                    <xsl:when test="count(tei:lem/tei:l) gt 1">
                      <xsl:text>ll. </xsl:text><xsl:value-of select="$self/@n"/>–<xsl:value-of
                        select="tei:lem/tei:l[last()]/@n"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>l. </xsl:text><xsl:value-of select="$self/@n"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:if test="tei:lem[not((*|text()))]"><xsl:text> om.</xsl:text></xsl:if>
                </lem>
                <xsl:for-each select="*">
                  <xsl:choose>
                    <xsl:when test="self::tei:rdg and not((*|text()))"><xsl:copy><xsl:copy-of
                      select="@*"/>om. </xsl:copy></xsl:when>
                    <xsl:when test="self::tei:lem"/>
                    <xsl:when test="self::tei:rdg[not(tei:l)]"><xsl:copy-of select="."/></xsl:when>
                    <xsl:when test="self::tei:rdg"/>
                    <xsl:when test="self::tei:rdgGrp"/>
                    <xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </app>
            </xsl:if>
          </xsl:for-each>
          <xsl:copy-of select="*|text()"/>
        </xsl:copy>
      </xsl:variable>
      <xsl:apply-templates select="$elt"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:app[not(tei:lem)]">
    <xsl:variable name="appnote">
      <xsl:copy>
        <tei:lem rend="none"> </tei:lem>
        <xsl:copy-of select="*"/>
      </xsl:copy>
    </xsl:variable>
    <xsl:apply-templates select="$appnote"/>
  </xsl:template>

  <!--<xsl:template match="tei:lg">
    <xsl:choose>
      <xsl:when test="count(key('APP',1))&gt;0">
        <xsl:variable name="c" select="(count(tei:l)+1) div 2"/>
        <xsl:text>\setstanzaindents{1,1,0}</xsl:text>
        <xsl:text>\setcounter{stanzaindentsrepetition}{</xsl:text>
        <xsl:value-of select="$c"/>
        <xsl:text>}</xsl:text>
        <xsl:text>\stanza&#10;</xsl:text>
        <xsl:for-each select="tei:l">
          <xsl:if test="parent::tei:lg/@xml:lang='Av'">{\itshape </xsl:if>
          <xsl:apply-templates/>
          <xsl:if test="parent::tei:lg/@xml:lang='Av'">}</xsl:if>
          <xsl:if test="following-sibling::tei:l">
            <xsl:text>&amp;</xsl:text>
          </xsl:if>
        </xsl:for-each>
        <xsl:text>\&amp;&#10;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>-->

  <xsl:template match="tei:witDetail[not(*|text())]">
    <xsl:choose>
      <xsl:when test="@type='correction-altered'">p.c.</xsl:when>
      <xsl:when test="@type='correction-original'">a.c.</xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
