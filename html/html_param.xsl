<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"                 
    xmlns:html="http://www.w3.org/1999/xhtml"                
    xmlns:xs="http://www.w3.org/2001/XMLSchema"                
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="tei html xs"
    version="3.0">
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>     <p>
    TEI stylesheet customization module for HTML output.</p>
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
  <xsl:key name="INDEX" use="1" match="tei:index"/>
  <xsl:key name="PB" match="tei:pb" use="1"/>
  <xsl:key name="FOOTNOTES" use="1"  match="tei:note[not(ancestor::tei:floatingText)][tei:isFootNote(.)]"/>
  <xsl:key name="ENDNOTES" use="1"  match="tei:note[not(ancestor::tei:floatingText)][tei:isEndNote(.)]"/>
  <xsl:key name="ALLNOTES" use="1"  match="tei:note[not(ancestor::tei:floatingText)][not(@place='margin' or @place='inline' or @place='display')
		  and not(parent::tei:bibl or  ancestor::tei:teiHeader)]"/>
  <xsl:key name="TREES" match="tei:eTree[not(ancestor::tei:eTree)]" use="1"/>
  <xsl:key name="TREES" match="tei:forest" use="1"/>


  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout" type="string">
    <desc>Separator between items in header, footer etc</desc>
  </doc>
  <xsl:param name="separator">
    <xsl:text>&#160;</xsl:text>
  </xsl:param>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout" type="string">
    <desc>which JavaScript library to use for drawing trees</desc>
  </doc>
  <xsl:param name="treestyle">googlechart</xsl:param>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="CSS" type="string">
    <desc>  CSS class for links derived from &lt;ptr&gt;    </desc>
  </doc>
  <xsl:param name="class_ptr">ptr</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="CSS" type="string">
      <desc>CSS class for links derived from &lt;ref&gt;</desc>

   </doc>
  <xsl:param name="class_ref">ref</xsl:param>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout" type="boolean">
      <desc>Whether we should construct a separate file for each page
      (based on page breaks)</desc>
   </doc>
  <xsl:param name="filePerPage">false</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout" type="number">
      <desc>When making fixed format epub, width of viewport</desc>
  </doc>
  <xsl:param name="viewPortWidth">1200</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout" type="number">
      <desc>When making fixed format epub, height of viewport</desc>
  </doc>
  <xsl:param name="viewPortHeight">1700</xsl:param>


  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout" type="boolean">
      <desc>Link back from footnotes to reference</desc>

   </doc>
  <xsl:param name="footnoteBackLink">false</xsl:param>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="cssFileInclude"
        type="boolean">
      <desc>Whether to include CSS by reference or by XInclusion</desc>

   </doc>
  <xsl:param name="cssFileInclude">false</xsl:param>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="CSS" type="anyURI">
      <desc>CSS style file to be associated with output file(s)</desc>

   </doc>
  <xsl:param name="cssFile" as="xs:string">https://www.tei-c.org/release/xml/tei/stylesheet/tei.css</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="CSS" type="anyURI">
      <desc>CSS style file for print; this will be given a media=print attribute.</desc>
   </doc>
  <xsl:param name="cssPrintFile" as="xs:string">https://www.tei-c.org/release/xml/tei/stylesheet/tei-print.css</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="CSS" type="anyURI">
      <desc>Secondary CSS style file; this will be given a media=screen attribute,
so that it does not affect printing. It should be used for screen layout.</desc>
   </doc>
    <xsl:param name="cssSecondaryFile"  as="xs:string" select="''"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="CSS" type="anyURI">
      <desc>CSS file to include in the output file directly; if
      expressed as a relative URI, is relative to the directory from
      which this parameter is defined (Stylesheets/html/).</desc>
   </doc>
    <xsl:param name="cssInlineFiles"  as="xs:string" select="''"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="figures" type="integer">
      <desc>Resolution of images. This is needed to calculate
