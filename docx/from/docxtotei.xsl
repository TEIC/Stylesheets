<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:prop="http://schemas.openxmlformats.org/officeDocument/2006/custom-properties"
                xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
                xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:dcmitype="http://purl.org/dc/dcmitype/"
                xmlns:iso="http://www.iso.org/ns/1.0"
                xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main"
                xmlns:mv="urn:schemas-microsoft-com:mac:vml"
                xmlns:o="urn:schemas-microsoft-com:office:office"
                xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"
                xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
                xmlns:rel="http://schemas.openxmlformats.org/package/2006/relationships"
                xmlns:tbx="http://www.lisa.org/TBX-Specification.33.0.html"
		xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:teidocx="http://www.tei-c.org/ns/teidocx/1.0"
                xmlns:v="urn:schemas-microsoft-com:vml"
                xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006"
                xmlns:w10="urn:schemas-microsoft-com:office:word"
                xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
                xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
                
                xmlns="http://www.tei-c.org/ns/1.0"
                version="2.0"
                exclude-result-prefixes="#all">

	  <xsl:import href="../../common/functions.xsl"/>
	  <xsl:import href="../../common/identity.xsl"/>
	  <xsl:import href="functions.xsl"/>
	  <xsl:import href="../variables.xsl"/>
	  <xsl:import href="omml2mml.xsl"/>
	  <xsl:import href="pass0.xsl"/>
	  <xsl:import href="pass2.xsl"/>
	
	  
	  <xsl:param name="convertGraphics">true</xsl:param>	  
	  <xsl:param name="mathMethod">mml</xsl:param>	  
	  <xsl:param name="termMethod">tei</xsl:param>	  
	  <xsl:param name="tableMethod">tei</xsl:param>	  
	  <xsl:param name="preserveWordSections">false</xsl:param>	  
	  <xsl:param name="preserveWordHeadersFooters">false</xsl:param>    	  
	  <xsl:param name="preserveSoftPageBreaks">false</xsl:param>    	  
	  <xsl:param name="preserveEffects">true</xsl:param><!-- was false -->	  
	  <xsl:param name="preserveFontSizeChanges">true</xsl:param><!-- was false -->
	  <xsl:param name="preserveObject">false</xsl:param>
	  <xsl:param name="preserveSpace">false</xsl:param>
	  <xsl:param name="verbose">false</xsl:param>	  
	  <xsl:param name="processChangeInformation">false</xsl:param>
	  <xsl:param name="pageHeight">890</xsl:param>
	  <xsl:param name="pageWidth">576</xsl:param>


	  <xsl:include href="fields.xsl"/>
	  <xsl:include href="toc.xsl"/>
	  <xsl:include href="graphics.xsl"/>
	  <xsl:include href="lists.xsl"/>
	  <xsl:include href="marginals.xsl"/>
	  <xsl:include href="maths.xsl"/>
	  <xsl:include href="paragraphs.xsl"/>
	  <xsl:include href="tables.xsl"/>
	  <xsl:include href="textruns.xsl"/>
	  <xsl:include href="wordsections.xsl"/>
	
	
	  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>
         <p> TEI stylesheet for converting Word docx files to TEI </p>
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

	  <xsl:variable name="processor">
		    <xsl:value-of select="system-property('xsl:vendor')"/>
	  </xsl:variable>
	  <xsl:variable name="digits">1234567890</xsl:variable>
	  <xsl:variable name="characters">~!@#$%^&amp;*()&lt;&gt;{}[]|:;,.?`'"=+-_</xsl:variable>


	  <xsl:variable name="wordDirectory">
	    <xsl:value-of
		select="translate($word-directory,'\\','/')"/>
	  </xsl:variable>
	  <xsl:variable name="customProps" select="concat($wordDirectory,'/docProps/custom.xml')"/>
	  <xsl:variable name="docProps" select="concat($wordDirectory,'/docProps/core.xml')"/>
	  <xsl:variable name="numberFile" select="concat($wordDirectory,'/word/numbering.xml')"/>
	  <xsl:variable name="relsDoc" select="concat($wordDirectory,'/word/_rels/document.xml.rels')"/>
	  <xsl:variable name="relsFile"  select="concat($wordDirectory,'/word/_rels/document.xml.rels')"/>
	  <xsl:variable name="styleDoc" select="concat($wordDirectory,'/word/styles.xml')"/>
	<xsl:strip-space elements="*"/>
	  <xsl:preserve-space elements="w:t"/>
	  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

	  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>The main template that starts the conversion from docx to TEI</p>
	 <p><b>IMPORTING STYLESHEETS AND OVERRIDING MATCHED TEMPLATES:</b></p>
		
	<p>When importing a stylesheet (xsl:import) all the templates
	in the imported stylesheet get a lower import-precedence than
	the ones in the importing stylesheet. If the importing
	stylesheet wants to override, let's say a general template to
	match all &lt;w:p&gt; elements where no more specialized rule
	applies it can't, since it will automatically override all
	w:p[somepredicate] template in the imported stylesheet as
	well.  In this case we have outsourced the processing of the
	general template into a named template and all the imported
	stylesheet does is to call the named template. Now, the
	importing stylesheet can simply override the named template,
	and everything works out fine.</p>
		
	<p>See templates: - w:p (mode: paragraph)</p>
	
	<p>Modes:</p>
	<ul>
	  <li>pass0: a normalization process for styles. Can also
	  detect illegal styles.</li>
	  
	  <li>pass2: templates that apply in the second stage
	  of the conversion, cleaning TEI elements created in the
	  first ise."</li>
	  
	  <li>inSectionGroup: defines a template that works on a
	  group of consecutive elements (w:p or w:tbl elements) that
	  form a section (a normal section, not to be confused with
	  w:sectPr).</li>
	  
	  <li>paragraph: defines that the template
	  works on an individual element (usually
	  starting with a w:p element).  </li>
	  
	  <li>iden: simply copies the content</li>
	</ul>
	
      </desc>
   </doc>
   <xsl:template match="/">
     <!-- Do an initial normalization and store everything in $pass0 -->
      <xsl:if test="not(doc-available($relsFile))">
	<xsl:message terminate="yes">The file <xsl:value-of
	select="$relsFile"/> cannot be read</xsl:message>
      </xsl:if>
      <xsl:if test="not(doc-available($styleDoc))">
	<xsl:message terminate="yes">The file <xsl:value-of
	select="$styleDoc"/> cannot be read</xsl:message>
      </xsl:if>
     <xsl:variable name="pass0">
       <xsl:apply-templates mode="pass0"/>
     </xsl:variable>
     
     <!-- Do the main transformation and store everything in the variable pass1 -->
     <xsl:variable name="pass1">
       <xsl:for-each select="$pass0">
	 <xsl:apply-templates/>
       </xsl:for-each>
     </xsl:variable>		  
     

     <!--
	 <xsl:result-document href="/tmp/foo.xml">
	 <xsl:copy-of select="$pass1"/>
	 </xsl:result-document>
     -->

     <!-- Do the final parse and create valid TEI -->

     <xsl:apply-templates select="$pass1" mode="pass2"/>
     
     <xsl:call-template name="fromDocxFinalHook"/>
   </xsl:template>
   
   <xsl:template name="fromDocxFinalHook"/>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
     <desc>Main document template</desc>
   </doc>
	  <xsl:template match="w:document">
	    <TEI>
	      <!-- create teiHeader -->
	      <xsl:call-template name="create-tei-header"/>
	      
	      <!-- convert main and back matter -->
	      <xsl:apply-templates select="w:body"/>
	    </TEI>
	  </xsl:template>


	  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
	    <desc>Create the basic text; worry later about dividing it up
	    </desc>
	  </doc>
	  <xsl:template match="w:body">
	    <text>
	      <!-- Create forme work -->
	      <xsl:call-template name="extract-forme-work"/>
	      
	      <!-- create TEI body -->
	      <body>
		<xsl:call-template name="mainProcess"/>
	      </body>
	    </text>
	  </xsl:template>

	  
	  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
	    <desc>Process the text by high-level divisions
	    </desc>
	  </doc>
	  <xsl:template name="mainProcess">
	    <xsl:param name="extrarow"  tunnel="yes"/>
	    <xsl:param name="extracolumn"   tunnel="yes"/>
	    <!-- 
		 group all paragraphs that form a first level section.
	    -->
	    <xsl:for-each-group select="w:sdt|w:p|w:tbl"
				group-starting-with="w:p[tei:isFirstlevel-heading(.)]">
	      
	      <xsl:choose>
		
		<!-- We are dealing with a first level section, we now have
		     to further divide the section into subsections that we can then
		     finally work on -->
		
		<xsl:when test="tei:is-heading(.)">
		  <xsl:call-template name="group-by-section"/>
		</xsl:when>
		
	      	<xsl:when test="tei:is-front(.)">
	      		<front>
	      			<xsl:apply-templates select="." mode="inSectionGroup"/>
	      		</front>
	      	</xsl:when>
	      	
		<!-- We have found some loose paragraphs. These are most probably
		     front matter paragraps. We can simply convert them without further
		     trying to split them up into sub sections. -->
		<xsl:otherwise>
		  <xsl:apply-templates select="." mode="inSectionGroup"/>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:for-each-group>
	    
	    <!-- I have no idea why I need this, but I apparently do. 
		 //TODO: find out what is going on-->
	    <xsl:apply-templates select="w:sectPr" mode="paragraph"/>
	  </xsl:template>
	  
	  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
	    <desc>
	      <p>Bookmarks in section mode</p>
	      <p>
		There are certain elements that we don't really care about, but that
		force us to regroup everything from the next sibling on.
		
		@see grouping in construction of headline outline.
	      </p>
	    </desc>
	  </doc>
	  <xsl:template match="w:bookmarkStart|w:bookmarkEnd"
			mode="inSectionGroup">
	    <xsl:for-each-group select="current-group() except ." group-adjacent="1">
	      <xsl:apply-templates select="." mode="inSectionGroup"/>
	    </xsl:for-each-group>
	  </xsl:template>


	  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
	    <desc>
	      <p>Bookmarks in normal mode</p>
	      <p>Copy bookmarks for processing in pass 2</p>
	    </desc>
	  </doc>
	  <xsl:template match="w:bookmarkStart|w:bookmarkEnd" >
	    <xsl:choose>
	    <xsl:when test="@w:name='_GoBack'"/>
	    <xsl:when test="starts-with(@w:name,'_')">
	      <xsl:copy-of select="."/>
	    </xsl:when>
	    <xsl:when test="self::w:bookmarkEnd"/>
	    <xsl:otherwise>
	      <ANCHOR>
		<xsl:attribute name="xml:id" select="@w:name"/>
	      </ANCHOR>
	    </xsl:otherwise>
	    </xsl:choose>
	  </xsl:template>
	  
	  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>Grouping consecutive elements that belong together</p>
         <p>
		We are now working on a group of all elements inside some group bounded by
		headings. These need to be further split up into smaller groups for figures,
		list etc. and into individual groups for simple paragraphs...
		</p>
      </desc>
	  </doc>
	  <xsl:template match="w:sdt|w:tbl|w:p" mode="inSectionGroup">
	    
	    <!-- 
		 We are looking for:
		 - Lists -> 1
		 - Table of Contents -> 2
		 - Figures -> 3
		 
		 Anything else is assigned a number of position()+100. This should be
		 sufficient even if we find lots more things to group.
	    -->
	    <xsl:for-each-group 
		select="current-group()"
		group-adjacent="if       (tei:is-list(.))  then 1
				else  if (tei:is-toc(.))   then 2
				else  if (tei:is-figure(.)) then 3
				else  if (tei:is-line(.)) then 4
				else  if (tei:is-caption(.)) then 5
				else  if (tei:is-front(.)) then 6
				else position() + 100">
	      
	      <!-- For each defined grouping call a specific template. If there is no
		   grouping defined, apply templates with mode
		   paragraph -->
	      <xsl:choose>
		<xsl:when test="current-grouping-key()=1">
		  <xsl:call-template name="listSection"/>
		</xsl:when>
		<xsl:when test="current-grouping-key()=2">
		  <xsl:call-template name="tocSection"/>
		</xsl:when>
		<xsl:when test="current-grouping-key()=3">
		  <xsl:call-template name="figureSection"/>
		</xsl:when>
		<xsl:when test="current-grouping-key()=4">
		  <xsl:call-template name="lineSection"/>
		</xsl:when>
		<xsl:when test="current-grouping-key()=5">
		  <xsl:call-template name="captionSection"/>
		</xsl:when>
	      	<xsl:when test="current-grouping-key()=6">
	      		<xsl:call-template name="frontSection"/>
	      	</xsl:when>
	      	<!-- it is not a defined grouping .. apply templates -->
		<xsl:otherwise>
		  <xsl:apply-templates select="." mode="paragraph"/>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:for-each-group>
	  </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Creating a group of a figure</desc>
   </doc>
    <xsl:template name="figureSection">
      <figure>
	<xsl:for-each select="current-group()">
	  <xsl:apply-templates select="." mode="paragraph"/>
	</xsl:for-each>
      </figure>
    </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Creating a group of a caption (figure or table)</desc>
   </doc>
    <xsl:template name="captionSection">
      <CAPTION>
	<xsl:for-each select="current-group()">
	  <xsl:apply-templates select="." mode="paragraph"/>
	</xsl:for-each>
      </CAPTION>
    </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Creating a gloss list</desc>
   </doc>

    <xsl:template name="glossListSection">
      <list type="gloss">
	<xsl:for-each select="current-group()">
	  <xsl:apply-templates select="." mode="paragraph"/>
	</xsl:for-each>
      </list>
    </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Creating a group of a figure</desc>
   </doc>
    <xsl:template name="lineSection">
      <lg>
	<xsl:for-each select="current-group()">
	  <xsl:apply-templates select="." mode="paragraph"/>
	</xsl:for-each>
      </lg>
    </xsl:template>

	<doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
		<desc>Creating a group of a front/title page</desc>
	</doc>
	<xsl:template name="frontSection">
		<titlePage>
			<xsl:for-each select="current-group()">
				<xsl:apply-templates select="." mode="paragraph"/>
			</xsl:for-each>
		</titlePage>
	</xsl:template>
	
	

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Groups the document by headings and thereby creating the document structure. 
      </desc>
   </doc>
   <xsl:template name="group-by-section">
     <xsl:variable name="Style" select="w:pPr/w:pStyle/@w:val"/>
     <xsl:variable name="NextHeader" select="tei:get-nextlevel-header($Style)"/>
     <div>
       <!-- generate the head -->
       <xsl:call-template name="generate-section-heading">
	 <xsl:with-param name="Style" select="$Style"/>
       </xsl:call-template>

       <!-- Process sub-sections -->
       <xsl:for-each-group select="current-group() except ."
			   group-starting-with="w:p[w:pPr/w:pStyle/@w:val=$NextHeader]">
	 <xsl:choose>
	   <xsl:when test="tei:is-heading(.)">
	     <xsl:call-template name="group-by-section"/>
	   </xsl:when>
	   <xsl:otherwise>
	     <xsl:apply-templates select="." mode="inSectionGroup"/>
	   </xsl:otherwise>
	 </xsl:choose>
       </xsl:for-each-group>
     </div>
   </xsl:template>
   

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
     <desc>
       <p>Looks through the document to find forme work related sections.</p>
       <p>
	 Creates a &lt;fw&gt; element for each forme work related section. These include
	 running headers and footers. The corresponding elements in OOXML are w:headerReference
	 and w:footerReference. These elements only define a reference that to a header or
	 footer definition file. The reference itself is resolved in the file word/_rels/document.xml.rels.
       </p>
     </desc>
   </doc>
	  <xsl:template name="extract-forme-work">
	    <xsl:if test="preserveWordHeadersFooters='true'">
		    <xsl:for-each-group select="//w:headerReference|//w:footerReference" group-by="@r:id">
			      <fw>
				        <xsl:attribute name="xml:id">
					          <xsl:value-of select="@r:id"/>
				        </xsl:attribute>
				        <xsl:attribute name="type">
					          <xsl:choose>
						            <xsl:when test="self::w:headerReference">header</xsl:when>
						            <xsl:otherwise>footer</xsl:otherwise>
					          </xsl:choose>
				        </xsl:attribute>

				        <xsl:variable name="rid" select="@r:id"/>
				        <xsl:variable name="h-file">
					          <xsl:value-of select="document($relsDoc)//rel:Relationship[@Id=$rid]/@Target"/>
				        </xsl:variable>

				        <!-- for the moment, just copy content -->
				<xsl:if test="doc-available(concat($wordDirectory,'/word/', $h-file))">
					          <xsl:for-each-group select="document(concat($wordDirectory,'/word/', $h-file))/*[1]/w:*"
                                   group-adjacent="1">
						            <xsl:apply-templates select="." mode="inSectionGroup"/>
					          </xsl:for-each-group>
				        </xsl:if>

			      </fw>
		    </xsl:for-each-group>
	    </xsl:if>
	  </xsl:template>

   <xsl:template match="w:hyperlink">
     <!-- hyperlinks that do not contain any children should *probably* be omitted as in Word they result in nothing visible at all -->
     <xsl:if test="child::node()">
       <xsl:variable name="target">
         <xsl:variable name="rid" select="@r:id"/>
           <xsl:choose>
             <xsl:when test="ancestor::w:endnote">
               <xsl:value-of
              select="document(concat($wordDirectory,'/word/_rels/endnotes.xml.rels'))//rel:Relationship[@Id=$rid]/@Target"/>
             </xsl:when>
             <xsl:when test="ancestor::w:footnote">
               <xsl:value-of
              select="document(concat($wordDirectory,'/word/_rels/footnotes.xml.rels'))//rel:Relationship[@Id=$rid]/@Target"/>
             </xsl:when>
             <xsl:otherwise>
              <xsl:value-of
              select="document($relsDoc)//rel:Relationship[@Id=$rid]/@Target"/>
             </xsl:otherwise>
           </xsl:choose>
         </xsl:variable>
         <xsl:variable name="anchor" select="@w:anchor"/>
         <ref target="{string-join(($target, $anchor), '#')}">
           <xsl:apply-templates/>
         </ref>
     </xsl:if>
   </xsl:template>

   <xsl:template match="w:instrText"/>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>simple teiHeader. For a more sophisticated header, think about overriding
        this template</desc>
    </doc>
    <xsl:template name="create-tei-header">
      <teiHeader>
	<fileDesc>
	  <titleStmt>
	    <title>
	      <xsl:call-template name="getDocTitle"/>
	    </title>
	    <author>
	      <xsl:call-template name="getDocAuthor"/>
	    </author>
	  </titleStmt>
	  <editionStmt>
	    <edition>
	      <date>
		<xsl:call-template name="getDocDate"/>
	      </date>
	    </edition>
	  </editionStmt>
	  <publicationStmt>
	    <p>unknown</p>
	  </publicationStmt>
	  <sourceDesc>
	    <p>Converted from a Word document</p>
	  </sourceDesc>
	</fileDesc>
	<encodingDesc>
	  <xsl:call-template name="generateAppInfo"/>
	</encodingDesc>
	<revisionDesc>
	  <listChange>
	    <change>
	      <date>
		<xsl:value-of select="tei:whatsTheDate()"/>
	      </date>
	      <name>
		<xsl:call-template name="getDocAuthor"/>
	      </name>
	    </change>
	  </listChange>
	</revisionDesc>
      </teiHeader>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>generates a section heading. If you need something specific, feel free
        to overwrite this template</desc>
    </doc>
    <xsl:template name="generate-section-heading">
        <xsl:param name="Style"/>
        <head>
	  <xsl:apply-templates/>
        </head>
    </xsl:template>
    

    <xsl:template name="generateAppInfo">
      <appInfo>
	        <application xml:id="docxtotei" ident="TEI_fromDOCX" version="2.15.0">
	           <label>DOCX to TEI</label>
	        </application>
	        <xsl:if test="doc-available($customProps)">
	           <xsl:for-each select="doc($customProps)/prop:Properties">
	              <xsl:for-each select="prop:property">
	                 <xsl:choose>
		                   <xsl:when test="@name='TEI_fromDOCX'"/>
		                   <xsl:when test="contains(@name,'TEI')">
		                      <application ident="{@name}" version="{.}">
		                         <label>
		                            <xsl:value-of select="@name"/>
		                         </label>
		                      </application>
		                   </xsl:when>
	                 </xsl:choose>
	              </xsl:for-each>
		      <xsl:if test="prop:property[@name='WordTemplateURI']">
			<application ident="WordTemplate" version="{prop:property[@name='WordTemplate']}">
			  <label>Word template file</label>
			  <ptr target="{prop:property[@name='WordTemplateURI']}"/>
			</application>
		      </xsl:if>
	           </xsl:for-each>
	        </xsl:if>
      </appInfo>
    </xsl:template>

    <xsl:template name="getDocTitle">
      <xsl:choose>
	<xsl:when test="doc-available($docProps)">
	  <xsl:value-of select="doc($docProps)/cp:coreProperties/dc:title"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:text>unknown title</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:template>

    <xsl:template name="getDocAuthor">
      <xsl:choose>
	<xsl:when test="doc-available($docProps)">
	  <xsl:value-of select="doc($docProps)/cp:coreProperties/dc:creator"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:text>unknown author</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:template>

    <xsl:template name="getDocDate">
      <xsl:choose>
	<xsl:when test="doc-available($docProps)">
	  <xsl:value-of select="substring-before(doc($docProps)/cp:coreProperties/dcterms:created,'T')"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:text>unknown date</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:template>

    <xsl:template name="identifyChange">
      <xsl:param name="who"/>
      <xsl:attribute name="resp">
	<xsl:text>#</xsl:text>
	<xsl:value-of select="translate($who,' ','_')"/>
      </xsl:attribute>
    </xsl:template>
    
</xsl:stylesheet>
