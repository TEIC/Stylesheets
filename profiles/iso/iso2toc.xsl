<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="tei"
                version="2.0">
   <xsl:import href="isoutils.xsl"/>
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

   <xsl:output method="xhtml" html-version="5.0" encoding="UTF-8" indent="yes" normalization-form="NFC"
      omit-xml-declaration="yes"/>
   <xsl:template match="tei:TEI">
      <xsl:variable name="today">
         <xsl:call-template name="whatsTheDate"/>
      </xsl:variable>
      <xsl:variable name="isotitle">
         <xsl:sequence select="tei:generateTitle(.)"/>
      </xsl:variable>
      <xsl:variable name="isonumber">
         <xsl:call-template name="getiso_documentNumber"/>
      </xsl:variable>
      <xsl:variable name="isopart">
         <xsl:call-template name="getiso_partNumber"/>
      </xsl:variable>
      <xsl:variable name="isoyear">
         <xsl:call-template name="getiso_year"/>
      </xsl:variable>
      <html>
         <head>
            <title>Report on 
	    <xsl:value-of select="$isotitle"/>:
	    <xsl:value-of select="$isoyear"/>:
	    <xsl:value-of select="$isonumber"/>:
	    <xsl:value-of select="$isopart"/>
            </title>
            <link href="iso.css" rel="stylesheet" type="text/css"/>

         </head>
         <body>
            <h1 class="maintitle">	      
	      <xsl:value-of select="$isotitle"/>:
	      <xsl:value-of select="$isoyear"/>:
	      <xsl:value-of select="$isonumber"/>:
	      <xsl:value-of select="$isopart"/>
            </h1>

            <xsl:for-each select="tei:text/tei:front">
               <ul>
                  <xsl:for-each select="tei:div">
	                    <li>
	                       <xsl:call-template name="head"/>
	                    </li>
                  </xsl:for-each>
               </ul>
               <hr/>
            </xsl:for-each>
            <xsl:for-each select="tei:text/tei:body">
               <ul>
                  <xsl:for-each select="tei:div[tei:head]">
      	              <li>
      	                 <xsl:call-template name="head"/>
      	              </li>
                  </xsl:for-each>
               </ul>
               <hr/>
            </xsl:for-each>
            <xsl:for-each select="tei:text/tei:back">
               <ul>
                  <xsl:for-each select="tei:div[tei:head]">
                     <li>
                        <xsl:call-template name="head"/>
                     </li>
                  </xsl:for-each>
               </ul>
               <hr/>
            </xsl:for-each>
         </body>
      </html>
   </xsl:template>

   <xsl:template name="head">
	     <xsl:choose>
	        <xsl:when test="@type='other'">
	           <xsl:value-of select="tei:head"/>
	        </xsl:when>
	        <xsl:otherwise>
	           <span style="color:red">
	              <xsl:value-of select="tei:head"/>
	           </span>
	        </xsl:otherwise>
	     </xsl:choose>
   </xsl:template>

 <xsl:template name="block-element">
     <xsl:param name="select"/>
     <xsl:param name="style"/>
     <xsl:param name="pPr" as="node()*"/>
     <xsl:param name="nop"/>
     <xsl:param name="bookmark-name"/>
     <xsl:param name="bookmark-id"/>
   </xsl:template>

   <xsl:template name="termNum"/>

</xsl:stylesheet>