HTML width and height (in pixels) from supplied dimensions.</desc>

   </doc>
  <xsl:param name="dpi">96</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="figures" type="boolean">
      <desc>Display figures.</desc>
   </doc>
  <xsl:param name="showFigures">true</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="hook">
      <desc>[html] Hook where HTML can be inserted just after &lt;body&gt;</desc>
   </doc>
  <xsl:template name="bodyHook"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="hook">
      <desc>     <p>[html] Hook where HTML can be inserted just before the
    &lt;body&gt; ends.</p>
         <p>This can be used to add a page-wide footer block.</p>
      </desc>
   </doc>
  <xsl:template name="bodyEndHook"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="hook">
      <desc>[html] Hook where JavaScript calls can be inserted  just after &lt;body&gt;</desc>
   </doc>
  <xsl:template name="bodyJavascriptHook"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="hook">
    <desc>     <p>[html] Hook where extra CSS can be inserted</p>      </desc>
   </doc>
  <xsl:template name="cssHook"/>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="hook">
      <desc>     <p>[html] Hook where code can be added to the HTML &lt;head&gt;.</p>
         <p>This would be used to insert &lt;meta&gt; tags.</p>
      </desc>
   </doc>
  <xsl:template name="headHook">
    <!--
    <link href="/favicon.ico" rel="icon" type="image/x-icon"/>
    <link href="/favicon.ico" rel="shortcut icon"
	  type="image/x-icon"/>
    -->
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="hook">
      <desc>[html] Hook where HTML can be inserted when creating an &lt;img&gt;</desc>
   </doc>
  <xsl:template name="imgHook"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="hook">
      <desc>[html] Hook where HTML can be inserted when processing a
    figure</desc>
   </doc>
  <xsl:template name="figureHook"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="hook">
      <desc>[html] Hook where extra JavaScript functions can be defined</desc>
   </doc>
  <xsl:template name="javascriptHook"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="hook">
      <desc>[html] Hook where HTML can be inserted just before the &lt;address&gt;</desc>
   </doc>
  <xsl:template name="preAddressHook"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="hook">
      <desc>[html] Hook where HTML can be inserted at the start of
    processing each section</desc>
   </doc>
  <xsl:template name="startDivHook"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="hook">
      <desc>[html] Hook where HTML can be inserted at the beginning
    of the main text, after the header</desc>
   </doc>
  <xsl:template name="startHook"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="hook">
      <desc>[html] Hook where HTML can be inserted after processing &lt;TEI&gt;</desc>
   </doc>
  <xsl:template name="teiEndHook"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="hook">
      <desc>[html] Hook where HTML can be inserted before processing &lt;TEI&gt;</desc>
   </doc>
  <xsl:template name="teiStartHook"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="hook">
      <desc>[html] Hook where HTML can be inserted when creating an
    &lt;a&gt; element</desc>
   </doc>
  <xsl:template name="xrefHook"/>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="i18n">
      <desc>[html] Make a copyright claim</desc>
   </doc>
  <xsl:template name="copyrightStatement"></xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout">
      <desc>[html] Banner for top of column</desc>
   </doc>
  <xsl:template name="columnHeader">
</xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout" type="string">
      <desc>     <p>How to use the front/body/back matter in creating
columns.</p>
         <p>
	   The choice is between
	   <ul xmlns="http://www.w3.org/1999/xhtml">
	     <li>
	       <b>all</b>: use &lt;front&gt; for left-hand column,
	       use &lt;body&gt; for centre column, and use &lt;back&gt; for
	     right-hand column</li>
	     <li>
	       <b>body</b>: use &lt;body&gt; for right-hand column,
	     generate left-hand with a TOC or whatever</li>
	   </ul>
         </p>
      </desc>
  </doc>
  <xsl:param name="contentStructure">body</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout" type="integer">
      <desc>     <p>The difference between TEI div levels and HTML.
headings.</p>
         <p>TEI &lt;div&gt;s are implicitly or explicitly numbered from 0
