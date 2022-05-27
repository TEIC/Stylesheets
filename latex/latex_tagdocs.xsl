<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:teix="http://www.tei-c.org/ns/Examples"
                
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="a rng tei teix"
                version="2.0">
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>
         <p> TEI stylesheet dealing with elements from the tagdocs module,
      making LaTeX output. </p>
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
      <desc>Process element gi</desc>
   </doc>
  <xsl:template match="tei:gi">
      <xsl:text>\texttt{&lt;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&gt;}</xsl:text>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process element val</desc>
   </doc>
  <xsl:template match="tei:val">
      <xsl:value-of select="$preQuote"/>
      <xsl:apply-templates/>
      <xsl:value-of select="$postQuote"/>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process element att</desc>
   </doc>
  <xsl:template match="tei:att">
      <xsl:text>\textit{@</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Example element</desc>
   </doc>

  <xsl:template match="teix:egXML">
      <xsl:param name="simple">false</xsl:param>
      <xsl:param name="highlight"/>
      <xsl:choose>
         <xsl:when test="parent::tei:cell[number(@cols)&gt;1]">
	           <xsl:call-template name="egXMLStartHook"/>
	           <xsl:text>\exampleFont </xsl:text>
	           <xsl:apply-templates mode="verbatim">
	              <xsl:with-param name="highlight">
	                 <xsl:value-of select="$highlight"/>
	              </xsl:with-param>
	           </xsl:apply-templates>
	           <xsl:call-template name="egXMLEndHook"/>
         </xsl:when>
         <xsl:when test="parent::tei:cell">
	           <xsl:text>\leavevmode\bgroup</xsl:text>
	           <xsl:call-template name="egXMLStartHook"/>
	           <xsl:text>\exampleFont </xsl:text>
	           <xsl:text>\begin{shaded}\noindent\mbox{}</xsl:text>
	           <xsl:apply-templates mode="verbatim">
	              <xsl:with-param name="highlight">
	                 <xsl:value-of select="$highlight"/>
	              </xsl:with-param>
	           </xsl:apply-templates>
	           <xsl:text>\end{shaded}</xsl:text>
	           <xsl:call-template name="egXMLEndHook"/>
	           <xsl:text>\egroup &#10;&#10;</xsl:text>
         </xsl:when>
         <xsl:otherwise>
	           <xsl:text>\par\bgroup</xsl:text>
	           <xsl:call-template name="egXMLStartHook"/>
	           <xsl:text>\exampleFont </xsl:text>
	           <xsl:text>\begin{shaded}\noindent\mbox{}</xsl:text>
	           <xsl:apply-templates mode="verbatim">
	              <xsl:with-param name="highlight">
	                 <xsl:value-of select="$highlight"/>
	              </xsl:with-param>
	           </xsl:apply-templates>
	           <xsl:text>\end{shaded}</xsl:text>
	           <xsl:call-template name="egXMLEndHook"/>
	           <xsl:text>\egroup\par </xsl:text>
	           <xsl:if test="parent::tei:p and following-sibling::node()">\noindent </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
  </xsl:template>


   <xsl:template name="egXMLStartHook"/>
   <xsl:template name="egXMLEndHook"/>

   <xsl:template match="tei:seg[tei:match(@rend,'specChildren')]">
      <xsl:choose>
         <xsl:when test=".//tei:seg[tei:match(@rend,'specChildModule')]">
            <xsl:text>\hfil\\[-10pt]\begin{sansreflist}</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>\end{sansreflist}</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
<xsl:template match="tei:seg[tei:match(@rend,'specChildren')]">
<xsl:text>\mbox{ }\\ \begin{description}</xsl:text>
<xsl:apply-templates/>
<xsl:text>\end{description}</xsl:text>
</xsl:template>
-->

   <xsl:template match="tei:seg[@xml:lang]">
      <xsl:choose>
         <xsl:when test="@xml:lang=('zh','zh-TW')">
            <xsl:text>{\textChinese </xsl:text>
            <xsl:apply-templates/>
            <xsl:text>}</xsl:text>
         </xsl:when>
         <xsl:when test="@xml:lang='ja'">
            <xsl:text>{\textJapanese {</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>}}</xsl:text>
         </xsl:when>
         <xsl:when test="@xml:lang='ko'">
            <xsl:text>{\textKorean </xsl:text>
            <xsl:apply-templates/>
            <xsl:text>}</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="tei:seg[tei:match(@rend,'unusedattribute')]">
      <xsl:text>\unusedattribute{</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
   </xsl:template>

   <xsl:template match="tei:seg[tei:match(@rend,'specChild')]">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="tei:seg[tei:match(@rend,'specChildModule')]">
    \item[<xsl:apply-templates/>]
   </xsl:template>

   <xsl:template match="tei:seg[tei:match(@rend,'specChildElements')]">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="tei:seg[tei:match(@rend,'parent')]">
      <xsl:choose>
         <xsl:when test="*">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>—</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="tei:hi[tei:match(@rend,'parent')]">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="tei:hi[tei:match(@rend,'showmembers1')]">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="tei:hi[tei:match(@rend,'showmembers2')]">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="tei:hi[tei:match(@rend,'showmembers3')]">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="tei:hi[tei:match(@rend,'showmembers4')]">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="tei:table[tei:match(@rend,'wovenodd') or tei:match(@rend,'attDef')]">
      <xsl:text>
\begin{reflist}</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>
\end{reflist}  </xsl:text>
   </xsl:template>

   <xsl:template match="tei:table[tei:match(@rend,'valList')       or tei:match(@rend,'attList')       or tei:match(@rend,'specDesc')]">
      <xsl:text>\hfil\\[-10pt]\begin{sansreflist}</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>
\end{sansreflist}  </xsl:text>
   </xsl:template>

   <xsl:template match="tei:table[tei:match(@rend,'wovenodd')      or tei:match(@rend,'attList')      or tei:match(@rend,'valList')      or tei:match(@rend,'attDef')      or tei:match(@rend,'specDesc')]/tei:row">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="tei:table[tei:match(@rend,'wovenodd')       or tei:match(@rend,'attList')       or tei:match(@rend,'specDesc')       or tei:match(@rend,'valList')       or tei:match(@rend,'attDef')]/tei:row/tei:cell[1]">
      <xsl:choose>
         <xsl:when test="parent::tei:row/parent::tei:table[tei:match(@rend,'attList')]">
    \item[@<xsl:apply-templates/>]
  </xsl:when>
         <xsl:when test="ancestor::tei:table[tei:match(@rend,'valList')]">
    \item[<xsl:apply-templates/>]
  </xsl:when>
         <xsl:when test="ancestor::tei:table[tei:match(@rend,'specDesc')]">
    \item[@<xsl:apply-templates/>]
  </xsl:when>
         <xsl:when test="@cols='2' and not(parent::tei:row/preceding-sibling::tei:row)">
            <xsl:text>
\item[]\begin{specHead}{</xsl:text>
            <xsl:value-of select="ancestor::tei:div[1]/@xml:id"/>
            <xsl:text>}</xsl:text>
            <xsl:apply-templates/>
	    <xsl:text>\end{specHead} </xsl:text>
         </xsl:when>
         <xsl:when test="@cols='2'">
    \item[]<xsl:apply-templates/>
         </xsl:when>
         <xsl:otherwise>
    \item[<xsl:apply-templates/>]
  </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="tei:div[@type='refdoc']/tei:head"/>

   <xsl:template match="tei:div[@type='refdoc']">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="tei:table[tei:match(@rend,'wovenodd')        or tei:match(@rend,'attList')        or tei:match(@rend,'valList')        or tei:match(@rend,'specDesc')        or tei:match(@rend,'attDef')]/tei:row/tei:cell[2]">
      <xsl:apply-templates/>
   </xsl:template>


   <xsl:template match="tei:list[tei:match(@rend,'specList')]">
\begin{sansreflist}
  <xsl:apply-templates/>
\end{sansreflist}
</xsl:template>

   <!-- 
      dedicated processing of links in specLists
      which become the custom label of a LaTeX list item
      (https://github.com/TEIC/Stylesheets/issues/537).
   -->
   <xsl:template match="tei:hi[tei:match(@rend,'specList-elementSpec')]">
      <xsl:text>[{\hyperref[</xsl:text>
      <xsl:value-of select="substring(tei:ref/@target, 2)"/>
      <xsl:text>]{&lt;</xsl:text>
      <xsl:value-of select="tei:ref"/>
      <xsl:text>&gt;}}]</xsl:text>
   </xsl:template>

   <xsl:template match="tei:hi[tei:match(@rend,'specList-macroSpec')]">
      <xsl:text>[{\hyperref[</xsl:text>
      <xsl:value-of select="substring(tei:ref/@target, 2)"/>
      <xsl:text>]{</xsl:text>
      <xsl:value-of select="tei:ref"/>
      <xsl:text>}}]</xsl:text>
   </xsl:template>

   <xsl:template match="tei:hi[tei:match(@rend,'specList-classSpec')]">
      <xsl:text>[{\hyperref[</xsl:text>
      <xsl:value-of select="substring(tei:ref/@target, 2)"/>
      <xsl:text>]{</xsl:text>
      <xsl:value-of select="tei:ref"/>
      <xsl:text>}}]</xsl:text>
   </xsl:template>

   <xsl:template match="tei:hi[tei:match(@rend,'label')  or tei:match(@rend,'defaultVal')]">
      <xsl:text>{</xsl:text>
      <xsl:choose>
         <xsl:when test="@xml:lang='ja'">
            <xsl:text>\textJapanese {</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>}</xsl:text>
         </xsl:when>
        <xsl:when test="@xml:lang='ko'">
          <xsl:text>\textKorean {</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>}</xsl:text>
        </xsl:when>
        <xsl:when test="@xml:lang=('zh','zh-TW')">
          <xsl:text>\textChinese {</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>}</xsl:text>
        </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:text>}</xsl:text>
   </xsl:template>


   <xsl:template match="tei:hi[tei:match(@rend,'attribute')]">
      <xsl:text>\textit{</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>}</xsl:text>
   </xsl:template>

   <xsl:template name="specHook">
      <xsl:param name="name"/>
   </xsl:template>


   <xsl:template match="tei:index[@indexName='ODDS']">
      <xsl:for-each select="tei:term">
         <xsl:text>\index{</xsl:text>
         <xsl:choose>
            <xsl:when test="@sortKey">
	              <xsl:value-of select="@sortKey"/>
	              <xsl:text>=</xsl:text>
	              <xsl:value-of select="."/>
            </xsl:when>
            <xsl:otherwise>
	              <xsl:value-of select="."/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:text>|oddindex</xsl:text>
         <xsl:text>}</xsl:text>
      </xsl:for-each>
      <xsl:for-each select="tei:index/tei:term">
         <xsl:text>\index{</xsl:text>
         <xsl:choose>
            <xsl:when test="@sortKey">
	              <xsl:value-of select="@sortKey"/>
	              <xsl:text>=</xsl:text>
	              <xsl:value-of select="."/>
            </xsl:when>
            <xsl:otherwise>
	              <xsl:value-of select="."/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:text>!</xsl:text>
         <xsl:value-of select="../../tei:term"/>
         <xsl:text>|oddindex</xsl:text>
         <xsl:text>}</xsl:text>
      </xsl:for-each>

   </xsl:template>

  <xsl:template match="tei:tag">
    <xsl:text>\texttt{</xsl:text>
      <xsl:text>&lt;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&gt;</xsl:text>
    <xsl:text>}</xsl:text>
  </xsl:template>

</xsl:stylesheet>
