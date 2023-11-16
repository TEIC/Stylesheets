<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet  xmlns="http://www.w3.org/1999/xhtml" xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"                 xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:rng="http://relaxng.org/ns/structure/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:teix="http://www.tei-c.org/ns/Examples" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="html a fo rng tei teix xs" version="2.0">

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
    <desc>
      <p> TEI stylesheet dealing with elements from the tagdocs module,
      making HTML output. </p>
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
    <desc>Process element ident</desc>
  </doc>
  <xsl:template match="tei:ident">
    <xsl:choose>
      <xsl:when test="@type">
        <span class="ident-{@type}">
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <span class="ident">
          <xsl:apply-templates/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element gi</desc>
  </doc>
  <xsl:template match="tei:gi">
    <span class="gi">
      <xsl:text>&lt;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&gt;</xsl:text>
    </span>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>
      <p>Process element att</p>
    </desc>
  </doc>
  <xsl:template match="tei:att">
    <span>
      <xsl:call-template name="makeRendition"/>
      <!-- JT (2023-09-28): At present, att's delimiter (@)
           is generated in CSS; if that changes, then the following
           should be included to be consistent -->
      <!--
        <xsl:call-template name="makeDelimiter">
         <xsl:with-param name="string" as="xs:string">@</xsl:with-param>
       </xsl:call-template>
      -->
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>
      <p>Process element val</p>
    </desc>
  </doc>
  <xsl:template match="tei:val">
    <span>
      <xsl:call-template name="makeRendition"/>
      <xsl:call-template name="makeDelimiter">
        <xsl:with-param name="string" as="xs:string">"</xsl:with-param>
        <xsl:with-param name="classes" select="'start'"/>
      </xsl:call-template>
      <xsl:apply-templates/>
      <xsl:call-template name="makeDelimiter">
        <xsl:with-param name="string" as="xs:string">"</xsl:with-param>
        <xsl:with-param name="classes" select="'end'"/>
      </xsl:call-template>
    </span>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>
      <p>Process element tag</p>
    </desc>
  </doc>
  <xsl:template match="tei:tag">
    <xsl:variable name="delims" as="xs:string*">
      <xsl:choose>
        <xsl:when test="empty(@type)">
          <xsl:sequence select="( '&lt;', '&gt;' )"/>
        </xsl:when>
        <xsl:when test="@type = 'start'">
          <xsl:sequence select="( '&lt;', '&gt;' )"/>
        </xsl:when>
        <xsl:when test="@type = 'end'">
          <xsl:sequence select="( '&lt;/', '&gt;' )"/>
        </xsl:when>
        <xsl:when test="@type eq 'empty'">
          <xsl:sequence select="( '&lt;', '/&gt;' )"/>
        </xsl:when>
        <xsl:when test="@type eq 'pi'">
          <xsl:sequence select="( '&lt;?', '?&gt;' )"/>
        </xsl:when>
        <xsl:when test="@type eq 'comment'">
          <xsl:sequence select="( '&lt;!--', '--&gt;' )"/>
        </xsl:when>
        <xsl:when test="@type eq 'ms'">
          <xsl:sequence select="( '&lt;[CDATA[', ']]&gt;' )"/>
        </xsl:when>
        <!--start, end, empty, pi, comment, and ms are the only
            legal values (as of 4.6.0); if a different type
            value is used, then this will break-->
        <xsl:otherwise>
          <xsl:message>Unhandled @type value of tei:tag: <xsl:value-of select="@type"/></xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <span>
      <xsl:attribute name="class" select="string-join( ( local-name(), @type, @scheme ),' ' )"/>
      <xsl:call-template name="makeRendition">
        <xsl:with-param name="default" select="'false'"/>
      </xsl:call-template>
      <xsl:call-template name="makeDelimiter">
        <xsl:with-param name="string" select="$delims[1]" as="xs:string"/>
        <xsl:with-param name="classes" select="'start'"/>
      </xsl:call-template>
      <xsl:apply-templates/>
      <xsl:call-template name="makeDelimiter">
        <xsl:with-param name="string" select="$delims[2]" as="xs:string"/>
        <xsl:with-param name="classes" select="'end'"/>
      </xsl:call-template>
    </span>
  </xsl:template>
  
  


<xsl:template match="tei:specGrp">
  <p><b>Specification group [<xsl:value-of select="@xml:id"/>]</b></p>
  <table class="border">
    <xsl:apply-templates/>
  </table>
</xsl:template>

<xsl:template match="tei:schemaSpec">
  <p><b>Specification [<xsl:value-of select="@xml:id"/>]</b></p>
  <table class="border">
    <xsl:apply-templates/>
  </table>
</xsl:template>


<xsl:template match="tei:classSpec">
  <tr>
    <td><xsl:sequence select="tei:showMode(@ident,@mode)"/></td>
    <td>
      <xsl:if test="*">
	<table class="border">
	  <xsl:apply-templates/>
	</table>
      </xsl:if>
    </td>
  </tr>
</xsl:template>

<xsl:template match="tei:elementSpec">
  <tr>
    <td>&lt;<xsl:sequence
    select="tei:showMode(@ident,@mode)"/>&gt;</td>
    <td>
      <xsl:if test="*">
	<table class="border">
	  <xsl:if test="tei:desc or tei:gloss">
	    <tr><td colspan="3">
	      <xsl:apply-templates  select="tei:desc |tei:gloss"/>
	    </td></tr>
	  </xsl:if>
	  <xsl:apply-templates select="*[not(self::tei:desc or self::tei:gloss)]"/>
	</table>
      </xsl:if>
    </td>
  </tr>
</xsl:template>

