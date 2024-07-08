<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
		xmlns:rel="http://schemas.openxmlformats.org/package/2006/relationships"
                xmlns:cals="http://www.oasis-open.org/specs/tm9901"
                xmlns:contypes="http://schemas.openxmlformats.org/package/2006/content-types"
                xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dcmitype="http://purl.org/dc/dcmitype/"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns:iso="http://www.iso.org/ns/1.0"
                xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                xmlns:o="urn:schemas-microsoft-com:office:office"
                xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"
                xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
                xmlns:tbx="http://www.lisa.org/TBX-Specification.33.0.html"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:teidocx="http://www.tei-c.org/ns/teidocx/1.0"
                xmlns:teix="http://www.tei-c.org/ns/Examples"
                xmlns:v="urn:schemas-microsoft-com:vml"
                xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
                xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006"
                xmlns:w10="urn:schemas-microsoft-com:office:word"
                xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
                xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
                
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="3.0"
                exclude-result-prefixes="cp ve o r m v wp w10 w wne mml tbx iso   rel  tei a xs pic fn xsi dc dcterms dcmitype     contypes teidocx teix html cals">
    
    
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>
         <p> TEI stylesheet for making Word docx files from TEI XML </p>
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

    <xsl:template match="m:oMath">
        <xsl:apply-templates select="." mode="iden"/>
    </xsl:template>
    
    
    <xsl:template match="mml:math">
      <oMath xmlns="http://schemas.openxmlformats.org/officeDocument/2006/math">
	        <xsl:apply-templates mode="mml"/>
      </oMath>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process Word objects</desc>
   </doc>
   <xsl:template match="w:object">
     <xsl:variable name="renderingProperties">
       <xsl:for-each select="..">
	 <xsl:call-template name="applyRend"/>
       </xsl:for-each>
     </xsl:variable>
     <w:r>
       <xsl:if test="$renderingProperties/*">
	 <w:rPr>
	   <xsl:copy-of select="$renderingProperties"/>
	 </w:rPr>
       </xsl:if>
       <xsl:copy>
	 <xsl:apply-templates mode="iden"/>
       </xsl:copy>
     </w:r>
   </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Image data 
    </desc>
   </doc>
    <xsl:template match="v:imagedata" mode="iden">
        <xsl:variable name="current" select="@r:id"/>
	<xsl:copy>
	    <!-- override r:id -->
            <xsl:attribute name="r:id">
	      <xsl:variable name="me" select="generate-id()"/>
	      <xsl:for-each select="key('IMAGEDATA',1)">
		<xsl:if test="generate-id()=$me">
		  <xsl:value-of select="concat('rId', string(1000 + position()))"/>
		</xsl:if>
	      </xsl:for-each>
            </xsl:attribute>
	</xsl:copy>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>OLE objects</desc>
   </doc>
    <xsl:template match="o:OLEObject" mode="iden">
        <xsl:variable name="current" select="@r:id"/>
        <xsl:copy>
            <!-- copy all attributes -->
            <xsl:copy-of select="@*"/>
            <!-- set rId -->
            <xsl:attribute name="r:id">
	      <xsl:variable name="me" select="generate-id()"/>
	      <xsl:for-each select="key('OLEOBJECTS',1)">
		<xsl:if test="generate-id()=$me">
		  <xsl:value-of select="concat('rId', string(2000 + position()))"/>
		</xsl:if>
	      </xsl:for-each>
            </xsl:attribute>
	</xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