upwards; this offset is added to that number to produce an HTML
&lt;Hn&gt; element. So a value of 2 here means that a &lt;div1&gt;
will generate an &lt;h2&gt;</p>
      </desc>
   </doc>
  <xsl:param name="divOffset">2</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout" type="boolean">
      <desc>Make a separate file for footnotes</desc>

   </doc>
  <xsl:param name="footnoteFile">false</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout">
      <desc>[html] Header section across top of page </desc>
   </doc>
  <xsl:template name="hdr">
      <xsl:call-template name="pageHeader">
         <xsl:with-param name="mode"/>
      </xsl:call-template>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout">
      <desc>[html] Navigation bar </desc>
   </doc>
  <xsl:template name="hdr2">
      <xsl:call-template name="navbar"/>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout">
      <desc>[html] Text or action to take at the start of the
    breadcrumb trail </desc>
   </doc>
  <xsl:template name="preBreadCrumbPath"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout">
      <desc>[html] Breadcrumb trail </desc>
   </doc>
  <xsl:template name="hdr3">
      <a href="#rh-col" title="Go to main page content" class="skiplinks">Skip links</a>
      <a class="hide">		 
      <xsl:value-of select="$separator"/>
      </a>
      <xsl:call-template name="crumbPath"/>
      <a class="hide">	
	<xsl:value-of select="$separator"/>
      </a>
      <xsl:if test="not($parentURL='')">
	<a class="bannerright" href="{$parentURL}" title="Go to home page">
	  <xsl:value-of select="$parentWords"/>
	</a>
      </xsl:if>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout">
      <desc>[html]Bottom of left-hand column <param
      name="currentID">ID of selected section</param>
      </desc>
   </doc>
  <xsl:template name="lh-col-bottom">
      <xsl:param name="currentID"/>
      <xsl:call-template name="leftHandFrame">
         <xsl:with-param name="currentID" select="$currentID"/>
      </xsl:call-template>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout">
      <desc>[html]Top of left-hand column </desc>
   </doc>
  <xsl:template name="lh-col-top">
      <xsl:call-template name="searchbox"/>
      <xsl:call-template name="printLink"/>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout">
      <desc>[html] Logo</desc>
   </doc>
  <xsl:template name="logoPicture">
      <a class="framelogo" href="https://www.tei-c.org/Stylesheets/">
         <img src="https://www.tei-c.org/release/common/doc/tei-xsl-common/teixsl.png" vspace="5" width="124"
              height="161"
              border="0"
              alt="created by TEI XSL Stylesheets"/>
      </a>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout">
      <desc>[html] Making elements in HTML &lt;head&gt;<param name="title">The text used to create the DC.Title field
    in the HTML header</param>
      </desc>
   </doc>
  <xsl:template name="metaHTML">
      <xsl:param name="title"/>
      <meta name="author">
         <xsl:attribute name="content">
            <xsl:sequence select="tei:generateMetadataAuthor(.)"/>
         </xsl:attribute>
      </meta>
      <xsl:if test="$filePerPage='true'">
	<meta name="viewport" content="width={$viewPortWidth}, height={$viewPortHeight}"/>
      </xsl:if>
      <meta name="generator" content="Text Encoding Initiative Consortium XSLT stylesheets"/>
      <xsl:choose>
	<xsl:when test="$outputTarget='epub3'">
	  <meta charset="utf-8" />
	</xsl:when>
	<xsl:otherwise>
	  <meta http-equiv="Content-Type" content="text/html; charset={$outputEncoding}"/>
	  <meta name="DC.Title">
	    <xsl:attribute name="content">
	      <xsl:value-of select="normalize-space(translate($title,'&lt;&gt;','&#x2329;&#x3009;'))"/>
	    </xsl:attribute>
	  </meta>
	  <meta name="DC.Type" content="Text"/>
	  <meta name="DC.Format" content="text/html"/>
	</xsl:otherwise>
      </xsl:choose>
  </xsl:template>

	<doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout">
      <desc>     <p>[html] Construction of navigation bar </p>
         <p>A file is looked for relative to the <i xmlns="http://www.w3.org/1999/xhtml">stylesheet</i> (the
    second parameter of the document function), which is expected to
    contain a TEI &lt;list&gt; where each &lt;item&gt; has an embedded
    &lt;xref&gt;</p>
      </desc>
   </doc>
  <xsl:template name="navbar">
    <xsl:choose>
      <xsl:when test="$navbarFile=''">
	<xsl:comment>no nav bar</xsl:comment>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{if ($outputTarget=('html5', 'html')) then 'nav' else 'div'}">
	  <xsl:for-each select="document($navbarFile,document(''))">
	    <xsl:for-each select="tei:list/tei:item">
	      <span class="navbar">
		<a href="{$URLPREFIX}{tei:xref/@url}" class="navbar">
		  <xsl:apply-templates select="tei:xref/text()"/>
		</a>
	      </span>
	      <xsl:if test="following-sibling::tei:item"> 
		<xsl:value-of select="$separator"/>
	      </xsl:if>
	    </xsl:for-each>
	  </xsl:for-each>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout" type="anyURI">
      <desc>     <p>XML resource defining a navigation bar.</p>
         <p>The XML should provide a &lt;list&gt; containing a series
