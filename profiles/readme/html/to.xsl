<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="3.0">
    <!-- import base conversion style -->
  
  <xsl:import href="../../../html/html.xsl"/>
  
  <xsl:param name="feedbackURL">https://tei-c.org/about/contact/</xsl:param>
  <xsl:param name="institution"/>
  <xsl:param name="cssFile">en/html/guidelines.css</xsl:param>
  <xsl:template name="copyrightStatement">released under the
    Creative Commons Attribution 3.0 Unported License 
    http://creativecommons.org/licenses/by/3.0/</xsl:template>
  
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
of this software, even if advised of the possibility of such damage.</p>
      <p>$Id: to.xsl 9669 2011-11-07 19:17:54Z rahtz $</p>
      <p>Copyright: 2013, TEI Consortium</p>
    </desc>
  </doc>
  
  <xsl:output method="xhtml" omit-xml-declaration="yes"/>

  <!-- ********* START ********* -->
  <!--
    From here to END is a block of code that is essentially special-purpose
    code for building the readme-X.Y.Z.html files for TEI releases from the
    corresponding .xml input files.
    Input: .../ReleaseNotes/readme*xml
    Output: the Makefile puts the .html files of the same name except with an
      extension of '.html' intsead of '.xml' into 
      .../release/tei-p5-doc/share/doc/tei-p5-doc/
  -->
  <xsl:variable name="filename" select="tokenize( base-uri(/),'/')[last()]"/>
  <xsl:param name="version_from_filename" select="replace( $filename, '^readme-([0-9aαbβ.-]+)\.xml$','$1')"/>
  <xsl:param name="vault" select="'https://www.tei-c.org/Vault/P5'"/>
  <!--
      Note on names of next 3 params:

      There was originally just 1 param for this, $docPath. We
      discovered the need to use just the initial portion of that path
      in the generation of $testVersionedDocument (see [1]). It would
      be perfectly reasonable to just hard-code that path or to chop
      the $docPath param into two parts and just use the first part
      for $testVersionedDocument and the concatentation of the two
      parts for $tagdocStart. But I do not know that there is not some
      routine that calls this program and tries to set $docPath as a
      parameter, so I did not want to remove it. Thus it is generated
      from the two pieces, but can still be overridden. (Note that if
      it is overridden, the value of $docPath2 may not be what we want
      in $tagdocStart.)  —Syd, 2021-10-02
  -->
  <xsl:param name="docPath1" select="'doc/tei-p5-doc'"/>
  <xsl:param name="docPath2" select="'en/html'"/>
  <xsl:param name="docPath" select="concat( $docPath1, '/', $docPath2 )"/>
  <!--
    The version # we grabbed from the filename might not have the patch level ".0" at the end.
    But the Guidelines we are trying to point to always have it. So here if we find only major-
    dot-minor (rather than major-dot-minor-dot-patch), we append a ".0".
  -->
  <xsl:variable name="version" as="xs:string"
                select="replace( $version_from_filename, '^([0-9]+\.[0-9]+)([aαbβ]?)$', '$1.0$2')"/>
  <!-- $versionZero is true() iff the major number is '0'. -->
  <xsl:variable name="versionZero" select="substring-before( $version, '.') eq '0'" as="xs:boolean"/>
  <xsl:variable name="testVersionedDocument" select="concat( $vault,'/',$version,'/',$docPath1,'/VERSION')"/>
  <xsl:variable name="tagdocStart" select="concat( $vault,'/',$version,'/',$docPath,'/ref-')"/>
  
  <xsl:template match="tei:gi | tei:name[ @type eq 'class']">
    <xsl:variable name="class" select="if (@type) then @type else local-name(.)"/>
    <!-- If this is the first one, check veresion number and warn iff needed -->
    <xsl:if test="not( preceding::tei:gi | preceding::tei:name[ @type eq 'class'] )">
      <xsl:choose>
        <xsl:when test="$version_from_filename eq ''">
          <xsl:message>WARNING: unable to parse version # from filename, so links will not work</xsl:message>
        </xsl:when>
        <xsl:when test="not( unparsed-text-available( $testVersionedDocument ) )">
          <xsl:message>INFO: file <xsl:value-of select="$testVersionedDocument"/> could not be read</xsl:message>
        </xsl:when>
        <xsl:when test="normalize-space( unparsed-text( $testVersionedDocument ) ) ne normalize-space( $version )">
          <xsl:message>WARNING: supplied version (<xsl:value-of select="$version"/>) is not equal to content of <xsl:value-of select="$testVersionedDocument"/>.</xsl:message>
        </xsl:when>
        <xsl:when test="substring-before( $version, '.') eq '0'">
          <xsl:message>INFO: version number is &lt; 1.0.0, so not generating links for element &amp; class names.</xsl:message>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
    <xsl:choose>
      <!-- if this is prior to release 1.0.0, do not even bother trying to generate a link, just highlight it … -->
      <xsl:when test="$versionZero">
        <span class="{$class}"><xsl:apply-templates/></span>
      </xsl:when>
      <!-- else if it is a TEI element or class, make it into a link … -->
      <xsl:when test="@scheme = ('TEI','tei') or not( @scheme )">
        <xsl:variable name="content" select="normalize-space(.)"/>
        <xsl:variable name="tagdoc" select="concat( $tagdocStart, $content, '.html' )"/>
        <a class="{$class}" href="{$tagdoc}"><xsl:apply-templates/></a>
      </xsl:when>
      <!-- else this is not a TEI scheme element or name, also no link, just highlight it -->
      <xsl:otherwise>
        <span class="{$class}"><xsl:apply-templates/></span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- ********* END ********* -->
  
  <xsl:template match="html:*">
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="html:*/comment()">
    <xsl:copy-of select="."/>
  </xsl:template>
  
  <xsl:template match="tei:div[@type = ('frontispiece','illustration')]">
    <xsl:apply-templates/>
  </xsl:template>
  
</xsl:stylesheet>
