<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"  xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:dbk="http://docbook.org/ns/docbook"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:teix="http://www.tei-c.org/ns/Examples"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:html="http://www.w3.org/1999/xhtml"

                
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="a fo dbk xlink xhtml rng tei teix"
                version="2.0">
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>
         <p> TEI stylesheet dealing with elements from the textcrit
      module, making HTML output. </p>
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
  
  <xsl:template name="injectNote">
    <xsl:param name="lemma"/>
    <xsl:param name="identifier"/>
    <xsl:param name="appN"/>
    <xsl:apply-templates select="$lemma" mode="injectNote">
      <xsl:with-param name="identifier" select="$identifier"/>
      <xsl:with-param name="appN" select="$appN"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="node()|@*" mode="injectNote">
    <xsl:param name="identifier"/>
    <xsl:param name="appN"/>
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" mode="injectNote"><xsl:with-param name="identifier" select="$identifier"/></xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="html:div[not(following-sibling::html:div)]" mode="injectNote">
    <xsl:param name="identifier"/>
    <xsl:param name="appN"/>
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" mode="injectNote"/>
      <xsl:choose>
        <xsl:when test="$footnoteFile='true'">
          <a class="notelink" href="{$masterFile}-notes.html#{$identifier}">
            <sup><xsl:value-of select="$appN"/></sup>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <a class="notelink" href="#{$identifier}">
            <sup><xsl:value-of select="$appN"/></sup>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

   <xsl:template name="makeAppEntry">
     <xsl:param name="lemma"/>
     <!--<xsl:message>App: <xsl:value-of select="($lemma,$lemmawitness,$readings)" separator="|"/></xsl:message>-->
      <xsl:variable name="identifier">
         <xsl:text>App</xsl:text>
         <xsl:choose>
	   <xsl:when test="@xml:id">
	     <xsl:value-of select="@xml:id"/>
	   </xsl:when>
	   <xsl:otherwise>
	     <xsl:number count="tei:app" level="any"/>
	   </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
     <xsl:choose>
       <xsl:when test="$lemma/html:div">
         <xsl:call-template name="injectNote">
           <xsl:with-param name="lemma" select="$lemma"/>
           <xsl:with-param name="identifier" select="$identifier"/>
           <xsl:with-param name="appN"><xsl:call-template name="appN"/></xsl:with-param>
         </xsl:call-template>
       </xsl:when>
       <xsl:when test="normalize-space($lemma) = '' and .//tei:l"/>
       <xsl:otherwise>
         <xsl:copy-of select="$lemma"/>
         <xsl:choose>
           <xsl:when test="$footnoteFile='true'">
             <a class="notelink" href="{$masterFile}-notes.html#{$identifier}">
               <sup>
                 <xsl:call-template name="appN"/>
               </sup>
             </a>
           </xsl:when>
           <xsl:otherwise>
             <a class="notelink" href="#{$identifier}">
               <sup>
                 <xsl:call-template name="appN"/>
               </sup>
             </a>
           </xsl:otherwise>
         </xsl:choose>
       </xsl:otherwise>
     </xsl:choose>
      

  </xsl:template>


   <xsl:template match="tei:app" mode="printnotes">
      <xsl:variable name="identifier">
         <xsl:text>App</xsl:text>
         <xsl:choose>
            <xsl:when test="@xml:id">
	      <xsl:value-of select="@xml:id"/>
            </xsl:when>
            <xsl:otherwise>
	      <xsl:number count="tei:app" level="any"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <div class="app">
         <xsl:call-template name="makeAnchor">
           <xsl:with-param name="name" select="$identifier"/>
         </xsl:call-template>
        <xsl:choose>
          <xsl:when test="tei:lem//tei:l">
            <xsl:choose>
              <xsl:when test="count(tei:lem//tei:l) = 1">
                <xsl:text>l. </xsl:text><xsl:value-of select="tei:lem//tei:l/@n"/><xsl:text> </xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="lines" select="tei:lem//tei:l[@n]"/>
                <xsl:text>ll. </xsl:text><xsl:value-of select="$lines[1]/@n"/>–<xsl:value-of select="$lines[last()]/@n"/><xsl:text> </xsl:text></xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="not(tei:lem) and tei:rdg[1]//tei:l">
            <xsl:choose>
              <xsl:when test="count(tei:rdg[1]//tei:l) = 1">
                <xsl:text>l. </xsl:text><xsl:value-of select="tei:rdg[1]//tei:l/@n"/><xsl:text> </xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="lines" select="tei:rdg[1]//tei:l[@n]"/>
                <xsl:text>ll. </xsl:text><xsl:value-of select="$lines[1]/@n"/>–<xsl:value-of select="$lines[last()]/@n"/><xsl:text> </xsl:text></xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <span class="lemma">
              <xsl:call-template name="appLemma"/>
            </span>
            <xsl:text>] </xsl:text>
          </xsl:otherwise></xsl:choose>
        <xsl:if test="*[1]/@wit or *[1]/@source"><span class="lemmawitness">
    	   <xsl:call-template name="appLemmaWitness"/>
    	 </span><xsl:text> </xsl:text></xsl:if>
	     <xsl:call-template name="appReadings"/>
     </div>
     
   </xsl:template>

</xsl:stylesheet>