of &lt;item&gt; elements, each containing an &lt;xref&gt; link.</p>
      </desc>
   </doc>
  <xsl:param name="navbarFile"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout">
      <desc>[html] Banner for top of page<param name="mode">layout mode</param>
      </desc>
   </doc>
    
  <xsl:template name="pageHeader">
      <xsl:param name="mode"/>
      <xsl:choose>
         <xsl:when test="$mode='table'">
            <table width="100%" border="0">
               <tr>
                  <td height="98" class="bgimage" onclick="window.location='{$homeURL}'"
                      cellpadding="0">

	                    <xsl:call-template name="makeHTMLHeading">
		                      <xsl:with-param name="class">subtitle</xsl:with-param>
		                      <xsl:with-param name="text">
		                         <xsl:sequence select="tei:generateSubTitle(.)"/>
		                      </xsl:with-param>
		                      <xsl:with-param name="level">2</xsl:with-param>
	                    </xsl:call-template>

	                    <xsl:call-template name="makeHTMLHeading">
		                      <xsl:with-param name="class">title</xsl:with-param>
		                      <xsl:with-param name="text">
		                         <xsl:sequence select="tei:generateTitle(.)"/>
		                      </xsl:with-param>
		                      <xsl:with-param name="level">1</xsl:with-param>
	                    </xsl:call-template>

                  </td>
                  <td style="vertical-align:top;"/>
               </tr>
            </table>
         </xsl:when>
         <xsl:otherwise>
	           <xsl:call-template name="makeHTMLHeading">
	              <xsl:with-param name="class">subtitle</xsl:with-param>
	              <xsl:with-param name="text">
	                 <xsl:sequence select="tei:generateSubTitle(.)"/>
	              </xsl:with-param>
	              <xsl:with-param name="level">2</xsl:with-param>
	           </xsl:call-template>
	
	           <xsl:call-template name="makeHTMLHeading">
	              <xsl:with-param name="class">title</xsl:with-param>
	              <xsl:with-param name="text">
	                 <xsl:sequence select="tei:generateTitle(.)"/>
	              </xsl:with-param>
	              <xsl:with-param name="level">1</xsl:with-param>
	           </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] Make a heading, if there some text to display<param name="text">Heading title</param>
         <param name="class">CSS class</param>
         <param name="level">Heading level</param>
      </desc>
   </doc>
  <xsl:template name="makeHTMLHeading">
      <xsl:param name="text"/>
      <xsl:param name="class">title</xsl:param>
      <xsl:param name="level">1</xsl:param>
      <xsl:if test="not($text='')">
	<xsl:choose>
	<xsl:when test="$level &gt; 6">
	  <div class="h{$level}">
            <xsl:copy-of select="$text"/>
	  </div>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:call-template name="splitHTMLBlocks">
	    <xsl:with-param name="element" select="concat('h',$level)"/>
	    <xsl:with-param name="content" select="$text"/>
	    <xsl:with-param name="class">maintitle</xsl:with-param>
	    <xsl:with-param name="copyid">false</xsl:with-param>
	  </xsl:call-template>
	</xsl:otherwise>
	</xsl:choose>
      </xsl:if>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] Make a link saying how to get printable version
    of file</desc>
   </doc>
  <xsl:template name="printLink"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout">
      <desc>[html] Bottom of right-hand column<param name="currentID">ID of selected section</param>
      </desc>
   </doc>
  <xsl:template name="rh-col-bottom">
      <xsl:param name="currentID"/>
      <xsl:call-template name="mainFrame">
         <xsl:with-param name="currentID" select="$currentID"/>
      </xsl:call-template>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout">
      <desc>[html] Top of right-hand column</desc>
   </doc>
  <xsl:template name="rh-col-top">
      <xsl:call-template name="columnHeader"/>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout">
      <desc>[html] Make a search box</desc>
   </doc>
  <xsl:template name="searchbox"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout">
      <desc>[html] Construct a label for the link which makes a
    printable version of the document.</desc>
   </doc>
  <xsl:template name="singleFileLabel">For Printing</xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="links" type="string">
      <desc>How to align the navigation panel at the bottom of the page</desc>

   </doc>
  <xsl:param name="alignNavigationPanel">right</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="links" type="boolean">
      <desc>Display navigation panel at bottom of pages</desc>

   </doc>
  <xsl:param name="bottomNavigationPanel">true</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="links" type="string">
      <desc>Fixed string to insert before normal page title in HTML meta
