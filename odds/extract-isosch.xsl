<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:teix="http://www.tei-c.org/ns/Examples"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                xmlns="http://purl.oclc.org/dsdl/schematron"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://www.oxygenxml.com/ns/doc/xsl"
                version="2.0"
                xpath-default-namespace="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="#all">
  <xsl:import href="../common/functions.xsl"/>

  <d:doc scope="stylesheet" type="stylesheet">
    <d:desc>
      <d:p> TEI stylesheet for extracting Schematron rules from  TEI ODD </d:p>
      <d:p>This software is dual-licensed:

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
</d:p>
      <d:p>Author: See AUTHORS</d:p>
      <d:p>Copyright: 2014, TEI Consortium</d:p>
      <d:p/>
      <d:p>Modified 2014-01-01/09 by Syd Bauman:
      <d:ul>
        <d:li>rely on xpath-default-namespace</d:li>
        <d:li>re-work how we support non-TEI namespaces</d:li>
        <d:li>re-work how we generate context= attrs</d:li>
      </d:ul>
      </d:p>
      <d:p>Modified 2013-12-31 by Syd Bauman:
        <d:ul>
          <d:li>change documentation prefix</d:li>
          <d:li>add code to support deprecation of constructs declared to
          be in non-TEI namespaces, part 1: elements, and attrs &amp; valItems delcared in elements</d:li>
        </d:ul>
      </d:p>
      <d:p>Modified 2013-12 by Syd Bauman:
      <d:ul>
        <d:li>generate checks for validUntil= on some constructs:
          <d:ul>
            <d:li><tt>&lt;attDef></tt> when inside either <tt>&lt;elementSpec></tt>
            or <tt>&lt;classSpec></tt></d:li>
            <d:li><tt>&lt;elementSpec></tt> itself</d:li>
            <d:li><tt>&lt;valItem></tt> when inside an <tt>&lt;elementSpec></tt></d:li>
          </d:ul>
        </d:li>
        <d:li>move ancestor::egXML test to key-building time (rather
          than testing in template that matches keys)</d:li>
        <d:li>add comment of metadata to output (perhaps this should be improved in future
        by passing in useful information via a parameter or parsing input <tt>&lt;teiHeader></tt>
        or some such)</d:li>
        <d:li>make output section comments into blocks that are pretty, at least
          if output is indentend nicely (e.g. via <tt>xmllint --format</tt>)</d:li>
      </d:ul>
      </d:p>
      <d:p>Modified 2012-05 by Syd Bauman: It seems that ISO Schematron does not have
        a <d:pre>&lt;key></d:pre> element. In fact, ISO 19757-3:2006 explicitly
        says “The XSLT key element may be used, in the XSLT namespace, before the pattern
        elements.” So we could just ignore <d:pre>&lt;key></d:pre> elements in
        the (ISO) Schematron namespace, but since then the user will likely not be
        getting what is intended, we’ll issue an error message as well.</d:p>
      <d:p>Modified 2010-07-03 by Syd Bauman: Add code to handle the case in which <d:pre>&lt;constraintSpec></d:pre>
        is a direct child of <d:pre>&lt;schemaSpec</d:pre>.</d:p>
    </d:desc>
  </d:doc>
  <xsl:output encoding="utf-8" indent="yes" method="xml"/>
  <xsl:param name="verbose" select="'false'"/>
  <xsl:param name="lang"/>
  <d:doc>
    <d:desc>"eip" stands for "Extract Iso schematron Prefix". Silly, I know, but
     my first thought (honestly) was "Tei Extract Iso schematron" :-|</d:desc>
  </d:doc>
  <xsl:param name="ns-prefix-prefix" select="'eip-'"/>
  <xsl:variable name="P5" select="/"/>
  <xsl:variable name="xslns">http://www.w3.org/1999/XSL/Transform</xsl:variable>
  
  <xsl:key name="DECLARED_NSs" 
           match="sch:ns[ not( ancestor::teix:egXML ) ]"
           use="1"/>
  
  <xsl:key name="KEYs" 
           match="xsl:key[ not( ancestor::teix:egXML ) ]"
           use="1"/>

  <xsl:key name="badKEYs" 
           match="sch:key[ not( ancestor::teix:egXML ) ]"
           use="1"/>
  
  <xsl:key name="DEPRECATEDs"
           match="//tei:*[@validUntil][ not( ancestor::teix:egXML ) ]"
           use="1"/>

  <xsl:key name="CONSTRAINTs"
           match="constraint[parent::constraintSpec[@scheme='isoschematron']]
                            [ not( ancestor::teix:egXML )]"
           use="1"/>

  <xsl:template match="/">
    <!-- first, decorate tree with namespace info -->
    <xsl:variable name="input-with-NSs">
      <xsl:apply-templates select="node()" mode="NSdecoration"/>
    </xsl:variable>
    <!-- then process decorated tree -->
    <xsl:apply-templates select="$input-with-NSs" mode="schematron-extraction">
      <xsl:with-param name="P5deco" select="$input-with-NSs/tei:TEI"/>
    </xsl:apply-templates>
      
    <!-- Note: to see decorated tree for debugging, change mode of above -->
    <!-- from "schematron-extraction" to "copy". -->
  </xsl:template>

  <xsl:template match="@*|node()" mode="copy">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="copy"/>
    </xsl:copy>
  </xsl:template>
  
  
  <d:doc>
    <d:desc>First pass ... elements that might have an ns= attribute
    get new nsu= (namespace URI) and nsp= (namespace prefix) attributes</d:desc>
  </d:doc>
  <xsl:template match="tei:attDef|tei:elementSpec|tei:schemaSpec" mode="NSdecoration">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:variable name="nsu">
        <xsl:choose>
          <xsl:when test="self::tei:attDef">
            <xsl:value-of select="if ( @ns ) then @ns else ''"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="if (ancestor-or-self::*[@ns] ) then ancestor-or-self::*[@ns][1]/@ns else 'http://www.tei-c.org/ns/1.0'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:attribute name="nsp">
        <xsl:choose>
          <xsl:when test="$nsu eq ''"/>
          <xsl:when test="$nsu eq 'http://www.tei-c.org/ns/1.0'">tei:</xsl:when>
          <xsl:when test="$nsu eq 'http://www.tei-c.org/ns/Examples'">teix:</xsl:when>
          <xsl:when test="ancestor-or-self::tei:schemaSpec//sch:ns[@uri eq $nsu]">
            <!-- oops ... what *should* we do if there's more than 1? Just taking the first seems lame, but -->
            <!-- I can't think of what else we might do right now. -Syd, 2014-07-23 -->
            <xsl:value-of select="concat( ancestor-or-self::tei:schemaSpec//sch:ns[@uri eq $nsu][1]/@prefix, ':')"/>
          </xsl:when>
          <xsl:when test="namespace::* = $nsu">
            <xsl:value-of select="concat( local-name( namespace::*[ . eq $nsu ][1] ), ':')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat( $ns-prefix-prefix, generate-id(), ':')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="nsu" select="$nsu"/>
      <xsl:apply-templates select="node()" mode="NSdecoration"/>
    </xsl:copy>
  </xsl:template>
  
  <d:doc>
    <d:desc>First pass ... everything else just gets copied</d:desc>
  </d:doc>
  <xsl:template match="@*|node()" mode="NSdecoration">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="NSdecoration"/>
    </xsl:copy>
  </xsl:template>
  
  <d:doc>
    <d:desc>Second pass does most the work ...</d:desc>
  </d:doc>
  <xsl:template match="/" mode="schematron-extraction">
    <xsl:param name="P5deco" as="element( tei:TEI )"/>
    <schema queryBinding="xslt2">
      <title>ISO Schematron rules</title>
      <xsl:comment> This file generated <xsl:sequence select="tei:whatsTheDate()"/> by 'extract-isosch.xsl'. </xsl:comment>

      <xsl:call-template name="blockComment">
        <xsl:with-param name="content" select="'namespaces, declared:'"/>
      </xsl:call-template>
      <xsl:for-each select="key('DECLARED_NSs',1)">
        <xsl:choose>
          <xsl:when test="ancestor::constraintSpec/@xml:lang
                  and not(ancestor::constraintSpec/@xml:lang = $lang)"/>
          <xsl:when test="@prefix = 'xsl'"/>
          <xsl:otherwise>
            <ns><xsl:apply-templates select="@*|node()" mode="copy"/></ns>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      
      <xsl:call-template name="blockComment">
        <xsl:with-param name="content" select="'namespaces, implicit:'"/>
      </xsl:call-template>
      <xsl:variable name="NSs" select="distinct-values( //tei:*[@nsu]/concat( @nsp, '␝', @nsu ) )"/>
      <xsl:variable name="NSpres" select="distinct-values( //tei:*[@nsu]/@nsp )"/>
      <xsl:for-each select="$NSs[ not(. eq '␝')  and not(contains(.,$xslns)) ]">
        <xsl:sort/>
        <ns prefix="{substring-before( .,':␝')}" uri="{substring-after( .,'␝')}"/>
      </xsl:for-each>      
      
      <xsl:if test="key('KEYs',1)">
        <xsl:call-template name="blockComment">
          <xsl:with-param name="content" select="'keys:'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:for-each select="key('KEYs',1)">
        <xsl:choose>
          <xsl:when test="ancestor::constraintSpec/@xml:lang
                  and not(ancestor::constraintSpec/@xml:lang = $lang)"/>
          <xsl:otherwise>
            <xsl:apply-templates select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>

      <xsl:if test="key('badKEYs',1)">
        <xsl:message>WARNING: You have <xsl:value-of select="count(key('badKEYs',1))"/> &lt;key>
          elements in the ISO Schematron namespace — but ISO Schematron does not have a &lt;key>
          element, so they are being summarily ignored. This will likely result in an ISO Schematron
          schema that does not perform the desired constraint tests properly.</xsl:message>
      </xsl:if>

      <xsl:if test="key('CONSTRAINTs',1)">
        <xsl:call-template name="blockComment">
          <xsl:with-param name="content" select="'constraints:'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:for-each select="key('CONSTRAINTs',1)">
        <xsl:choose>
          <xsl:when test="parent::constraintSpec/@xml:lang
                  and not(parent::constraintSpec/@xml:lang = $lang)"/>
          <xsl:otherwise> 
            <xsl:variable name="patID" select="tei:makePatternID(.)"/>
            <xsl:if test="sch:pattern">
              <xsl:apply-templates/>
            </xsl:if>
            <xsl:if test="sch:rule">
              <pattern id="{$patID}">
                <xsl:apply-templates/>
              </pattern>
            </xsl:if>
            <xsl:if test="sch:assert|sch:report">
              <pattern id="{$patID}">
                <rule>
                  <xsl:apply-templates select="@*"/>
                  <xsl:attribute name="context" select="tei:generate-context(.)"/>
                  <xsl:apply-templates select="node()"/>
                </rule>
              </pattern>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>

      <xsl:if test="key('DEPRECATEDs',1)">
        <xsl:call-template name="blockComment">
          <xsl:with-param name="content" select="'deprecated:'"/>
        </xsl:call-template>
      </xsl:if>
      <!-- Things that can be deprecated: -->
      <!--   attDef classSpec constraintSpec elementSpec macroSpec -->
      <!--   moduleSpec schemaSpec valDesc valItem valList -->
      <!-- right now we only handle the few that actually appear -->
      <xsl:for-each select="key('DEPRECATEDs',1)">
        <xsl:variable name="amsg1" select="'WARNING: use of deprecated attribute —'"/>
        <xsl:variable name="vmsg1" select="'WARNING: use of deprecated attribute value — The'"/>
        <xsl:variable name="msg2" select="'will be removed from the TEI on '"/>
        <xsl:variable name="nsp" select="ancestor-or-self::tei:*[@nsp][1]/@nsp"/>
        <xsl:choose>
          <xsl:when test="self::attDef[ancestor::elementSpec]">
            <xsl:variable name="gi" select="ancestor::elementSpec/@ident"/>
            <xsl:variable name="ginsp" select="ancestor::elementSpec/@nsp"/>
            <pattern>
              <rule context="{tei:generate-context(.)}">
                <report test="@{concat($nsp,@ident)}" role="nonfatal">
                   <xsl:value-of select="$amsg1"/> @<xsl:value-of select="@ident"/> of the <xsl:value-of select="$gi"/> element <xsl:value-of select="$msg2"/> <xsl:value-of select="@validUntil"/>.
                </report>
              </rule>
            </pattern>
          </xsl:when>
          <xsl:when test="self::attDef[ancestor::classSpec]">
            <xsl:variable name="class" select="ancestor::classSpec/@ident"/>
            <xsl:variable name="fqgis">
              <xsl:choose>
                <xsl:when test="contains( $class,'global')">tei:*</xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$P5deco//elementSpec[classes/memberOf[@key=$class]]/concat( @nsp, @ident )" separator="|"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="giPattern">
              <xsl:value-of select="$fqgis" separator="|"/>
            </xsl:variable>
            <pattern>
              <rule context="{$giPattern}">
                <report test="@{@ident}" role="nonfatal">
                  <xsl:value-of select="$amsg1"/> @<xsl:value-of select="@ident"/> of the <name/> element <xsl:value-of select="$msg2"/> <xsl:value-of select="@validUntil"/>.
                </report>
              </rule>
            </pattern>
          </xsl:when>
          <xsl:when test="self::elementSpec">
            <pattern>
              <rule context="{concat($nsp,@ident)}">
                <report test="true()" role="nonfatal">
                  WARNING: use of deprecated element — The <name/> element <xsl:value-of select="$msg2"/> <xsl:value-of select="@validUntil"/>. 
                </report>
              </rule>
            </pattern>
          </xsl:when>
          <xsl:when test="self::valItem[ancestor::elementSpec]">
            <xsl:variable name="gi" select="ancestor::elementSpec/@ident"/>
            <xsl:variable name="attrName" select="ancestor::attDef/@ident"/>
            <pattern>
              <rule context="{concat($nsp,$gi)}">
                <report test="@{$attrName} eq '{@ident}'" role="nonfatal">
                  <xsl:value-of select="$vmsg1"/> the value '<xsl:value-of select="@ident"/>' of @<xsl:value-of select="$attrName"/> of the <xsl:value-of select="$gi"/> element <xsl:value-of select="$msg2"/> <xsl:value-of select="@validUntil"/>.
                </report>
              </rule>
            </pattern>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>

      <xsl:apply-templates select="//paramList"/>

    </schema>
  </xsl:template>
  
  <xsl:template match="sch:rule[parent::tei:constraint]">
    <rule>
      <xsl:apply-templates select="@*"/>
      <xsl:if test="not(@context)">
        <!-- note: don't want to call generate-context() if not needed, -->
        <!-- as we may want it to generate warning msgs -->
        <xsl:attribute name="context" select="tei:generate-context(.)"/>
      </xsl:if>
      <xsl:apply-templates select="node()"/>
    </rule>
  </xsl:template>
  
  <xsl:template match="@*|text()|comment()|processing-instruction()">
    <xsl:copy/>
  </xsl:template>
  
  <xsl:template match="sch:*|xsl:key">
    <xsl:element name="{local-name()}" namespace="{namespace-uri(.)}">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="sch:key|sch:ns"/>

  <xsl:template name="blockComment">
    <xsl:param name="content"/>
    <xsl:variable name="myContent" select="normalize-space($content)"/>
    <xsl:variable name="border" select="replace($myContent,'.','*')"/>
    <xsl:variable name="useContent" select="concat(' ',$myContent,' ')"/>
    <xsl:variable name="useBorder" select="concat(' ',$border,' ')"/>
    <xsl:text>&#x0A;&#x0A;</xsl:text>
    <xsl:comment><xsl:value-of select="$useBorder"/></xsl:comment>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:comment><xsl:value-of select="$useContent"/></xsl:comment>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:comment><xsl:value-of select="$useBorder"/></xsl:comment>
    <xsl:text>&#x0A;</xsl:text>
  </xsl:template>
  
  <xsl:function name="tei:generate-context">
    <xsl:param name="here"/>
    <xsl:for-each select="$here">
      <xsl:choose>
        <!-- attDef classSpec elementSpec macroSpec schemaSpec -->
        <xsl:when test="ancestor::attDef[ancestor::classSpec]">
          <!-- this is WRONG: need to run around and get the -->
          <!-- members of the class, and for each use its -->
          <!-- @nsp:@ident -->
          <xsl:variable name="me">
            <xsl:text>@</xsl:text>
            <xsl:value-of select="ancestor::attDef/@nsp"/>
            <xsl:value-of select="ancestor::attDef/@ident"/>
          </xsl:variable>
          <xsl:value-of select="$me"/>
          <xsl:message>WARNING: constraint for <xsl:value-of select="$me"/> of the <xsl:value-of select="ancestor::classSpec/@ident"/> class does not have a context=. Resulting rule is applied to *all* occurences of <xsl:value-of select="$me"/>.</xsl:message>
        </xsl:when>
        <xsl:when test="ancestor::attDef[ancestor::elementSpec]">
          <xsl:value-of select="ancestor::elementSpec/@nsp"/>
          <xsl:value-of select="ancestor::elementSpec/@ident"/>
          <xsl:text>/@</xsl:text>
          <xsl:value-of select="ancestor::attDef/@nsp"/>
          <xsl:value-of select="ancestor::attDef/@ident"/>
        </xsl:when>
        <xsl:when test="ancestor::classSpec">
          <!-- this is WRONG: need to run around and get the -->
          <!-- members of the class, and for each use its -->
          <!-- @nsp:@ident -->
          <xsl:message>WARNING: constraint for <xsl:value-of select="ancestor::classSpec/@ident"/> class does not have a context=. Resulting rule is applied to *all* elements.</xsl:message>
          <xsl:text>*</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor::elementSpec">
          <xsl:value-of select="ancestor::elementSpec/@nsp"/>
          <xsl:value-of select="ancestor::elementSpec/@ident"/>
        </xsl:when>
        <!-- this should not happen: -->
        <xsl:when test="ancestor::macroSpec"/>
        <!-- root seems the least problematic: -->
        <xsl:when test="ancestor::schemaSpec">
          <xsl:text>/</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:function>

  <xsl:template match="tei:TEI">
    <xsl:apply-templates/>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>work out unique ID for generated Schematron</desc>
  </doc>
  <xsl:function name="tei:makePatternID" as="xs:string">
    <xsl:param name="context"/>
    <xsl:for-each select="$context">
      <xsl:variable name="num">
	<xsl:number level="any"/>
      </xsl:variable>
      <xsl:value-of
	  select="(../ancestor::*[@ident]/@ident,'constraint',../@ident,$num)"
	  separator="-"/>
    </xsl:for-each>
  </xsl:function>

  <xsl:template match="paramList">
    <xsl:variable name="N">
      <xsl:number from="elementSpec" level="any"/>
    </xsl:variable>
    <xsl:variable name="B">
      <xsl:value-of select="parent::valItem/@ident"/>
    </xsl:variable>
    <pattern id="teipm-{ancestor::elementSpec/@ident}-paramList-{$N}">
          <rule context="tei:param[parent::tei:model/@behaviour='{$B}']">
            <assert role="error">
	      <xsl:attribute name="test">
		<xsl:text>@name='</xsl:text>
		<xsl:value-of select="(paramSpec/@ident)" separator="'   or  @name='"/>
		<xsl:text>'</xsl:text>
	      </xsl:attribute>
	      Parameter name '<value-of select="@name"/>'  (on <value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
	      Must  be  drawn from the list: <xsl:value-of separator=", " select="(paramSpec/@ident)" />
	    </assert>
	    
          </rule>
        </pattern>

  </xsl:template>

</xsl:stylesheet>
