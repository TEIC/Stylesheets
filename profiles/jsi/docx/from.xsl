<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns="http://www.tei-c.org/ns/1.0"
                xpath-default-namespace="http://www.tei-c.org/ns/1.0"
                xmlns:teix="http://www.tei-c.org/ns/Examples"
                xmlns:iso="http://www.iso.org/ns/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006"
                xmlns:o="urn:schemas-microsoft-com:office:office"
                xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
                xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
                xmlns:v="urn:schemas-microsoft-com:vml"
		xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
                xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
                xmlns:w10="urn:schemas-microsoft-com:office:word"
                xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                xmlns:tbx="http://www.lisa.org/TBX-Specification.33.0.html"
                xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"       
                xmlns:teidocx="http://www.tei-c.org/ns/teidocx/1.0"
                version="2.0"
                exclude-result-prefixes="#all">

    <!-- import default conversion style -->
    <xsl:import href="/project/tei/convert/Stylesheets/profiles/default/docx/from.xsl"/>

    <!--Key pointing elements (any others?); Remove evil Windows underscore as well -->
    <xsl:key name="ref" match="tei:*" use="fn:replace(@target,'^#_?','#')"/>
    <xsl:key name="spanTo" match="tei:*" use="fn:replace(@spanTarget,'^#_?','#')"/>

    <!-- indent and strip-space: for testing only! -->
    <xsl:output
	cdata-section-elements="eg" 
	indent="yes" 
	/>
    <xsl:strip-space elements="tei:additional tei:address tei:adminInfo
			     tei:altGrp tei:altIdentifier tei:analytic
			     tei:app tei:appInfo tei:application
			     tei:arc tei:argument tei:attDef
			     tei:attList tei:availability tei:back
			     tei:biblFull tei:biblStruct tei:bicond
		             tei:binding tei:bindingDesc tei:body
			     tei:broadcast tei:cRefPattern tei:calendar
			     tei:calendarDesc tei:castGroup
			     tei:castList tei:category tei:certainty
			     tei:char tei:charDecl tei:charProp
			     tei:choice tei:cit tei:classDecl
			     tei:classSpec tei:classes tei:climate
			     tei:cond tei:constraintSpec tei:correction
			     tei:custodialHist tei:decoDesc
			     tei:dimensions tei:div tei:div1 tei:div2
			     tei:div3 tei:div4 tei:div5 tei:div6
			     tei:div7 tei:divGen tei:docTitle tei:eLeaf
			     tei:eTree tei:editionStmt
			     tei:editorialDecl tei:elementSpec
			     tei:encodingDesc tei:entry tei:epigraph
			     tei:epilogue tei:equipment tei:event
			     tei:exemplum tei:fDecl tei:fLib
			     tei:facsimile tei:figure tei:fileDesc
			     tei:floatingText tei:forest tei:front
			     tei:fs tei:fsConstraints tei:fsDecl
			     tei:fsdDecl tei:fvLib tei:gap tei:glyph
			     tei:graph tei:graphic tei:group
			     tei:handDesc tei:handNotes tei:history
			     tei:hom tei:hyphenation tei:iNode tei:if
			     tei:imprint tei:incident tei:index
			     tei:interpGrp tei:interpretation tei:join
			     tei:joinGrp tei:keywords tei:kinesic
			     tei:langKnowledge tei:langUsage
			     tei:layoutDesc tei:leaf tei:lg tei:linkGrp
			     tei:list tei:listBibl tei:listChange
			     tei:listEvent tei:listForest tei:listNym
			     tei:listOrg tei:listPerson tei:listPlace
			     tei:listRef tei:listRelation
			     tei:listTranspose tei:listWit tei:location
			     tei:locusGrp tei:macroSpec tei:metDecl
			     tei:moduleRef tei:moduleSpec tei:monogr
			     tei:msContents tei:msDesc tei:msIdentifier
			     tei:msItem tei:msItemStruct tei:msPart
			     tei:namespace tei:node tei:normalization
			     tei:notatedMusic tei:notesStmt tei:nym
			     tei:objectDesc tei:org tei:particDesc
			     tei:performance tei:person tei:personGrp
			     tei:physDesc tei:place tei:population
			     tei:postscript tei:precision
			     tei:profileDesc tei:projectDesc
			     tei:prologue tei:publicationStmt
			     tei:quotation tei:rdgGrp tei:recordHist
			     tei:recording tei:recordingStmt
			     tei:refsDecl tei:relatedItem tei:relation
			     tei:relationGrp tei:remarks tei:respStmt
			     tei:respons tei:revisionDesc tei:root
			     tei:row tei:samplingDecl tei:schemaSpec
			     tei:scriptDesc tei:scriptStmt tei:seal
			     tei:sealDesc tei:segmentation
			     tei:seriesStmt tei:set tei:setting
			     tei:settingDesc tei:sourceDesc
			     tei:sourceDoc tei:sp tei:spGrp tei:space
			     tei:spanGrp tei:specGrp tei:specList
			     tei:state tei:stdVals tei:subst
			     tei:substJoin tei:superEntry
			     tei:supportDesc tei:surface tei:surfaceGrp
			     tei:table tei:tagsDecl tei:taxonomy
			     tei:teiCorpus tei:teiHeader tei:terrain
			     tei:text tei:textClass tei:textDesc
			     tei:timeline tei:titlePage tei:titleStmt
			     tei:trait tei:transpose tei:tree
			     tei:triangle tei:typeDesc tei:vAlt
			     tei:vColl tei:vDefault tei:vLabel
			     tei:vMerge tei:vNot tei:vRange tei:valItem
			     tei:valList tei:vocal"/>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>
         <p>TEI stylesheet for converting Word docx files to TEI XML</p>
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
<p xml:lang="en">Tomaž Erjavec, JSI</p>
<p xml:lang="sl">Tomaž Erjavec, IJS</p>
<p>JSI 2014-01-25, et</p>
      </desc>
   </doc>

   <!-- This should be true only for text-cricital editions -->
   <xsl:param name="preserveSoftPageBreaks">true</xsl:param>    	  
	  
   <!-- By default this is not set correctly?? -->
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
           <p>JSI profile test</p>
         </publicationStmt>
         <sourceDesc>
           <p xml:lang="en">Converted from a Word (.docx) document</p>
           <p xml:lang="sl">Pretvorjeno iz dokumenta Word (.docx)</p>
         </sourceDesc>
       </fileDesc>
       <encodingDesc>
	 <xsl:call-template name="generateAppInfo"/>
       </encodingDesc>
       <revisionDesc>
	 <change>
	   <date>
	     <xsl:value-of select="tei:whatsTheDate()"/>
	   </date>
	   <name type="person">
	     <xsl:call-template name="getDocAuthor"/>
	   </name>
	 </change>
       </revisionDesc>
     </teiHeader>
   </xsl:template>


   <!-- PASS1 fixes -->

   <!-- Overwiting template from Stylesheets/docx/from/docxtotei.xsl:
	Relax constraints and add more instructions -->
   <xsl:template match="w:instrText">
      <xsl:choose>
         <xsl:when test="contains(.,'REF ')"/>
         <xsl:when test="contains(.,'HYPERLINK ')"/>
         <xsl:when test="contains(.,'XE ')"/>
         <xsl:when test="contains(.,'TOC ')"/>
         <xsl:when test="contains(.,'INDEX ')"/>
         <xsl:when test="contains(.,'MERGEFORMAT ')"/>
	 <xsl:when test="contains(.,'SEQ')"/>
         <xsl:otherwise>
	   <xsl:message>WARN: Instruction text ouput: '<xsl:value-of select="."/>'</xsl:message>
           <xsl:value-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- Overwriting template from Stylesheets/docx/from/paragraphs.xsl -->
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>Not sure what is happening, but giving it a try..</p>
      </desc>
   </doc>
    <xsl:template match="w:p" mode="paragraph">
      <xsl:variable name="style" select="w:pPr/w:pStyle/@w:val"/>
      <xsl:choose>
	<xsl:when test="$style='GeneratedTitle'"/>
	<xsl:when test="$style='GeneratedSubTitle'"/>
	<xsl:when test="$style='Tabletitle'">
	  <head>
	    <xsl:apply-templates/>
	  </head>
	</xsl:when>
	<xsl:when test="$style='dl'">
	  <GLOSSITEM>
	    <xsl:apply-templates/>
	  </GLOSSITEM>
	</xsl:when>
        <!-- ADDED: -->
	<xsl:when test="$style='Quote'">
	  <quote>
	    <xsl:apply-templates/>
	  </quote>
	</xsl:when>
	<xsl:when test="$style='Bibliography'">
	  <listBibl>
	    <xsl:apply-templates/>
	  </listBibl>
	</xsl:when>
        <!-- ADDED: -->
	<xsl:when test="starts-with($style,'MarginNote')">
	  <note>
	    <xsl:attribute name="place">
	      <xsl:text>margin</xsl:text>
	      <xsl:variable name="place" select="substring-after($style,'MarginNote')"/>
	      <xsl:choose>
		<xsl:when test="$place =  'Left'">_left</xsl:when>
		<xsl:when test="$place = 'Right'">_right</xsl:when>
		<xsl:when test="$place = 'Inner'">_inner</xsl:when>
		<xsl:when test="$place = 'Outer'">_outer</xsl:when>
	      </xsl:choose>
	    </xsl:attribute>
	    <xsl:apply-templates/>
	  </note>
	</xsl:when>
        <!-- WHY ARE THE FOLLOWING HERE? And why are they handled on a case-per-case basis? 
	     And why are they not merged with TEI and tei: prefixed styles? -->
	<xsl:when test="$style='tei_lg'"/>
	<xsl:when test="$style='tei_l'">
	  <l>
	    <xsl:apply-templates/>
	  </l>
	</xsl:when>
	<xsl:when test="$style='tei_signed'">
	  <signed>
	    <xsl:apply-templates/>
	  </signed>
	</xsl:when>
	<xsl:when test="$style='tei_speaker'">
	  <speaker>
	    <xsl:apply-templates/>
	  </speaker>
	</xsl:when>
	<xsl:when test="$style='tei_speech'">
	  <speech>
	    <xsl:apply-templates/>
	  </speech>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:call-template name="paragraph-wp">
	    <xsl:with-param name="style" select="$style"/>
	  </xsl:call-template>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:template>

   <!-- PASS2: overwriting templates from Stylesheets/docx/from/pass2.xsl -->

   <!-- Change pass2 on div to run through new pass3 and pass4 -->
   <xsl:template match="tei:body/tei:div" mode="pass2">
     <xsl:variable name="pass2">
       <xsl:copy>
	 <xsl:apply-templates mode="pass2" select="@*"/>
	 <xsl:apply-templates mode="pass2"/>
       </xsl:copy>
     </xsl:variable>
     <xsl:variable name="pass3">
       <xsl:apply-templates select="$pass2" mode="pass3"/>
       <!--xsl:copy-of select="$pass2"/-->
     </xsl:variable>
     <xsl:apply-templates select="$pass3" mode="pass4"/>
     <!-- For debugging: -->
     <!--xsl:copy-of select="."/-->
     <!--xsl:copy-of select="$pass2"/-->
     <!--xsl:copy-of select="$pass3"/-->
   </xsl:template>
   
   <!-- This template is a project-specific hack: -->
   <!-- Consider div[1] to be tei:front/tei:titlePage if it contains Title; other divs are tei:body -->
   <!-- Takes only Title, Subtitle, Author, Date from the div, other stuff is ignored -->
   <!-- This template ignores tei:text/tei:fw, tei:text/tei:front, tei:text/tei:back 
        from the original template, but I don't see how those could be present anyway!?-->
   <xsl:template match="tei:text" mode="pass2">
     <xsl:variable name="div1" select="tei:body/tei:div[1]"/>
     <text>
       <xsl:if test="$div1/tei:p[@rend = 'Title']">
	 <front>
	   <titlePage>
	     <docTitle>
	       <titlePart type="main">
		 <xsl:apply-templates select="$div1/tei:p[@rend = 'Title']/node()" 
				      mode="pass2"/>
	       </titlePart>
	       <xsl:if test="$div1/tei:p[@rend = 'Subtitle']">
		 <titlePart type="sub">
		   <xsl:apply-templates select="$div1/tei:p[@rend = 'Subtitle']/node()" 
					mode="pass2"/>
		 </titlePart>
	       </xsl:if>
	     </docTitle>
	     <xsl:if test="$div1/tei:p[@rend = 'Author']">
	       <docAuthor>
		 <xsl:apply-templates select="$div1/tei:p[@rend = 'Author']/node()" 
				      mode="pass2"/>
	       </docAuthor>
	     </xsl:if>
	     <xsl:if test="$div1/tei:p[@rend = 'Date']">
	       <docDate>
		 <xsl:apply-templates select="$div1/tei:p[@rend = 'Date']/node()" 
				      mode="pass2"/>
	       </docDate>
	     </xsl:if>
	   </titlePage>
	 </front>
       </xsl:if>
       <body>
	 <xsl:choose>
	   <xsl:when test="$div1/tei:p[@rend = 'Title']">
	     <xsl:for-each select="tei:body/tei:div[preceding::tei:div]">
	       <xsl:apply-templates select="." mode="pass2"/>
	     </xsl:for-each>
	   </xsl:when>
	   <xsl:otherwise>
	     <xsl:for-each select="tei:body/tei:div">
	       <xsl:apply-templates select="." mode="pass2"/>
	     </xsl:for-each>
	   </xsl:otherwise>
	 </xsl:choose>
       </body>
     </text>
   </xsl:template>


   <!-- FIX: original only takes care of captions that follow tables and figures 
	but they can be before as well.
	However, this can lead to errors if two images are one next to another:
	We give priority to caption below and issue a warning if adjecent.
   -->
   <xsl:template match="tei:table|tei:figure" mode="pass2">
     <xsl:copy>
       <xsl:apply-templates select="@*" mode="pass2"/>
       <xsl:apply-templates mode="pass2"/>
       <xsl:if test="preceding-sibling::*[1][self::tei:CAPTION] and 
		     following-sibling::*[1][self::tei:CAPTION]">
       	   <xsl:message>
	   <xsl:text>WARN: Possible confusion on where these captions belong: [[</xsl:text>
	   <xsl:value-of select="concat(preceding-sibling::*[1],']] and [[',
				 following-sibling::*[1],']]')"/>
	   </xsl:message>
       </xsl:if>
       <xsl:choose>
	 <xsl:when test="following-sibling::*[1][self::tei:CAPTION]">
	   <xsl:apply-templates
	       select="following-sibling::*[1][self::tei:CAPTION]/*" mode="pass2"/>
	 </xsl:when>
	 <xsl:when test="preceding-sibling::*[1][self::tei:CAPTION]">
	   <xsl:apply-templates
	       select="preceding-sibling::*[1][self::tei:CAPTION]/*" mode="pass2"/>
	 </xsl:when>
       </xsl:choose>
     </xsl:copy>
   </xsl:template>

   <!-- Two key templates in pass2.xsl need to be fixed!
   We write the overriding templates here, but they could be much simple if the original were fixed -->

   <!-- Original template: -->
   <!--xsl:template match="tei:p[not(.//tei:pb) and normalize-space(.)='']" mode="pass2" priority="99"/-->
   <!-- Proposed fix
	addes tei:graphic as otherwise they get zapped in "empty" paragraphs -->
   <!--xsl:template match="tei:p[not(.//tei:pb) and not(.//tei:graphic) and normalize-space(.)='']" 
       mode="pass2" priority="99"/-->
   <!-- Overriding template, has to be more complicated to override the origina one: -->
   <xsl:template match="tei:p[not(.//tei:pb) and normalize-space(.)='']" mode="pass2" priority="99">
     <!-- we also add tei:* for some fancy magic we do with such empty ps in pass3-->
     <xsl:if test=".//tei:graphic or starts-with(@rend,'tei:')">
       <xsl:copy>
	 <xsl:apply-templates select="@*" mode="pass2"/>
         <xsl:apply-templates mode="pass2"/>
       </xsl:copy>
     </xsl:if>
   </xsl:template>

   <!-- Original template: -->
   <!--xsl:template match="tei:figure/tei:p[tei:graphic and count(*)=1]" mode="pass2" priority="101"-->
   <!-- Proposed fix
        we check if there are two graphics in a figure (either within same p or one two p -->
   <!--xsl:template match="tei:figure/tei:p[tei:graphic and normalize-space(.)='' and not(../tei:p[2])]" 
       mode="pass2" priority="101">
       <xsl:apply-templates mode="pass2"/>
   </xsl:template-->
   <!-- Overriding template, has to be more complicated to override the origina one: -->
   <xsl:template match="tei:figure/tei:p[tei:graphic and count(*)=1]" mode="pass2" priority="101">
     <xsl:choose>
       <xsl:when test="normalize-space(.)='' and not(../tei:p[2])">
	 <xsl:apply-templates mode="pass2"/>
       </xsl:when>
       <xsl:otherwise>
	 <xsl:copy>
	   <xsl:apply-templates select="@*" mode="pass2"/>
           <xsl:apply-templates mode="pass2"/>
	 </xsl:copy>
       </xsl:otherwise>
     </xsl:choose>
   </xsl:template>

   <!-- Another addition to pass2:
	Graphics without captions in paragraphs are rather wrapped in figure -->
   <xsl:template match="tei:p[tei:graphic and normalize-space(.)='' and not(ancestor::tei:figure)]" 
		 mode="pass2" priority="100">
     <figure>
       <xsl:apply-templates mode="pass2"/>
     </figure>
   </xsl:template>

   <!-- PASS3: New pass to tidy up -->

   <!-- Fix children of div: Collect and rename group elements -->
   <!-- Rather a nightmare of a template... -->
   <xsl:template match="tei:div" mode="pass3">
     <xsl:copy>
       <xsl:apply-templates select="@*" mode="iden"/>
       <xsl:for-each-group select="tei:*" group-adjacent="name()">
	 <xsl:choose>
	   <xsl:when test="current-grouping-key() = 'listBibl'">
	     <listBibl>
	       <xsl:for-each select="current-group()">
		 <xsl:if test="string-length(.)>0 or tei:*">
		   <bibl>
		     <xsl:apply-templates mode="pass3"/>
		   </bibl>
		 </xsl:if>
               </xsl:for-each> 
	     </listBibl>
	   </xsl:when>
	   <xsl:when test="current-grouping-key() = 'cit'">
	     <xsl:for-each select="current-group()">
	       <xsl:if test="string-length(.)>0 or tei:*">
		 <cit>
		   <quote>
		     <xsl:apply-templates mode="pass3"/>
		   </quote>
		   <xsl:if test="tei:bibl">
		     <bibl>
		       <xsl:apply-templates select="tei:bibl/node()" mode="pass3"/>
		     </bibl>
		   </xsl:if>
		 </cit>
	       </xsl:if>
	     </xsl:for-each>
	   </xsl:when>
	   <xsl:when test="current-grouping-key() = 'lg'">
	     <xsl:for-each-group select="current-group()" group-starting-with="tei:lg[string-length(.)=0]">
	       <xsl:variable name="lg">
		 <xsl:for-each select="current-group()">
		   <xsl:if test="string-length(.)>0 or tei:*">
		     <l>
		       <xsl:apply-templates mode="pass3"/>
		     </l>
		   </xsl:if>
		 </xsl:for-each> 
	       </xsl:variable>
	       <xsl:if test="$lg/tei:l">
		 <lg>
		   <xsl:copy-of select="$lg"/>
		 </lg>
	       </xsl:if>
	     </xsl:for-each-group>
	   </xsl:when>
	   <!-- Maybe this is no longer needed as source has some handling sp/speaker+speech
	   (but there speech is not lines but paragraphs) -->
	   <xsl:when test="current-grouping-key() = 'sp'">
	     <xsl:for-each-group select="current-group()" group-starting-with="tei:sp[string-length(.)=0]">
	       <xsl:variable name="sp">
		 <xsl:for-each select="current-group()">
		   <xsl:choose>
		     <xsl:when test="string-length(.)=0"/>
		     <xsl:when test="not(preceding-sibling::tei:*[1][self::tei:sp]) or
				     preceding-sibling::tei:*[1][self::tei:sp][string-length(.)=0]">
		       <speaker>
			 <xsl:apply-templates mode="pass3"/>
		       </speaker>
		     </xsl:when>
		     <xsl:otherwise>
		       <l>
			 <xsl:apply-templates mode="pass3"/>
		       </l>
		     </xsl:otherwise>
		   </xsl:choose>
		 </xsl:for-each> 
	       </xsl:variable>
	       <xsl:if test="$sp/tei:*">
		 <sp>
		   <xsl:copy-of select="$sp"/>
		 </sp>
	       </xsl:if>
	     </xsl:for-each-group>
	   </xsl:when>
	   <xsl:when test="current-grouping-key() = 'div'">
	     <xsl:for-each select="current-group()">
	       <xsl:apply-templates mode="pass3" select="."/>
	     </xsl:for-each> 
	   </xsl:when>
	   <xsl:otherwise>
	     <xsl:for-each select="current-group()">
	       <xsl:apply-templates mode="pass3" select="."/>
             </xsl:for-each> 
	   </xsl:otherwise>
	 </xsl:choose>
       </xsl:for-each-group>
     </xsl:copy>
   </xsl:template>

   <!-- Fix table/head so it is always at start of table -->
   <!-- This doesn't happen with standard stylesheets, producing non-valid TEI -->
   <xsl:template match="tei:table[tei:head]" mode="pass3">
       <xsl:copy>
	 <xsl:copy-of select="@*"/>
	 <xsl:apply-templates mode="pass3" select="tei:head"/>
	 <xsl:apply-templates mode="pass3" select="tei:*[not(self::tei:head)]"/>
       </xsl:copy>
   </xsl:template>

   <!-- Output tei:p tag only if there is more than one in a footnote -->
   <!-- We also nuke tei:p/@rend -->
   <xsl:template match="tei:note/tei:p" mode="pass3">
     <xsl:choose>
       <xsl:when test="../tei:p[2]">
	 <xsl:copy>
	   <xsl:copy-of select="@*[name()!='rend']"/>
	   <xsl:apply-templates mode="pass3"/>
	 </xsl:copy>
       </xsl:when>
       <xsl:otherwise>
	 <xsl:apply-templates mode="pass3"/>
       </xsl:otherwise>
     </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:note/tei:p/@rend[. = 'footnote text']" mode="pass2"/>

   <!-- tei:cit already takes care of this one -->
   <xsl:template match="tei:cit/tei:bibl" mode="pass3"/>

   <!-- Dates inside a paragraph -->
   <!-- Can't do it in pass2 as that one fiddles with adjecent tei:hi elements -->
   <xsl:template match="tei:hi[@rend = 'Date_Char']" mode="pass3">
     <date>
       <xsl:apply-templates mode="pass3"/>
     </date>
   </xsl:template>

   <!-- Here we take care of "special" tei: styles -->
   <xsl:template match="tei:fwCatch" mode="pass3" priority="99">
     <fw type='catch'>
       <xsl:apply-templates mode="pass3"/>
     </fw>
   </xsl:template>
  
   <xsl:template match="tei:persName" mode="pass3">
     <name type='person'>
       <xsl:apply-templates mode="pass3"/>
     </name>
   </xsl:template>
   <xsl:template match="tei:placeName" mode="pass3">
     <name type='place'>
       <xsl:apply-templates mode="pass3"/>
     </name>
   </xsl:template>
   <xsl:template match="tei:orgName" mode="pass3">
     <name type='org'>
       <xsl:apply-templates mode="pass3"/>
     </name>
   </xsl:template>

   <!-- Janus elements: del/add, abbr/expan, orig/reg, sic/corr
	These are wrapped in subst or choice if they are adjacent -->
   
   <xsl:template match="tei:del" mode="pass3">
     <xsl:if test="string-length(normalize-space(.))>0 or tei:*">
       <xsl:if test="not(
		     following-sibling::*[1][self::tei:add] and
		     not(following-sibling::node()[1][self::text()][normalize-space(.)])
		     )
		     and
		     not(
		     preceding-sibling::*[1][self::tei:add] and
		     not(preceding-sibling::node()[1][self::text()][normalize-space(.)])
		     )">
	 <xsl:copy>
	   <xsl:apply-templates mode="pass3"/>
	 </xsl:copy>
       </xsl:if>
     </xsl:if>
   </xsl:template>
   <xsl:template match="tei:add" mode="pass3">
     <xsl:if test="string-length(normalize-space(.))>0 or tei:*">
       <xsl:choose>
	 <xsl:when test="following-sibling::*[1][self::tei:del] and
			 not(following-sibling::node()[1][self::text()][normalize-space(.)])">
	   <subst>
	     <xsl:copy>
	       <xsl:apply-templates mode="pass3"/>
	     </xsl:copy>
	     <del>
	       <xsl:apply-templates select="following-sibling::tei:del[1]/node()" mode="pass3"/>
	     </del>
	   </subst>
	 </xsl:when>
	 <xsl:when test="preceding-sibling::*[1][self::tei:del] and
			 not(preceding-sibling::node()[1][self::text()][normalize-space(.)])">
	   <subst>
	     <del>
	       <xsl:apply-templates select="preceding-sibling::tei:del[1]/node()" mode="pass3"/>
	     </del>
	     <xsl:copy>
	       <xsl:apply-templates mode="pass3"/>
	     </xsl:copy>
	   </subst>
	 </xsl:when>
	 <xsl:otherwise>
	   <xsl:copy>
	     <xsl:apply-templates mode="pass3"/>
	   </xsl:copy>
	 </xsl:otherwise>
       </xsl:choose>
     </xsl:if>
   </xsl:template>

   <xsl:template match="tei:abbr" mode="pass3">
     <xsl:if test="string-length(normalize-space(.))>0 or tei:*">
       <xsl:if test="not(
		     following-sibling::*[1][self::tei:expan] and
		     not(following-sibling::node()[1][self::text()][normalize-space(.)])
		     )
		     and
		     not(
		     preceding-sibling::*[1][self::tei:expan] and
		     not(preceding-sibling::node()[1][self::text()][normalize-space(.)])
		     )">
	 <xsl:copy>
	   <xsl:apply-templates mode="pass3"/>
	 </xsl:copy>
       </xsl:if>
     </xsl:if>
   </xsl:template>
   <xsl:template match="tei:expan" mode="pass3">
     <xsl:if test="string-length(normalize-space(.))>0 or tei:*">
       <xsl:choose>
	 <xsl:when test="following-sibling::*[1][self::tei:abbr] and
			 not(following-sibling::node()[1][self::text()][normalize-space(.)])">
	   <choice>
	     <xsl:copy>
	       <xsl:apply-templates mode="pass3"/>
	     </xsl:copy>
	     <abbr>
	       <xsl:apply-templates select="following-sibling::tei:abbr[1]/node()" mode="pass3"/>
	     </abbr>
	   </choice>
	 </xsl:when>
	 <xsl:when test="preceding-sibling::*[1][self::tei:abbr] and
			 not(preceding-sibling::node()[1][self::text()][normalize-space(.)])">
	   <choice>
	     <abbr>
	       <xsl:apply-templates select="preceding-sibling::tei:abbr[1]/node()" mode="pass3"/>
	     </abbr>
	     <xsl:copy>
	       <xsl:apply-templates mode="pass3"/>
	     </xsl:copy>
	   </choice>
	 </xsl:when>
	 <xsl:otherwise>
	   <xsl:copy>
	     <xsl:apply-templates mode="pass3"/>
	   </xsl:copy>
	 </xsl:otherwise>
       </xsl:choose>
     </xsl:if>
   </xsl:template>
   
   <xsl:template match="tei:orig" mode="pass3">
     <xsl:if test="string-length(normalize-space(.))>0 or tei:*">
       <xsl:if test="not(
		     following-sibling::*[1][self::tei:reg] and
		     not(following-sibling::node()[1][self::text()][normalize-space(.)])
		     )
		     and
		     not(
		     preceding-sibling::*[1][self::tei:reg] and
		     not(preceding-sibling::node()[1][self::text()][normalize-space(.)])
		     )">
	 <xsl:copy>
	   <xsl:apply-templates mode="pass3"/>
	 </xsl:copy>
       </xsl:if>
     </xsl:if>
   </xsl:template>
   <xsl:template match="tei:reg" mode="pass3">
     <xsl:if test="string-length(normalize-space(.))>0 or tei:*">
       <xsl:choose>
	 <xsl:when test="following-sibling::*[1][self::tei:orig] and
			 not(following-sibling::node()[1][self::text()][normalize-space(.)])">
	   <choice>
	     <xsl:copy>
	       <xsl:apply-templates mode="pass3"/>
	     </xsl:copy>
	     <orig>
	       <xsl:apply-templates select="following-sibling::tei:orig[1]/node()" mode="pass3"/>
	     </orig>
	   </choice>
	 </xsl:when>
	 <xsl:when test="preceding-sibling::*[1][self::tei:orig] and
			 not(preceding-sibling::node()[1][self::text()][normalize-space(.)])">
	   <choice>
	     <orig>
	       <xsl:apply-templates select="preceding-sibling::tei:orig[1]/node()" mode="pass3"/>
	     </orig>
	     <xsl:copy>
	       <xsl:apply-templates mode="pass3"/>
	     </xsl:copy>
	   </choice>
	 </xsl:when>
	 <xsl:otherwise>
	   <xsl:copy>
	     <xsl:apply-templates mode="pass3"/>
	   </xsl:copy>
	 </xsl:otherwise>
       </xsl:choose>
     </xsl:if>
   </xsl:template>
   
   <xsl:template match="tei:sic" mode="pass3">
     <xsl:if test="string-length(normalize-space(.))>0 or tei:*">
       <xsl:if test="not(
		     following-sibling::*[1][self::tei:corr] and
		     not(following-sibling::node()[1][self::text()][normalize-space(.)])
		     )
		     and
		     not(
		     preceding-sibling::*[1][self::tei:corr] and
		     not(preceding-sibling::node()[1][self::text()][normalize-space(.)])
		     )">
	 <xsl:copy>
	   <xsl:apply-templates mode="pass3"/>
	 </xsl:copy>
       </xsl:if>
     </xsl:if>
   </xsl:template>
   <xsl:template match="tei:corr" mode="pass3">
     <xsl:if test="string-length(normalize-space(.))>0 or tei:*">
       <xsl:choose>
	 <xsl:when test="following-sibling::*[1][self::tei:sic] and
			 not(following-sibling::node()[1][self::text()][normalize-space(.)])">
	   <choice>
	     <xsl:copy>
	       <xsl:apply-templates mode="pass3"/>
	     </xsl:copy>
	     <sic>
	       <xsl:apply-templates select="following-sibling::tei:sic[1]/node()" mode="pass3"/>
	     </sic>
	   </choice>
	 </xsl:when>
	 <xsl:when test="preceding-sibling::*[1][self::tei:sic] and
			 not(preceding-sibling::node()[1][self::text()][normalize-space(.)])">
	   <choice>
	     <sic>
	       <xsl:apply-templates select="preceding-sibling::tei:sic[1]/node()" mode="pass3"/>
	     </sic>
	     <xsl:copy>
	       <xsl:apply-templates mode="pass3"/>
	     </xsl:copy>
	   </choice>
	 </xsl:when>
	 <xsl:otherwise>
	   <xsl:copy>
	     <xsl:apply-templates mode="pass3"/>
	   </xsl:copy>
	 </xsl:otherwise>
       </xsl:choose>
     </xsl:if>
   </xsl:template>
   
   <!-- By default pass through -->
   <xsl:template match="tei:*" mode="pass3">
     <xsl:copy>
       <xsl:apply-templates select="@*" mode="pass3"/>
       <xsl:apply-templates mode="pass3"/>
     </xsl:copy>
   </xsl:template>
   <xsl:template match="@*|comment()" mode="pass3">
     <xsl:copy/>
   </xsl:template>


   <!-- PASS4: final clean-up -->

   <!-- ToDo: 
        - check which other attributes apart from @target, @spanTo can have pointers (if evil underscore is still there..)
        - promote <pb>s out of subordinate elements and nuke these if they contain nothing but pb?
        - fix spaces in cases as "foo<term> bar </term>baz" -> "foo <term>bar</term> baz"?
    -->

   <!-- Remove evil Windows underscore -->
   <!-- Do we still need this? -->
   <xsl:template match="@target | @spanTo" mode="pass4">
     <xsl:attribute name="{name()}">
       <xsl:if test="fn:matches(.,'^#_')">
	 <xsl:message>
	   <xsl:text>INFO: Removing evil Windows underscore </xsl:text>
	   <xsl:value-of select="."/>
	 </xsl:message>
       </xsl:if>
       <xsl:value-of select="fn:replace(.,'^#_','#')"/>
     </xsl:attribute>
   </xsl:template>

   <!-- Remove unused anchors -->
   <xsl:template match="tei:anchor" mode="pass4">
     <xsl:variable name="ref" select="concat('#',@xml:id)"/>
     <xsl:if test="key('ref',$ref) or key('spanTo',$ref)">
       <xsl:copy>
	 <xsl:apply-templates select="@*" mode="pass4"/>
	 <xsl:apply-templates mode="pass4"/>
       </xsl:copy>
     </xsl:if>
     <xsl:if test="not(key('ref',$ref) or key('spanTo',$ref))">
       <xsl:message>
	 <xsl:text>INFO: Removing anchor with no referent for </xsl:text>
	 <xsl:value-of select="@xml:id"/>
       </xsl:message>
     </xsl:if>
   </xsl:template>

   <!-- By default pass through -->
   <xsl:template match="tei:*" mode="pass4">
     <xsl:copy>
       <xsl:apply-templates select="@*" mode="pass4"/>
       <xsl:apply-templates mode="pass4"/>
     </xsl:copy>
   </xsl:template>
   <xsl:template match="@*|comment()" mode="pass4">
     <xsl:copy/>
   </xsl:template>

 </xsl:stylesheet>