&lt;title&gt; element</desc>

   </doc>
  <xsl:param name="htmlTitlePrefix"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="links" type="boolean">
      <desc>Make a panel with next page/previous page links.</desc>

   </doc>
  <xsl:param name="linkPanel">true</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="misc" type="boolean">
      <desc>Generate a unique ID for all paragraphs</desc>

   </doc>
  <xsl:param name="generateParagraphIDs">false</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="misc" type="boolean">
      <desc>Show a title and author at start of document</desc>

   </doc>
  <xsl:param name="showTitleAuthor">false</xsl:param>


  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="misc" type="boolean">
      <desc>Add a comment to web page showing when it was generated,
      stylesheet version, etc</desc>
   </doc>
  <xsl:param name="generationComment">true</xsl:param>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="misc" type="boolean">
      <desc>Be talkative while working.</desc>
   </doc>
  <xsl:param name="verbose">false</xsl:param>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="output" type="string">
      <desc>An ID passed to the stylesheet to indicate which section to display</desc>

   </doc>
  <xsl:param name="ID"/>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="output" type="string">
      <desc>A wrapper around the ID, to allow for other ways of getting it</desc>

   </doc>
  <xsl:param name="requestedID">
      <xsl:value-of select="$ID"/>
  </xsl:param>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="output" type="string">
      <desc>A path fragment to put before all internal URLs </desc>

   </doc>
  <xsl:param name="URLPREFIX"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="output" type="string">
      <desc>The name of the output file</desc>

   </doc>
  <xsl:param name="outputName"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="output" type="string">
      <desc>Directory in which to place generated files.</desc>

   </doc>
  <xsl:param name="outputDir"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="output" type="string">
      <desc>Encoding of output file(s).</desc>

   </doc>
  <xsl:param name="outputEncoding">UTF-8</xsl:param>

  <xsl:param name="outputNamespace">http://www.w3.org/1999/xhtml</xsl:param>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="output" type="string">
      <desc>Output method for output file(s).</desc>
   </doc>
  <xsl:param name="outputMethod">xhtml</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="output" type="string">
    <desc>HTML version of output file(s).</desc>
  </doc>
  <xsl:param name="htmlVersion">5.0</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="output" type="string">
    <desc>Normalization form of output file(s).</desc>
  </doc>
  <xsl:param name="normalizationForm">NFC</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="output" type="string">
    <desc>Omission of XML declaration in output file(s).</desc>
  </doc>
  <xsl:param name="omitXMLDeclaration">yes</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="output" type="string">
      <desc>Suffix of output file(s).</desc>

   </doc>
  <xsl:param name="outputSuffix">.html</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="output" type="string">
      <desc>Public Doctype of output file(s).</desc>

   </doc>

  <xsl:param name="doctypePublic">-//W3C//DTD XHTML 1.0 Transitional//EN</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="output" type="string">
      <desc>System Doctype of output file(s).</desc>

   </doc>
  <xsl:param name="doctypeSystem">http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="output" type="string">
      <desc>     <p>The style of HTML (Simple or Complex) which creates the layout for generated pages.</p>
         <p>The choice is between
<ul xmlns="http://www.w3.org/1999/xhtml">
               <li>
                  <b>Simple</b>: A linear presentation is created</li>
               <li>
                  <b>Complex</b>: The page is created as a series of nested
 &lt;div&gt;s which can be arranged using CSS into a multicolumn
