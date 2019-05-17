<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:teix="http://www.tei-c.org/ns/Examples"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
		xmlns:sch="http://www.ascc.net/xml/schematron"
		xmlns="http://www.ascc.net/xml/schematron"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0"
                exclude-result-prefixes="tei rng teix sch xi xs
					 #default">

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
    <desc>
      <p> TEI stylesheet for simplifying TEI ODD markup </p>
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
  <xsl:output encoding="utf-8" indent="yes" method="xml"/>
  <xsl:param name="lang"></xsl:param>

  <xsl:key name="NS" 
	   match="sch:ns"
	   use="1"/>

  <xsl:key name="PATTERNS"
	   match="sch:pattern"
	   use="1"/>

  <xsl:key name="CONSTRAINTS"
	   match="tei:constraint"
	   use="1"/>


  <xsl:template match="/">
      <schema>
         <title>Schematron 1.5 rules</title>
         <xsl:for-each select="key('NS',1)">
            <xsl:choose>
               <xsl:when test="ancestor::teix:egXML"/>
	       <xsl:when test="ancestor::tei:constraintSpec/@xml:lang
		 and not(ancestor::tei:constraintSpec/@xml:lang = $lang)"/>
               <xsl:otherwise>
                  <xsl:apply-templates select="."/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>

         <xsl:for-each select="key('PATTERNS',1)">
            <xsl:choose>
               <xsl:when test="ancestor::teix:egXML"/>
	       <xsl:when test="ancestor::tei:constraintSpec/@xml:lang
		 and not(ancestor::tei:constraintSpec/@xml:lang = $lang)"/>
               <xsl:otherwise>
                  <xsl:apply-templates select="."/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>

         <xsl:for-each select="key('CONSTRAINTS',1)">
            <xsl:choose>
               <xsl:when test="ancestor::teix:egXML"/>
	       <xsl:when test="ancestor::tei:constraintSpec/@xml:lang
		 and not(ancestor::tei:constraintSpec/@xml:lang = $lang)"/>
               <xsl:otherwise>
		 <xsl:variable name="patID" select="tei:makePatternID(.)"/>
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
			     <xsl:value-of
				 select="ancestor::tei:elementSpec/@ident"/>
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
      <xsl:copy-of select="."/>
  </xsl:template>
  
  
  <xsl:template match="sch:*">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="*|@*|processing-instruction()|comment()|text()"/>
    </xsl:element>
  </xsl:template>

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
	      <xsl:value-of
		  select="concat((ancestor::tei:schemaSpec//sch:ns[@uri=$myns]/@prefix)[1],':')"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:message terminate="yes">schematron rule cannot work out prefix for <xsl:value-of select="ancestor::tei:elementSpec/@ident"/></xsl:message>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:otherwise>
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


</xsl:stylesheet>
