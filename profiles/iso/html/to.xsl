<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
                xmlns:tbx="http://www.lisa.org/TBX-Specification.33.0.html"
		xmlns:iso="http://www.iso.org/ns/1.0"
		xmlns:its="http://www.w3.org/2005/11/its"
		xmlns:cals="http://www.oasis-open.org/specs/tm9901"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns:teix="http://www.tei-c.org/ns/Examples"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:t="http://www.thaiopensource.com/ns/annotations"
                xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                exclude-result-prefixes="tei html t its a rng iso tbx cals teix"
                version="2.0">
   <xsl:import href="../../../html/html.xsl"/>
   <xsl:import href="../../../html/html_oddprocessing.xsl"/>
   <xsl:import href="../../../odds/teiodds.xsl"/>
   <xsl:import href="../isoutils.xsl"/>
   <xsl:import href="../isotei-schema.xsl"/>
   <xsl:import href="web.xsl"/>
   <xsl:import href="tbx.xsl"/>
   <xsl:import href="cals.xsl"/>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>

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

    
   <xsl:strip-space elements="tei:bibl"/>
   <xsl:param name="numberFormat">uk</xsl:param>
   <xsl:output encoding="utf-8" omit-xml-declaration="yes" method="xhtml"
     normalization-form="NFC" html-version="5.0"
               indent="yes"/>

   <xsl:param name="STDOUT">true</xsl:param>
   <xsl:param name="xhtml">true</xsl:param>
   <xsl:param name="splitLevel">-1</xsl:param>
   <xsl:param name="autoToc">true</xsl:param>
   <xsl:param name="tocDepth">3</xsl:param>
   <xsl:param name="institution"></xsl:param>
   <xsl:param name="department"/>
   <xsl:param name="cssFile">iso.css</xsl:param>
   <xsl:param name="cssSecondaryFile">http://tei.oucs.ox.ac.uk/TEIISO/iso-odd.css</xsl:param>
   <xsl:param name="cssPrintFile">http://tei.oucs.ox.ac.uk/TEIISO/iso-print.css</xsl:param>
   <xsl:param name="TEIC">false</xsl:param>
   <xsl:param name="wrapLength">65</xsl:param>
   <xsl:param name="attLength">60</xsl:param>
   <xsl:param name="forceWrap">true</xsl:param>
   <xsl:param name="numberBackHeadings">A.1</xsl:param>
   <xsl:template match="/">
     <xsl:variable name="All">
       <xsl:apply-templates mode="checkSchematron"/>
     </xsl:variable>
     <xsl:for-each select="$All">
      <xsl:call-template name="processTEI"/>
     </xsl:for-each>
   </xsl:template>

</xsl:stylesheet>