layout</li>
               <li>
                  <b>Table</b>: The page is created as an HTML table</li>
            </ul>
         </p>
      </desc>
   </doc>
  <xsl:param name="pageLayout">Simple</xsl:param>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="output" type="boolean">
      <desc>Break back matter into separate HTML pages (if splitting enabled).</desc>

   </doc>
  <xsl:param name="splitBackmatter">true</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="output" type="boolean">
      <desc>Break front matter into separate HTML pages (if splitting enabled).</desc>

   </doc>
  <xsl:param name="splitFrontmatter">true</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="output" type="integer">
      <desc>     <p>Level at which to split sections.</p>
         <p>When processing a &lt;div&gt; or &lt;div[0-5]&gt;, compare
the nesting depth and see whether to start a new HTML page. Since the
TEI starts with &lt;div1&gt;, setting this parameter to 0 will cause
top-level sections to be split apart. The default is not to split at
all.
</p>
      </desc>
   </doc>
  <xsl:param name="splitLevel">-1</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="output" type="string">
      <desc>Suffix for generated output files.</desc>

   </doc>
  <xsl:param name="standardSuffix">
      <xsl:choose>
         <xsl:when test="tei:teiCorpus">.html</xsl:when>
         <xsl:when test="$STDOUT='true'"/>
         <xsl:otherwise>
	           <xsl:value-of select="$outputSuffix"/>
         </xsl:otherwise>
      </xsl:choose>
  </xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="output" type="boolean">
      <desc>Display navigation panel at top of pages.</desc>

   </doc>
  <xsl:param name="topNavigationPanel">true</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="output" type="string">
      <desc>How to specify infra-document links. When a document is split,
links need to be constructed between parts of the document. 
The default is to use a query parameter on the URL.</desc>

   </doc>
  <xsl:param name="urlChunkPrefix">?ID=</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="output" type="boolean">
      <desc>     <p>Construct links using existing ID values.</p>
         <p>It is often nice if, when making separate files, their names
