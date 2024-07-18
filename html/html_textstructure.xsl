<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xlink="http://www.w3.org/1999/xlink"
   xmlns:teidocx="http://www.tei-c.org/ns/teidocx/1.0" xmlns:its="http://www.w3.org/2005/11/its"
   xmlns:html="http://www.w3.org/1999/xhtml" xmlns:dbk="http://docbook.org/ns/docbook"
   xmlns:rng="http://relaxng.org/ns/structure/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:teix="http://www.tei-c.org/ns/Examples"
   xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
   xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   exclude-result-prefixes="a fo dbk xlink rng tei html
					 teix its teidocx" version="3.0">
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>
         <p> TEI stylesheet dealing with elements from the textstructure module, making HTML output. </p>
         <p>This software is dual-licensed: 1. Distributed under a Creative Commons
            Attribution-ShareAlike 3.0 Unported License
            http://creativecommons.org/licenses/by-sa/3.0/ 2.
            http://www.opensource.org/licenses/BSD-2-Clause Redistribution and use in source and
            binary forms, with or without modification, are permitted provided that the following
            conditions are met: * Redistributions of source code must retain the above copyright
            notice, this list of conditions and the following disclaimer. * Redistributions in
            binary form must reproduce the above copyright notice, this list of conditions and the
            following disclaimer in the documentation and/or other materials provided with the
            distribution. This software is provided by the copyright holders and contributors "as
            is" and any express or implied warranties, including, but not limited to, the implied
            warranties of merchantability and fitness for a particular purpose are disclaimed. In no
            event shall the copyright holder or contributors be liable for any direct, indirect,
            incidental, special, exemplary, or consequential damages (including, but not limited to,
            procurement of substitute goods or services; loss of use, data, or profits; or business
            interruption) however caused and on any theory of liability, whether in contract, strict
            liability, or tort (including negligence or otherwise) arising in any way out of the use
            of this software, even if advised of the possibility of such damage. </p>
         <p>Author: See AUTHORS</p>

         <p>Copyright: 2013, TEI Consortium</p>
      </desc>
   </doc>

   <xsl:variable name="top" select="/"/>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process elements * in inner mode</desc>
   </doc>
   <xsl:template match="*" mode="innertext">
      <xsl:apply-templates select="."/>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process elements * in paging mode</desc>
   </doc>
   <xsl:template match="*" mode="paging">
      <xsl:choose>
         <xsl:when test="self::tei:divGen[@type = 'summary']">
            <xsl:call-template name="summaryToc"/>
         </xsl:when>
         <xsl:when test="self::tei:divGen">
            <xsl:apply-templates select="."/>
         </xsl:when>
         <xsl:when test="starts-with(local-name(), 'div')">
            <xsl:if test="not(preceding-sibling::tei:*) or preceding-sibling::tei:titlePage">
               <xsl:call-template name="makeDivBody">
                  <xsl:with-param name="depth">2</xsl:with-param>
                  <xsl:with-param name="nav">true</xsl:with-param>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
         <xsl:when test="local-name(..) = 'front'">
            <xsl:apply-templates select="."/>
            <xsl:apply-templates mode="paging" select="following-sibling::*[1]"/>
            <xsl:apply-templates mode="paging" select="../../tei:body/*[1]"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="."/>
            <xsl:apply-templates mode="paging" select="following-sibling::*[1]"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>Process root /</p>
         <p xmlns="http://www.w3.org/1999/xhtml"> processors must support `key' </p>
      </desc>
   </doc>
   <xsl:template match="/">
      <xsl:call-template name="processTEI"/>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>Process top-level elements /</p>
      </desc>
   </doc>
   <xsl:template name="processTEI">
      <xsl:choose>
         <!-- there are various choices of how to proceed, driven by
        
        $pageLayout: Simple, Complex
        
        $STDOUT: true or false
        
        $splitLevel: -1 to 3
        
        $requestedID: requests a particular page
      -->
         <!-- we are making a composite layout and there is a TEI or teiCorpus element -->
         <xsl:when
            test="
               ($pageLayout = 'Complex') and (tei:TEI or
               tei:teiCorpus or tei:text)">
            <xsl:if test="$verbose = 'true'">
               <xsl:message>case 1: pageLayout <xsl:value-of select="$pageLayout"/>
               </xsl:message>
            </xsl:if>
            <xsl:for-each select="tei:TEI | tei:teiCorpus | tei:text">
               <xsl:call-template name="doPage">
                  <xsl:with-param name="currentID" select="$requestedID"/>
               </xsl:call-template>
            </xsl:for-each>
            <xsl:if test="$STDOUT = 'false'">
               <xsl:call-template name="doDivs"/>
            </xsl:if>
         </xsl:when>
         <!-- we have been asked for a particular section of the document -->
         <xsl:when test="not($requestedID = '')">
            <xsl:if test="$verbose = 'true'">
               <xsl:message>case 3: ID <xsl:value-of select="$requestedID"/>, pageLayout
                     <xsl:value-of select="$pageLayout"/>
               </xsl:message>
            </xsl:if>
            <xsl:choose>
               <xsl:when test="$requestedID = 'prelim___'">
                  <xsl:apply-templates/>
               </xsl:when>
               <xsl:when test="count(id($requestedID)) &gt; 0">
                  <xsl:for-each select="id($requestedID)">
                     <xsl:call-template name="writeDiv"/>
                  </xsl:for-each>
               </xsl:when>
               <xsl:otherwise>
                  <!-- the passed ID is a pseudo-XPath expression
              which starts below TEI/text.
              The real XPath syntax is changed to avoid problems
            -->
                  <xsl:apply-templates mode="xpath" select="tei:TEI/tei:text">
                     <xsl:with-param name="xpath" select="$requestedID"/>
                  </xsl:apply-templates>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <!-- we want HTML to just splurge out-->
         <xsl:when test="$STDOUT = 'true'">
            <xsl:if test="$verbose = 'true'">
               <xsl:message>case 4: write to stdout, pageLayout <xsl:value-of select="$pageLayout"/>
               </xsl:message>
            </xsl:if>
            <xsl:apply-templates/>
         </xsl:when>
         <!-- we want the document split up into separate files -->
         <xsl:when test="tei:TEI or tei:teiCorpus and number($splitLevel) &gt; -1">
            <xsl:if test="$verbose = 'true'">
               <xsl:message>case 5: split output, <xsl:value-of select="$splitLevel"/> pageLayout
                     <xsl:value-of select="$pageLayout"/>
               </xsl:message>
            </xsl:if>
            <xsl:apply-templates mode="split"/>
         </xsl:when>
         <!-- we want the whole document, in an output file -->
         <xsl:otherwise>
            <xsl:if test="$verbose = 'true'">
               <xsl:message>case 6: one document, pageLayout <xsl:value-of select="$pageLayout"/>
               </xsl:message>
            </xsl:if>
            <xsl:choose>
               <xsl:when test="$masterFile = '' or $STDOUT = 'true'">
                  <xsl:apply-templates/>
               </xsl:when>
               <xsl:otherwise>

                  <xsl:variable name="outName">
                     <xsl:call-template name="outputChunkName">
                        <xsl:with-param name="ident">
                           <xsl:value-of select="$masterFile"/>
                        </xsl:with-param>
                     </xsl:call-template>
                  </xsl:variable>

                  <xsl:if test="$verbose = 'true'">
                     <xsl:message>Opening file (process TEI)<xsl:value-of select="$outName"/>
                     </xsl:message>
                  </xsl:if>
                  <xsl:result-document html-version="{$htmlVersion}" normalization-form="{$normalizationForm}"
                     encoding="{$outputEncoding}" href="{$outName}" method="{$outputMethod}" omit-xml-declaration="{$omitXMLDeclaration}">
                     <xsl:apply-templates/>
                  </xsl:result-document>

                  <xsl:if test="$verbose = 'true'">
                     <xsl:message>Closing file <xsl:value-of select="$outName"/>
                     </xsl:message>
                  </xsl:if>

               </xsl:otherwise>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process elements processing-instruction()[name()='xmltex']</desc>
   </doc>
   <xsl:template match="processing-instruction()[name() = 'xmltex']">
      <xsl:value-of select="."/>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process element *</desc>
   </doc>
   <xsl:template match="tei:*" mode="generateNextLink">
      <span class="nextLink">
         <xsl:text> </xsl:text>
         <xsl:sequence select="tei:i18n('nextWord')"/>
         <xsl:call-template name="navInterSep"/>
      </span>
      <a class="navigation">
         <xsl:attribute name="href">
            <xsl:apply-templates mode="generateLink" select="."/>
         </xsl:attribute>
         <xsl:call-template name="headerLink">
            <xsl:with-param name="minimal" select="$minimalCrossRef"/>
         </xsl:call-template>
      </a>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process elements looking for something to link to backwards</desc>
   </doc>
   <xsl:template match="tei:*" mode="generatePreviousLink">
      <span class="previousLink">
         <xsl:text> </xsl:text>
         <xsl:sequence select="tei:i18n('previousWord')"/>
         <xsl:call-template name="navInterSep"/>
      </span>
      <a class="navigation">
         <xsl:attribute name="href">
            <xsl:apply-templates mode="generateLink" select="."/>
         </xsl:attribute>
         <xsl:call-template name="headerLink">
            <xsl:with-param name="minimal" select="$minimalCrossRef"/>
         </xsl:call-template>
      </a>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>Process any element in xpath mode</p>
         <p>
            <p xmlns="http://www.w3.org/1999/xhtml"> This nice bit of code is from Jeni Tennison
            </p>
         </p>
         <param name="xpath">xpath</param>
         <param name="action">action</param>
      </desc>
   </doc>
   <xsl:template match="tei:*" mode="xpath">
      <xsl:param name="xpath"/>
      <xsl:param name="action"/>
      <xsl:choose>
         <!-- if there is a path -->
         <xsl:when test="$xpath">
            <!-- step is the part before the '_' (if there is one) -->
            <xsl:variable name="step">
               <xsl:choose>
                  <xsl:when test="contains($xpath, '_')">
                     <xsl:value-of select="substring-before($xpath, '_')"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="$xpath"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <!-- the child's name is the part before the '.' -->
            <xsl:variable name="childName" select="substring-before($step, '.')"/>
            <!-- and its index is the part after '.' -->
            <xsl:variable name="childIndex" select="substring-after($step, '.')"/>
            <!-- so apply templates to that child, passing in the $xpath
	     left after the first step -->
            <xsl:apply-templates mode="xpath" select="*[name() = $childName][number($childIndex)]">
               <xsl:with-param name="xpath" select="substring-after($xpath, '_')"/>
               <xsl:with-param name="action" select="$action"/>
            </xsl:apply-templates>
         </xsl:when>
         <!-- if there's no path left, then this is the element we want -->
         <xsl:otherwise>
            <xsl:choose>
               <xsl:when test="$action = 'header'">
                  <xsl:apply-templates mode="xref" select="."/>
               </xsl:when>
               <xsl:when test="$action = 'notes'">
                  <xsl:call-template name="printNotes"/>
               </xsl:when>
               <xsl:when test="$action = 'toclist'">
                  <xsl:call-template name="linkListContents">
                     <xsl:with-param name="style" select="'toclist'"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:when test="starts-with(local-name(), 'div') or $pageLayout = 'Complex'">
                  <xsl:call-template name="makeDivBody">
                     <xsl:with-param name="depth">2</xsl:with-param>
                     <xsl:with-param name="nav">true</xsl:with-param>
                  </xsl:call-template>
               </xsl:when>
               <xsl:when test="self::tei:divGen[@type = 'summary']">
                  <xsl:call-template name="summaryToc"/>
               </xsl:when>
               <xsl:otherwise>
                  <html>
                     <xsl:call-template name="addLangAtt"/>
                     <xsl:variable name="pagetitle">
                        <xsl:sequence select="tei:generateTitle(.)"/>
                     </xsl:variable>
                     <xsl:sequence select="tei:htmlHead($pagetitle, 6)"/>
                     <body id="TOP">
                        <xsl:call-template name="bodyMicroData"/>
                        <xsl:call-template name="bodyJavascriptHook"/>
                        <xsl:call-template name="bodyHook"/>
                        <div class="stdheader autogenerated">
                           <xsl:call-template name="stdheader">
                              <xsl:with-param name="title">
                                 <xsl:sequence select="tei:generateTitle(.)"/>
                              </xsl:with-param>
                           </xsl:call-template>
                        </div>
                        <h2>
                           <xsl:apply-templates mode="xref" select="."/>
                           <xsl:call-template name="sectionHeadHook"/>
                        </h2>
                        <xsl:apply-templates/>
                        <xsl:call-template name="printNotes"/>
                        <xsl:call-template name="htmlFileBottom"/>
                        <xsl:call-template name="bodyEndHook"/>
                     </body>
                  </html>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>Process root element TEI</p>
      </desc>
   </doc>
   <xsl:template match="tei:TEI">
      <xsl:call-template name="teiStartHook"/>
      <xsl:if test="$verbose = 'true'">
         <xsl:message>TEI HTML creation in single document mode </xsl:message>
      </xsl:if>
      <html>
         <xsl:call-template name="addLangAtt"/>
         <xsl:variable name="pagetitle">
            <xsl:sequence select="tei:generateTitle(.)"/>
         </xsl:variable>
         <xsl:sequence select="tei:htmlHead($pagetitle, 5)"/>
         <body class="simple" id="TOP">
            <xsl:call-template name="bodyMicroData"/>
            <xsl:call-template name="bodyJavascriptHook"/>
            <xsl:call-template name="bodyHook"/>
            <xsl:if test="not(tei:text/tei:front/tei:titlePage)">
               <div class="stdheader autogenerated">
                  <xsl:call-template name="stdheader">
                     <xsl:with-param name="title">
                        <xsl:sequence select="tei:generateTitle(.)"/>
                     </xsl:with-param>
                  </xsl:call-template>
               </div>
            </xsl:if>
            <xsl:call-template name="startHook"/>
            <xsl:call-template name="simpleBody"/>
            <xsl:call-template name="stdfooter"/>
            <xsl:call-template name="bodyEndHook"/>
         </body>
      </html>
      <xsl:if test="$verbose = 'true'">
         <xsl:message>TEI HTML: run end hook template teiEndHook</xsl:message>
      </xsl:if>
      <xsl:call-template name="teiEndHook"/>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>Process root element TEI when inside a corpus</p>
      </desc>
   </doc>
   <xsl:template match="tei:teiCorpus/tei:TEI">
      <xsl:if test="$verbose = 'true'">
         <xsl:message>TEI HTML inside corpus </xsl:message>
      </xsl:if>
      <xsl:if test="not(tei:text/tei:front/tei:titlePage)">
         <div class="stdheader autogenerated">
            <xsl:call-template name="stdheader">
               <xsl:with-param name="title">
                  <xsl:sequence select="tei:generateTitle(.)"/>
               </xsl:with-param>
            </xsl:call-template>
         </div>
      </xsl:if>
      <xsl:call-template name="simpleBody"/>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>Process root element TEI in splitting mode</p>
      </desc>
   </doc>
   <xsl:template match="tei:TEI" mode="split">
      <xsl:variable name="BaseFile">
         <xsl:value-of select="$masterFile"/>
         <xsl:call-template name="addCorpusID"/>
      </xsl:variable>
      <xsl:if test="$verbose = 'true'">
         <xsl:message>TEI HTML: run start hook template teiStartHook</xsl:message>
      </xsl:if>
      <xsl:call-template name="teiStartHook"/>
      <xsl:if test="$verbose = 'true'">
         <xsl:message>TEI HTML in splitting mode, base file is <xsl:value-of select="$BaseFile"/>
         </xsl:message>
      </xsl:if>

      <xsl:variable name="outName">
         <xsl:call-template name="outputChunkName">
            <xsl:with-param name="ident">
               <xsl:choose>
                  <xsl:when test="parent::tei:teiCorpus">
                     <xsl:apply-templates select="." mode="ident"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="$BaseFile"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:variable>

      <xsl:if test="$verbose = 'true'">
         <xsl:message>Opening file (split TEI)<xsl:value-of select="$outName"/>
         </xsl:message>
      </xsl:if>
      <xsl:result-document html-version="{$htmlVersion}" normalization-form="{$normalizationForm}"
         encoding="{$outputEncoding}" href="{$outName}" method="{$outputMethod}" omit-xml-declaration="{$omitXMLDeclaration}">
     
         <xsl:call-template name="pageLayoutSimple"/>
      </xsl:result-document>

      <xsl:if test="$verbose = 'true'">
         <xsl:message>Closing file <xsl:value-of select="$outName"/>
         </xsl:message>
      </xsl:if>

      <xsl:if test="$verbose = 'true'">
         <xsl:message>TEI HTML: run end hook template teiEndHook</xsl:message>
      </xsl:if>
      <xsl:call-template name="teiEndHook"/>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process element body in inner mode</desc>
   </doc>
   <xsl:template match="tei:body" mode="inner">
      <xsl:apply-templates/>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process element closer</desc>
   </doc>
   <xsl:template match="tei:closer">
      <xsl:choose>
         <xsl:when test="not(node())"/>
         <xsl:when test="tei:signed">
            <div class="closer">
               <xsl:apply-templates/>
            </div>
         </xsl:when>
         <xsl:when test="tei:postscript">
            <div class="closer">
               <xsl:apply-templates/>
            </div>
         </xsl:when>
         <xsl:when test="tei:p">
            <blockquote class="closer">
               <xsl:apply-templates/>
            </blockquote>
         </xsl:when>
         <xsl:otherwise>
            <blockquote class="closer">
               <xsl:call-template name="splitHTMLBlocks">
                  <xsl:with-param name="element">p</xsl:with-param>
                  <xsl:with-param name="content">
                     <xsl:apply-templates/>
                  </xsl:with-param>
               </xsl:call-template>
            </blockquote>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process element dateline</desc>
   </doc>
   <xsl:template match="tei:dateline">
      <div class="dateline">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process element divGen[@type='actions']</desc>
   </doc>
   <xsl:template match="tei:divGen[@type = 'actions']">
      <h3>Actions arising</h3>
      <dl>
         <xsl:for-each select="/tei:TEI/tei:text//tei:note[@type = 'action']">
            <dt>
               <b>
                  <xsl:number count="tei:note[@type = 'action']" level="any"/>
               </b>
            </dt>
            <dd>
               <xsl:apply-templates/>
            </dd>
         </xsl:for-each>
      </dl>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>Process element divGen[@type='toc']</p>
         <p>
            <p xmlns="http://www.w3.org/1999/xhtml"> table of contents </p>
         </p>
      </desc>
   </doc>
   <xsl:template match="tei:divGen[@type = 'toc']">
      <div class="tei_toc">
         <h2>
            <xsl:sequence select="tei:i18n('tocWords')"/>
         </h2>
         <xsl:call-template name="mainTOC"/>
      </div>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>index element, by default does nothing, unless it has an xml:id</p>
      </desc>
   </doc>
   <xsl:template match="tei:index">
      <xsl:if test="@xml:id">
         <span>
            <xsl:attribute name="id" select="@xml:id"/>
            <span style="display:none">
               <xsl:value-of select="normalize-space(tei:term)"/>
            </span>
         </span>
      </xsl:if>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>Simplistic processing of element divGen[@type='index']</p>
         <p>
            <p xmlns="http://www.w3.org/1999/xhtml">make an index; does not take indexName or nested
               index into account </p>
         </p>
      </desc>
   </doc>
   <xsl:template match="tei:divGen[@type = 'index']">
      <div class="tei_index">
         <h2>Index</h2>
         <xsl:variable name="index">
            <xsl:for-each select="key('INDEX', 1)">
               <tei:REF>
                  <tei:SORT>
                     <xsl:value-of select="lower-case(normalize-unicode(tei:term, 'NFD'))"/>
                  </tei:SORT>
                  <tei:TERM>
                     <xsl:value-of select="tei:term"/>
                  </tei:TERM>
                  <xsl:for-each select="ancestor-or-self::*[tei:isIdentifiable(.)][1]">
                     <tei:LINK>
                        <xsl:apply-templates mode="generateLink" select="."/>
                     </tei:LINK>
                     <tei:TARGET>
                        <xsl:call-template name="header"/>
                     </tei:TARGET>
                  </xsl:for-each>
               </tei:REF>
            </xsl:for-each>
         </xsl:variable>
         <dl>
            <xsl:for-each-group select="$index/tei:REF" group-by="tei:TERM">
               <xsl:sort select="tei:SORT" lang="{$doclang}"/>
               <dt>
                  <xsl:value-of select="current-grouping-key()"/>
               </dt>
               <dd>
                  <xsl:for-each-group select="current-group()" group-by="tei:LINK">
                     <xsl:for-each select="current-group()[1]">
                        <a href="{tei:LINK}">
                           <xsl:value-of select="tei:TARGET"/>
                        </a>
                     </xsl:for-each>
                     <xsl:value-of select="$spaceCharacter"/>
                  </xsl:for-each-group>
               </dd>
            </xsl:for-each-group>
         </dl>
      </div>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process elements tei:div|tei:div1|tei:div2|tei:div3|tei:div4|tei:div5|tei:div6</desc>
   </doc>
   <xsl:template match="tei:div | tei:div1 | tei:div2 | tei:div3 | tei:div4 | tei:div5 | tei:div6">
      <xsl:variable name="depth">
         <xsl:apply-templates mode="depth" select="."/>
      </xsl:variable>
      <!-- depending on depth and splitting level, 
	 we may do one of two things: -->
      <xsl:choose>
         <xsl:when
            test="
               tei:keepDivOnPage(.) or
               number($depth) &gt; number($splitLevel)">
            <xsl:call-template name="makeDivBody">
               <xsl:with-param name="depth" select="$depth"/>
            </xsl:call-template>
         </xsl:when>
         <!-- 1. We have gone far enough -->
         <xsl:when test="$depth = $splitLevel and $STDOUT = 'true'"/>
         <!-- 2. we are at or above splitting level, 
	   so start a new page  -->
         <xsl:when
            test="number($depth) &lt;= number($splitLevel) and ancestor::tei:front and $splitFrontmatter = 'true'">
            <xsl:call-template name="makeDivPage">
               <xsl:with-param name="depth" select="$depth"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:when
            test="number($depth) &lt;= number($splitLevel) and ancestor::tei:back and $splitBackmatter = 'true'">
            <xsl:call-template name="makeDivPage">
               <xsl:with-param name="depth" select="$depth"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:when
            test="
               number($depth) &lt;= number($splitLevel) and
               ancestor::tei:body">
            <xsl:call-template name="makeDivPage">
               <xsl:with-param name="depth" select="$depth"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="makeDivBody">
               <xsl:with-param name="depth" select="$depth"/>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Create a new output page for a section <param name="depth">depth of section (1, 2 3, 4
            etc)</param>
      </desc>
   </doc>
   <xsl:template name="makeDivPage">
      <xsl:param name="depth"/>
      <xsl:variable name="outName">
         <xsl:call-template name="outputChunkName">
            <xsl:with-param name="ident">
               <xsl:apply-templates mode="ident" select="."/>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:variable>

      <xsl:if test="$verbose = 'true'">
         <xsl:message>Opening file (makeDivPage)<xsl:value-of select="$outName"/>
         </xsl:message>
      </xsl:if>
      <xsl:result-document html-version="{$htmlVersion}" normalization-form="{$normalizationForm}"
         encoding="{$outputEncoding}" href="{$outName}" method="{$outputMethod}" omit-xml-declaration="{$omitXMLDeclaration}">
         <xsl:choose>
            <xsl:when test="$pageLayout = 'Complex'">
               <xsl:call-template name="pageLayoutComplex">
                  <xsl:with-param name="currentID">
                     <xsl:apply-templates mode="ident" select="."/>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <xsl:call-template name="writeDiv"/>
            </xsl:otherwise>
         </xsl:choose>

      </xsl:result-document>

      <xsl:if test="$verbose = 'true'">
         <xsl:message>Closing file <xsl:value-of select="$outName"/>
         </xsl:message>
      </xsl:if>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process element opener</desc>
   </doc>

   <xsl:template match="tei:opener">
      <div class="opener">
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process element text</desc>
   </doc>
   <xsl:template match="tei:text">
      <xsl:choose>
         <xsl:when test="parent::tei:TEI">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:when test="ancestor::tei:group and $splitLevel = 0">
            <xsl:call-template name="makeDivPage">
               <xsl:with-param name="depth">-1</xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="ancestor::tei:group">
            <xsl:call-template name="makeDivBody">
               <xsl:with-param name="depth">-1</xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="wrapRootText"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process element titlePage</desc>
   </doc>
   <xsl:template match="tei:titlePage">
      <div class="titlePage">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] <param name="crumbBody">crumbBody</param>
      </desc>
   </doc>
   <xsl:template name="aCrumb">
      <xsl:param name="crumbBody"/>
      <li class="breadcrumb">
         <xsl:copy-of select="$crumbBody"/>
      </li>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] corpus identifier</desc>
   </doc>
   <xsl:template name="addCorpusID">
      <xsl:if test="ancestor-or-self::tei:teiCorpus">
         <xsl:for-each select="ancestor-or-self::tei:TEI">
            <xsl:text>-</xsl:text>
            <xsl:choose>
               <xsl:when test="@xml:id">
                  <xsl:value-of select="@xml:id"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:number/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
      </xsl:if>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] </desc>
   </doc>
   <xsl:template name="addLangAtt">
      <xsl:variable name="documentationLanguage">
         <xsl:choose>
            <xsl:when test="string-length($doclang) &gt; 0">
               <xsl:value-of select="$doclang"/>
            </xsl:when>
            <xsl:when test="ancestor-or-self::tei:schemaSpec/@docLang">
               <xsl:value-of select="//tei:schemaSpec[1]/@docLang"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>en</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="supplied">
         <xsl:choose>
            <xsl:when test="ancestor-or-self::tei:*[@xml:lang]">
               <xsl:value-of select="ancestor-or-self::tei:*[@xml:lang][1]/@xml:lang"/>
            </xsl:when>
            <xsl:when test="ancestor-or-self::tei:*[@lang]">
               <xsl:value-of select="ancestor-or-self::tei:*[@lang][1]/@lang"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$documentationLanguage"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:choose>
<!--         When output format is XHTML, both @xml:lang and @lang attributes are created.
         For other outputs, just @lang-->
         <xsl:when test="$outputTarget = ('html', 'html5')">
            <xsl:attribute name="xml:lang">
               <xsl:value-of select="$supplied"/>
            </xsl:attribute>
            <xsl:attribute name="lang">
               <xsl:value-of select="$supplied"/>
            </xsl:attribute>
         </xsl:when>
         <xsl:otherwise>
            <xsl:attribute name="lang">
               <xsl:value-of select="$supplied"/>
            </xsl:attribute>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>[html] </p>
         <p>where to start the path from</p>
         <param name="crumbRoot">/</param>
      </desc>
   </doc>
   <xsl:template name="crumbPath">
      <xsl:param name="crumbRoot">/</xsl:param>
      <xsl:param name="currentID"/>
      <div class="breadcrumb">
         <xsl:call-template name="preBreadCrumbPath"/>
         <ul class="breadcrumb">
            <li class="breadcrumb-first">
               <a class="breadcrumb" href="{$homeURL}">
                  <xsl:value-of select="$homeLabel"/>
               </a>
            </li>
            <xsl:call-template name="walkTree">
               <xsl:with-param name="path">
                  <xsl:value-of select="substring-after($REQUEST, $crumbRoot)"/>
               </xsl:with-param>
               <xsl:with-param name="currentID">
                  <xsl:value-of select="$currentID"/>
               </xsl:with-param>
               <xsl:with-param name="whole">
                  <xsl:value-of select="$crumbRoot"/>
               </xsl:with-param>
               <xsl:with-param name="class">breadcrumb</xsl:with-param>
            </xsl:call-template>
         </ul>
      </div>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] Make a section heading <param name="depth">which head level to make</param>
      </desc>
   </doc>
   <xsl:template name="makeDivBody">
      <xsl:param name="depth"/>
      <xsl:param name="nav">false</xsl:param>
      <xsl:choose>
         <xsl:when test="$filePerPage = 'true'">
            <xsl:call-template name="startDivHook"/>
            <xsl:call-template name="divContents">
               <xsl:with-param name="depth" select="$depth"/>
               <xsl:with-param name="nav" select="$nav"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:element
               name="{if ($outputTarget=('html5', 'html') and number($depth)
			     &lt; 1) then 'section' else 'div'}">
               <xsl:call-template name="microdata"/>
               <xsl:call-template name="divClassAttribute">
                  <xsl:with-param name="depth" select="$depth"/>
               </xsl:call-template>
               <xsl:call-template name="startDivHook"/>
               <xsl:call-template name="divContents">
                  <xsl:with-param name="depth" select="$depth"/>
                  <xsl:with-param name="nav" select="$nav"/>
               </xsl:call-template>
            </xsl:element>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] doing the contents of a div</desc>
   </doc>

   <xsl:template name="divContents">
      <xsl:param name="depth"/>
      <xsl:param name="nav">false</xsl:param>
      <xsl:variable name="ident">
         <xsl:apply-templates mode="ident" select="."/>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="parent::tei:*/tei:match(@rend, 'multicol')">
            <td style="vertical-align:top;">
               <xsl:if test="not($depth = '')">
                  <xsl:element name="h{$depth + $divOffset}">
                     <xsl:for-each select="tei:head[1]">
                        <xsl:call-template name="makeRendition">
                           <xsl:with-param name="default">false</xsl:with-param>
                        </xsl:call-template>
                     </xsl:for-each>
                     <xsl:if test="@xml:id">
                        <xsl:call-template name="makeAnchor"/>
                     </xsl:if>
                     <xsl:call-template name="header">
                        <xsl:with-param name="display">full</xsl:with-param>
                     </xsl:call-template>
                     <xsl:call-template name="sectionHeadHook"/>
                  </xsl:element>
               </xsl:if>
               <xsl:apply-templates/>
            </td>
         </xsl:when>
         <xsl:when test="tei:match(@rend, 'multicol')">
            <xsl:apply-templates select="*[not(local-name(.) = 'div')]"/>
            <table>
               <tr>
                  <xsl:apply-templates select="tei:div"/>
               </tr>
            </table>
         </xsl:when>
         <xsl:when test="tei:match(@rend, 'nohead')">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:when test="not(tei:head)">
            <xsl:call-template name="splitHTMLBlocks">
               <xsl:with-param name="element"
                  select="
                     if (number($depth) + $divOffset &gt; 6) then
                        'div'
                     else
                        concat('h', number($depth) + $divOffset)"/>
               <xsl:with-param name="content">
                  <xsl:call-template name="sectionHeadHook"/>
                  <xsl:call-template name="header">
                     <xsl:with-param name="display">full</xsl:with-param>
                  </xsl:call-template>
               </xsl:with-param>
               <xsl:with-param name="copyid">false</xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:if
               test="
                  $topNavigationPanel = 'true' and
                  $nav = 'true'">
               <xsl:element name="{if ($outputTarget= ('html5', 'html')) then 'nav'
				  else 'div'}">
                  <xsl:call-template name="xrefpanel">
                     <xsl:with-param name="homepage" select="concat($masterFile, $standardSuffix)"/>
                     <xsl:with-param name="mode" select="local-name(.)"/>
                  </xsl:call-template>
               </xsl:element>
            </xsl:if>

            <xsl:apply-templates/>

            <xsl:if
               test="
                  $bottomNavigationPanel = 'true' and
                  $nav = 'true'">
               <xsl:element name="{if ($outputTarget=('html5', 'html')) then 'nav' else
				'div'}">
                  <xsl:call-template name="xrefpanel">
                     <xsl:with-param name="homepage" select="concat($masterFile, $standardSuffix)"/>
                     <xsl:with-param name="mode" select="local-name(.)"/>
                  </xsl:call-template>
               </xsl:element>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] process divisions</desc>
   </doc>
   <xsl:template name="doDivs">
      <xsl:for-each select="tei:TEI/tei:text">
         <xsl:for-each select="tei:front | tei:body | tei:back">
            <xsl:comment>TEI <xsl:value-of select="name()"/></xsl:comment>
            <xsl:for-each select="tei:div | tei:div1">
               <xsl:variable name="currentID">
                  <xsl:apply-templates mode="ident" select="."/>
               </xsl:variable>
               <xsl:call-template name="doPage">
                  <xsl:with-param name="currentID" select="$currentID"/>
               </xsl:call-template>
            </xsl:for-each>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] make an output page for ID <param name="currentID">currentID</param>
      </desc>
   </doc>
   <xsl:template name="doPage">
      <xsl:param name="currentID"/>
      <xsl:variable name="BaseFile">
         <xsl:value-of select="$masterFile"/>
         <xsl:call-template name="addCorpusID"/>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="$STDOUT = 'true'">
            <xsl:call-template name="pageLayoutComplex">
               <xsl:with-param name="currentID" select="$currentID"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:variable name="outName">
               <xsl:call-template name="outputChunkName">
                  <xsl:with-param name="ident">
                     <xsl:choose>
                        <xsl:when test="not($currentID = '')">
                           <xsl:value-of select="$currentID"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="$BaseFile"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:variable>
            <xsl:if test="$verbose = 'true'">
               <xsl:message>Opening file (doPage) <xsl:value-of select="$outName"/>
               </xsl:message>
            </xsl:if>
            <xsl:result-document html-version="{$htmlVersion}" normalization-form="{$normalizationForm}"
               encoding="{$outputEncoding}" href="{$outName}" method="{$outputMethod}" omit-xml-declaration="{$omitXMLDeclaration}">
               <xsl:call-template name="pageLayoutComplex">
                  <xsl:with-param name="currentID" select="$currentID"/>
               </xsl:call-template>
            </xsl:result-document>
            <xsl:if test="$verbose = 'true'">
               <xsl:message>Closing file <xsl:value-of select="$outName"/>
               </xsl:message>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>


   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] link to level above </desc>
   </doc>
   <xsl:template name="generateUpLink">
      <xsl:variable name="myName">
         <xsl:value-of select="local-name(.)"/>
      </xsl:variable>
      <xsl:variable name="BaseFile">
         <xsl:value-of select="$masterFile"/>
         <xsl:value-of select="$standardSuffix"/>
         <xsl:call-template name="addCorpusID"/>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="$myName = 'div' and not(ancestor::tei:div)">
            <xsl:call-template name="upLink">
               <xsl:with-param name="up" select="$BaseFile"/>
               <xsl:with-param name="title" select="$homeLabel"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="$myName = 'div'">
            <xsl:call-template name="upLink">
               <xsl:with-param name="up" select="ancestor::tei:div[1]"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="$myName = 'div1'">
            <xsl:call-template name="upLink">
               <xsl:with-param name="up" select="$BaseFile"/>
               <xsl:with-param name="title" select="$homeLabel"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="$myName = 'div2'">
            <xsl:call-template name="upLink">
               <xsl:with-param name="up" select="ancestor::tei:div1"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="$myName = 'div3'">
            <xsl:call-template name="upLink">
               <xsl:with-param name="up" select="ancestor::tei:div2"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="$myName = 'div4'">
            <xsl:call-template name="upLink">
               <xsl:with-param name="up" select="ancestor::tei:div3"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="$myName = 'div5'">
            <xsl:call-template name="upLink">
               <xsl:with-param name="up" select="ancestor::tei:div4"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="upLink">
               <xsl:with-param name="up" select="(ancestor::tei:div1 | ancestor::tei:div)[1]"/>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>What happens at the end of an HTML file [html] </p>
      </desc>
   </doc>
   <xsl:template name="htmlFileBottom">
      <xsl:call-template name="topNavigation"/>
      <xsl:call-template name="stdfooter"/>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] make the header of an HTML file </desc>
   </doc>
   <xsl:function name="tei:htmlHead">

      <xsl:param name="pagetitle"/>
      <xsl:param name="number"/>
      <xsl:for-each select="$top/*">
         <head>
            <xsl:comment>THIS FILE IS GENERATED FROM AN XML MASTER. DO NOT EDIT (<xsl:value-of select="$number"/>)</xsl:comment>
            <!-- No empty <title/> allowed, main browsers don't like it at all -->
            <xsl:if test="string($pagetitle) or string($htmlTitlePrefix)">
               <title>
                  <xsl:value-of select="$htmlTitlePrefix"/>
                  <xsl:if test="$htmlTitlePrefix != ''">
                     <xsl:text> </xsl:text>
                  </xsl:if>
                  <xsl:value-of select="$pagetitle"/>
               </title>
            </xsl:if>

            <xsl:call-template name="headHook"/>
            <xsl:call-template name="metaHTML">
               <xsl:with-param name="title" select="$pagetitle"/>
            </xsl:call-template>

            <xsl:choose>
               <xsl:when test="count(key('TREES', 1)) = 0"/>
               <xsl:when test="$treestyle = 'googlechart'">
                  <script type="text/javascript" src="https://www.google.com/jsapi"/>
                  <script type="text/javascript">
                            google.load('visualization', '1', {
                                packages:[ 'orgchart']
                            });
                            google.setOnLoadCallback(drawCharts);</script>
               </xsl:when>
               <xsl:when test="$treestyle = 'd3DragDropTree'">
                  <!-- from  http://www.robschmuecker.com/d3-js-drag-and-drop-zoomable-tree/ -->
                  <script type="text/javascript" src="http://d3js.org/d3.v3.min.js"/>
                  <style type="text/css">
                     .node {
                         cursor: pointer;
                     }
                     
                     .overlay {
                         background-color: #EEE;
                     }
                     
                     .node circle {
                         fill: #fff;
                         stroke: steelblue;
                         stroke-width: 1.5px;
                     }
                     
                     .node text {
                         font-size: 10px;
                         font-family: sans-serif;
                     }
                     
                     .link {
                         fill: none;
                         stroke: #ccc;
                         stroke-width: 1.5px;
                     }
                     
                     .templink {
                         fill: none;
                         stroke: red;
                         stroke-width: 3px;
                     }
                     
                     .ghostCircle.show {
                         display: block;
                     }
                     
                     .ghostCircle,
                     .activeDrag .ghostCircle {
                         display: none;
                     }</style>
               </xsl:when>
               <xsl:when test="$treestyle = 'd3CollapsableTree'">
                  <script type="text/javascript" src="http://d3js.org/d3.v3.min.js"/>
                  <!-- from d3noob’s block #8375092 January 11, 2014
	    Interactive d3.js tree diagram
	    This is a d3.js tree diagram that includes an interactive element as used as an example in the book D3 Tips and Tricks.

	    Any parent node can be clicked on to collapse the portion of the tree below it, on itself. Conversely, it can be clicked on again to regrow.

	    It is derived from the Mike Bostock Collapsible tree example but it is a slightly cut down version.
	    -->

                  <style>
                     .treediagram {
                         background-color: #eee
                     }
                     .node {
                         cursor: pointer;
                     }
                     .nodediv.desc {
                         font: 8px sans-serif;
                     }
                     .nodediv {
                         border: solid black 1px;
                         background-color: white;
                         padding: 2px;
                         font: 12px sans-serif;
                         font-weight: bold;
                     }
                     span.att {
                         font-style: italic;
                     }
                     .highlight {
                         color: red;
                     }
                     .link {
                         fill: none;
                         stroke: #aaa;
                         stroke-width: 2px;
                     }</style>
                  <script>
	      // ************** Generate the tree diagram	 *****************
	      var margin = {top: 0, right: 0, bottom: 0, left: 30};
	      var width, height, tree, svg, diagonal;
	      var rectw = 120,recth=50;
	      var i = 0,	duration = 750,	treeData;
	     
function drawCollapsibleTree (ID, w,h) {
   width = w - margin.right - margin.left;
   height = h - margin.top - margin.bottom;
   tree = d3.layout.tree()
	.size([height, width]);

   diagonal = d3.svg.diagonal()
	.projection(function(d) { return [d.y, d.x]; });
   treeData.x0 = height / 2;
   treeData.y0 = 0;
   svg = d3.select(ID).append("svg:svg")
	.attr("width", width + margin.right + margin.left)
	.attr("height", height + margin.top + margin.bottom)
     .append("g")
	.attr("transform", "translate(" + margin.left + "," + margin.top + ")");
   update(treeData);
}


function update(source) {

  // Compute the new tree layout.
  var nodes = tree.nodes(treeData).reverse(),
	  links = tree.links(nodes);

  // Normalize for fixed-depth.
  nodes.forEach(function(d) { d.y = d.depth * 180; });

  // Update the nodes…
  var node = svg.selectAll("g.node")
	  .data(nodes, function(d) { return d.id || (d.id = ++i); });

  // Enter any new nodes at the parent's previous position.
  var nodeEnter = node.enter().append("g")
	  .attr("class", "node")
	  .attr("transform", function(d) { return "translate(" + source.y0 + "," + source.x0 + ")"; })
	  .on("click", click);

   nodeEnter.append("foreignObject")
      .attr("x", -10)
      .attr("y", -10)
      .attr("width", rectw) 
      .attr("height", recth) 
      .append("xhtml:div")
      .attr("class",  function(d) { return "nodediv " + d.style; })
      .html(function(d) { return d.name; });


  // Transition nodes to their new position.
  var nodeUpdate = node.transition()
	  .duration(duration)
	  .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; });

  nodeUpdate.select("div")
 	  .attr("width", rectw)
 	  .attr("height", recth)
	  .style("background-color", function(d) { return d._children ? "lightsteelblue" : "#fff"; });

  nodeUpdate.select("text")
	  .style("fill-opacity", 1);

  // Transition exiting nodes to the parent's new position.
  var nodeExit = node.exit().transition()
	  .duration(duration)
	  .attr("transform", function(d) { return "translate(" + source.y + "," + source.x + ")"; })
	  .remove();

  nodeExit.select("foreignObject")
 	  .attr("width", rectw)
 	  .attr("height", recth);

  // Update the links…
  var link = svg.selectAll("path.link")
	  .data(links, function(d) { return d.target.id; });

  // Enter any new links at the parent's previous position.
  link.enter().insert("path", "g")
	  .attr("class", "link")
	  .attr("d", function(d) {
		var o = {x: source.x0, y: source.y0};
		return diagonal({source: o, target: o});
	  });

  // Transition links to their new position.
  link.transition()
	  .duration(duration)
	  .attr("d", diagonal);

  // Transition exiting nodes to the parent's new position.
  link.exit().transition()
	  .duration(duration)
	  .attr("d", function(d) {
		var o = {x: source.x, y: source.y};
		return diagonal({source: o, target: o});
	  })
	  .remove();

  // Stash the old positions for transition.
  nodes.forEach(function(d) {
	d.x0 = d.x;
	d.y0 = d.y;
  });
}

// Toggle children on click.
function click(d) {
  if (d.children) {
	d._children = d.children;
	d.children = null;
  } else {
	d.children = d._children;
	d._children = null;
  }
  update(d);
}
	  </script>
               </xsl:when>
               <xsl:when test="$treestyle = 'd3verticaltree'">
                  <script type="text/javascript" src="http://d3js.org/d3.v3.min.js"/>
                  <script type="text/javascript">
                            var downoffset = 40;
                            var down2offset = 5;
                            var diagonal = d3.svg.diagonal().projection(function (d) {
                                return[d.x, d.y];
                            });
                            function elbow(d, i) {
                                return "M" + d.target.x + "," + (d.target.y - downoffset) + "V" + (d.source.y + down2offset) + "H" + d.source.x;
                            }
                            function visMe (ID, extray) {
                                var vis = d3.select(ID).append("svg:svg").attr("class", "svgtree").attr("width", treewidth + 50).attr("height", treedepth + extray).append("svg:g").attr("transform", function (d) {
                                    return "translate(" + 0 + "," + (extray + 25) + ")";
                                })
                                var tree = d3.layout.tree().size([treewidth, treedepth]);
                                var nodes = tree.nodes(treeData);
                                var links = tree.links(nodes);
                                var link = vis.selectAll("pathlink").data(links).enter().append("svg:path").attr("class", function (d) {
                                    return "link" + d.source.showlink;
                                }).attr("d", elbow);
                                var node = vis.selectAll("g.node").data(nodes).enter().append("svg:g").attr("class", "node").attr("id", function (d) {
                                    return d.id;
                                })
                                node.append("svg:foreignObject").attr("transform", function (d) {
                                    return "translate(" + d.x + "," + d.y + ")";
                                }).attr("x", -40).attr("y", yoffset).attr("width", 80).attr("height", 80).attr("style", "fill-opacity:1.0").append("xhtml:div").attr("class", function (d) {
                                    return "nodetext " + d.type;
                                }).html(function (d) {
                                    return d.name;
                                });
                                var linknode = vis.selectAll("g.node").data(nodes).filter(function (d) {
                                    return d.synch
                                });
                                linknode.append("svg:line").attr("x1", function (d) {
                                    other = vis.select(d.synch).datum();
                                    if (d.x<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                            other.x) {
                                return d.x - 30;
                            } else {
                                return d.x + 30;
                            };
                        }).attr("y1", function (d) {
                            return d.y + (yoffset + 5);
                        }).attr("x2", function (d) {
                            other = vis.select(d.synch).datum();
                            if (d.x<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                            other.x) {
                                return other.x + 30;
                            } else {
                                return other.x - 30;
                            };
                        }).attr("y2", function (d) {
                            return vis.select(d.synch).datum().y + (yoffset + 5);
                        }).attr("stroke-dasharray", "10,10").attr("style", "stroke-width: 2px;stroke:green");
                    }</script>
                  <style>
                     .nodetext {
                         text-align: center;
                     }
                     .linkinvisible {
                         visibility: hidden;
                     }
                     .link {
                         fill: none;
                         stroke: black;
                         stroke-width: 1px;
                     }
                     .node {
                         font-weight: normal;
                         font-size: 7pt;
                     }
                     .treediagram {
                     }
                     .svgtree {
                         padding-bottom: 6pt;
                     }</style>
               </xsl:when>
            </xsl:choose>
            <xsl:call-template name="includeCSS"/>
            <xsl:call-template name="cssHook"/>
            <xsl:call-template name="includeJavascript"/>
            <xsl:call-template name="javascriptHook"/>
         </head>
      </xsl:for-each>
   </xsl:function>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] bring in CSS files </desc>
   </doc>
   <xsl:template name="includeCSS">

      <xsl:if test="string-length($cssFile) &gt; 0">
         <link href="{$cssFile}" rel="stylesheet" type="text/css"/>
      </xsl:if>

      <xsl:if test="string-length($cssSecondaryFile) &gt; 0">
         <link href="{$cssSecondaryFile}" rel="stylesheet" type="text/css"/>
      </xsl:if>

      <xsl:if test="string-length($cssPrintFile) &gt; 0">
         <link rel="stylesheet" media="print" type="text/css">
            <xsl:attribute name="href" select="$cssPrintFile"/>
         </link>
      </xsl:if>

      <xsl:if test="$cssInlineFiles">
         <style type="text/css" title="inline_css">
	  <xsl:for-each select="tokenize(normalize-space($cssInlineFiles), ' ')">
	    <xsl:for-each select="
                     tokenize(unparsed-text(.),
                     '\r?\n')">
	      <xsl:if test="not(starts-with(., '$Id:') or starts-with(., '@import'))">
		<xsl:value-of select="normalize-space(.)"/>
	      </xsl:if>
	      <xsl:text>&#10;</xsl:text>
	    </xsl:for-each>
	  </xsl:for-each>
	</style>
      </xsl:if>

      <xsl:call-template name="generateLocalCSS"/>

   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] JavaScript functions to be declared in HTML header</desc>
   </doc>
   <xsl:template name="includeJavascript"> </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>[html] Write out some JavaScript into the HTML</p>
         <p>Note that it does not have to commented if the output is XHTML</p>
         <param name="content">The code</param>
      </desc>
   </doc>
   <xsl:template name="writeJavascript">
      <xsl:param name="content"/>
      <script type="text/javascript">
	<xsl:value-of select="$content"/>
      </script>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] Make contents of left-hand column<param name="currentID">currentID</param>
      </desc>
   </doc>
   <xsl:template name="leftHandFrame">
      <xsl:param name="currentID"/>
      <xsl:call-template name="makeSidebar"/>
      <xsl:choose>
         <xsl:when test="$currentID = ''">
            <xsl:call-template name="linkListContents">
               <xsl:with-param name="style" select="'toclist'"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:choose>
               <xsl:when test="count(id($currentID)) &gt; 0">
                  <xsl:for-each select="id($currentID)">
                     <xsl:call-template name="linkListContents">
                        <xsl:with-param name="style" select="'toclist'"/>
                     </xsl:call-template>
                  </xsl:for-each>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:apply-templates mode="xpath" select="ancestor-or-self::tei:TEI/tei:text">
                     <xsl:with-param name="xpath" select="$currentID"/>
                     <xsl:with-param name="action" select="'toclist'"/>
                  </xsl:apply-templates>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] bypass sidebar lists in normal mode</desc>
   </doc>
   <xsl:template match="tei:list[@type = 'sidebar']"/>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] Summary links in left-hand column</desc>
   </doc>
   <xsl:template name="makeSidebar">
      <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:body/tei:list[@type = 'sidebar']">
         <xsl:for-each select=".//tei:ref">
            <p class="sidebar">
               <a class="toclist" href="{@url}">
                  <xsl:apply-templates/>
               </a>
            </p>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] Summary table of contents in left-hand column<param name="style">style</param>
      </desc>
   </doc>
   <xsl:template name="linkListContents">
      <xsl:param name="style" select="'toc'"/>
      <xsl:variable name="BaseFile">
         <xsl:value-of select="$masterFile"/>
         <xsl:call-template name="addCorpusID"/>
      </xsl:variable>
      <xsl:variable name="thisOne">
         <xsl:value-of select="generate-id()"/>
      </xsl:variable>
      <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text">
         <!-- front matter -->
         <xsl:for-each select="tei:front">
            <xsl:if test="tei:div1 | tei:div">
               <div class="tocFront">
                  <xsl:element name="{$tocContainerElement}">
                     <xsl:attribute name="class">
                        <xsl:text>tocContainer</xsl:text>
                     </xsl:attribute>
                     <xsl:call-template name="tocSection">
                        <xsl:with-param name="id" select="$thisOne"/>
                        <xsl:with-param name="style" select="$style"/>
                     </xsl:call-template>
                  </xsl:element>
               </div>
            </xsl:if>
         </xsl:for-each>
         <!-- body matter -->
         <xsl:for-each select="tei:body">
            <xsl:if test="tei:div1 | tei:div">
               <div class="tocBody">
                  <xsl:comment>start TOC</xsl:comment>
                  <xsl:element name="{$tocContainerElement}">
                     <xsl:attribute name="class">
                        <xsl:text>tocContainer</xsl:text>
                     </xsl:attribute>
                     <xsl:comment>TOC components</xsl:comment>
                     <xsl:call-template name="tocSection">
                        <xsl:with-param name="id" select="$thisOne"/>
                        <xsl:with-param name="style" select="$style"/>
                     </xsl:call-template>
                  </xsl:element>
               </div>
            </xsl:if>
         </xsl:for-each>
         <!-- back matter -->
         <xsl:for-each select="tei:back">
            <xsl:if test="tei:div1 | tei:div">
               <div class="tocBack">
                  <xsl:element name="{$tocContainerElement}">
                     <xsl:attribute name="class">
                        <xsl:text>tocContainer</xsl:text>
                     </xsl:attribute>
                     <xsl:call-template name="tocSection">
                        <xsl:with-param name="id" select="$thisOne"/>
                        <xsl:with-param name="style" select="$style"/>
                     </xsl:call-template>
                  </xsl:element>
               </div>
            </xsl:if>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] Main page in right-hand column<param name="currentID">currentID</param>
      </desc>
   </doc>
   <xsl:template name="mainFrame">
      <xsl:param name="currentID"/>
      <xsl:param name="minimal">false</xsl:param>
      <xsl:choose>
         <xsl:when test="$currentID = 'current'">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:when test="$currentID = '' and number($splitLevel) = -1">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:when test="$currentID = ''">
            <!-- we need to locate the first interesting object in the file, ie
	     the first grandchild of <text > -->
            <xsl:for-each select="descendant-or-self::tei:TEI/tei:text/tei:*[1]/*[1]">
               <xsl:apply-templates mode="paging" select="."/>
               <xsl:if test="$autoToc = 'true'">
                  <xsl:if test="following-sibling::tei:div/tei:head">
                     <xsl:call-template name="contentsHeading"/>
                     <ul class="toc">
                        <xsl:apply-templates mode="maketoc" select="following-sibling::tei:div">
                           <xsl:with-param name="forcedepth" select="'0'"/>
                        </xsl:apply-templates>
                     </ul>
                  </xsl:if>
               </xsl:if>
            </xsl:for-each>
         </xsl:when>
         <xsl:otherwise>
            <xsl:choose>
               <xsl:when test="count(id($currentID)) &gt; 0">
                  <xsl:for-each select="id($currentID)">
                     <h2>
                        <xsl:apply-templates mode="xref" select="."/>
                        <xsl:call-template name="sectionHeadHook"/>
                     </h2>
                     <xsl:if test="$topNavigationPanel = 'true'">
                        <xsl:element name="{if ($outputTarget=('html5', 'html')) then 'nav' else 'div'}">
                           <xsl:call-template name="xrefpanel">
                              <xsl:with-param name="homepage"
                                 select="concat($masterFile, $standardSuffix)"/>
                              <xsl:with-param name="mode" select="local-name(.)"/>
                           </xsl:call-template>
                        </xsl:element>
                     </xsl:if>
                     <xsl:call-template name="makeDivBody">
                        <xsl:with-param name="depth" select="count(ancestor::tei:div) + 1"/>
                     </xsl:call-template>
                     <xsl:if test="$bottomNavigationPanel = 'true'">
                        <xsl:element name="{if ($outputTarget=('html5', 'html')) then 'nav' else 'div'}">
                           <xsl:call-template name="xrefpanel">
                              <xsl:with-param name="homepage"
                                 select="concat($masterFile, $standardSuffix)"/>
                              <xsl:with-param name="mode" select="local-name(.)"/>
                           </xsl:call-template>
                        </xsl:element>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:when>
               <xsl:otherwise>
                  <!-- the passed ID is a pseudo-XPath expression
		 which starts below TEI/tei:text.
		 The real XPath syntax is changed to avoid problems
	    -->
                  <xsl:choose>
                     <xsl:when test="ancestor-or-self::tei:TEI/tei:group/tei:text">
                        <xsl:apply-templates mode="xpath"
                           select="ancestor-or-self::tei:TEI/tei:group/tei:text">
                           <xsl:with-param name="xpath" select="$currentID"/>
                        </xsl:apply-templates>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:apply-templates mode="xpath"
                           select="ancestor-or-self::tei:TEI/tei:text">
                           <xsl:with-param name="xpath" select="$currentID"/>
                        </xsl:apply-templates>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>

      <xsl:if test="$minimal = 'false'">
         <xsl:call-template name="partialFootNotes">
            <xsl:with-param name="currentID" select="$currentID"/>
         </xsl:call-template>
         <xsl:call-template name="stdfooter"/>
      </xsl:if>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] Table of contents </desc>
   </doc>
   <xsl:template name="mainTOC">
      <xsl:choose>
         <xsl:when test="self::tei:teiCorpus">
            <ul>
               <xsl:for-each select="tei:TEI">
                  <li>
                     <a>
                        <xsl:attribute name="href">
                           <xsl:apply-templates mode="generateLink" select="."/>
                        </xsl:attribute>
                        <xsl:call-template name="header">
                           <xsl:with-param name="minimal">false</xsl:with-param>
                           <xsl:with-param name="display">plain</xsl:with-param>
                        </xsl:call-template>
                     </a>
                     <xsl:for-each select="tei:text/tei:front">
                        <xsl:call-template name="partTOC">
                           <xsl:with-param name="part">front</xsl:with-param>
                        </xsl:call-template>
                     </xsl:for-each>

                     <xsl:for-each select="tei:text/tei:body">
                        <xsl:call-template name="partTOC">
                           <xsl:with-param name="part">body</xsl:with-param>
                        </xsl:call-template>
                     </xsl:for-each>

                     <xsl:for-each select="tei:text/tei:back">
                        <xsl:call-template name="partTOC">
                           <xsl:with-param name="part">back</xsl:with-param>
                        </xsl:call-template>
                     </xsl:for-each>
                  </li>
               </xsl:for-each>
            </ul>
         </xsl:when>
         <xsl:when
            test="
               ancestor-or-self::tei:TEI/tei:text/tei:group and
               $splitLevel = 0">
            <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:front">
               <xsl:call-template name="partTOC">
                  <xsl:with-param name="part">front</xsl:with-param>
               </xsl:call-template>
            </xsl:for-each>

            <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:group">
               <xsl:call-template name="groupTOC"/>
            </xsl:for-each>

            <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:back">
               <xsl:call-template name="partTOC">
                  <xsl:with-param name="part">back</xsl:with-param>
               </xsl:call-template>
            </xsl:for-each>
         </xsl:when>

         <xsl:when test="ancestor-or-self::tei:TEI/tei:text/tei:group">
            <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:group/tei:text">
               <h3>
                  <xsl:number/>
                  <xsl:choose>
                     <xsl:when test="tei:body/tei:head">
                        <xsl:text>. </xsl:text>
                        <xsl:apply-templates select="tei:body/tei:head" mode="plain"/>
                     </xsl:when>
                     <xsl:when test="tei:front/tei:titlePage//tei:title">
                        <xsl:apply-templates select="tei:front/tei:titlePage//tei:title[1]"
                           mode="plain"/>
                     </xsl:when>
                  </xsl:choose>
               </h3>
               <xsl:for-each select="tei:front">
                  <xsl:call-template name="partTOC">
                     <xsl:with-param name="part">front</xsl:with-param>
                  </xsl:call-template>
               </xsl:for-each>

               <xsl:for-each select="tei:body">
                  <xsl:call-template name="partTOC">
                     <xsl:with-param name="part">body</xsl:with-param>
                  </xsl:call-template>
               </xsl:for-each>

               <xsl:for-each select="tei:back">
                  <xsl:call-template name="partTOC">
                     <xsl:with-param name="part">back</xsl:with-param>
                  </xsl:call-template>
               </xsl:for-each>

            </xsl:for-each>

         </xsl:when>
         <xsl:otherwise>
            <xsl:if test="$tocFront">
               <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:front">
                  <xsl:call-template name="partTOC">
                     <xsl:with-param name="part">front</xsl:with-param>
                  </xsl:call-template>
               </xsl:for-each>
            </xsl:if>

            <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:body">
               <xsl:call-template name="partTOC">
                  <xsl:with-param name="part">body</xsl:with-param>
               </xsl:call-template>
            </xsl:for-each>

            <xsl:if test="$tocBack">
               <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:back">
                  <xsl:call-template name="partTOC">
                     <xsl:with-param name="part">back</xsl:with-param>
                  </xsl:call-template>
               </xsl:for-each>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>[html] </p>
         <p xmlns="http://www.w3.org/1999/xhtml"> make table of contents for nested texts/groups</p>
      </desc>
   </doc>
   <xsl:template name="groupTOC">
      <xsl:variable name="gDepth" select="count(ancestor::tei:group)"/>
      <xsl:comment>a TOC for a group of texts (<xsl:value-of select="name()"/>)</xsl:comment>
      <ul class="toc toc_group{$gDepth}">
         <li>
            <xsl:if
               test="not($autoHead = 'true') and not(tei:head or tei:text/tei:body/tei:head or @n)">
               <xsl:attribute name="class">headless</xsl:attribute>
            </xsl:if>
            <ul>
               <xsl:for-each select="tei:text">
                  <li>
                     <xsl:call-template name="header">
                        <xsl:with-param name="toc">
                           <xsl:apply-templates mode="generateLink" select="."/>
                        </xsl:with-param>
                        <xsl:with-param name="minimal">false</xsl:with-param>
                        <xsl:with-param name="display">plain</xsl:with-param>
                     </xsl:call-template>

                     <xsl:for-each select="tei:front">
                        <xsl:if test="tei:titlePage/tei:docTitle/tei:titlePart">
                           <span>
                              <xsl:apply-templates select="tei:titlePage/tei:docTitle/tei:titlePart"
                                 mode="plain"/>
                           </span>
                        </xsl:if>
                        <xsl:call-template name="partTOC">
                           <xsl:with-param name="part">front</xsl:with-param>
                        </xsl:call-template>
                     </xsl:for-each>

                     <xsl:for-each select="tei:group">
                        <xsl:call-template name="groupTOC"/>
                     </xsl:for-each>

                     <xsl:for-each select="tei:body">
                        <xsl:call-template name="partTOC">
                           <xsl:with-param name="part">body</xsl:with-param>
                        </xsl:call-template>
                     </xsl:for-each>

                     <xsl:for-each select="tei:back">
                        <xsl:call-template name="partTOC">
                           <xsl:with-param name="part">back</xsl:with-param>
                        </xsl:call-template>
                     </xsl:for-each>
                  </li>
               </xsl:for-each>
               <xsl:for-each select="tei:group">
                  <li>
                     <xsl:call-template name="groupTOC"/>
                  </li>
               </xsl:for-each>
            </ul>
         </li>
      </ul>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>[html] </p>
         <p xmlns="http://www.w3.org/1999/xhtml"> make partial table of contents </p>
      </desc>
   </doc>
   <xsl:template name="partTOC">
      <xsl:param name="part"/>
      <xsl:param name="force"/>
      <xsl:if test="tei:div | tei:div1 | tei:div2 | tei:div3 | tei:div4 | tei:div5 | tei:div6">
         <ul class="toc{$force} toc_{$part}">
            <xsl:apply-templates mode="maketoc"
               select="tei:div | tei:div1 | tei:div2 | tei:div3 | tei:div4 | tei:div5 | tei:div6">
               <xsl:with-param name="forcedepth" select="$force"/>
            </xsl:apply-templates>
         </ul>
      </xsl:if>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] sections in mode for table of contents</desc>
   </doc>
   <xsl:template name="continuedToc">
      <xsl:if test="tei:div | tei:div1 | tei:div2 | tei:div3 | tei:div4 | tei:div5 | tei:div6">
         <ul class="toc">
            <xsl:apply-templates mode="maketoc"
               select="tei:div | tei:div1 | tei:div2 | tei:div3 | tei:div4 | tei:div5 | tei:div6"/>
         </ul>
      </xsl:if>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>[html] </p>
         <p xmlns="http://www.w3.org/1999/xhtml"> xref to previous and last sections </p>
      </desc>
   </doc>
   <xsl:template name="nextLink">
      <xsl:variable name="myName">
         <xsl:value-of select="local-name(.)"/>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="following-sibling::tei:TEI">
            <xsl:apply-templates mode="generateNextLink" select="following-sibling::tei:TEI[1]"/>
         </xsl:when>
         <xsl:when test="following-sibling::tei:div[tei:head or $autoHead = 'true']">
            <xsl:apply-templates mode="generateNextLink" select="following-sibling::tei:div[1]"/>
         </xsl:when>
         <xsl:when
            test="parent::tei:body/following-sibling::tei:back/tei:div[tei:head or $autoHead = 'true']">
            <xsl:apply-templates mode="generateNextLink"
               select="parent::tei:body/following-sibling::tei:back/tei:div[1]"/>
         </xsl:when>
         <xsl:when
            test="parent::tei:front/following-sibling::tei:body/tei:div[tei:head or $autoHead = 'true']">
            <xsl:apply-templates mode="generateNextLink"
               select="parent::tei:front/following-sibling::tei:body/tei:div[1]"/>
         </xsl:when>
         <xsl:when
            test="$myName = 'div1' and following-sibling::tei:div1[tei:head or $autoHead = 'true']">
            <xsl:apply-templates mode="generateNextLink" select="following-sibling::tei:div1[1]"/>
         </xsl:when>
         <xsl:when
            test="$myName = 'div2' and following-sibling::tei:div2[tei:head or $autoHead = 'true']">
            <xsl:apply-templates mode="generateNextLink" select="following-sibling::tei:div2[1]"/>
         </xsl:when>
         <xsl:when
            test="$myName = 'div3' and following-sibling::tei:div3[tei:head or $autoHead = 'true']">
            <xsl:apply-templates mode="generateNextLink" select="following-sibling::tei:div3[1]"/>
         </xsl:when>
         <xsl:when
            test="$myName = 'div4' and following-sibling::tei:div4[tei:head or $autoHead = 'true']">
            <xsl:apply-templates mode="generateNextLink" select="following-sibling::tei:div4[1]"/>
         </xsl:when>
         <xsl:when
            test="$myName = 'div5' and following-sibling::tei:div5[tei:head or $autoHead = 'true']">
            <xsl:apply-templates mode="generateNextLink" select="following-sibling::tei:div5[1]"/>
         </xsl:when>
         <xsl:when
            test="$myName = 'div6' and following-sibling::tei:div6[tei:head or $autoHead = 'true']">
            <xsl:apply-templates mode="generateNextLink" select="following-sibling::tei:div6[1]"/>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] Generate name for a chunk of output<param name="ident">ident</param>
      </desc>
   </doc>
   <xsl:template name="outputChunkName">
      <xsl:param name="ident"/>
      <xsl:if test="not($outputDir = '')">
         <xsl:value-of
            select="
               if (matches($outputDir, '^[A-Za-z]:')) then
                  concat('file:///', $outputDir)
               else
                  $outputDir"/>
         <xsl:if
            test="not(substring($outputDir, string-length($outputDir), string-length($outputDir)) = '/')">
            <xsl:text>/</xsl:text>
         </xsl:if>
      </xsl:if>
      <xsl:value-of
         select="
            if (matches($ident, '^[A-Za-z]:')) then
               concat('file:///', $ident)
            else
               $ident"/>
      <xsl:value-of select="$outputSuffix"/>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] Make a new page using multicolumn layout <param name="currentID">current
            ID</param>
      </desc>
   </doc>
   <xsl:template name="pageLayoutComplex">
      <xsl:param name="currentID"/>
      <html>
         <xsl:call-template name="addLangAtt"/>
         <xsl:variable name="pagetitle">
            <xsl:choose>
               <xsl:when test="$currentID = ''">
                  <xsl:sequence select="tei:generateTitle(.)"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:choose>
                     <xsl:when test="$currentID = 'current'">
                        <xsl:apply-templates mode="xref" select="."/>
                     </xsl:when>
                     <xsl:when test="count(id($currentID)) &gt; 0">
                        <xsl:for-each select="id($currentID)">
                           <xsl:apply-templates mode="xref" select="."/>
                        </xsl:for-each>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:apply-templates mode="xpath" select="descendant::text">
                           <xsl:with-param name="xpath" select="$currentID"/>
                           <xsl:with-param name="action" select="'header'"/>
                        </xsl:apply-templates>
                     </xsl:otherwise>
                  </xsl:choose>
                  <xsl:text> - </xsl:text>
                  <xsl:sequence select="tei:generateTitle(.)"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:sequence select="tei:htmlHead($pagetitle, 4)"/>
         <body>
            <xsl:copy-of select="tei:text/tei:body/@unload"/>
            <xsl:copy-of select="tei:text/tei:body/@onunload"/>
            <xsl:call-template name="bodyMicroData"/>
            <xsl:call-template name="bodyJavascriptHook"/>
            <xsl:call-template name="bodyHook"/>
            <xsl:call-template name="mainPage">
               <xsl:with-param name="currentID">
                  <xsl:value-of select="$currentID"/>
               </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="bodyEndHook"/>
         </body>
      </html>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] the main page structure</desc>
   </doc>
   <xsl:template name="mainPage">
      <xsl:param name="currentID"/>
      <!-- header -->
      <div id="hdr">
         <xsl:call-template name="hdr"/>
      </div>
      <xsl:if test="not($REQUEST = '')">
         <div id="accessibility">
            <span class="tocontent">
               <a href="{$REQUEST}?style=text">Text only</a> | <a class="skiplinks" href="#rh-col"
                  title="Go to main page content">Skip links</a>
            </span>
         </div>
      </xsl:if>
      <div id="hdr2">
         <xsl:call-template name="hdr2"/>
      </div>
      <xsl:if test="not($contentStructure = 'all' or tei:match(@rend, 'all'))">
         <div id="hdr3">
            <xsl:call-template name="hdr3"/>
         </div>
      </xsl:if>
      <xsl:choose>
         <xsl:when test="$contentStructure = 'all' or tei:match(@rend, 'all')">
            <div class="column-wrapper">
               <xsl:call-template name="col1"/>
               <xsl:call-template name="col2"/>
               <xsl:call-template name="col3"/>
            </div>
         </xsl:when>
         <xsl:when test="tei:match(@rend, 'frontpage')">
            <div class="column-wrapper">
               <div id="rh-col">
                  <xsl:for-each select="descendant-or-self::tei:TEI/tei:text/tei:body">
                     <xsl:apply-templates/>
                  </xsl:for-each>
               </div>
               <div id="lh-col">
                  <xsl:for-each select="descendant-or-self::tei:TEI/tei:text/tei:front">
                     <xsl:apply-templates/>
                  </xsl:for-each>
               </div>
            </div>
         </xsl:when>
         <xsl:when test="$contentStructure = 'body'">
            <xsl:call-template name="bodyLayout">
               <xsl:with-param name="currentID" select="$currentID"/>
            </xsl:call-template>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] what to do in column 1 of 3 column arrangement </desc>
   </doc>
   <xsl:template name="col1">
      <div id="col1">
         <xsl:for-each select="descendant-or-self::tei:TEI/tei:text/tei:front">
            <xsl:apply-templates/>
         </xsl:for-each>
      </div>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] what to do in column 2 of 3 column arrangement </desc>
   </doc>
   <xsl:template name="col2">
      <div id="col2">
         <xsl:for-each select="descendant-or-self::tei:TEI/tei:text/tei:body">
            <xsl:apply-templates/>
         </xsl:for-each>
      </div>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] what to do in column 3 of 3 column arrangement </desc>
   </doc>
   <xsl:template name="col3">
      <div id="col3">
         <xsl:for-each select="descendant-or-self::tei:TEI/tei:text/tei:back">
            <xsl:apply-templates/>
         </xsl:for-each>
      </div>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] arrangement of page as HTML divs <param name="currentID">currentID</param>
      </desc>
   </doc>
   <xsl:template name="bodyLayout">
      <xsl:param name="currentID"/>
      <div class="column-wrapper">
         <div id="lh-col">
            <div id="lh-col-top">
               <xsl:comment>top of left-hand column</xsl:comment>
               <xsl:call-template name="lh-col-top"/>
            </div>
            <div id="lh-col-bottom">
               <xsl:comment>bottom of left-hand column</xsl:comment>
               <xsl:call-template name="lh-col-bottom">
                  <xsl:with-param name="currentID" select="$currentID"/>
               </xsl:call-template>
            </div>
         </div>
         <div id="rh-col">
            <div id="rh-col-top">
               <xsl:comment>top of right-hand column</xsl:comment>
               <xsl:call-template name="rh-col-top"/>
            </div>
            <div id="rh-col-bottom">
               <xsl:comment>bottom of right-hand column</xsl:comment>
               <xsl:call-template name="rh-col-bottom">
                  <xsl:with-param name="currentID" select="$currentID"/>
               </xsl:call-template>
            </div>
         </div>
      </div>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] Generate a page using simple layout </desc>
   </doc>
   <xsl:template name="pageLayoutSimple">
      <html>
         <xsl:call-template name="addLangAtt"/>
         <xsl:variable name="pagetitle">
            <xsl:sequence select="tei:generateTitle(.)"/>
         </xsl:variable>
         <xsl:sequence select="tei:htmlHead($pagetitle, 3)"/>
         <body class="simple" id="TOP">
            <xsl:copy-of select="tei:text/tei:body/@unload"/>
            <xsl:copy-of select="tei:text/tei:body/@onunload"/>
            <xsl:call-template name="bodyMicroData"/>
            <xsl:call-template name="bodyJavascriptHook"/>
            <xsl:call-template name="bodyHook"/>
            <xsl:if test="not(tei:text/tei:front/tei:titlePage)">
               <div class="stdheader autogenerated">
                  <xsl:call-template name="stdheader">
                     <xsl:with-param name="title">
                        <xsl:sequence select="tei:generateTitle(.)"/>
                     </xsl:with-param>
                  </xsl:call-template>
               </div>
            </xsl:if>
            <xsl:comment>TEI  front matter </xsl:comment>
            <xsl:apply-templates select="tei:text/tei:front"/>
            <xsl:if
               test="$autoToc = 'true' and (descendant::tei:div or descendant::tei:div1) and not(descendant::tei:divGen[@type = 'toc'])">
               <h2>
                  <xsl:sequence select="tei:i18n('tocWords')"/>
               </h2>
               <xsl:call-template name="mainTOC"/>
            </xsl:if>
            <xsl:choose>
               <xsl:when test="tei:text/tei:group">
                  <xsl:apply-templates select="tei:text/tei:group"/>
               </xsl:when>
               <xsl:when test="tei:match(@rend, 'multicol')">
                  <table>
                     <tr>
                        <xsl:apply-templates select="tei:text/tei:body"/>
                     </tr>
                  </table>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:comment>TEI body matter </xsl:comment>
                  <xsl:call-template name="startHook"/>
                  <xsl:variable name="ident">
                     <xsl:apply-templates mode="ident" select="."/>
                  </xsl:variable>
                  <xsl:apply-templates select="tei:text/tei:body"/>
               </xsl:otherwise>
            </xsl:choose>
            <xsl:comment>TEI back matter </xsl:comment>
            <xsl:apply-templates select="tei:text/tei:back"/>
            <xsl:call-template name="printNotes"/>
            <xsl:call-template name="htmlFileBottom"/>
            <xsl:call-template name="bodyEndHook"/>
         </body>
      </html>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] create a link to previous section</desc>
   </doc>
   <xsl:template name="previousLink">
      <xsl:variable name="myName">
         <xsl:value-of select="local-name(.)"/>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="preceding-sibling::tei:TEI">
            <xsl:apply-templates mode="generatePreviousLink" select="preceding-sibling::tei:TEI[1]"
            />
         </xsl:when>
         <xsl:when test="preceding-sibling::tei:div[tei:head or $autoHead = 'true']">
            <xsl:apply-templates mode="generatePreviousLink" select="preceding-sibling::tei:div[1]"
            />
         </xsl:when>
         <xsl:when
            test="parent::tei:body/preceding-sibling::tei:front/tei:div[tei:head or $autoHead = 'true']">
            <xsl:apply-templates mode="generatePreviousLink"
               select="parent::tei:body/preceding-sibling::tei:front/tei:div[last()]"/>
         </xsl:when>
         <xsl:when
            test="parent::tei:back/preceding-sibling::tei:body/tei:div[tei:head or $autoHead = 'true']">
            <xsl:apply-templates mode="generatePreviousLink"
               select="parent::tei:body/preceding-sibling::tei:body/tei:div[last()]"/>
         </xsl:when>
         <xsl:when
            test="$myName = 'div1' and preceding-sibling::tei:div1[tei:head or $autoHead = 'true']">
            <xsl:apply-templates mode="generatePreviousLink" select="preceding-sibling::tei:div1[1]"
            />
         </xsl:when>
         <xsl:when
            test="$myName = 'div2' and preceding-sibling::tei:div2[tei:head or $autoHead = 'true']">
            <xsl:apply-templates mode="generatePreviousLink" select="preceding-sibling::tei:div2[1]"
            />
         </xsl:when>
         <xsl:when
            test="$myName = 'div3' and preceding-sibling::tei:div3[tei:head or $autoHead = 'true']">
            <xsl:apply-templates mode="generatePreviousLink" select="preceding-sibling::tei:div3[1]"
            />
         </xsl:when>
         <xsl:when
            test="$myName = 'div4' and preceding-sibling::tei:div4[tei:head or $autoHead = 'true']">
            <xsl:apply-templates mode="generatePreviousLink" select="preceding-sibling::tei:div4[1]"
            />
         </xsl:when>
         <xsl:when
            test="$myName = 'div5' and preceding-sibling::tei:div5[tei:head or $autoHead = 'true']">
            <xsl:apply-templates mode="generatePreviousLink" select="preceding-sibling::tei:div5[1]"
            />
         </xsl:when>
         <xsl:when
            test="$myName = 'div6' and preceding-sibling::tei:div6[tei:head or $autoHead = 'true']">
            <xsl:apply-templates mode="generatePreviousLink" select="preceding-sibling::tei:div6[1]"
            />
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <xsl:template name="simpleBody">
      <xsl:apply-templates select="tei:sourceDoc"/>
      <xsl:choose>
         <xsl:when test="tei:text/tei:group">
            <xsl:apply-templates select="tei:text/*"/>
         </xsl:when>
         <xsl:when test="$filePerPage = 'true'">
            <xsl:variable name="pass1">
               <xsl:apply-templates select="tei:text/*"/>
            </xsl:variable>
            <xsl:choose>
               <xsl:when test="$pass1/html:PAGEBREAK">
                  <xsl:for-each-group select="$pass1/*" group-starting-with="html:PAGEBREAK">
                     <xsl:choose>
                        <xsl:when test="self::html:PAGEBREAK">
                           <xsl:call-template name="pageperfile">
                              <xsl:with-param name="page" select="self::html:PAGEBREAK/@name"/>
                           </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:copy-of select="current-group()"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:for-each-group>
               </xsl:when>
               <xsl:when
                  test="
                     $pass1/html:div[@class = 'tei_front' or
                     @class = 'tei_body' or @class = 'tei_back']/html:PAGEBREAK">
                  <xsl:for-each-group select="$pass1/*/*" group-starting-with="html:PAGEBREAK">
                     <xsl:choose>
                        <xsl:when test="self::html:PAGEBREAK">
                           <xsl:call-template name="pageperfile">
                              <xsl:with-param name="page" select="self::html:PAGEBREAK/@name"/>
                           </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:copy-of select="current-group()"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:for-each-group>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:for-each-group select="$pass1/*"
                     group-ending-with="*[(position() mod 40) = 0]">
                     <xsl:call-template name="pageperfile">
                        <xsl:with-param name="page">
                           <xsl:text>page</xsl:text>
                           <xsl:value-of select="position()"/>
                        </xsl:with-param>
                     </xsl:call-template>
                  </xsl:for-each-group>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <xsl:comment>TEI front</xsl:comment>
            <xsl:apply-templates select="tei:text/tei:front"/>
            <xsl:if
               test="$autoToc = 'true' and (descendant::tei:div or descendant::tei:div1) and not(descendant::tei:divGen[@type = 'toc'])">
               <h2>
                  <xsl:sequence select="tei:i18n('tocWords')"/>
               </h2>
               <xsl:call-template name="mainTOC"/>
            </xsl:if>
            <xsl:comment>TEI body</xsl:comment>
            <xsl:apply-templates select="tei:text/tei:body"/>
            <xsl:comment>TEI back</xsl:comment>
            <xsl:apply-templates select="tei:text/tei:back"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="printNotes"/>
   </xsl:template>

   <xsl:template name="pageperfile">
      <xsl:param name="page"/>
      <xsl:variable name="outName">
         <xsl:call-template name="outputChunkName">
            <xsl:with-param name="ident">
               <xsl:value-of select="$page"/>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:variable>
      <xsl:if test="$verbose = 'true'">
         <xsl:message>Opening file (pageperfile) <xsl:value-of select="$outName"/></xsl:message>
      </xsl:if>

      <xsl:result-document html-version="{$htmlVersion}" normalization-form="{$normalizationForm}"
         encoding="{$outputEncoding}" href="{$outName}" method="{$outputMethod}" omit-xml-declaration="{$omitXMLDeclaration}">
         <html>
            <xsl:call-template name="addLangAtt"/>
            <xsl:variable name="pagetitle">
               <xsl:sequence select="tei:generateTitle(.)"/>
               <xsl:text> page </xsl:text>
               <xsl:value-of select="$page"/>
            </xsl:variable>
            <xsl:sequence select="tei:htmlHead($pagetitle, 8)"/>
            <body>
               <xsl:apply-templates select="current-group()" mode="copy"/>
            </body>
         </html>
      </xsl:result-document>
      <xsl:choose>
         <xsl:when test="not(@facs)"/>
         <xsl:when test="starts-with(@facs, 'unknown:')"/>
         <xsl:otherwise>
            <xsl:variable name="outNameFacs">
               <xsl:call-template name="outputChunkName">
                  <xsl:with-param name="ident">
                     <xsl:value-of select="$page"/>
                     <xsl:text>-facs</xsl:text>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:variable>
            <xsl:result-document html-version="{$htmlVersion}" normalization-form="{$normalizationForm}"
               encoding="{$outputEncoding}" href="{$outNameFacs}" method="{$outputMethod}" omit-xml-declaration="{$omitXMLDeclaration}">
                <html>
                  <xsl:call-template name="addLangAtt"/>
                  <xsl:variable name="pagetitle">
                     <xsl:sequence select="tei:generateTitle(.)"/>
                     <xsl:text> page </xsl:text>
                     <xsl:value-of select="$page"/>
                     <xsl:text> (facsimile) </xsl:text>
                  </xsl:variable>
                  <xsl:sequence select="tei:htmlHead($pagetitle, 9)"/>
                  <body style="margin:0;padding:0">
                     <p>
                        <img src="{@facs}" class="fullpage" alt="page facsimile"/>
                     </p>
                  </body>
               </html>
            </xsl:result-document>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="html:PAGEBREAK" mode="copy"/>
   <xsl:template match="html:*" mode="copy">
      <xsl:copy-of select="."/>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] </desc>
   </doc>
   <xsl:template name="stdfooter">
      <xsl:param name="style" select="'plain'"/>
      <xsl:param name="file"/>
      <xsl:variable name="date">
         <xsl:sequence select="tei:generateDate(.)"/>
      </xsl:variable>
      <xsl:variable name="author">
         <xsl:sequence select="tei:generateAuthor(.)"/>
      </xsl:variable>
      <div class="stdfooter autogenerated">
         <xsl:if test="$linkPanel = 'true'">
            <div class="footer">
               <xsl:comment>standard links to project, institution etc</xsl:comment>
               <xsl:if test="not($parentURL = '')">
                  <a class="{$style}" href="{$parentURL}">
                     <xsl:value-of select="$parentWords"/>
                  </a>
                  <xsl:value-of select="$separator"/>
               </xsl:if>

               <xsl:if test="not($homeURL = '')">
                  <a class="{$style}" href="{$homeURL}">
                     <xsl:value-of select="$homeWords"/>
                  </a>
                  <xsl:value-of select="$separator"/>
               </xsl:if>

               <xsl:if test="not($searchURL = '')">
                  <a class="{$style}" href="{$searchURL}">
                     <xsl:sequence select="tei:i18n('searchWords')"/>
                  </a>
                  <xsl:value-of select="$separator"/>
               </xsl:if>

               <xsl:if test="not($feedbackURL = '')">
                  <a class="{$style}" href="{$feedbackURL}">
                     <xsl:sequence select="tei:i18n('feedbackWords')"/>
                  </a>
                  <xsl:value-of select="$separator"/>
               </xsl:if>
            </div>
         </xsl:if>
         <xsl:call-template name="preAddressHook"/>
         <address>
            <xsl:if test="not($author = '')">
               <xsl:value-of select="$author"/>. </xsl:if>
            <xsl:sequence select="tei:i18n('dateWord')"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="$date"/>
            <br/>
            <xsl:call-template name="copyrightStatement"/>
            <xsl:if test="$generationComment = 'true'">
               <xsl:comment>
		 <xsl:text>&#x0A; Generated </xsl:text>
		 <xsl:if test="not($masterFile = 'index')">
                   <xsl:text>from </xsl:text>
                   <xsl:value-of select="$masterFile"/>
		 </xsl:if>
		 <xsl:text> using XSLT stylesheets version </xsl:text>
		 <xsl:value-of select="tei:stylesheetVersion()"/>
		 based on <xsl:value-of select="$teixslHome"/>
		 on <xsl:sequence select="tei:whatsTheDate()"/>.
		 <xsl:choose>
		   <xsl:when test="$useFixedDate = 'true'">
		     <xsl:value-of select="system-property('xsl:product-name')"/>.
		   </xsl:when>
		   <xsl:otherwise>
		     <xsl:value-of select="(system-property('xsl:product-name'), system-property('xsl:product-version'))" separator=" "/>.
		   </xsl:otherwise>
		 </xsl:choose>
               </xsl:comment>
            </xsl:if>
         </address>
      </div>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] <param name="title">title</param>
      </desc>
   </doc>
   <xsl:template name="stdheader">
      <xsl:param name="title">(no title)</xsl:param>
      <xsl:choose>
         <xsl:when test="$pageLayout = 'Simple'">
            <xsl:if test="not($institution = '')">
               <h2 class="institution">
                  <xsl:value-of select="$institution"/>
               </h2>
            </xsl:if>
            <xsl:if test="not($department = '')">
               <h2 class="department">
                  <xsl:value-of select="$department"/>
               </h2>
            </xsl:if>

            <xsl:call-template name="makeHTMLHeading">
               <xsl:with-param name="class">maintitle</xsl:with-param>
               <xsl:with-param name="text">
                  <xsl:copy-of select="$title"/>
               </xsl:with-param>
               <xsl:with-param name="level">1</xsl:with-param>
            </xsl:call-template>

            <xsl:call-template name="makeHTMLHeading">
               <xsl:with-param name="class">subtitle</xsl:with-param>
               <xsl:with-param name="text">
                  <xsl:sequence select="tei:generateSubTitle(.)"/>
               </xsl:with-param>
               <xsl:with-param name="level">2</xsl:with-param>
            </xsl:call-template>

            <xsl:if test="$showTitleAuthor = 'true'">
               <xsl:if test="$verbose = 'true'">
                  <xsl:message>displaying author and date</xsl:message>
               </xsl:if>
               <xsl:call-template name="makeHTMLHeading">
                  <xsl:with-param name="class">subtitle</xsl:with-param>
                  <xsl:with-param name="text">
                     <xsl:call-template name="generateAuthorList"/>
                     <xsl:sequence select="tei:generateDate(.)"/>
                     <xsl:sequence select="tei:generateEdition(.)"/>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="makeHTMLHeading">
               <xsl:with-param name="class">maintitle</xsl:with-param>
               <xsl:with-param name="text">
                  <xsl:value-of select="$title"/>
               </xsl:with-param>
               <xsl:with-param name="level">1</xsl:with-param>
            </xsl:call-template>

            <xsl:call-template name="makeHTMLHeading">
               <xsl:with-param name="class">subtitle</xsl:with-param>
               <xsl:with-param name="text">
                  <xsl:sequence select="tei:generateTitle(.)"/>
               </xsl:with-param>
               <xsl:with-param name="level">2</xsl:with-param>
            </xsl:call-template>

            <xsl:if test="$showTitleAuthor = 'true'">
               <xsl:if test="$verbose = 'true'">
                  <xsl:message>displaying author and date</xsl:message>
               </xsl:if>
               <xsl:call-template name="generateAuthorList"/>
               <xsl:sequence select="tei:generateDate(.)"/>
               <xsl:sequence select="tei:generateEdition(.)"/>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] </desc>
   </doc>
   <xsl:template name="subtoc">
      <xsl:if
         test="child::tei:div | tei:div1 | tei:div2 | tei:div3 | tei:div4 | tei:div5 | tei:div6">
         <xsl:variable name="parent">
            <xsl:choose>
               <xsl:when test="ancestor::tei:div">
                  <xsl:apply-templates mode="ident" select="ancestor::tei:div[last()]"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:apply-templates mode="ident" select="."/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:variable name="depth">
            <xsl:apply-templates mode="depth" select="."/>
         </xsl:variable>
         <p>
            <span class="subtochead">
               <xsl:sequence select="tei:i18n('tocWords')"/>
            </span>
         </p>
         <div class="subtoc">
            <ul class="subtoc">
               <xsl:for-each
                  select="tei:div | tei:div1 | tei:div2 | tei:div3 | tei:div4 | tei:div5 | tei:div6">
                  <xsl:variable name="innerdent">
                     <xsl:apply-templates mode="generateLink" select="."/>
                  </xsl:variable>
                  <li class="subtoc">
                     <xsl:call-template name="makeInternalLink">
                        <xsl:with-param name="dest">
                           <xsl:value-of select="$innerdent"/>
                        </xsl:with-param>
                        <xsl:with-param name="class">
                           <xsl:value-of select="$class_subtoc"/>
                        </xsl:with-param>
                        <xsl:with-param name="body">
                           <xsl:call-template name="header">
                              <xsl:with-param name="display">simple</xsl:with-param>
                           </xsl:call-template>
                        </xsl:with-param>
                     </xsl:call-template>
                  </li>
               </xsl:for-each>
            </ul>
         </div>
      </xsl:if>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] </desc>
   </doc>
   <xsl:template name="summaryToc">
      <div class="teidiv">
         <p>Select headings on the left-hand side to see more explanation of the links on the
            right.</p>
         <table cellspacing="7">
            <thead>
               <tr>
                  <th nowrap="nowrap"/>
                  <th/>
               </tr>
            </thead>
            <tbody>
               <xsl:for-each select="//tei:body/tei:div">
                  <xsl:text>&#10;</xsl:text>
                  <tr class="summaryline">
                     <td align="right" class="summarycell" style="vertical-align:top;">
                        <b>
                           <a class="nolink">
                              <xsl:attribute name="href">
                                 <xsl:apply-templates mode="generateLink" select="."/>
                              </xsl:attribute>
                              <xsl:value-of select="tei:head"/>
                           </a>
                        </b>
                     </td>
                     <td class="link" style="vertical-align:top;">
                        <xsl:for-each select=".//xref | .//xptr">
                           <xsl:if test="position() &gt; 1">
                              <xsl:text>&#160;</xsl:text>
                              <img alt="*" src="/images/dbluball.gif"/>
                              <xsl:text> </xsl:text>
                           </xsl:if>
                           <span class="nowrap">
                              <xsl:apply-templates select="."/>
                           </span>
                        </xsl:for-each>
                     </td>
                  </tr>
               </xsl:for-each>
            </tbody>
         </table>
      </div>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] Make a TOC section <param name="style">CSS style to use</param>
         <param name="id">ID to link to</param>
         <param name="force">whether to force a TOC entry even if other rules would normally prevent
            it</param>
      </desc>
   </doc>
   <xsl:template name="tocSection">
      <xsl:param name="style"/>
      <xsl:param name="id"/>
      <xsl:param name="force">false</xsl:param>
      <xsl:choose>
         <xsl:when test="tei:div1">
            <xsl:for-each select="tei:div1[tei:head or $autoHead = 'true']">
               <xsl:call-template name="tocEntry">
                  <xsl:with-param name="style" select="$style"/>
                  <xsl:with-param name="id" select="$id"/>
               </xsl:call-template>
            </xsl:for-each>
         </xsl:when>
         <xsl:when test="tei:div2 and (number($splitLevel) &gt;= 1 or $force = 'true')">
            <xsl:for-each select="tei:div2[tei:head or $autoHead = 'true']">
               <xsl:call-template name="tocEntry">
                  <xsl:with-param name="style" select="$style"/>
                  <xsl:with-param name="id" select="$id"/>
               </xsl:call-template>
            </xsl:for-each>
         </xsl:when>
         <xsl:when test="tei:div3 and (number($splitLevel) &gt;= 2 or $force = 'true')">
            <xsl:for-each select="tei:div3[tei:head or $autoHead = 'true']">
               <xsl:call-template name="tocEntry">
                  <xsl:with-param name="style" select="$style"/>
                  <xsl:with-param name="id" select="$id"/>
               </xsl:call-template>
            </xsl:for-each>
         </xsl:when>
         <xsl:when test="self::tei:div">
            <xsl:variable name="depth">
               <xsl:apply-templates mode="depth" select="."/>
            </xsl:variable>
            <xsl:if
               test="(number($splitLevel) &gt; number($depth) or $force = 'true' or ancestor::tei:TEI/tei:match(@rend, 'nosplit'))">
               <xsl:for-each select="tei:div[tei:head or $autoHead = 'true']">
                  <xsl:call-template name="tocEntry">
                     <xsl:with-param name="style" select="$style"/>
                     <xsl:with-param name="id" select="$id"/>
                  </xsl:call-template>
               </xsl:for-each>
            </xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:for-each select="tei:div[tei:head or $autoHead = 'true']">
               <xsl:call-template name="tocEntry">
                  <xsl:with-param name="style" select="$style"/>
                  <xsl:with-param name="id" select="$id"/>
               </xsl:call-template>
            </xsl:for-each>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] Make a TOC entry <param name="style">style</param>
         <param name="id">id</param>
      </desc>
   </doc>
   <xsl:template name="tocEntry">
      <xsl:param name="style"/>
      <xsl:param name="id"/>
      <xsl:element name="{$tocElement}">
         <xsl:attribute name="class">
            <xsl:value-of select="$style"/>
            <xsl:apply-templates mode="depth" select="."/>
         </xsl:attribute>
         <xsl:choose>
            <xsl:when test="generate-id(.) = $id">
               <span class="toclist-this">
                  <xsl:call-template name="header">
                     <xsl:with-param name="display">simple</xsl:with-param>
                  </xsl:call-template>
               </span>
            </xsl:when>
            <xsl:otherwise>
               <a>
                  <xsl:attribute name="class">
                     <xsl:value-of select="$style"/>
                  </xsl:attribute>
                  <xsl:attribute name="href">
                     <xsl:apply-templates mode="generateLink" select="."/>
                  </xsl:attribute>
                  <xsl:call-template name="header">
                     <xsl:with-param name="display">simple</xsl:with-param>
                  </xsl:call-template>
               </a>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:text>&#10;</xsl:text>
         <xsl:call-template name="tocSection">
            <xsl:with-param name="style" select="$style"/>
            <xsl:with-param name="id" select="$id"/>
            <xsl:with-param name="force">
               <xsl:if test="generate-id(.) = $id">true</xsl:if>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] </desc>
   </doc>
   <xsl:template name="topNavigation">
      <xsl:if test="ancestor::teiCorpus">
         <xsl:element name="{if ($outputTarget=('html5', 'html')) then 'nav' else 'div'}">
            <xsl:attribute name="class" select="$alignNavigationPanel"/>
            <xsl:call-template name="nextLink"/>
            <xsl:call-template name="previousLink"/>
            <xsl:call-template name="upLink">
               <xsl:with-param name="up" select="concat($masterFile, $standardSuffix)"/>
               <xsl:with-param name="title">
                  <xsl:call-template name="contentsWord"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:element>
      </xsl:if>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] <param name="up">the link to which "Up" goes</param>
         <param name="title">the text of the link</param>
      </desc>
   </doc>
   <xsl:template name="upLink">
      <xsl:param name="up"/>
      <xsl:param name="title"/>
      <xsl:if test="$up">
         <span class="upLink">
            <xsl:text> </xsl:text>
            <xsl:sequence select="tei:i18n('upWord')"/>
            <xsl:call-template name="navInterSep"/>
         </span>
         <a class="navigation">
            <xsl:choose>
               <xsl:when test="$title">
                  <xsl:attribute name="href">
                     <xsl:value-of select="$up"/>
                  </xsl:attribute>
                  <xsl:value-of select="$title"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:attribute name="href">
                     <xsl:apply-templates mode="generateLink" select="$up"/>
                  </xsl:attribute>
                  <xsl:for-each select="$up">
                     <xsl:call-template name="headerLink">
                        <xsl:with-param name="minimal" select="$minimalCrossRef"/>
                     </xsl:call-template>
                  </xsl:for-each>
               </xsl:otherwise>
            </xsl:choose>
         </a>
      </xsl:if>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] <param name="path">path</param>
         <param name="class">class</param>
         <param name="whole">whole</param>
      </desc>
   </doc>
   <xsl:template name="walkTree">
      <xsl:param name="path"/>
      <xsl:param name="class"/>
      <xsl:param name="whole"/>
      <xsl:param name="currentID"/>
      <xsl:choose>
         <xsl:when test="contains($path, '/')">
            <xsl:variable name="current">
               <xsl:value-of select="substring-before($path, '/')"/>
            </xsl:variable>
            <xsl:variable name="rest">
               <xsl:value-of select="substring-after($path, '/')"/>
            </xsl:variable>
            <xsl:call-template name="aCrumb">
               <xsl:with-param name="crumbBody">
                  <xsl:choose>
                     <xsl:when test="$rest = 'index.xml' and $requestedID = '' and $currentID = ''">
                        <xsl:value-of select="$current"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <a class="{$class}">
                           <xsl:attribute name="href">
                              <xsl:value-of select="$whole"/>
                              <xsl:value-of select="$current"/>
                              <xsl:text>/</xsl:text>
                           </xsl:attribute>
                           <xsl:value-of select="$current"/>
                        </a>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="walkTree">
               <xsl:with-param name="class">
                  <xsl:value-of select="$class"/>
               </xsl:with-param>
               <xsl:with-param name="currentID">
                  <xsl:value-of select="$currentID"/>
               </xsl:with-param>
               <xsl:with-param name="path" select="$rest"/>
               <xsl:with-param name="whole">
                  <xsl:value-of select="$whole"/>
                  <xsl:value-of select="$current"/>
                  <xsl:text>/</xsl:text>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:choose>
               <xsl:when test="not($currentID = '')">
                  <xsl:call-template name="aCrumb">
                     <xsl:with-param name="crumbBody">
                        <xsl:value-of select="$currentID"/>
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:when>
               <xsl:when test="not($path = 'index.xml')">
                  <xsl:call-template name="aCrumb">
                     <xsl:with-param name="crumbBody">
                        <a class="{$class}">
                           <xsl:attribute name="href">
                              <xsl:value-of select="$whole"/>
                              <xsl:value-of select="$path"/>
                           </xsl:attribute>
                           <xsl:value-of select="$path"/>
                        </a>
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:when>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] </desc>
   </doc>
   <xsl:template name="writeDiv">
      <xsl:variable name="BaseFile">
         <xsl:value-of select="$masterFile"/>
         <xsl:call-template name="addCorpusID"/>
      </xsl:variable>
      <html>
         <xsl:call-template name="addLangAtt"/>
         <xsl:variable name="pagetitle">
            <xsl:choose>
               <xsl:when test="tei:head">
                  <xsl:apply-templates select="tei:head" mode="plain"/>
               </xsl:when>
               <xsl:when test="self::tei:TEI">
                  <xsl:value-of select="tei:generateTitle(.)"/>
               </xsl:when>
               <xsl:when test="self::tei:text">
                  <xsl:value-of select="tei:generateTitle(ancestor::tei:TEI)"/>
                  <xsl:value-of select="concat('[', position(), ']')"/>
               </xsl:when>
               <xsl:otherwise>&#160;</xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:sequence select="tei:htmlHead($pagetitle, 2)"/>
         <body id="TOP">
            <xsl:call-template name="bodyMicroData"/>
            <xsl:call-template name="bodyJavascriptHook"/>
            <xsl:call-template name="bodyHook"/>
            <div class="teidiv">
               <xsl:call-template name="stdheader">
                  <xsl:with-param name="title">
                     <xsl:call-template name="header"/>
                  </xsl:with-param>
               </xsl:call-template>
               <xsl:if test="$topNavigationPanel = 'true'">
                  <xsl:element name="{if ($outputTarget=('html5', 'html')) then 'nav' else 'div'}">
                     <xsl:call-template name="xrefpanel">
                        <xsl:with-param name="homepage" select="concat($BaseFile, $standardSuffix)"/>
                        <xsl:with-param name="mode" select="local-name(.)"/>
                     </xsl:call-template>
                  </xsl:element>
               </xsl:if>
               <xsl:if test="$subTocDepth &gt;= 0">
                  <xsl:call-template name="subtoc"/>
               </xsl:if>
               <xsl:call-template name="startHook"/>
               <xsl:call-template name="makeDivBody">
                  <xsl:with-param name="depth" select="count(ancestor::tei:div) + 1"/>
               </xsl:call-template>
               <xsl:call-template name="printNotes"/>
               <xsl:if test="$bottomNavigationPanel = 'true'">
                  <xsl:element name="{if ($outputTarget=('html5', 'html')) then 'nav' else 'div'}">
                     <xsl:call-template name="xrefpanel">
                        <xsl:with-param name="homepage" select="concat($BaseFile, $standardSuffix)"/>
                        <xsl:with-param name="mode" select="local-name(.)"/>
                     </xsl:call-template>
                  </xsl:element>
               </xsl:if>
               <xsl:call-template name="stdfooter"/>
               <xsl:call-template name="bodyEndHook"/>
            </div>
         </body>
      </html>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html]provide a class attribute and/or ID for each div <param name="depth">depth of
            section (1, 2 3, 4 etc)</param>
      </desc>
   </doc>
   <xsl:template name="divClassAttribute">
      <xsl:param name="depth"/>
      <xsl:if test="@its:dir">
         <xsl:attribute name="dir" select="@its:dir"/>
      </xsl:if>
      <xsl:call-template name="makeRendition">
         <xsl:with-param name="default">
            <xsl:choose>
               <xsl:when test="@type">
                  <xsl:value-of select="@type"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:text>teidiv</xsl:text>
                  <xsl:value-of select="$depth"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:with-param>
      </xsl:call-template>
      <xsl:variable name="ident">
         <xsl:apply-templates mode="ident" select="."/>
      </xsl:variable>
      <xsl:attribute name="id">
         <xsl:value-of select="$ident"/>
      </xsl:attribute>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] <param name="homepage">homepage</param>
         <param name="mode">mode</param>
      </desc>
   </doc>
   <xsl:template name="xrefpanel">
      <xsl:param name="homepage"/>
      <xsl:param name="mode"/>
      <xsl:attribute name="class" select="$alignNavigationPanel"/>
      <xsl:call-template name="generateUpLink"/>
      <xsl:if test="not(ancestor-or-self::tei:TEI[tei:match(@rend, 'nomenu')])">
         <xsl:call-template name="previousLink"/>
         <xsl:call-template name="nextLink"/>
      </xsl:if>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] </desc>
   </doc>
   <xsl:template match="tei:floatingText">
      <div class="floatingText">
         <xsl:apply-templates select="@xml:id"/>
         <xsl:for-each select="tei:front">
            <div class="floatingText_front">
               <xsl:apply-templates select="@xml:id | node()"/>
            </div>
         </xsl:for-each>
         <xsl:for-each select="tei:body">
            <div class="floatingText_body">
               <xsl:apply-templates select="@xml:id | node()"/>
            </div>
         </xsl:for-each>
         <xsl:for-each select="tei:back">
            <div class="floatingText_back">
               <xsl:apply-templates select="@xml:id | node()"/>
            </div>
         </xsl:for-each>
         <xsl:call-template name="printNotes"/>
      </div>
   </xsl:template>

   <xsl:template match="tei:trailer">
      <div class="trailer">
         <xsl:apply-templates/>
      </div>
   </xsl:template>

</xsl:stylesheet>