<xsl:template match="tei:attDef">
  <tr>
    <td>@<xsl:sequence select="tei:showMode(@ident,@mode)"/></td>
    <td>
      <xsl:if test="*">
	<table class="border">
	  <xsl:if test="tei:desc or tei:gloss">
	    <tr><td colspan="3">
	      <xsl:apply-templates  select="tei:desc |tei:gloss"/>
	    </td></tr>
	  </xsl:if>
	  <xsl:apply-templates select="*[not(self::tei:desc or self::tei:gloss)]"/>
	</table>
      </xsl:if>
    </td>
  </tr>
</xsl:template>

<xsl:template match="tei:valItem">
  <tr>
    <td><xsl:sequence select="tei:showMode(@ident,@mode)"/>
	  <xsl:if test="tei:paramList">
	    <xsl:text> (</xsl:text>
	    <xsl:value-of select="tei:paramList/tei:paramSpec/@ident" separator=","/>
	    <xsl:text>)</xsl:text>
	  </xsl:if>
    </td>
    <td><xsl:value-of select="tei:desc"/>    </td>
  </tr>
</xsl:template>

<xsl:template match="tei:elementSpec[@mode='change' and not(*)]"/>

<xsl:template match="tei:model">
  <tr>
    <td>[model] <i><xsl:value-of select="tei:desc"/></i></td>
    <td><xsl:value-of
    select="(@predicate,@behaviour,@class,@output)" separator=" ; "/> 
    <xsl:apply-templates select="tei:rendition"/>
    </td>
  </tr>
</xsl:template>

<xsl:template match="tei:modelGrp">
  <tr>
    <td>[modelGrp] <xsl:value-of select="tei:desc"/></td>
    <td><xsl:value-of
    select="(@predicate,@behaviour,@class,@output)" separator=" ; "/></td>
    <xsl:apply-templates select="tei:rendition"/>
  </tr>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="tei:model/tei:rendition|tei:modelGrp/tei:rendition">
  (<tt><xsl:apply-templates/></tt>)
</xsl:template>

<xsl:template match="tei:constraintSpec">
  <tr>
    <td>[#<xsl:value-of select="@ident"/>]</td>
    <td>
	<xsl:variable name="c">
	  <egXML xmlns="http://www.tei-c.org/ns/Examples">
	    <xsl:copy-of select="tei:constraint"/>
	  </egXML>
	</xsl:variable>
	<xsl:for-each select="$c">
	  <xsl:apply-templates/>
	</xsl:for-each>
    </td>
  </tr>
</xsl:template>

<xsl:template match="tei:elementRef">
  <tr>
    <td>+ &lt;<xsl:value-of select="@key"/>&gt;</td>
  </tr>
</xsl:template>

<xsl:template match="tei:classRef">
  <tr>
    <td>+ <xsl:value-of select="@key"/></td>
  </tr>
</xsl:template>

<xsl:template match="tei:macroRef">
  <tr>
    <td>+ <xsl:value-of select="@key"/></td>
  </tr>
</xsl:template>

<xsl:template match="tei:specGrp/tei:p">
  <tr>
    <td colspan="3" class="norules"><xsl:apply-templates/></td>
  </tr>
</xsl:template>

<xsl:template match="tei:moduleRef">
  <tr>
    <td>Module: <xsl:value-of select="@key"/></td>
  </tr>
</xsl:template>

<xsl:template match="tei:content">
  <tr>
    <td colspan="3">
    <div class="pre"><xsl:apply-templates mode="verbatim"/></div></td>
  </tr>
</xsl:template>

<xsl:template match="tei:exemplum">
  <tr>
    <td colspan="3"><xsl:apply-templates/></td>
  </tr>
</xsl:template>

<doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
  <desc>Process elements teix:egXML</desc>
</doc>
<xsl:template match="teix:egXML">
  <xsl:param name="simple">false</xsl:param>
  <xsl:param name="highlight"/>
  <div>
    <xsl:attribute name="id">
      <xsl:apply-templates mode="ident" select="."/>
    </xsl:attribute>
    <xsl:attribute name="class">
      <xsl:text>pre</xsl:text>
      <xsl:if test="not(*)">
	<xsl:text> cdata</xsl:text>
      </xsl:if>
      <xsl:choose>
	<xsl:when test="@valid='feasible'">
	  <xsl:text> egXML_feasible</xsl:text>
	</xsl:when>
	<xsl:when test="@valid='false'">
	  <xsl:text> egXML_invalid</xsl:text>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:text> egXML_valid</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:choose>
      <xsl:when test="$simple='true'">
	<xsl:apply-templates mode="verbatim">
	  <xsl:with-param name="highlight">
	    <xsl:value-of select="$highlight"/>
	  </xsl:with-param>
	</xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
	<xsl:call-template name="egXMLStartHook"/>
	<xsl:apply-templates mode="verbatim">
	  <xsl:with-param name="highlight">
	    <xsl:value-of select="$highlight"/>
	  </xsl:with-param>
	</xsl:apply-templates>
	<xsl:call-template name="egXMLEndHook"/>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<xsl:template match="tei:classes">
  <tr>
    <td>Classes</td>
    <td colspan="2">
      <ul>
	<xsl:for-each select="tei:memberOf">
	  <xsl:value-of select="@key"/>
	</xsl:for-each>
      </ul>
    </td>
  </tr>
</xsl:template>

<xsl:function name="tei:showMode">
<xsl:param name="value"/>
<xsl:param name="mode"/>
<span class="{if ($mode='delete') then 'red del' else if ($mode='change')
  then 'orange' else 'green'}">
<xsl:value-of select="$value"/>
</span>
</xsl:function>

</xsl:stylesheet>