correspond to the ID attribute of the &gt;div&lt;. Alternatively, you
	  can let the system choose names.</p>
      </desc>
   </doc>
  <xsl:param name="useIDs">true</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="style" type="string">
      <desc>HTML element to put around visible text of display URLs</desc>

   </doc>
  <xsl:param name="urlMarkup">span</xsl:param>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="toc" type="boolean">
      <desc>Make an automatic table of contents</desc>

   </doc>
  <xsl:param name="autoToc">true</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="toc" type="string">
      <desc>CSS class for second-level TOC entries</desc>

   </doc>
  <xsl:param name="class_subtoc">subtoc</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="toc" type="integer">
      <desc>
	<p>Depth at which to stop doing a recursive table of contents.</p>
         <p>You can have a mini table of contents at the start of each
         section. The default is only to construct a TOC at the top
         level; a value of -1 here means no subtoc at all. </p>
      </desc>
   </doc>
  <xsl:param name="subTocDepth">-1</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="toc" type="boolean">
      <desc>Include the back matter in the table of contents.</desc>

   </doc>
  <xsl:param name="tocBack">true</xsl:param>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="toc" type="string">
      <desc>Depth to which table of contents is constructed.</desc>

   </doc>
  <xsl:param name="tocDepth">5</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="toc" type="boolean">
      <desc>Include the front matter in the table of contents.</desc>

   </doc>
  <xsl:param name="tocFront">true</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="toc" type="string">
      <desc>Which HTML element to wrap each TOCs entry in.</desc>

   </doc>
  <xsl:param name="tocElement">p</xsl:param>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="toc" type="string">
      <desc>Which HTML element to wrap each TOC sections in.</desc>

   </doc>
  <xsl:param name="tocContainerElement">div</xsl:param>


  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="toc" type="string">
      <desc>Text to link back to from foot of ODD reference pages</desc>
   </doc>
   <xsl:param name="refDocFooterText">TEI Guidelines</xsl:param>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="toc" type="anyURI">
      <desc>URL to link back to from foot of ODD reference pages</desc>
   </doc>
   <xsl:param name="refDocFooterURL">index.html</xsl:param>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="toc" type="anyURI">
      <desc>Gap between elements in navigation list</desc></doc>
   <xsl:template name="navInterSep">
      <xsl:text>: </xsl:text>
   </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="hook">
      <desc>[html] Hooks where HTML can be inserted when processing
    &lt;egXML&gt; element</desc>
   </doc>
   <xsl:template name="egXMLStartHook"/>
   <xsl:template name="egXMLEndHook"/>

   <xsl:template name="emphasize">
      <xsl:param name="class"/>
      <xsl:param name="content"/>
      <xsl:choose>
         <xsl:when test="$class='titlea'">
            <q class="titlea">
	              <xsl:copy-of select="$content"/>
            </q>
         </xsl:when>
         <xsl:otherwise>
            <span class="{$class}">
	              <xsl:copy-of select="$content"/>
            </span>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

  <xsl:param name="mediaoverlay">false</xsl:param>



  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>[html] break up a block content (h1, p etc) so that it
    breaks around nested  HTML blocks, and turns nested asides
    into spans</desc>
  </doc>
  <xsl:template  name="splitHTMLBlocks">
    <xsl:param name="copyid">true</xsl:param>
    <xsl:param name="element"/>
    <xsl:param name="content"/>
    <xsl:param name="class">false</xsl:param>
    <xsl:variable name="CLASS">
	<tmp1>
	  <xsl:call-template name="makeRendition">
	    <xsl:with-param name="default" select="$class"/>
	  </xsl:call-template>
	</tmp1>
    </xsl:variable>
    <xsl:variable name="ID">
      <tmp2>
	<xsl:choose>
	  <xsl:when test="not($copyid='true')"/>
	  <xsl:when test="@xml:id or ($generateParagraphIDs='true' and $element='p')">
	    <xsl:call-template name="makeAnchor"/>
	  </xsl:when>
	</xsl:choose>
      </tmp2>
    </xsl:variable>
    <xsl:for-each-group select="$content/node()" 		
			group-adjacent="if (self::html:ol or
					self::html:ul or
					self::html:dl or
					self::html:pre or
					self::html:figure or
					self::html:blockquote or
					self::html:div) then 1
					else 2">
      <xsl:choose>
	<xsl:when test="current-grouping-key()=1">
	  <xsl:copy-of select="current-group()"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:element name="{$element}">
	      <xsl:copy-of select="$CLASS/html:tmp1/@*"/>
	      <xsl:if test="position()=1">
		<xsl:copy-of select="$ID/html:tmp2/@*"/>
	      </xsl:if>
	      <xsl:apply-templates select="current-group()" mode="copyhtml"/>
	    </xsl:element>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>

  <xsl:template match="@rowspan|@colspan|@class" mode="copyhtml"/>
  <xsl:template match="comment()|@*|processing-instruction()|text()" mode="copyhtml">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="*" mode="copyhtml">
    <xsl:copy>
      <xsl:copy-of select="@class"/>
      <xsl:apply-templates select="@*|*|processing-instruction()|comment()|text()" mode="copyhtml"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="html:blockquote|html:dt|html:dd|html:aside|html:h1|html:h2|html:h3|html:h4|html:h5|html:h6|html:div|html:p|html:pre|html:figure" mode="copyhtml">
    <span style="display:block">
      <xsl:attribute name="class">
	<xsl:value-of select="(@class, local-name())"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*|*|processing-instruction()|comment()|text()" mode="copyhtml"/>
    </span>
  </xsl:template>

  <xsl:template match="html:ol" mode="copyhtml">
    <span style="list-style-type:decimal;margin-left: 40px ; display:
		 block">
      <xsl:attribute name="class">
	<xsl:value-of select="(@class, local-name())"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*|*|processing-instruction()|comment()|text()" mode="copyhtml"/>
    </span>
  </xsl:template>
  <xsl:template match="html:dl" mode="copyhtml">
    <span class="{local-name()}" style="margin-left: 40px ; display: block">
      <xsl:apply-templates select="@*|*|processing-instruction()|comment()|text()" mode="copyhtml"/>
    </span>
  </xsl:template>
  <xsl:template match="html:ul" mode="copyhtml">
    <span class="{local-name()}" style="margin-left: 40px ; display:block">
      <xsl:attribute name="class">
	<xsl:value-of select="(@class, local-name())"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*|*|processing-instruction()|comment()|text()" mode="copyhtml"/>
    </span>
  </xsl:template>


  <xsl:template match="html:table|html:tr|html:thead|html:tbody|html:td|html:th|html:caption|html:li" mode="copyhtml">
    <span>
      <xsl:attribute name="class">
	<xsl:value-of select="(@class, local-name())"/>
      </xsl:attribute>
      <xsl:attribute name="style">
	<xsl:text>display:</xsl:text>
	<xsl:choose>
	  <xsl:when test="local-name()='table'">table</xsl:when>
	  <xsl:when test="local-name()='tr'">table-row</xsl:when>
	  <xsl:when test="local-name()='thead'">table-header-group</xsl:when>
	  <xsl:when test="local-name()='tbody'">table-row-group</xsl:when>
	  <xsl:when test="local-name()='td'">table-cell</xsl:when>
	  <xsl:when test="local-name()='th'">table-cell</xsl:when>
	  <xsl:when test="local-name()='caption'">table-caption</xsl:when>
	  <xsl:when test="local-name()='li'">list-item</xsl:when>
	</xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates select="@*|*|processing-instruction()|comment()|text()" mode="copyhtml"/>
    </span>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>[html] show an XML element in a verbatim context</desc>
  </doc>

  <xsl:template name="Element">
    <xsl:param name="content"/>
    <span class="element">
      <xsl:copy-of select="$content"/>
    </span>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>[html] show an XML element name in a verbatim context</desc>
  </doc>
  <xsl:template name="ElementName">
    <xsl:param name="content"/>
    <span class="elementname">
      <xsl:copy-of select="$content"/>
    </span>
  </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>[html] show an XML element name highlighted in a verbatim context</desc>
  </doc>
 <xsl:template name="HighlightElementName">
    <xsl:param name="content"/>
    <span class="highlightelementname">
      <xsl:copy-of select="$content"/>
    </span>
  </xsl:template>
  
  <xsl:template name="RefLinkAttributeValue">
    <xsl:param name="content"/>
    <a class="link_odd" href="ref-{$content}.html"><xsl:copy-of select="$content"/></a>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>[html] show an XML attribute value in a verbatim context</desc>
  </doc>

  <xsl:template name="AttributeValue">
    <xsl:param name="content"/>
    <span class="attributevalue">
      <xsl:copy-of select="$content"/>
    </span>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>[html] show an XML attribute in a verbatim context</desc>
  </doc>

  <xsl:template name="Attribute">
    <xsl:param name="content"/>
    <span class="attribute">
      <xsl:copy-of select="$content"/>
    </span>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>[html] show an XML namespace in a verbatim context</desc>
  </doc>
  <xsl:template name="Namespace">
    <xsl:param name="content"/>
    <span class="namespace">
      <xsl:copy-of select="$content"/>
    </span>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>[html] show an XML comment in a verbatim context</desc>
  </doc>
  <xsl:template name="Comment">
    <xsl:param name="content"/>
    <span class="comment">
      <xsl:copy-of select="$content"/>
    </span>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>[html] the content of a list item in a gloss list</desc>
  </doc>
  <xsl:template name="makeLabelItem">
    <dd>
      <xsl:call-template name="makeRendition"/>
      <xsl:if test="@xml:id">
	<xsl:call-template name="makeAnchor"/>
      </xsl:if>
      <xsl:apply-templates/>
    </dd>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>[html] the content of a list item</desc>
  </doc>
  <xsl:template name="makeItem">
    <li>
      <xsl:call-template name="makeRendition"/>
      <xsl:choose>
	<xsl:when test="@xml:id">
	  <xsl:call-template name="makeAnchor"/>
	</xsl:when>
	<xsl:when test="$generateParagraphIDs='true'">
	  <xsl:call-template name="makeAnchor">
	    <xsl:with-param name="name">
	      <xsl:value-of select="generate-id()"/>
	    </xsl:with-param>
	  </xsl:call-template>
	</xsl:when>
      </xsl:choose>
      <xsl:apply-templates/>
    </li>
  </xsl:template>

</xsl:stylesheet>
