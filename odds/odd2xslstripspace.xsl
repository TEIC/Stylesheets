<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
    xmlns:gen="http://www.w3.org/1999/XSL/TransformAlias" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" 
    xmlns:html="http://www.w3.org/1999/xhtml" 
    xmlns:i="http://www.iso.org/ns/1.0"
    xmlns:rng="http://relaxng.org/ns/structure/1.0"
    xmlns:s="http://www.ascc.net/xml/schematron" 
    xmlns:sch="http://purl.oclc.org/dsdl/schematron" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:teix="http://www.tei-c.org/ns/Examples" 
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="3.0">

  <!-- Import the usual suspects -->
  <!-- (I think these are included only for the 'followRef' template
       and its subordinates, as it were. —Syd, 2020-09-25) -->
  <xsl:import href="teiodds.xsl"/>
  <xsl:import href="../common/i18n.xsl"/>
  <xsl:import href="../common/functions.xsl"/>
  <xsl:import href="../common/common_tagdocs.xsl"/>
  <xsl:import href="../common/common_param.xsl"/>

  <!-- Output specification, including a namespace for the XSLT we are
       producing -->
  <xsl:namespace-alias stylesheet-prefix="gen" result-prefix="xsl"/>
  <xsl:output encoding="utf-8" indent="yes" method="xml"/>

  <!-- I do not really know why these are needed, let alone why they
       are parameters, not just variables. Would any of them *ever* be
       changed for this program? —Syd, 2020-09-25 -->
  <xsl:param name="cellName">cell</xsl:param>
  <xsl:param name="codeName">code</xsl:param>
  <xsl:param name="colspan"/>
  <xsl:param name="ddName"/>
  <xsl:param name="divName">div</xsl:param>
  <xsl:param name="dlName"/>
  <xsl:param name="dtName"/>
  <xsl:param name="hiName">hi</xsl:param>
  <xsl:param name="itemName"/>
  <xsl:param name="labelName">label</xsl:param>
  <xsl:param name="outputNS"/>
  <xsl:param name="rendName">rend</xsl:param>
  <xsl:param name="rowName"/>
  <xsl:param name="sectionName"/>
  <xsl:param name="segName">seg</xsl:param>
  <xsl:param name="spaceCharacter"/>
  <xsl:param name="tableName"/>
  <xsl:param name="ulName"/>
  <xsl:param name="urlName"/>
  <xsl:param name="xrefName"/>
  <!-- -->
  <xsl:param name="TEIC">false</xsl:param>
  <xsl:param name="verbose"/>
  <xsl:param name="outputDir"/>
  <xsl:param name="appendixWords"/>
  <xsl:param name="splitLevel">-1</xsl:param>

  <!-- Just as confusing as why the above are params, why are these
       variables instead? —Syd, 2020-10-03 -->
  <xsl:variable name="oddmode">dtd</xsl:variable>
  <xsl:variable name="filesuffix"/>
  <xsl:variable name="linkColor"/>


  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
    <desc>
      <p>TEI stylesheet for generating list of TEI elements that
      have element (as opposed to mixed) content</p>

      <p>This routine reads in a “compiled” copy of a TEI ODD
      customization language (e.g., p5.xml, p5subset.xml, or the
      output of odds/odd2odd.xsl) and generates a single
      <tt>&lt;xsl:strip-space></tt> element that lists on its
      <tt>@elements</tt> attribute all of the elements declared in
      the input encoding language as having element content.</p>

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


  <!-- Templates that are over-ridden to do & return nothing: -->
  <xsl:template name="schemaOut">
    <xsl:param name="grammar"/>
    <xsl:param name="element"/>
    <xsl:param name="content"/>
  </xsl:template>
  <xsl:template name="pureODDOut">
    <xsl:param name="grammar"/>
    <xsl:param name="element"/>
    <xsl:param name="content"/>
  </xsl:template>
  <xsl:template name="PMOut">
    <xsl:param name="element"/>
    <xsl:param name="content"/>
  </xsl:template>
  <xsl:template name="typewriter">
    <xsl:param name="text"/>
  </xsl:template>
  <xsl:template name="emphasize">
    <xsl:param name="class"/>
    <xsl:param name="content"/>
  </xsl:template>
  <xsl:template name="emptySlash">
    <xsl:param name="name"/>
  </xsl:template>
  <xsl:template name="generateEndLink">
    <xsl:param name="where"/>
  </xsl:template>
  <xsl:template name="identifyElement">
    <xsl:param name="id"/>
  </xsl:template>
  <xsl:template name="makeExternalLink">
    <xsl:param name="ptr" as="xs:boolean" select="false()"/>
    <xsl:param name="dest"/>
    <xsl:param name="title"/>
  </xsl:template>
  <xsl:template name="makeInternalLink">
    <xsl:param name="ptr" as="xs:boolean" select="false()"/>
    <xsl:param name="target"/>
    <xsl:param name="dest"/>
    <xsl:param name="class"/>
    <xsl:param name="body"/>
  </xsl:template>
  <xsl:template name="makeSectionHead">
    <xsl:param name="name"/>
    <xsl:param name="id"/>
  </xsl:template>
  <xsl:template name="refdoc"/>
  <xsl:template name="showRNC">
    <xsl:param name="style"/>
    <xsl:param name="contents"/>
    <!--since $contents is set to nil, this returns nil: —Syd, 2020-10-03 -->
    <xsl:value-of select="$contents"/>
  </xsl:template>
  <xsl:template name="showSpace"/>
  <xsl:template name="showSpaceBetweenItems"/>
  <xsl:template name="specHook">
    <xsl:param name="name"/>
  </xsl:template>
  <!-- -->
  <xsl:template name="makeAnchor">
    <xsl:param name="name"/>
  </xsl:template>

  <!-- Finally, do the work: -->
  <xsl:template match="/">
    <gen:strip-space>
      <xsl:attribute name="elements">
        <xsl:for-each select="//tei:elementSpec">
          <xsl:sort select="@ident"/>
          <xsl:variable name="gi" select="@ident"/>
	  <!-- Process this element by looking at its <tei:content>.
	       If it should be in the <xsl:strip-space> @elememnt
	       list, then add its name here (if it should not, just
	       ignore it). -->
          <xsl:choose>
	    <!-- Ignore, and thus do not strip space, from elements
	         that allow arbitrary XML content anywhere inside
	         their content models. -->
            <xsl:when test="tei:content//rng:ref[@name eq 'macro.anyXML']"/>
	    <xsl:when test="tei:content//tei:anyElement">
	      <xsl:message select="'debug: I found any in '||$gi||'.'"/>
	    </xsl:when>
	    <!-- Ignore, and thus do not strip space, from elements
	         that allow #PCDATA as a child node. -->
            <xsl:when test="tei:content/rng:text and count(tei:content/rng:*) eq 1"/>
            <xsl:when test="tei:content/tei:textNode and count(tei:content/*) eq 1"/>
	    <!-- Ignore empty elements, they have no space to strip. :-) -->
            <xsl:when test="tei:content/rng:empty | tei:content/tei:empty"/>
            <xsl:otherwise>
	      <!-- This is an elementSpec we need to pay attention to.
	           Create a variable ($Children) which is a sequence
	           of <Elmement> children. (See common_tagdocs.xsl.) -->
              <xsl:variable name="Children">
                <xsl:for-each select="tei:content">
		  <!-- The <for-each> is here to set the context node
		       for followRef, as there is, by definition, only
		       0 or 1 <content> children of the current
		       <elementSpec>. -->
                  <xsl:call-template name="followRef"/>
                </xsl:for-each>
              </xsl:variable>
	      <xsl:for-each select="$Children">
		<!-- Look at each of those sets of <Element>s in our
		     content model ... -->
		<xsl:choose>
		  <!-- If there are no <Element>s in the set, our
		       content model is empty, and we ignore this
		       element, there is no space to strip. -->
                  <xsl:when test="count(Element) eq 0"/>
		  <!-- If the @type of at least one <Element> is TEXT
		       or XSD, ignore this element as we should not be
		       stripping space of content text nodes. (You
		       might think that <gi> and <att>, our elements
		       with @type of XSD, should have whitespace
		       stripped, as the content is definitionally only
		       an xs:Name. But strip-space is about whitespace
		       only nodes, and there cannot be a whitespace
		       only child of either of those elements.) -->
		  <xsl:when test="Element[ @type = ('TEXT','XSD')]"/>
                  <xsl:otherwise>
		    <!-- Doesn't meet any of the criteria above,
		         include it in our list of GIs in the @element
		         of <strip-space>.-->
                    <xsl:value-of select="$gi"/>
                    <xsl:text> </xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:attribute>
    </gen:strip-space>
  </xsl:template>

</xsl:stylesheet>
