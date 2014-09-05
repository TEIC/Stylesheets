<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:iso="http://www.iso.org/ns/1.0"
                xmlns:teidocx="http://www.tei-c.org/ns/teidocx/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006"
                xmlns:o="urn:schemas-microsoft-com:office:office"
                xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
                xmlns:rel="http://schemas.openxmlformats.org/package/2006/relationships"
                xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
                xmlns:v="urn:schemas-microsoft-com:vml"
                xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
                xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
                xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"
                xmlns:w10="urn:schemas-microsoft-com:office:word"
                xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                xmlns:tbx="http://www.lisa.org/TBX-Specification.33.0.html"
                version="2.0"
                exclude-result-prefixes="ve o r m v wp w10 w wne mml tbx pic rel a         tei teidocx xs iso">
    <!-- import base conversion style -->



  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
    <desc>
      <p>This software is dual-licensed:

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
</p>
      <p>Author: See AUTHORS for the basic scheme. This profile constructed by Lou Burnard</p>
      <p>Id: $Id$</p>
      <p>Copyright: 2013, TEI Consortium; 2014 Lou Burnard Consulting</p>
    </desc>
  </doc>

  <xsl:template match="tei:appInfo" mode="pass2"/>
  <xsl:template match="tei:encodingDesc" mode="pass2"/>
  <xsl:template match="tei:editionStmt" mode="pass2"/>

  <xsl:template match="tei:hi[@rend='Nom-manifestation']" mode="pass3">
    <name type="event">
      <xsl:apply-templates mode="pass3"/>
    </name>
  </xsl:template>

 <xsl:template match="tei:hi[@rend='Nom-oulipien']" mode="pass3">
   <persName >
	   <xsl:apply-templates mode="pass3"/>
   </persName>
 </xsl:template>

  <xsl:template match="tei:hi[@rend='Nom-personne-auteur']" mode="pass3">
    <persName role="auteur">
      <xsl:apply-templates mode="pass3"/>
    </persName>
  </xsl:template>
  
  <xsl:template match="tei:hi[@rend='Nom-personne-divers']" mode="pass3">
    <persName >
      <xsl:apply-templates mode="pass3"/>
    </persName>
  </xsl:template>
  
  
  <xsl:template match="tei:hi[@rend='Nom-personne-editeur']" mode="pass3">
    <orgName role="editeur">
      <xsl:apply-templates mode="pass3"/>
    </orgName>
  </xsl:template>
  
  <xsl:template match="tei:hi[@rend='notions']" mode="pass3">
    <term>
      <xsl:apply-templates mode="pass3"/>
    </term>
  </xsl:template>
  
  <xsl:template match="tei:p[@rend='listeDesPresents'][1]" mode="pass3">
    <list type="present">
      <head><xsl:value-of select="." /></head>
      <xsl:for-each select="following::tei:p[@rend='listeDesPresents']">
        <item> <xsl:apply-templates mode="pass3"/></item>
      </xsl:for-each>
    </list>
  </xsl:template>
 
  <xsl:template match="tei:p[@rend='listeDesPresents'][position() > 1]" mode="pass3"/>

  <xsl:template match="tei:hi[@rend='ref-document']" mode="pass3">
    <ref>
      <xsl:apply-templates mode="pass3"/>
    </ref>
  </xsl:template>
    
  <xsl:template match="tei:hi[@rend='reunion-date']" mode="pass3">
    <date type="réunion">
      <xsl:apply-templates mode="pass3"/>
    </date>
  </xsl:template>
  
  <xsl:template match="tei:hi[@rend='reunion-invité']" mode="pass3">
    <persName role="invité">
      <xsl:apply-templates mode="pass3"/>
    </persName>
  </xsl:template>
  
  <xsl:template match="tei:hi[@rend='reunion-invite']" mode="pass3">
    <persName role="invité">
      <xsl:apply-templates mode="pass3"/>
    </persName>
  </xsl:template>
  
  <xsl:template match="tei:hi[@rend='reunion-lieu']" mode="pass3">
    <placeName role="réunion">
      <xsl:apply-templates mode="pass3"/>
    </placeName>
  </xsl:template>
  
 <xsl:template match="tei:hi[@rend='reunion-presents']" mode="pass3">
   <persName role="présent">
     <xsl:apply-templates mode="pass3"/>
   </persName>
 </xsl:template>
  
  <xsl:template match="tei:hi[@rend='reunion-president']" mode="pass3">
    <persName role="président">
      <xsl:apply-templates mode="pass3"/>
    </persName>
  </xsl:template>
  
  <xsl:template match="tei:hi[@rend='reunion-secretaire']" mode="pass3">
    <persName role="secrétaire">
      <xsl:apply-templates mode="pass3"/>
    </persName>
  </xsl:template>
  
  <xsl:template match="tei:hi[@rend='titreOeuvre']" mode="pass3">
    <title>
      <xsl:apply-templates mode="pass3"/>
    </title>
  </xsl:template>
  
  <xsl:template match="tei:hi[@rend='titre-divers']" mode="pass3">
    <title type="divers">
      <xsl:apply-templates mode="pass3"/>
    </title>
  </xsl:template>
  
  <xsl:template match="tei:hi[@rend='unclear']" mode="pass3">
    <unclear>
      <xsl:apply-templates mode="pass3"/>
    </unclear>
  </xsl:template>
  
 <xsl:template match="tei:body" mode="pass3">
   <pb/>
   <xsl:for-each-group select="*" group-adjacent="if
						  (tei:is-front(.))  then 1
						  else  if (tei:is-back(.))   then 2
						  else 3">     
     <xsl:choose>
       <xsl:when test="current-grouping-key()=1">
	 <front>
	   <xsl:apply-templates select="current-group()" mode="pass3"/>
	 </front>
       </xsl:when>
       <xsl:when test="current-grouping-key()=2">
	 <back>
	   <xsl:apply-templates select="current-group()" mode="pass3"/>
	 </back>
       </xsl:when>
       <xsl:when test="current-grouping-key()=3">
	 <body>
	   <xsl:apply-templates select="current-group()" mode="pass3"/>
	 </body>
       </xsl:when>
     </xsl:choose>
   </xsl:for-each-group>
 </xsl:template>

 <!-- and copy everything else -->

 <xsl:template match="@*|comment()|processing-instruction()|text()" mode="pass3">
  <xsl:copy-of select="."/>
 </xsl:template>
 <xsl:template match="*" mode="pass3">
  <xsl:copy>
   <xsl:apply-templates select="*|@*|processing-instruction()|comment()|text()" mode="pass3"/>
  </xsl:copy>
 </xsl:template>

 <xsl:template match="tei:opener" mode="pass3">
   <p>
     <xsl:apply-templates select="*|@*|processing-instruction()|comment()|text()" mode="pass3"/>
   </p>
 </xsl:template>
 <xsl:template match="tei:closer" mode="pass3">
   <p>
     <xsl:apply-templates select="*|@*|processing-instruction()|comment()|text()" mode="pass3"/>
   </p>
 </xsl:template>

 <xsl:function name="tei:is-front"   as="xs:boolean">
    <xsl:param name="p"/>
      <xsl:choose>
	<xsl:when test="$p[@rend='Title']">true</xsl:when>
	<xsl:when test="$p[@rend='P4']">true</xsl:when>
	<xsl:when test="$p[@rend='Présents']">true</xsl:when>
	<xsl:when test="$p[@rend='Excusés']">true</xsl:when>
	<xsl:when test="$p[@rend='Président']">true</xsl:when>
	<xsl:when test="$p[@rend='Secrétaire']">true</xsl:when>
	<xsl:when test="$p[@rend='opener']">true</xsl:when>
	<xsl:when test="$p[self::tei:opener]">true</xsl:when>
	<xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
 </xsl:function>

 <xsl:function name="tei:is-back"   as="xs:boolean">
    <xsl:param name="p"/>
      <xsl:choose>
	<xsl:when test="$p[self::tei:closer]">true</xsl:when>
	<xsl:when test="$p[@rend='closer']">true</xsl:when>
	<xsl:when test="$p[self::tei:byline]">true</xsl:when>
	<xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
 </xsl:function>

 <xsl:template match="tei:revisionDesc/tei:change/tei:date" mode="pass3">
   <xsl:value-of select="tei:whatsTheDate()"/>
 </xsl:template>

 <xsl:template match="tei:persName[.=' ']">
   <xsl:value-of select="."/>
 </xsl:template>

</xsl:stylesheet>
  
