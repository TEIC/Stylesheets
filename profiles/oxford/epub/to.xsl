<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:tbx="http://www.lisa.org/TBX-Specification.33.0.html"
  xmlns:iso="http://www.iso.org/ns/1.0"
  xmlns:cals="http://www.oasis-open.org/specs/tm9901"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:teix="http://www.tei-c.org/ns/Examples"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:t="http://www.thaiopensource.com/ns/annotations"
  xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
  xmlns:rng="http://relaxng.org/ns/structure/1.0"
  exclude-result-prefixes="tei html t a rng iso tbx
  cals xlink teix"
  version="3.0">
    <xsl:import href="../../../epub/tei-to-epub.xsl"/>

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

    <xsl:param name="numberHeadings">false</xsl:param>
    <xsl:param name="numberHeadingsDepth">-1</xsl:param>
    <xsl:param name="numberBackHeadings"></xsl:param>
    <xsl:param name="numberFrontHeadings"></xsl:param>
    <xsl:param name="numberFigures">false</xsl:param>
    <xsl:param name="numberTables">false</xsl:param>
    <xsl:param name="autoToc">true</xsl:param>

   <xsl:param name="cssFile">../profiles/oxford/epub/oxford.css</xsl:param>
    
    <xsl:template match="tei:w[@type and @lemma]">
      <span class="wordtype{@type}">
	<xsl:apply-templates/>
      </span>
    </xsl:template>

</xsl:stylesheet>
