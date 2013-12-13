<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:teix="http://www.tei-c.org/ns/Examples"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                xmlns="http://purl.oclc.org/dsdl/schematron"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:oxdoc="http://www.oxygenxml.com/ns/doc/xsl"
                version="2.0"
                exclude-result-prefixes="tei rng teix sch xi #default">
  <oxdoc:doc scope="stylesheet" type="stylesheet">
    <oxdoc:desc>
      <oxdoc:p> TEI stylesheet for simplifying TEI ODD markup </oxdoc:p>
      <oxdoc:p>This software is dual-licensed:

1. Distributed under a Creative Commons Attribution-ShareAlike 3.0
Unported License http://creativecommons.org/licenses/by-sa/3.0/ 

2. http://www.opensource.org/licenses/BSD-2-Clause
                
All rights reserved.

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
</oxdoc:p>
      <oxdoc:p>Author: See AUTHORS</oxdoc:p>
      <oxdoc:p>Id: $Id$</oxdoc:p>
      <oxdoc:p>Copyright: 2013, TEI Consortium</oxdoc:p>
      <oxdoc:p/>
      <oxdoc:p>Modified 2013-12 by Syd Bauman:
      <oxdoc:ul>
        <oxdoc:li>generate checks for validUntil= on some constructs:
          <oxdoc:ul>
            <oxdoc:li><tt>&lt;attDef></tt> when inside either <tt>&lt;elementSpec></tt>
            or <tt>&lt;classSpec></tt></oxdoc:li>
            <oxdoc:li><tt>&lt;elementSpec></tt> itself</oxdoc:li>
            <oxdoc:li><tt>&lt;valItem></tt> when inside an <tt>&lt;elementSpec></tt></oxdoc:li>
          </oxdoc:ul>
        </oxdoc:li>
        <oxdoc:li>move ancestor::egXML test to key-building time (rather
          than testing in template that matches keys)</oxdoc:li>
        <oxdoc:li>add comment of metadata to output (perhaps this should be improved in future
        by passing in useful information via a parameter or parsing input <tt>&lt;teiHeader></tt>
        or some such)</oxdoc:li>
        <oxdoc:li>make output section comments into blocks that are pretty, at least
          if output is indentend nicely (e.g. via <tt>xmllint --format</tt>)</oxdoc:li>
      </oxdoc:ul>
      </oxdoc:p>
      <oxdoc:p>Modified 2012-05 by Syd Bauman: It seems that ISO Schematron does not have
        a <oxdoc:pre>&lt;key></oxdoc:pre> element. In fact, ISO 19757-3:2006 explicitly
        says “The XSLT key element may be used, in the XSLT namespace, before the pattern
        elements.” So we could just ignore <oxdoc:pre>&lt;key></oxdoc:pre> elements in
        the (ISO) Schematron namespace, but since then the user will likely not be
        getting what is intended, we’ll issue an error message as well.</oxdoc:p>
    </oxdoc:desc>
  </oxdoc:doc>

  <xsl:output encoding="utf-8" indent="yes" method="xml"/>
  <xsl:param name="lang"/>
  <xsl:variable name="P5" select="/"/>

  <xsl:key name="NSs" 
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

  <xsl:key name="PATTERNs"
           match="sch:pattern[ not( ancestor::teix:egXML ) ]"
           use="1"/>

  <xsl:key name="CONSTRAINTs"
    match="tei:constraint[ not( ancestor::teix:egXML ) ]"
           use="1"/>

  <xsl:template match="/">
    <schema queryBinding="xslt2">
      <title>ISO Schematron rules</title>
      <xsl:comment> This file generated <xsl:value-of
    select="current-dateTime()"/> by 'extract-isosch.xsl'. </xsl:comment>

      <xsl:call-template name="blockComment">
        <xsl:with-param name="content" select="'namespaces:'"/>
      </xsl:call-template>
      <xsl:for-each select="key('NSs',1)">
        <xsl:choose>
          <xsl:when test="ancestor::tei:constraintSpec/@xml:lang
                  and not(ancestor::tei:constraintSpec/@xml:lang = $lang)"/>
          <xsl:otherwise>
            <xsl:apply-templates select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <xsl:if test="not( key('NSs',1)[@prefix='tei'] )">
        <sch:ns prefix="tei" uri="http://www.tei-c.org/ns/1.0"/>
      </xsl:if>

      <xsl:if test="key('KEYs',1)">
        <xsl:call-template name="blockComment">
          <xsl:with-param name="content" select="'keys:'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:for-each select="key('KEYs',1)">
        <xsl:choose>
          <xsl:when test="ancestor::tei:constraintSpec/@xml:lang
                  and not(ancestor::tei:constraintSpec/@xml:lang = $lang)"/>
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

      <xsl:if test="key('PATTERNs',1)">
        <xsl:call-template name="blockComment">
          <xsl:with-param name="content" select="'patterns:'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:for-each select="key('PATTERNs',1)">
        <xsl:choose>
          <xsl:when
            test="ancestor::tei:constraintSpec/@xml:lang
                 and not(ancestor::tei:constraintSpec/@xml:lang = $lang)"/>
          <xsl:otherwise>
            <xsl:apply-templates select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>

      <xsl:if test="key('CONSTRAINTs',1)">
        <xsl:call-template name="blockComment">
          <xsl:with-param name="content" select="'constraints:'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:for-each select="key('CONSTRAINTs',1)">
        <xsl:choose>
          <xsl:when test="ancestor::tei:constraintSpec/@xml:lang
                  and not(ancestor::tei:constraintSpec/@xml:lang = $lang)"/>
          <xsl:otherwise>
            <xsl:variable name="patID">
              <xsl:choose>
                <xsl:when test="ancestor::tei:elementSpec">
                  <xsl:value-of
                    select="concat(ancestor::tei:elementSpec/@ident,'-constraint-',ancestor::tei:constraintSpec/@ident)"
                  />
                </xsl:when>
                <xsl:when test="ancestor::tei:classSpec">
                  <xsl:value-of
                    select="concat(ancestor::tei:classSpec/@ident,'-constraint-',ancestor::tei:constraintSpec/@ident)"
                  />
                </xsl:when>
                <xsl:when test="ancestor::tei:macroSpec">
                  <xsl:value-of
                    select="concat(ancestor::tei:macroSpec/@ident,'-constraint-',ancestor::tei:constraintSpec/@ident)"
                  />
                </xsl:when>
                <xsl:otherwise>
                  <!-- Added 2010-07-03 by Syd Bauman to handle the case in which <constraintSpec> -->
                  <!-- is a direct child of <schemaSpec>. -->
                  <xsl:text>constraint-</xsl:text>
                  <xsl:value-of select="ancestor::tei:constraintSpec/@ident"/>
                  <xsl:if test="count( ../sch:rule ) > 1">
                    <xsl:text>-</xsl:text>
                    <xsl:number/>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:if test="sch:rule">
              <pattern id="{$patID}">
                <xsl:apply-templates select="sch:rule"/>
              </pattern>
            </xsl:if>
            <xsl:if test="sch:assert|sch:report">
              <pattern id="{$patID}">
                <rule>
                  <xsl:attribute name="context">
                    <xsl:sequence select="tei:generate-nsprefix-schematron(.)"/>
                    <xsl:choose>
                      <xsl:when test="ancestor::tei:elementSpec">
                        <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
                      </xsl:when>
                      <xsl:otherwise>*</xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>
                  <xsl:apply-templates select="sch:assert|sch:report"/>
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
      <xsl:for-each select="key('DEPRECATEDs',1)">
        <xsl:variable name="amsg1" select="'WARNING: use of deprecated attribute — The TEI-C may drop support for'"/>
        <xsl:variable name="vmsg1" select="'WARNING: use of deprecated attribute value — The TEI-C may drop support for'"/>
        <xsl:choose>
          <xsl:when test="self::tei:attDef[ancestor::tei:elementSpec]">
            <xsl:variable name="gi" select="ancestor::tei:elementSpec/@ident"/>
            <!-- This is a start at how we might process other namespaces;
              doesn't work yet for a variety of reasons, but also is not
              important yet, as @validUntil is used by TEI-C only on its
              own constructs
            <xsl:if test="ancestor-or-self::*/@ns">
              <xsl:variable name="nsu" select="ancestor-or-self::*[@ns][1]/@ns"/>
              <xsl:variable name="nsp" select="concat('ex-is-ns-', generate-id() )"/>
              <ns prefix="{$nsp}" uri="{$nsu}"/>
            </xsl:if> -->
            <sch:pattern>
              <sch:rule context="tei:{$gi}">
                <sch:report test="@{@ident}" role="nonfatal">
                   <xsl:value-of select="$amsg1"/> @<xsl:value-of select="@ident"/> of the <xsl:value-of select="$gi"/> element as early as <xsl:value-of select="@validUntil"/>.
                </sch:report>
              </sch:rule>
            </sch:pattern>
          </xsl:when>
          <xsl:when test="self::tei:attDef[ancestor::tei:classSpec]">
            <xsl:variable name="class" select="ancestor::tei:classSpec/@ident"/>
            <xsl:variable name="gis" select="$P5//tei:elementSpec[tei:classes/tei:memberOf[@key=$class]]/@ident"/>
            <xsl:variable name="fqgis">
              <xsl:for-each select="$gis">
                <xsl:value-of select="concat(' tei:', . )"/>
              </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="giPattern">
              <xsl:value-of select="tokenize( normalize-space($fqgis), ' ')" separator="|"/>
            </xsl:variable>
            <sch:pattern>
              <sch:rule context="{$giPattern}">
                <sch:report test="@{@ident}" role="nonfatal">
                  <xsl:value-of select="$amsg1"/> @<xsl:value-of select="@ident"/> of the <sch:name/> element as early as <xsl:value-of select="@validUntil"/>.
                </sch:report>
              </sch:rule>
            </sch:pattern>
          </xsl:when>
          <xsl:when test="self::tei:elementSpec">
            <sch:pattern>
              <sch:rule context="tei:{@ident}">
                <sch:report test="true()" role="nonfatal">
                  WARNING: use of deprecated element — The TEI-C may drop support for the <sch:name/> element as early as <xsl:value-of select="@validUntil"/>. 
                </sch:report>
              </sch:rule>
            </sch:pattern>
          </xsl:when>
          <xsl:when test="self::tei:valItem[ancestor::tei:elementSpec]">
            <xsl:variable name="gi" select="ancestor::tei:elementSpec/@ident"/>
            <xsl:variable name="attrName" select="ancestor::tei:attDef/@ident"/>
            <sch:pattern>
              <sch:rule context="tei:{$gi}">
                <sch:report test="@{$attrName} eq '{@ident}'" role="nonfatal">
                  <xsl:value-of select="$vmsg1"/> the value '<xsl:value-of select="@ident"/>' of @<xsl:value-of select="$attrName"/> of the <xsl:value-of select="$gi"/> element as early as <xsl:value-of select="@validUntil"/>.
                </sch:report>
              </sch:rule>
            </sch:pattern>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </schema>
  </xsl:template>
  
  <xsl:template match="sch:rule[not(@context)]">
    <rule>
      <xsl:attribute name="context">
        <xsl:sequence select="tei:generate-nsprefix-schematron(.)"/>        
        <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>
      </xsl:attribute>
      <xsl:apply-templates/>
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

  <xsl:template match="sch:key"/>

  <xsl:function name="tei:generate-nsprefix-schematron" as="xs:string">
    <xsl:param name="e"/>
    <xsl:for-each select="$e">
      <xsl:variable name="myns" select="ancestor::tei:elementSpec/@ns"/>
      <xsl:choose>
        <xsl:when test="not($myns) or $myns='http://www.tei-c.org/ns/1.0'">
          <xsl:text>tei:</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="ancestor::tei:schemaSpec//sch:ns[@uri=$myns]">
              <xsl:value-of select="concat(ancestor::tei:schemaSpec//sch:ns[@uri=$myns]/@prefix,':')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message terminate="yes">schematron rule cannot work out prefix for <xsl:value-of select="ancestor::tei:elementSpec/@ident"/></xsl:message>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:function>
  
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
  
</xsl:stylesheet>
