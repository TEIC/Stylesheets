<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:s="http://www.ascc.net/xml/schematron"
    xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
    xmlns:rng="http://relaxng.org/ns/structure/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:teix="http://www.tei-c.org/ns/Examples"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all">

  <xd:doc scope="stylesheet" type="stylesheet">
    <xd:desc>
      <xd:p>TEI stylesheet for merging TEI ODD specification with source to
        make a new source document.</xd:p>
      <xd:p>This software is dual-licensed:
        <xd:ul>
          <xd:li>1. Distributed under a Creative Commons Attribution-ShareAlike 3.0
            Unported License http://creativecommons.org/licenses/by-sa/3.0/
          </xd:li>
          <xd:li>2. http://www.opensource.org/licenses/BSD-2-Clause</xd:li>
        </xd:ul>
      </xd:p>
      <xd:p>Redistribution and use in source and binary forms, with or without
        modification, are permitted provided that the following conditions are
        met:
        <xd:ul>
          <xd:li>Redistributions of source code must retain the above copyright
            notice, this list of conditions and the following disclaimer.</xd:li>
          <xd:li>Redistributions in binary form must reproduce the above copyright
            notice, this list of conditions and the following disclaimer in the
            documentation and/or other materials provided with the distribution.</xd:li>
        </xd:ul>
      </xd:p>
      <xd:p>This software is provided by the copyright holders and contributors
        “as is” and any express or implied warranties, including, but not
        limited to, the implied warranties of merchantability and fitness for
        a particular purpose are disclaimed. In no event shall the copyright
        holder or contributors be liable for any direct, indirect, incidental,
        special, exemplary, or consequential damages (including, but not
        limited to, procurement of substitute goods or services; loss of use,
        data, or profits; or business interruption) however caused and on any
        theory of liability, whether in contract, strict liability, or tort
        (including negligence or otherwise) arising in any way out of the use
        of this software, even if advised of the possibility of such damage.
      </xd:p>
      <xd:p>Author: See AUTHORS</xd:p>
      <xd:p>Copyright: 2013, TEI Consortium</xd:p>
    </xd:desc>
  </xd:doc>

  <xsl:output encoding="UTF-8" indent="no"/>

  <!-- ***** parameters ***** -->
  <xsl:param name="autoGlobal" as="xs:boolean" select="false()"/>
  <xsl:param name="configDirectory"/>
  <xsl:param name="currentDirectory"/>
  <xsl:param name="defaultSource"/>
  <xsl:param name="defaultTEIServer">http://www.tei-c.org/Vault/P5/</xsl:param>
  <xsl:param name="defaultTEIVersion">current</xsl:param>
  <xsl:param name="doclang"/>
  <!-- which <schemaSpec> we are processing, by its ident attr: -->
  <!-- WARNING: as currently configured teianttasks.xml (and perhaps
  other build processes) call this param w/ a null value, meaning this
  won't work. I'm not sure if this should be changed here or (better IMHO),
  the calling routines should not say the selected schema is nil ot get
  the default.-->
  <xsl:param name="selectedSchema" select="//schemaSpec[1]/@ident"/>
  <xsl:param name="stripped" as="xs:boolean" select="false()"/>
  <!-- following param was added 2016-06-06 by Syd Bauman for use by
       TEI in Libraries Best Practices Guidelines. If set to 'true'
       then all <exmplum> elements from TEI source are summarily
       dropped, whereas <exemplum> elements in ODD customization file
       are copied through. -->
  <xsl:param name="suppressTEIexamples" as="xs:boolean" select="false()"/>
  <xsl:param name="useVersionFromTEI" as="xs:boolean" select="true()"/>
  <xsl:param name="verbose" as="xs:boolean" select="false()"/>

  <!-- ***** keys ***** -->
  <xsl:key name="odd2odd-CHANGEATT" match="attDef[@mode eq 'change']" use="concat(../../@ident,'_',@ident)"/>
  <xsl:key name="odd2odd-CHANGECONSTRAINT" match="constraintSpec[@mode eq 'change']" use="concat(../@ident,'_',@ident)"/>
  <xsl:key name="odd2odd-CLASS_MEMBERED" match="classSpec" use="classes/memberOf/@key"/>
  <xsl:key name="odd2odd-DELETEATT" match="attDef[@mode eq 'delete']" use="concat(ancestor::classSpec/@ident,'_',@ident)"/>
  <xsl:key name="odd2odd-DELETEATT" match="attDef[@mode eq 'delete']" use="concat(ancestor::elementSpec/@ident,'_',@ident)"/>
  <xsl:key name="odd2odd-DELETECONSTRAINT" match="constraintSpec[@mode eq 'delete']" use="concat(../@ident,'_',@ident)"/>
  <xsl:key name="odd2odd-ELEMENT_MEMBERED" match="elementSpec" use="classes/memberOf/@key"/>
  <xsl:key name="odd2odd-IDENTS" match="dataSpec" use="@ident"/>
  <xsl:key name="odd2odd-IDENTS" match="macroSpec" use="@ident"/>
  <xsl:key name="odd2odd-IDENTS" match="classSpec" use="@ident"/>
  <xsl:key name="odd2odd-IDENTS" match="elementSpec" use="@ident"/>
  <xsl:key name="odd2odd-MACROS" match="macroSpec" use="@ident"/>
  <xsl:key name="odd2odd-MEMBEROFADD" match="memberOf[@mode eq 'add' or not (@mode)]" use="concat(../../@ident,@key)"/>
  <xsl:key name="odd2odd-MEMBEROFDELETE" match="memberOf[@mode eq 'delete']" use="concat(../../@ident,@key)"/>
  <xsl:key name="odd2odd-MODULES" match="moduleRef" use="@key"/>
  <xsl:key name="odd2odd-MODULE_MEMBERS_ELEMENT" match="elementSpec" use="@module"/>
  <xsl:key name="odd2odd-MODULE_MEMBERS_NONELEMENT" match="dataSpec" use="@module"/>
  <xsl:key name="odd2odd-MODULE_MEMBERS_NONELEMENT" match="macroSpec" use="@module"/>
  <xsl:key name="odd2odd-MODULE_MEMBERS_NONELEMENT" match="classSpec" use="@module"/>
  <xsl:key name="odd2odd-ATTREFED" match="attRef" use="substring-before(@name,'.attribute.')"/>
  <xsl:key name="odd2odd-REFED" match="rng:ref[ancestor::elementSpec]" use="@name"/>
  <xsl:key name="odd2odd-REFED" match="rng:ref[ancestor::macroSpec and not(@name=ancestor::macroSpec/@ident)]" use="@name"/>
  <xsl:key name="odd2odd-REFED" match="rng:ref[ancestor::datatype]" use="@name"/>
  <xsl:key name="odd2odd-REFED" match="attRef" use="@class"/>
  <xsl:key name="odd2odd-REFED" match="rng:ref[contains(@name,'_')]" use="substring-before(@name,'_')"/>
  <xsl:key name="odd2odd-REFED" match="dataRef" use="@key"/>
  <xsl:key name="odd2odd-REFED" match="macroRef" use="@key"/>
  <xsl:key name="odd2odd-REFED" match="classRef" use="@key"/>
  <xsl:key name="odd2odd-REFED" match="elementRef" use="@key"/>

  <xsl:key name="odd2odd-REFOBJECTS" match="schemaSpec/macroRef[not(ancestor::content)]" use="@key"/>
  <xsl:key name="odd2odd-REFOBJECTS" match="schemaSpec/classRef[not(ancestor::content)]" use="@key"/>
  <xsl:key name="odd2odd-REFOBJECTS" match="schemaSpec/elementRef[not(ancestor::content)]" use="@key"/>
  <xsl:key name="odd2odd-REPLACECONSTRAINT" match="constraintSpec[@mode eq 'replace']" use="concat(../@ident,'_',@ident)"/>
  <xsl:key name="odd2odd-SCHEMASPECS" match="schemaSpec" use="@ident"/>
  <xsl:key name="odd2odd-MODULES" match="moduleSpec" use="@ident"/>

   <!-- 
        The following keys use a combination of @ident _and_ @ns
        (where present) as their key, so as to avoid problems when
        names are duplicated accross schemes.
   -->
  <xsl:key name="odd2odd-CHANGE" match="classSpec[@mode eq 'change']" use="tei:uniqueName(.)"/>
  <xsl:key name="odd2odd-CHANGE" match="dataSpec[@mode eq 'change']" use="tei:uniqueName(.)"/>
  <xsl:key name="odd2odd-CHANGE" match="elementSpec[@mode eq 'change']" use="tei:uniqueName(.)"/>
  <xsl:key name="odd2odd-CHANGE" match="macroSpec[@mode eq 'change']" use="tei:uniqueName(.)"/>

  <xsl:key name="odd2odd-DELETE" match="classSpec[@mode eq 'delete']" use="tei:uniqueName(.)"/>
  <xsl:key name="odd2odd-DELETE" match="macroSpec[@mode eq 'delete']" use="tei:uniqueName(.)"/>
  <xsl:key name="odd2odd-DELETE" match="dataSpec[@mode eq 'delete']" use="tei:uniqueName(.)"/>
  <xsl:key name="odd2odd-DELETE" match="elementSpec[@mode eq 'delete']" use="tei:uniqueName(.)"/>

  <xsl:key name="odd2odd-REPLACE" match="classSpec[@mode eq 'replace']" use="tei:uniqueName(.)"/>
  <xsl:key name="odd2odd-REPLACE" match="dataSpec[@mode eq 'replace']" use="tei:uniqueName(.)"/>
  <xsl:key name="odd2odd-REPLACE" match="elementSpec[@mode eq 'replace']" use="tei:uniqueName(.)"/>
  <xsl:key name="odd2odd-REPLACE" match="macroSpec[@mode eq 'replace']" use="tei:uniqueName(.)"/>

  <xsl:key name="odd2odd-REPLACEATT" match="attDef[@mode eq 'replace']" use="concat(../../@ident,'_',@ident)"/>

  <!-- ***** global variables ***** -->
  <xsl:variable name="top" select="/"/>
  
  <xsl:variable name="ODD">
    <xsl:for-each select="/*">
      <xsl:copy>
        <xsl:attribute name="xml:base" select="document-uri(/)"/>
        <xsl:copy-of select="@*"/>
        <xsl:if test="$useVersionFromTEI">
          <xsl:processing-instruction name="TEIVERSION">
            <xsl:call-template name="odd2odd-getversion"/>
          </xsl:processing-instruction>
        </xsl:if>
        <xsl:apply-templates mode="pass0"/>
      </xsl:copy>
    </xsl:for-each>
  </xsl:variable>
  
  <!-- location of source XML file for language we are customizing -->
  <xsl:variable name="DEFAULTSOURCE">
    <xsl:choose>
      <!-- 
           User specified a default source, use it, stripping
           leading and trailing U+0022 characters if present.
      -->
      <xsl:when test="$defaultSource ne ''">
        <!-- Why strip them instead of just tell users not to specify 'em? —Syd, 2017-12-30 -->
        <xsl:choose>
          <xsl:when test="starts-with( $defaultSource,'&quot;') and ends-with( $defaultSource,'&quot;')">
            <xsl:value-of select="substring( $defaultSource, 2, string-length( $defaultSource )-2 )"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$defaultSource"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- User specified a configuration directory, assume our p5subset is in that -->
      <xsl:when test="$configDirectory ne ''">
        <xsl:value-of select="$configDirectory"/>
        <xsl:text>odd/p5subset.xml</xsl:text>
      </xsl:when>
      <!-- 
           No clues from user, use default path to web veresion (which
           user may have overridden via parameters).
      -->
      <xsl:otherwise>
        <xsl:value-of select="$defaultTEIServer"/>
        <xsl:value-of select="$defaultTEIVersion"/>
        <xsl:text>/xml/tei/odd/p5subset.xml</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="teins" select="'http://www.tei-c.org/ns/1.0'"/>

  <!-- ***** functions ***** -->
  <!-- 
    NOTE added 2016-12-02 by Syd: Many, if not most, of the functions
    below duplicate in name functions that are in teiodds.xsl. The
    files odd2relax, odd2dtd, odd2html, and even odd2json & odd2lite
    import that file. But this one does not. I do not know if the
    functions are slightly different, or if there is some other reason
    this file does not import teiodds.xsl. Someday I hope to test this
    out and do the right thing (either import that file so there is
    only 1 definition of each function, or add documentation
    explaining why not and perhaps re-name the functions so the
    difference is clear). But for now, since I'm in a rush, I'm just
    following the lead of what's here already, and copying my new
    function from teiodds to here.
  -->

  <xd:doc>
    <xd:desc>
      <xd:p>Given an element or attribute identifier and a list of @include and @except
      GIs or attribute names, return false() if a) there is an @include and the
      identifier is not in its list, or b) there is an @except and the identifier
      is in its list.</xd:p>
    </xd:desc>
    <xd:param name="ident">a GI or an attribute name</xd:param>
    <xd:param name="exc">the @except list from the &lt;moduleRef> the &lt;classRef> being examined</xd:param>
    <xd:param name="inc">the @include list from the &lt;moduleRef> the &lt;classRef> being examined</xd:param>
  </xd:doc>
  <xsl:function name="tei:includeMember" as="xs:boolean">
    <xsl:param name="ident" as="xs:string"/>
    <!-- the values of $exc and $inc should be space-normalized before reaching us -->
    <xsl:param name="exc"/>
    <xsl:param name="inc"/>
    <xsl:choose>
      <xsl:when test="not($exc) and not($inc)">
        <xsl:sequence select="true()"/>
      </xsl:when>
      <xsl:when test="$inc  and  $ident = tokenize( $inc,'&#x20;')">
        <xsl:sequence select="true()"/>
      </xsl:when>
      <xsl:when test="$inc">
        <xsl:sequence select="false()"/>
      </xsl:when>
      <xsl:when test="$exc  and  $ident = tokenize( $exc,'&#x20;')">
        <xsl:sequence select="false()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="true()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xd:doc>
    <xd:desc>
      <xd:p>Given a context node, figure out which ODD source file it
      is supposed to be customizing.</xd:p>
    </xd:desc>
    <xd:param name="context">the context node from where we were called</xd:param>
  </xd:doc>
  <xsl:function name="tei:workOutSource" as="xs:anyURI">
    <xsl:param name="context"/>
    <xsl:variable name="loc" select="normalize-space( ( $context/@source, $context/ancestor::schemaSpec/@source, $DEFAULTSOURCE )[1] )"/>
    <!-- 
         Note: I think the above should probably instead be
         ( $context/ancestor-or-self::*[@source][1]/@source, $DEFAULTSOURCE )[1]
         but even if so, that change does not get made in this branch. See issue
         303 at target="https://github.com/TEIC/Stylesheets/issues/303. —Syd, 2017-12-30
    -->
    <xsl:variable name="source">
      <xsl:choose>
        <!-- if $loc is an absolute URI w/ scheme, just use it -->
        <xsl:when test="matches( $loc,'^(file|https?):')">
          <xsl:value-of select="$loc"/>
        </xsl:when>
        <!-- if it is an absolute filepath, use it as a file URI -->
        <xsl:when test="starts-with( $loc,'/')">
          <xsl:value-of select="resolve-uri( $loc, 'file:///')"/>
        </xsl:when>
        <!-- if it is our private URI scheme, expand it automagically -->
        <xsl:when test="starts-with( $loc,'tei:')">
          <xsl:value-of select="replace( $loc, 'tei:', $defaultTEIServer )"/>
          <xsl:text>/xml/tei/odd/p5subset.xml</xsl:text>
        </xsl:when>
        <!-- 
             If we can figure out the base URI of the input document, then
             just use $loc raw (unless user specified an overriding current
             directory, in which case prepend it).
        -->
        <!-- (Note: that is what this code is doing, but I don't get it —Syd, 2017-12-30) -->
        <xsl:when test="base-uri( $top ) eq ''">
          <xsl:value-of select="$currentDirectory"/>
          <xsl:value-of select="$loc"/>
        </xsl:when>
        <!-- 
             OK, so we *can* figure out the base URI, use it. Since
             user did not specify an overriding current directory,
             just use URI of source againt base URI of input doc.
        -->
        <xsl:when test="$currentDirectory=''">
          <xsl:value-of select="resolve-uri( $loc, base-uri( $top ) )"/>
        </xsl:when>
        <!-- 
             Same as above, but user did specify an overriding current
             directory, so prepend that.
        -->
        <xsl:otherwise>
          <xsl:value-of select="resolve-uri( string-join( ( $currentDirectory, $loc ),'/'), base-uri( $top ) )"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- OK, now we have a $source URI. -->
    <xsl:choose>
      <xsl:when test="doc-available( $source )">
        <xsl:if test="$verbose">
          <xsl:message>Setting source document to <xsl:value-of select="$source"/></xsl:message>
        </xsl:if>
        <xsl:sequence select="$source"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="die">
          <xsl:with-param name="message">
            <xsl:text>Source </xsl:text>
            <xsl:value-of select='($source,$loc,name($top),base-uri($top))' separator=" + "/>
            <xsl:text> not readable</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xd:doc>
    <xd:desc>Function to execute an &lt;xsl:message></xd:desc>
    <xd:param name="message">the message text to emit</xd:param>
  </xd:doc>
  <xsl:function name="tei:message" as="empty-sequence()">
    <xsl:param name="message"/>
    <xsl:message><xsl:value-of select="$message"/></xsl:message>
  </xsl:function>

  <xd:doc>
    <xd:desc>Function to generate a unique key based on the namespace in which we are
    currently generating constructs and the local name of the construct being addressed.</xd:desc>
    <xd:param name="context">the context node from where we were called</xd:param>
    <xd:return>a string that can be used to uniquely identify the construct represented by the $context.
    In particular, its namespace (if other than TEI) concatonated to its identifier.</xd:return>
  </xd:doc>
  <xsl:function name="tei:uniqueName" as="xs:string">
    <xsl:param name="context"/>
    <xsl:sequence select="concat(
                          if ( $context/@ns eq $teins )
                            then ''
                            else ( $context/@ns, $context/ancestor::schemaSpec/@ns, '')[1],
                          $context/@ident
                          )"/>
  </xsl:function>

  <xd:doc>
    <xd:param name="minOccurs">string value of @minOccurs attr</xd:param>
    <xd:param name="maxOccurs">string value of @maxOccurs attr</xd:param>
    <xd:return>a sequence of 2 integers representing the integer values thereof with -1 used to indicate "unbounded"</xd:return>
  </xd:doc>
  <xsl:function name="tei:minOmaxO" as="xs:integer">
    <xsl:param name="minOccurs"/>
    <xsl:param name="maxOccurs"/>
    <!-- get the value of @minOccurs, defaulting to "1" -->
    <xsl:variable name="minOccurs" select="( $minOccurs, '1')[1]"/>
    <!-- get the value of @maxOccurs, defaulting to "1" -->
    <xsl:variable name="maxOccurs" select="( $maxOccurs, '1')[1]"/>
    <!-- We now have two _string_ representations of the attrs, but -->
    <!-- we need integers. So cast them, converting "unbounded" to  -->
    <!-- a special flag value (-1): -->
    <xsl:variable name="min" select="xs:integer( $minOccurs )"/>
    <xsl:variable name="max">
      <xsl:choose>
        <xsl:when test="$maxOccurs castable as xs:integer">
          <xsl:value-of select="xs:integer( $maxOccurs )"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- Must be "unbounded". -->
          <xsl:value-of select="-1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:sequence select="( $min, $max )"/>
  </xsl:function>

  <!-- ***** subroutines (i.e., named templates) ***** -->
  <xd:doc>
    <xd:desc>Issue error msg and stop execution</xd:desc>
    <xd:param name="message">the error message to display</xd:param>
    <xd:return>N/A: execution is halted.</xd:return>
  </xd:doc>
  <xsl:template name="die">
    <xsl:param name="message"/>
    <xsl:message terminate="yes">
      <xsl:text>Error: odd2odd.xsl: </xsl:text>
      <xsl:value-of select="$message"/>
    </xsl:message>
  </xsl:template>
  
  <!-- ***** start main processing ***** -->
  <xd:doc>
    <xd:desc>Process root by taking output of pass0 and processing in pass1</xd:desc>
  </xd:doc>
  <xsl:template match="/">
    <xsl:apply-templates mode="pass1" select="$ODD"/>
  </xsl:template>

  <!-- ******************* Pass 0, follow and expand specGrp ********************************* -->

  <xd:doc>
    <xd:desc><xd:i>pass 0</xd:i>: unless specified below, just copy over</xd:desc>
  </xd:doc>
  <xsl:template match="@*|node()" mode="pass0">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="pass0"/>
    </xsl:copy>
  </xsl:template>
  
  <xd:doc>
    <xd:desc><xd:i>pass 0</xd:i>: Ignore &lt;specGrp> w/o interesting children</xd:desc>
  </xd:doc>
  <xsl:template match="specGrp">
    <xsl:if test="$verbose">
      <xsl:message>Phase 0: ignore childless specGrp <xsl:value-of select="@xml:id"/>&#x0A;</xsl:message>
    </xsl:if>
  </xsl:template>
  
  <xd:doc>
    <xd:desc><xd:i>pass 0</xd:i>: Generate a descriptive table of the &lt;specGrp></xd:desc>
  </xd:doc>
  <xsl:template match="specGrp[ specGrpRef | elementSpec | classSpec | macroSpec | dataSpec | moduleRef ]" mode="pass0">
    <xsl:if test="$verbose">
      <xsl:message>Phase 0: summarize specGrp <xsl:value-of select="@xml:id"/>&#x0A;</xsl:message>
    </xsl:if>
    <table rend="specGrpSummary">
      <xsl:apply-templates select="specGrpRef|elementSpec|classSpec|macroSpec|dataSpec|moduleRef" mode="specGrpTableRow"></xsl:apply-templates>
    </table>
  </xsl:template>
  <xd:doc>
    <xd:desc><xd:i>pass 0</xd:i>: table row for &lt;specGrpRef: prose in cell 1</xd:desc>
  </xd:doc>
  <xsl:template match="specGrpRef" mode="specGrpTableRow">
    <row>
      <cell>
        <ref target="#{@target}">reference <xsl:value-of select="@target"/></ref>
      </cell>
      <cell/>
    </row>
  </xsl:template>
  <xd:doc>
    <xd:desc><xd:i>pass 0</xd:i>: table row for &lt;elementSpec: prose in cell 1, mode in cell 2</xd:desc>
  </xd:doc>
  <xsl:template match="elementSpec" mode="specGrpTableRow">
    <row>
      <cell>
        Element <gi><xsl:value-of select="@ident"/></gi>
      </cell>
      <cell>
        <xsl:value-of select="@mode"/>
      </cell>
    </row>
  </xsl:template>
  <xd:doc>
    <xd:desc><xd:i>pass 0</xd:i>: table row for &lt;classSpec: prose in cell 1, mode in cell 2</xd:desc>
  </xd:doc>
  <xsl:template match="classSpec" mode="specGrpTableRow">
    <row>
      <cell>
        Class <ident type="class"><xsl:value-of select="@ident"/></ident>
      </cell>
      <cell>
        <xsl:value-of select="@mode"/>
      </cell>
    </row>
  </xsl:template>
  <xd:doc>
    <xd:desc><xd:i>pass 0</xd:i>: table row for &lt;macroSpec: prose in cell 1, mode in cell 2</xd:desc>
  </xd:doc>
  <xsl:template match="macroSpec" mode="specGrpTableRow">
    <row>
      <cell>
        Macro <ident type="macro"><xsl:value-of select="@ident"/></ident>
      </cell>
      <cell>
        <xsl:value-of select="@mode"/>
      </cell>
    </row>
  </xsl:template>
  <xd:doc>
    <xd:desc><xd:i>pass 0</xd:i>: table row for &lt;dataSpec: prose in cell 1, mode in cell 2</xd:desc>
  </xd:doc>
  <xsl:template match="dataSpec" mode="specGrpTableRow">
    <row>
      <cell>
        Data <ident type="macro"><xsl:value-of select="@ident"/></ident>
      </cell>
      <cell>
        <xsl:value-of select="@mode"/>
      </cell>
    </row>
  </xsl:template>
  <xd:doc>
    <xd:desc><xd:i>pass 0</xd:i>: table row for &lt;moduleRef: prose in cell 1</xd:desc>
  </xd:doc>
  <xsl:template match="moduleRef" mode="specGrpTableRow">
    <row>
      <cell>
        Module <xsl:value-of select="@key"/>
      </cell>
      <cell/>
    </row>
  </xsl:template>
  
  <xd:doc>
    <xd:desc><xd:i>pass 0</xd:i>: Ignore &lt;schemaSpec>s other than selected</xd:desc>
  </xd:doc>
  <xsl:template match="schemaSpec" mode="pass0">
    <xsl:message>DEBUG: Ignoring schemaSpec <xsl:value-of select="@ident"/> as selectedSchema=<xsl:value-of select="$selectedSchema"/>!</xsl:message>
  </xsl:template>
  
  <xd:doc>
    <xd:desc><xd:i>pass 0</xd:i>: Process selected &lt;schemaSpec></xd:desc>
  </xd:doc>
  <xsl:template match="schemaSpec[ @ident eq $selectedSchema ]" mode="pass0">
    <xsl:message>DEBUG: Processing schemaSpec <xsl:value-of select="@ident"/> as selectedSchema=<xsl:value-of select="$selectedSchema"/>!</xsl:message>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <!-- generate a @defaultExceptions attribute if it's not present -->
      <xsl:if test="not(@defaultExceptions)">
        <!-- first, get the default value of @defaultExceptions from the source -->
        <xsl:variable name="defval" select="document(tei:workOutSource(.))//elementSpec[@ident eq 'schemaSpec']//attDef[@ident eq 'defaultExceptions']/defaultVal"/>
        <!-- there are two kinds of values: QNames and URIs; we want to declare the namespace of the QNames -->
        <xsl:for-each select="tokenize($defval,'\s+')">
          <xsl:if test=". castable as xs:QName">
            <!-- Yes, an NCName is castable as a QName, since the prefix and colon are optional,
            however, we know there is a colon because the schema requires it. -->
            <xsl:variable name="prefix" select="substring-before(., ':')"/>
            <xsl:namespace name="{$prefix}" select="namespace-uri-for-prefix( $prefix, $defval )"/>
          </xsl:if>
        </xsl:for-each>
        <xsl:if test="$defval">
          <xsl:attribute name="defaultExceptions" select="$defval"/>
        </xsl:if>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="@source">
          <xsl:if test="$verbose">
            <xsl:message>Source for TEI is <xsl:value-of select="@source"/></xsl:message>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$verbose">
            <xsl:message>Source for TEI will be set to <xsl:value-of select="$DEFAULTSOURCE"/> </xsl:message>
          </xsl:if>
          <xsl:attribute name="source">
            <xsl:value-of select="$DEFAULTSOURCE"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <!-- process my children, except for comments (why not?) -->
      <xsl:apply-templates select="*|text()|processing-instruction()" mode="pass0"/>
    </xsl:copy>
  </xsl:template>
  
  <xd:doc>
    <xd:desc><xd:i>pass 0</xd:i>: Expand &lt;specGrpRef>s</xd:desc>
  </xd:doc>
  <xsl:template match="specGrpRef" mode="pass0">
    <xsl:variable name="target" select="normalize-space( @target )"/>
    <xsl:sequence select="if ($verbose) then tei:message(concat('Phase 0: expand specGrpRef ', $target )) else ()"/>
    <xsl:choose>
      <xsl:when test="starts-with( $target,'#')">
        <!-- If target is a pointer to a local element, process its children here -->
        <xsl:apply-templates mode="pass0" select="id( substring( $target, 2 ) )/*"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- If target is a pointer outside the current document, resolve it (in case it is relative) ... -->
        <xsl:variable name="externalTarget" select="resolve-uri( $target, base-uri( /TEI ) )"/>
        <xsl:if test="$verbose">
          <xsl:sequence select="tei:message( concat('... read from ', $externalTarget ) )"/>
        </xsl:if>
        <xsl:for-each select="doc( $externalTarget )">
          <!-- ... then take what it points to and ... -->
          <xsl:choose>
            <xsl:when test="specGrp">
              <!-- ... if it has <specGrp> children, process their children ... -->
              <xsl:apply-templates select="specGrp/*" mode="pass0"/>
            </xsl:when>
            <xsl:otherwise>
              <!-- ... if not, just process its children (presumably it is a <specGrp>? —Syd, 2018-01-01) -->
              <xsl:apply-templates  mode="pass0"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xd:doc>
    <xd:desc>
      <xd:p><xd:i>pass 0</xd:i>: Process &lt;*Spec>s in mode "change"</xd:p>
      <xd:p>Regardless of how many &lt;*Spec> elements in "change" mode
      there are for a given construct, create one output element that
      has the attributes of the first one, and the [output of processing the] children
      of all of them [in mode "pass0"]</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="elementSpec[@mode eq 'change']|classSpec[@mode eq 'change']|macroSpec[@mode eq 'change']|dataSpec[@mode eq 'change']" mode="pass0">
    <xsl:if test=". is key('odd2odd-CHANGE',@ident)[1]">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:for-each select="key('odd2odd-CHANGE',@ident)">
          <!-- Yes, if there only is 1 such node, this <for-each> is completely pointless -->
          <xsl:apply-templates select="node()" mode="pass0"/>
        </xsl:for-each>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

  <!-- ******************* Phase 1, expand schemaSpec ********************************* -->

  <xsl:template match="schemaSpec" mode="pass1">
    <xsl:variable name="pass1">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:sequence select="if ($verbose)then
          tei:message(concat('Schema pass 1: ',@ident)) else ()"/>

        <!--
          it is important to process "tei" and "core" first
          because of the order of declarations
        -->
        <xsl:for-each select="moduleRef[@key eq 'tei']">
          <xsl:call-template name="odd2odd-expandModule"/>
        </xsl:for-each>

        <xsl:for-each select="moduleRef[@key eq 'core']">
          <xsl:call-template name="odd2odd-expandModule"/>
        </xsl:for-each>

        <xsl:for-each select="moduleRef[@key]">
          <xsl:if test="not(@key eq 'tei' or @key eq 'core')">
            <xsl:call-template name="odd2odd-expandModule"/>
          </xsl:if>
        </xsl:for-each>
        <xsl:for-each
          select="*[not(self::moduleRef[@key])]">
          <xsl:apply-templates select="." mode="pass1"/>
        </xsl:for-each>
      </xsl:copy>
    </xsl:variable>
    <!--
        <xsl:result-document href="/tmp/odd2odd-pass1.xml">
          <xsl:copy-of select="$pass1"/>
        </xsl:result-document>
    -->
    <xsl:for-each select="$pass1">
      <xsl:apply-templates mode="pass2"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="*" mode="pass1">
    <xsl:copy>
      <xsl:apply-templates mode="pass1" select="@*|*|processing-instruction()|comment()|text()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|processing-instruction()|text()|comment()" mode="pass1">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="elementSpec[@mode eq 'delete']|classSpec[@mode eq 'delete']|macroSpec[@mode eq 'delete']|dataSpec[@mode eq 'delete']"
                mode="pass1">
        <xsl:if test="$verbose">
          <xsl:message>Phase 1: remove <xsl:value-of select="@ident"/></xsl:message>
        </xsl:if>
  </xsl:template>

  <xsl:template match="elementSpec|classSpec|macroSpec|dataSpec"
                mode="pass1">
    <xsl:variable name="specName" select="@ident"/>
    <xsl:choose>
      <xsl:when test="$ODD/key('odd2odd-DELETE',$specName)">
        <xsl:if test="$verbose">
          <xsl:message>Phase 1: remove <xsl:value-of select="$specName"/></xsl:message>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$verbose">
          <xsl:message>Phase 1: hang onto <xsl:value-of
          select="$specName"/> <xsl:if test="@mode"> in mode <xsl:value-of
          select="@mode"/></xsl:if></xsl:message>
        </xsl:if>
        <xsl:copy>
          <xsl:apply-templates mode="pass1" select="@*|*|processing-instruction()|comment()|text()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="pass1"
                match="schemaSpec//classSpec[  @mode eq 'add' or not(@mode) ]
                     | schemaSpec//macroSpec[  @mode eq 'add' or not(@mode) ]
                     | schemaSpec//dataSpec [  @mode eq 'add' or not(@mode) ]
                     | schemaSpec//elementSpec[@mode eq 'add' or not(@mode) ]
                     ">
    <xsl:call-template name="odd2odd-createCopy"/>
  </xsl:template>

  <xsl:template match="dataRef|macroRef|classRef|elementRef"
    mode="pass1">
    <xsl:choose>
      <xsl:when test="ancestor::content">
        <xsl:copy-of select="."/>
      </xsl:when>
      <xsl:when test="ancestor::datatype">
        <xsl:copy-of select="."/>
      </xsl:when>
      <xsl:when test="@name">
        <xsl:copy-of select="."/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="sourceDoc" select="tei:workOutSource(.)"/>
        <xsl:variable name="name" select="@key"/>
        <xsl:variable name="id" select="ancestor::*[@ident]/@ident"/>
        <xsl:for-each select="document($sourceDoc,$top)">
          <xsl:choose>
            <xsl:when test="key('odd2odd-IDENTS',$name)">
              <xsl:for-each select="key('odd2odd-IDENTS',$name)">
                <xsl:if test="$verbose">
                  <xsl:message>Phase 1: import <xsl:value-of  select="$name"/> by direct reference</xsl:message>
                </xsl:if>
                <xsl:apply-templates mode="pass1" select="."/>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="die">
                <xsl:with-param name="message">
                  <xsl:text>Reference to </xsl:text>
                  <xsl:value-of select="$name"/>
                  <xsl:text> in </xsl:text>
                  <xsl:value-of select="$id"/>
                  <xsl:text>: not found in source</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="odd2odd-expandModule">
    <xsl:variable name="sourceDoc" select="tei:workOutSource(.)"/>
    <xsl:variable name="name" select="@key"/>
    <xsl:variable name="exc" select="normalize-space( @except )"/>
    <xsl:variable name="inc" select="normalize-space( @include )"/>
    <xsl:sequence select="if ($verbose) then
                          tei:message(concat('Process module reference to [',@key,'] with exclusion/inclusion of [',@except,'/',@include,']')) else ()"/>
          <xsl:for-each select="document($sourceDoc,$top)">

            <!-- get model and attribute classes regardless -->
            <xsl:for-each select="key('odd2odd-MODULE_MEMBERS_NONELEMENT',$name)">
              <xsl:variable name="class" select="@ident"/>
              <xsl:if test="not($ODD/key('odd2odd-REFOBJECTS',$class))">
                <xsl:if test="$verbose">
                  <xsl:message>Phase 1: import <xsl:value-of select="$class"/> by moduleRef</xsl:message>
                </xsl:if>
                <xsl:apply-templates mode="pass1" select="."/>
              </xsl:if>
            </xsl:for-each>

            <!-- now elements -->
            <xsl:for-each select="key('odd2odd-MODULE_MEMBERS_ELEMENT',$name)">
              <xsl:variable name="i" select="@ident"/>
              <xsl:if test="tei:includeMember(@ident,$exc,$inc)
                and not($ODD/key('odd2odd-REFOBJECTS',$i))">
                <xsl:if test="$verbose">
                  <xsl:message>Phase 1: import <xsl:value-of
                    select="$i"/> by moduleRef</xsl:message>
                </xsl:if>
                <xsl:apply-templates mode="pass1" select="."/>
              </xsl:if>
            </xsl:for-each>
          </xsl:for-each>
  </xsl:template>

  <xsl:template match="elementSpec[@mode = ('change','replace')]
                     | classSpec[ @mode  = ('change','replace')]
                     | macroSpec[ @mode  = ('change','replace')]
                     | dataSpec[ @mode   = ('change','replace')]"
                mode="pass1"/>

  <xsl:template match="classSpec/attList/attDef" mode="pass1">
    <xsl:variable name="c" select="ancestor::classSpec/@ident"/>
    <xsl:variable name="a" select="@ident"/>
    <xsl:choose>
      <xsl:when test="$ODD/key('odd2odd-REFED',$c)[@include or @except]">
        <xsl:if test="tei:includeMember(@ident,$ODD/key('odd2odd-REFED',$c)/@except,$ODD/key('odd2odd-REFED',$c)/@include)">
          <xsl:if test="$verbose">
            <xsl:message>  keeping attribute <xsl:value-of
              select="(ancestor::classSpec/@ident,@ident)" separator="/"/></xsl:message>
          </xsl:if>
          <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="pass1"/>
          </xsl:copy>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()" mode="pass1"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- ******************* Phase 2, make the changes ********************************* -->
  <xsl:template match="@*|processing-instruction()|text()|comment()" mode="pass2">
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="*" mode="pass2">
    <xsl:copy>
      <xsl:apply-templates mode="#current" select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()" mode="justcopy"/>

  <xsl:template match="@*|text()|processing-instruction()|exemplum//comment()" mode="justcopy">
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="*" mode="justcopy">
    <xsl:param name="rend"/>
    <xsl:copy>
      <xsl:if test="$rend">
        <xsl:attribute name="rend" select="$rend"/>
      </xsl:if>
      <xsl:apply-templates select="@*|node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="a:* | rng:*" mode="justcopy">
    <xsl:copy>
      <xsl:apply-templates select="@*|*|processing-instruction()|text()" mode="#current"/>
    </xsl:copy>
  </xsl:template>

   <xsl:template match="schemaSpec" mode="pass2">
     <xsl:variable name="oddsource">
       <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:sequence select="if ($verbose)then
           tei:message(concat('Schema pass 2: ',@ident))
           else ()"/>
         <xsl:for-each select="*">
           <xsl:call-template name="odd2odd-checkObject"/>
         </xsl:for-each>
       </xsl:copy>
     </xsl:variable>
    <xsl:for-each select="$oddsource">
      <xsl:apply-templates mode="pass3"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="odd2odd-checkObject">
    <!--
        for every object
         - if its in the ODD spec's REPLACE list, use that
         - if its in ODD spec's CHANGE list  (do the hard merge bit)
               - if its duplicated by an existing spec, ignore
         - otherwise copy
        done
  -->

    <xsl:variable name="specName" select="tei:uniqueName(.)"/>
    <xsl:variable name="N" select="local-name(.)"/>
    <xsl:choose>
      <xsl:when test="$ODD/key('odd2odd-DELETE',$specName)">
        <xsl:if test="$verbose">
          <xsl:message>Phase 2: delete <xsl:value-of select="$specName"/></xsl:message>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$ODD/key('odd2odd-REPLACE',$specName)">
        <xsl:if test="$verbose">
          <xsl:message>Phase 2: replace <xsl:value-of select="$specName"/></xsl:message>
        </xsl:if>
        <xsl:apply-templates mode="odd2odd-copy" select="$ODD/key('odd2odd-REPLACE',$specName)"/>
      </xsl:when>
      <xsl:when test="$ODD/key('odd2odd-CHANGE',$specName)">
        <xsl:if test="$verbose">
          <xsl:message>Phase 2: change <xsl:value-of select="$specName"/></xsl:message>
        </xsl:if>
        <xsl:apply-templates mode="odd2odd-change" select="."/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$verbose">
          <xsl:message>Phase 2: keep <xsl:value-of  select="($N,$specName)"/></xsl:message>
        </xsl:if>
        <xsl:apply-templates mode="justcopy" select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="odd2odd-change odd2odd-copy"
                match="@*|processing-instruction()|text()">
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="*" mode="odd2odd-change">
    <xsl:copy>
      <xsl:apply-templates mode="odd2odd-change" select="@*|*|processing-instruction()|text()"/>
    </xsl:copy>
  </xsl:template>

<!--  <xsl:template match="rng:*" mode="odd2odd-change">
    <xsl:element xmlns="http://relaxng.org/ns/structure/1.0" name="{local-name()}">
      <xsl:apply-templates mode="odd2odd-change" select="@*|*|processing-instruction()|text()"/>
    </xsl:element>
  </xsl:template>
 USELESS template to be removed? see e-mail "copying craziness" of 2016-11-15 22:54Z -->

<!--  <xsl:template match="elementSpec/@mode" mode="odd2odd-change">
    <xsl:copy/>
  </xsl:template>
 USELESS? same as above, I think. -->
  <xsl:variable name="key" select="@key"/>
  <xsl:variable name="whence" select="local-name()"/>

  <xsl:template match="elementSpec" mode="odd2odd-change">
    <xsl:variable name="elementName" select="tei:uniqueName(.)"/>
    <xsl:variable name="ORIGINAL" select="."/>
    <xsl:copy>
      <xsl:attribute name="rend">change</xsl:attribute>
      <xsl:apply-templates mode="odd2odd-change" select="@*"/>
      <!--
              For each element, go through most of the sections one by one
              and see if they are present in the change mode version.
              If so, use them as is. The constraints and attributes are identifiable
              for change individually.
      -->
      <xsl:for-each select="$ODD/key('odd2odd-CHANGE',$elementName)">
        <xsl:copy-of select="@ns"/>
        <!-- if there is an altIdent, use it -->
        <xsl:apply-templates mode="justcopy" select="altIdent"/>
        <!-- equiv, gloss, desc trio -->
        <xsl:choose>
          <xsl:when test="equiv">
            <xsl:apply-templates mode="justcopy"
              select="equiv">
              <xsl:with-param name="rend">replace</xsl:with-param>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
              <xsl:apply-templates mode="justcopy" select="$ORIGINAL/equiv"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="gloss">
              <xsl:apply-templates mode="justcopy" select="gloss">
                <xsl:with-param name="rend">replace</xsl:with-param>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="justcopy" select="$ORIGINAL/gloss"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="$stripped"/>
            <xsl:when test="desc">
              <xsl:apply-templates mode="justcopy" select="desc">
                <xsl:with-param name="rend">replace</xsl:with-param>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="justcopy" select="$ORIGINAL/desc"/>
            </xsl:otherwise>
          </xsl:choose>
          <!-- classes -->
          <classes>
            <xsl:choose>
              <xsl:when test="classes[@mode eq 'change']">
                <xsl:for-each select="classes/memberOf">
                  <xsl:choose>
                    <xsl:when test="@mode eq 'delete'"/>
                    <xsl:when test="@mode eq 'add' or not (@mode)">
                      <memberOf key="{@key}">
                        <xsl:copy-of select="@min|@max"/>
                      </memberOf>
                    </xsl:when>
                  </xsl:choose>
                </xsl:for-each>
                <xsl:for-each select="$ORIGINAL">
                  <xsl:for-each select="classes/memberOf">
                    <xsl:variable name="me">
                      <xsl:value-of select="@key"/>
                    </xsl:variable>
                    <xsl:variable name="metoo">
                      <xsl:value-of select="concat(../../@ident,@key)"/>
                    </xsl:variable>
                      <xsl:choose>
                        <xsl:when test="$ODD/key('odd2odd-DELETE',$me)"> </xsl:when>
                        <xsl:when test="$ODD/key('odd2odd-MEMBEROFDELETE',$metoo)"> </xsl:when>
                        <xsl:when test="$ODD/key('odd2odd-MEMBEROFADD',$metoo)"> </xsl:when>
                        <xsl:otherwise>
                          <memberOf key="{$me}"/>
                        </xsl:otherwise>
                      </xsl:choose>
                  </xsl:for-each>
                </xsl:for-each>
              </xsl:when>
              <xsl:when test="classes">
                <xsl:for-each select="classes/memberOf[not(@mode eq 'delete')]">
                  <xsl:copy-of select="."/>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each select="$ORIGINAL">
                  <xsl:for-each select="classes/memberOf">
                    <xsl:variable name="me">
                      <xsl:value-of select="@key"/>
                    </xsl:variable>
                    <xsl:for-each select="$ODD">
                      <xsl:if test="not(key('odd2odd-DELETE',$me))">
                        <memberOf key="{$me}"/>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:for-each>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          </classes>
          <!-- valList -->
          <xsl:choose>
            <xsl:when test="valList[@mode eq 'delete']"/>
            <xsl:when test="valList">
              <xsl:apply-templates mode="odd2odd-copy" select="valList[1]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="odd2odd-copy" select="$ORIGINAL/valList"/>
            </xsl:otherwise>
          </xsl:choose>
          <!-- element content -->
          <content>
            <xsl:choose>
              <xsl:when test="content and not(content/*)"/>
              <xsl:when test="content/rng:*">
                <xsl:apply-templates mode="odd2odd-copy" select="content/*"/>
              </xsl:when>
              <xsl:when test="content/tei:*">
                <xsl:apply-templates mode="odd2odd-copy" select="content/@*"/>
                <xsl:apply-templates mode="odd2odd-copy" select="content/*"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates mode="odd2odd-copy" select="$ORIGINAL/content/@*"/>
                <xsl:apply-templates mode="odd2odd-copy" select="$ORIGINAL/content/*"/>
              </xsl:otherwise>
            </xsl:choose>
          </content>
          <!-- element constraints -->
          <xsl:call-template name="odd2odd-processConstraints">
            <xsl:with-param name="ORIGINAL" select="$ORIGINAL"/>
            <xsl:with-param name="elementName" select="$elementName"/>
          </xsl:call-template>
          <!-- attList -->
          <attList>
            <xsl:apply-templates mode="justcopy" select="attList/@org"/>
            <xsl:call-template name="odd2odd-processAttributes">
              <xsl:with-param name="ORIGINAL" select="$ORIGINAL"/>
              <xsl:with-param name="objectName" select="$elementName"/>
            </xsl:call-template>
          </attList>


          <!-- models -->
          <xsl:choose>
            <xsl:when test="modelGrp|model|modelSequence">
              <xsl:apply-templates mode="justcopy" select="modelGrp|model|modelSequence"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="justcopy" select="$ORIGINAL/modelGrp|$ORIGINAL/model|$ORIGINAL/modelSequence"/>
            </xsl:otherwise>
          </xsl:choose>

          <!-- exempla -->
          <xsl:choose>
            <xsl:when test="$stripped"/>
            <xsl:when test="exemplum">
              <xsl:apply-templates mode="justcopy" select="exemplum"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="justcopy" select="$ORIGINAL/exemplum"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="$stripped"/>
            <xsl:when test="remarks">
              <xsl:apply-templates mode="justcopy" select="remarks"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="justcopy" select="$ORIGINAL/remarks"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="listRef">
              <xsl:apply-templates mode="justcopy" select="listRef"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="justcopy" select="$ORIGINAL/listRef"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="dataSpec|macroSpec" mode="odd2odd-change">
    <xsl:variable name="specName" select="tei:uniqueName(.)"/>
    <xsl:variable name="ORIGINAL" select="."/>
    <xsl:copy>
      <xsl:attribute name="rend">change</xsl:attribute>
      <xsl:apply-templates mode="odd2odd-change" select="@*"/>
      <!--
           For each macro, go through most of the sections one by one
           and see if they are present in the change mode version.
           If so, use them as is.
      -->
      <xsl:for-each select="$ODD">
        <xsl:for-each select="key('odd2odd-CHANGE',$specName)">
          <!-- if there is an altIdent, use it -->
          <xsl:apply-templates mode="justcopy" select="altIdent"/>
          <!-- equiv, gloss, desc trio -->
          <xsl:choose>
            <xsl:when test="$stripped"/>
            <xsl:when test="equiv">
              <xsl:apply-templates mode="justcopy"
                select="equiv">
                <xsl:with-param name="rend">replace</xsl:with-param>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="odd2odd-copy" select="$ORIGINAL/equiv"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="gloss">
              <xsl:apply-templates mode="justcopy" select="gloss">
                <xsl:with-param name="rend">replace</xsl:with-param>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="justcopy" select="$ORIGINAL/gloss"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="$stripped"/>
            <xsl:when test="desc">
              <xsl:apply-templates mode="justcopy" select="desc">
                <xsl:with-param name="rend">replace</xsl:with-param>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="justcopy" select="$ORIGINAL/desc"/>
            </xsl:otherwise>
          </xsl:choose>
          <!-- content -->
          <xsl:choose>
            <xsl:when test="dataRef">
              <xsl:apply-templates mode="justcopy" select="dataRef">
                <xsl:with-param name="rend">replace</xsl:with-param>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="content">
              <xsl:apply-templates mode="justcopy" select="content">
                <xsl:with-param name="rend">replace</xsl:with-param>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="$ORIGINAL/dataRef">
              <xsl:apply-templates mode="odd2odd-copy" select="$ORIGINAL/dataRef">
                <xsl:with-param name="rend">replace</xsl:with-param>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="odd2odd-copy" select="$ORIGINAL/content"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="valList">
              <xsl:apply-templates mode="justcopy" select="valList[1]">
                <xsl:with-param name="rend">replace</xsl:with-param>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="stringVal">
              <xsl:apply-templates mode="justcopy" select="stringVal"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="odd2odd-copy" select="$ORIGINAL/stringVal"/>
            </xsl:otherwise>
          </xsl:choose>
          <!-- constraints -->
          <xsl:call-template name="odd2odd-processConstraints">
            <xsl:with-param name="ORIGINAL" select="$ORIGINAL"/>
            <xsl:with-param name="elementName" select="$specName"/>
          </xsl:call-template>
          <!-- exemplum, remarks and listRef are either replacements or not -->
          <xsl:choose>
            <xsl:when test="$stripped"/>
            <xsl:when test="exemplum">
              <xsl:apply-templates mode="justcopy" select="exemplum"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="justcopy" select="$ORIGINAL/exemplum"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="remarks">
              <xsl:apply-templates mode="justcopy" select="remarks"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="justcopy" select="$ORIGINAL/remarks"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="$stripped"/>
            <xsl:when test="listRef">
              <xsl:apply-templates mode="justcopy" select="listRef"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="justcopy" select="$ORIGINAL/listRef"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="classSpec" mode="odd2odd-change">
    <xsl:variable name="className" select="tei:uniqueName(.)"/>
    <xsl:variable name="ORIGINAL" select="."/>
    <xsl:copy>
      <xsl:attribute name="rend">change</xsl:attribute>
      <xsl:apply-templates mode="odd2odd-change" select="@*"/>
      <!-- for each section of the class spec,
     go through the sections one by one
     and see if they are present in the change mode version -->
      <xsl:for-each select="$ODD">
        <xsl:for-each select="key('odd2odd-CHANGE',$className)">
          <!-- context is now a classSpec in change mode in the ODD spec -->
          <!-- description -->
          <!-- For each non-identifiable element type (namely:
               <gloss>, <altIdent>, <equiv>, <desc>, then <remarks>,
               <exemplum>, and <listRef>) copy instances over from the
               customization ODD if it is present there, and from the
               original source ODD if it is not present in the context
               node; unless we are stripping out prose content stuff,
               in which case some are not copied no matter what. The
               <classes>, <constraintSpec>s, and <attList> are handled
               differently, as they are identifiable. -->
          <xsl:choose> <!-- maybe copy <gloss>s from ODD or ORIGINAL -->
            <xsl:when test="$stripped"/>
            <xsl:when test="gloss">
              <xsl:apply-templates mode="justcopy" select="gloss"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="justcopy" select="$ORIGINAL/gloss"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose> <!-- copy <altIdent>s from ODD or ORIGINAL -->
            <xsl:when test="altIdent">
              <xsl:apply-templates mode="justcopy" select="altIdent"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="justcopy" select="$ORIGINAL/altIdent"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose> <!-- copy <equiv>s from ODD or ORIGINAL -->
            <xsl:when test="equiv">
              <xsl:apply-templates mode="justcopy" select="equiv"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="justcopy" select="$ORIGINAL/equiv"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose> <!-- maybe copy <desc>s from ODD or ORIGINAL -->
            <xsl:when test="$stripped"/>
            <xsl:when test="desc">
              <xsl:apply-templates mode="justcopy" select="desc"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="justcopy" select="$ORIGINAL/desc"/>
            </xsl:otherwise>
          </xsl:choose>
          <!-- classes -->
          <classes>
            <xsl:choose>
              <xsl:when test="classes[@mode eq 'change']">
                <xsl:for-each select="classes/memberOf">
                  <xsl:choose>
                    <xsl:when test="@mode eq 'delete'"/>
                    <xsl:when test="@mode eq 'add' or not (@mode)">
                      <memberOf key="{@key}">
                        <xsl:copy-of select="@min|@max"/>
                      </memberOf>
                    </xsl:when>
                  </xsl:choose>
                </xsl:for-each>
                <xsl:for-each select="$ORIGINAL">
                  <xsl:for-each select="classes/memberOf">
                    <xsl:variable name="me">
                      <xsl:value-of select="@key"/>
                    </xsl:variable>
                    <xsl:variable name="metoo">
                      <xsl:value-of select="concat(../../@ident,@key)"/>
                    </xsl:variable>
                    <xsl:choose>
                      <xsl:when test="$ODD/key('odd2odd-DELETE',$me)"> </xsl:when>
                      <xsl:when test="$ODD/key('odd2odd-MEMBEROFDELETE',$metoo)"> </xsl:when>
                      <xsl:when test="$ODD/key('odd2odd-MEMBEROFADD',$metoo)"> </xsl:when>
                      <xsl:otherwise>
                        <memberOf key="{$me}"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each>
                </xsl:for-each>
              </xsl:when>
              <xsl:when test="classes">
                <xsl:for-each select="classes/memberOf">
                  <xsl:copy-of select="."/>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each select="$ORIGINAL">
                  <xsl:for-each select="classes/memberOf">
                    <xsl:variable name="me">
                      <xsl:value-of select="@key"/>
                    </xsl:variable>
                    <xsl:for-each select="$ODD">
                      <xsl:if test="not(key('odd2odd-DELETE',$me))">
                        <memberOf key="{$me}"/>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:for-each>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          </classes>
          <!-- constraints -->
          <xsl:call-template name="odd2odd-processConstraints">
            <xsl:with-param name="ORIGINAL" select="$ORIGINAL"/>
            <xsl:with-param name="elementName" select="$className"/>
          </xsl:call-template>
          <!-- attList -->
          <attList>
            <xsl:call-template name="odd2odd-processAttributes">
              <xsl:with-param name="ORIGINAL" select="$ORIGINAL"/>
              <xsl:with-param name="objectName" select="$className"/>
            </xsl:call-template>
          </attList>
          <xsl:choose> <!-- maybe copy <exemplum>s from ODD or ORIGINAL -->
            <xsl:when test="$stripped"/>
            <xsl:when test="exemplum">
              <xsl:apply-templates mode="justcopy" select="exemplum"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="justcopy" select="$ORIGINAL/exemplum"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose> <!-- maybe copy <remarks>s from ODD or ORIGINAL -->
            <xsl:when test="$stripped"/>
            <xsl:when test="remarks">
              <xsl:apply-templates mode="justcopy" select="remarks"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="justcopy" select="$ORIGINAL/remarks"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose> <!-- maybe copy <listRef>s from ODD or ORIGINAL -->
            <xsl:when test="$stripped"/>
            <xsl:when test="listRef">
              <xsl:apply-templates mode="justcopy" select="listRef"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="justcopy" select="$ORIGINAL/listRef"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  <!-- TODO: Duplicate the functionality here for Pure ODD constructs -->
  <xsl:template match="rng:choice|rng:list|rng:group|rng:optional|rng:oneOrMore|rng:zeroOrMore" mode="odd2odd-copy">
    <xsl:call-template name="odd2odd-simplifyRelax"/>
  </xsl:template>
  <xsl:template match="alternate|sequence" mode="odd2odd-copy">
    <xsl:call-template name="odd2odd-simplifyODD"/>
  </xsl:template>
  <xsl:template match="content//valList" mode="odd2odd-copy">
    <xsl:copy-of select="."/>
  </xsl:template>
  <xsl:template name="odd2odd-simplifyRelax">
    <xsl:variable name="element">
      <xsl:value-of select="local-name(.)"/>
    </xsl:variable>
    <!--
      for each RELAX NG content model,
      remove reference to any elements which have been
      deleted, or to classes which are empty.
      This may make the container empty,
      so that is only put back in if there is some content
    -->
    <xsl:variable name="contents">
      <WHAT>
        <xsl:for-each select="a:*|rng:*|processing-instruction()">
          <xsl:choose>
            <xsl:when test="self::a:*">
              <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:when test="self::processing-instruction()">
              <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:when test="self::rng:element | self::rng:name | self::rng:attribute | self::rng:data | self::rng:text ">
              <xsl:copy>
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates mode="odd2odd-copy"/>
              </xsl:copy>
            </xsl:when>
            <xsl:when test="self::rng:value">
              <value xmlns="http://relaxng.org/ns/structure/1.0">
                <xsl:apply-templates/>
              </value>
            </xsl:when>
            <xsl:when test="self::rng:ref">
              <xsl:variable name="N" select="@name"/>
              <xsl:for-each select="$ODD">
                <xsl:choose>
                  <xsl:when test="$stripped">
                    <ref xmlns="http://relaxng.org/ns/structure/1.0" name="{$N}"/>
                  </xsl:when>
                  <xsl:when test="key('odd2odd-DELETE',$N)"/>
                  <xsl:otherwise>
                    <ref xmlns="http://relaxng.org/ns/structure/1.0" name="{$N}"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="odd2odd-simplifyRelax"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </WHAT>
    </xsl:variable>
    <xsl:variable name="entCount">
      <xsl:value-of select="count($contents/WHAT/*)"/>
    </xsl:variable>
    <xsl:for-each select="$contents/WHAT">
      <xsl:choose>
        <xsl:when test="$entCount=1     and local-name(*)=$element">
          <xsl:copy-of select="@*|*|text()|processing-instruction()"/>
        </xsl:when>
        <xsl:when test="$element='optional'     and $entCount=1     and rng:zeroOrMore">
          <xsl:copy-of select="@*|*|text()|processing-instruction()"/>
        </xsl:when>
        <xsl:when test="$element='optional'     and $entCount=1     and rng:oneOrMore">
          <xsl:copy-of select="@*|*|text()|processing-instruction()"/>
        </xsl:when>
        <xsl:when test="$element='oneOrMore'     and $entCount=1     and rng:zeroOrMore">
          <oneOrMore xmlns="http://relaxng.org/ns/structure/1.0">
            <xsl:copy-of select="rng:zeroOrMore/*"/>
          </oneOrMore>
        </xsl:when>
        <xsl:when test="self::rng:zeroOrMore/rng:ref/@name eq 'model.global'        and preceding-sibling::rng:*[1][self::rng:zeroOrMore/rng:ref/@name eq 'model.global']"/>
        <xsl:when test="$entCount&gt;0 or $stripped">
          <xsl:element namespace="http://relaxng.org/ns/structure/1.0" name="{$element}">
            <xsl:copy-of select="@*|*|text()|processing-instruction()"/>
          </xsl:element>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="odd2odd-simplifyODD">
    <xsl:variable name="element">
      <xsl:value-of select="local-name(.)"/>
    </xsl:variable>
    <xsl:variable name="minOmaxO" select="tei:minOmaxO( @minOccurs, @maxOccurs )"/>
    <xsl:variable name="min" select="$minOmaxO[1]"/>
    <xsl:variable name="max" select="$minOmaxO[2]"/>
    <!--
      for each Pure ODD content model,
      remove reference to any elements which have been
      deleted, or to classes which are empty.
      This may make the container empty,
      so that is only put back in if there is some content
    -->
    <xsl:variable name="contents">
      <WHAT>
        <xsl:for-each select="a:*|tei:*|rng:*|processing-instruction()">
          <xsl:choose>
            <xsl:when test="self::a:* | self::processing-instruction() ">
              <xsl:copy/>
            </xsl:when>
            <!-- Keep for now to support anyXML -->
            <xsl:when test="self::rng:element | self::rng:name | self::rng:attribute">
              <xsl:copy>
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates mode="odd2odd-copy"/>
              </xsl:copy>
            </xsl:when>
            <!-- end anyXML section -->
            <xsl:when test="self::dataRef[@name] | self::textNode | self::valList |
              self::anyElement">
              <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:when test="self::classRef or self::elementRef or self::macroRef or self::dataRef">
              <xsl:variable name="N" select="@key"/>
              <xsl:variable name="current" select="."/>
              <xsl:for-each select="$ODD">
                <xsl:choose>
                  <xsl:when test="$stripped">
                    <xsl:copy-of select="$current"/>
                  </xsl:when>
                  <xsl:when test="key('odd2odd-DELETE',$N)"/>
                  <xsl:otherwise>
                    <xsl:copy-of select="$current"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="odd2odd-simplifyODD"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </WHAT>
    </xsl:variable>
    <xsl:variable name="entCount" select="count($contents/WHAT/*)"/>
    <xsl:for-each select="$contents/WHAT">
      <xsl:choose>
        <xsl:when test="$entCount eq 1 and local-name(*) eq $element">
          <xsl:copy-of select="@*|*|text()|processing-instruction()"/>
        </xsl:when>
        <!-- sequence or alternate that's zero or one containing sequence or alternate that's zero or one-->
        <xsl:when test="$element=('sequence','alternate')
                    and $min eq 0 and $max eq 1
                    and $entCount eq 1
                    and (sequence|alternate)[
                        tei:minOmaxO( @minOccurs, @maxOccurs )[1] eq 0
                        and
                        tei:minOmaxO( @minOccurs, @maxOccurs )[2] eq -1
                        ]">
          <xsl:copy-of select="@*|*|text()|processing-instruction()"/>
        </xsl:when>
        <xsl:when test="$element=('sequence','alternate')
                    and $min eq 0 and $max eq 1
                    and $entCount eq 1
                    and (sequence|alternate)[
                        tei:minOmaxO( @minOccurs, @maxOccurs )[1] eq 1
                        and
                        tei:minOmaxO( @minOccurs, @maxOccurs )[2] eq -1
                        ]">
          <xsl:copy-of select="@*|*|text()|processing-instruction()"/>
        </xsl:when>
        <!-- sequence or alternate that's zero or more containing sequence or alternate that's zero or more  -->
        <xsl:when test="$element=('sequence','alternate')
                    and $min eq 1 and $max eq -1
                    and $entCount eq 1
                    and (sequence|alternate)[
                        tei:minOmaxO( @minOccurs, @maxOccurs )[1] eq 0
                        and
                        tei:minOmaxO( @minOccurs, @maxOccurs )[2] eq -1
                        ]">
          <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:copy-of select="(sequence|alternate)/*"/>
          </xsl:copy>
        </xsl:when>
        <!-- classRef that's 0 or more immediately following a classRef that's 0 or more -->
        <xsl:when test="self::classRef[
                              @key eq 'model.global'
                              and
                              tei:minOmaxO( @minOccurs, @maxOccurs )[1] eq 0
                              and
                              tei:minOmaxO( @minOccurs, @maxOccurs )[2] eq -1
                              ] and
                          preceding-sibling::*[1][
                                self::classRef/@key eq 'model.global'
                                and
                                tei:minOmaxO( @minOccurs, @maxOccurs )[1] eq 0
                                and
                                tei:minOmaxO( @minOccurs, @maxOccurs )[2] eq -1
                                ]"/>
        <xsl:when test="$entCount gt 0 or $stripped">
          <xsl:element namespace="http://www.tei-c.org/ns/1.0" name="{$element}">
            <xsl:attribute name="minOccurs" select="$min"/>
            <xsl:attribute name="maxOccurs" select="if ($max eq -1) then 'unbounded' else $max"/>
            <xsl:copy-of select="@*|*|text()|processing-instruction()"/>
          </xsl:element>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="memberOf" mode="odd2odd-copy">
    <xsl:variable name="k" select="@key"/>
    <xsl:choose>
      <xsl:when test="key('odd2odd-DELETE',$k)"/>
      <xsl:otherwise>
        <memberOf key="{$k}">
          <xsl:copy-of select="@min|@max"/>
        </memberOf>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- following template, added 2016-06-06 by Syd Bauman, completely
       supresses <exemplum> elements from the TEI source iff
       $suppressTEIexamples (a parameter) is set to true(). Note that
       <exemplum> elements from the ODD customization file are still
       copied through. -->
  <xsl:template match="exemplum" mode="odd2odd-copy">
    <xsl:choose>
      <xsl:when test="$suppressTEIexamples"/>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates mode="odd2odd-copy" select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*" mode="odd2odd-copy">
    <xsl:copy>
      <xsl:apply-templates mode="odd2odd-copy" select="@*|*|processing-instruction()|text()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="listRef" mode="odd2odd-copy"/>

  <xsl:template match="elementSpec" mode="odd2odd-copy">
    <xsl:copy>
      <xsl:call-template name="odd2odd-copyElementSpec">
        <xsl:with-param name="n" select="'1'"/>
      </xsl:call-template>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="odd2odd-copyElementSpec">
    <xsl:param name="n"/>
    <xsl:variable name="orig" select="."/>
    <xsl:apply-templates mode="odd2odd-copy" select="@*"/>
    <xsl:apply-templates mode="justcopy" select="altIdent"/>
    <xsl:if test="not($stripped)">
      <xsl:apply-templates mode="odd2odd-copy" select="equiv"/>
      <xsl:apply-templates mode="justcopy" select="gloss"/>
      <xsl:apply-templates mode="justcopy" select="desc"/>
    </xsl:if>
    <xsl:apply-templates mode="justcopy" select="classes"/>
    <xsl:apply-templates mode="odd2odd-copy" select="content"/>
    <xsl:apply-templates mode="odd2odd-copy" select="constraintSpec"/>
    <xsl:if test="attList">
      <attList>
        <xsl:choose>
          <xsl:when test="attList[@org='choice']">
            <xsl:for-each select="attList">
              <xsl:copy>
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates mode="justcopy" select="attDef"/>
                <xsl:apply-templates mode="justcopy" select="attRef"/>
                <xsl:apply-templates mode="justcopy" select="attList"/>
              </xsl:copy>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="justcopy" select="attList/attDef"/>
            <xsl:apply-templates mode="justcopy" select="attList/attRef"/>
            <xsl:apply-templates mode="justcopy" select="attList/attList"/>
          </xsl:otherwise>
        </xsl:choose>
      </attList>
    </xsl:if>
    <xsl:apply-templates mode="odd2odd-copy" select="modelGrp|model|modelSequence"/>
    <xsl:if test="not($stripped)">
      <xsl:apply-templates mode="justcopy" select="exemplum"/>
      <xsl:apply-templates mode="justcopy" select="remarks"/>
      <xsl:apply-templates mode="justcopy" select="listRef"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="odd2odd-addClassAttsToCopy">
  </xsl:template>

  <xsl:template name="odd2odd-processAttributes">
    <xsl:param name="ORIGINAL"/>
    <xsl:param name="objectName"/>
    <!-- we are sitting in the ODD -->
    <!-- first put in the ones we know take precedence as replacements -->
    <xsl:for-each select="attList/attDef[@mode eq 'replace' and @ident=$ORIGINAL/attList//attDef/@ident]">
      <attDef >
        <xsl:apply-templates select="@*"/>
        <xsl:apply-templates mode="justcopy"/>
      </attDef>
    </xsl:for-each>
    <xsl:for-each select="attList/attDef[@mode eq 'add' or not(@mode)]">
      <attDef >
        <xsl:apply-templates select="@*[not(name()='mode')]"/>
        <xsl:apply-templates mode="justcopy"/>
      </attDef>
    </xsl:for-each>
    <!-- class attributes are ones where there is no direct correspondence in
    the source for this element -->
    <xsl:apply-templates mode="justcopy"
                         select="attList/attDef[(@mode eq 'change'
                                 or @mode eq 'delete'
                                 or @mode eq 'replace') and
                                 not(@ident=$ORIGINAL/attList//attDef/@ident)]"/>
    <!-- any direct attRef elements -->
    <xsl:apply-templates mode="justcopy"
                           select="attList/attRef"/>
    <!-- now look at each of the original object's attributes and see
    if we have an update -->
    <xsl:for-each select="$ORIGINAL/attList">
      <!-- original source  context -->
      <!-- first looking at nested attList -->
      <xsl:for-each select="attList">
        <attList>
          <xsl:copy-of select="@org"/>
          <xsl:for-each select="attDef">
            <xsl:variable name="ATT" select="."/>
            <xsl:variable name="lookingAt">
              <xsl:value-of select="concat(../../../@ident,'_',@ident)"/>
            </xsl:variable>
              <xsl:choose>
                <xsl:when test="ancestor::classSpec and $ODD/key('odd2odd-DELETEATT',$lookingAt)"/>
                <xsl:when test="$ODD/key('odd2odd-DELETEATT',$lookingAt)">
                  <xsl:copy-of
                    select="$ODD/key('odd2odd-DELETEATT',$lookingAt)"/>
                </xsl:when>
                <xsl:when test="$ODD/key('odd2odd-REPLACEATT',$lookingAt)"/>
                <xsl:when test="$ODD/key('odd2odd-CHANGEATT',$lookingAt)">
                  <xsl:call-template name="odd2odd-mergeAttribute">
                    <xsl:with-param name="New" select="$ODD/key('odd2odd-CHANGEATT',$lookingAt)"/>
                    <xsl:with-param name="Old" select="$ATT"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:copy-of select="$ATT"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
        </attList>
      </xsl:for-each>
      <!-- now the normal attributes -->
      <xsl:variable name="atts">
        <xsl:for-each select="attDef">
          <xsl:variable name="ATT" select="."/>
          <xsl:variable name="lookingAt">
            <xsl:value-of select="concat(../../@ident,'_',@ident)"/>
          </xsl:variable>
            <xsl:choose>
                <xsl:when test="ancestor::classSpec and
                                $ODD/key('odd2odd-DELETEATT',$lookingAt)"/>
              <xsl:when
                  test="$ODD/key('odd2odd-DELETEATT',$lookingAt)">
                <xsl:copy-of
                    select="$ODD/key('odd2odd-DELETEATT',$lookingAt)"/>
              </xsl:when>
              <xsl:when  test="$ODD/key('odd2odd-REPLACEATT',$lookingAt)"/>
              <xsl:when test="$ODD/key('odd2odd-CHANGEATT',$lookingAt)">
                <xsl:call-template name="odd2odd-mergeAttribute">
                  <xsl:with-param name="New" select="$ODD/key('odd2odd-CHANGEATT',$lookingAt)"/>
                  <xsl:with-param name="Old" select="$ATT"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:copy-of select="$ATT"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="@org">
          <attList>
            <xsl:copy-of select="@org"/>
            <xsl:copy-of select="$atts"/>
          </attList>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$atts"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="odd2odd-mergeAttribute">
    <xsl:param name="New"/>
    <xsl:param name="Old"/>
    <attDef>
      <xsl:attribute name="ident" select="$Old/@ident"/>
      <xsl:copy-of select="$Old/@mode"/>
      <xsl:if test="$Old/@mode">
        <xsl:attribute name="rend"><xsl:value-of select="$Old/@mode"/></xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="$New/@usage">
          <xsl:copy-of select="$New/@usage"/>
        </xsl:when>
        <xsl:when test="$Old/@usage">
          <xsl:copy-of select="$Old/@usage"/>
        </xsl:when>
      </xsl:choose>
      <xsl:if test="$New/altIdent">
        <xsl:apply-templates mode="justcopy" select="$New/altIdent"/>
      </xsl:if>
      <!-- equiv, gloss, desc trio -->
      <xsl:choose>
          <xsl:when test="$stripped"/>
          <xsl:when test="$New/equiv">
            <xsl:apply-templates mode="justcopy"
                                 select="$New/equiv">
                <xsl:with-param name="rend">replace</xsl:with-param>
              </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="justcopy" select="$Old/equiv"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="$New/gloss">
            <xsl:apply-templates mode="justcopy"
                                 select="$New/gloss">
                <xsl:with-param name="rend">replace</xsl:with-param>
              </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
              <xsl:apply-templates mode="justcopy" select="$Old/gloss"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="$stripped"/>
          <xsl:when test="$New/desc">
            <xsl:apply-templates mode="justcopy"
                                 select="$New/desc">
                <xsl:with-param name="rend">replace</xsl:with-param>
              </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
              <xsl:apply-templates mode="justcopy" select="$Old/desc"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="$New/constraintSpec">
            <xsl:apply-templates mode="justcopy" select="$New/constraintSpec"/>
          </xsl:when>
          <xsl:when test="$Old/constraintSpec">
            <xsl:copy-of select="$Old/constraintSpec"/>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="$New/datatype">
            <xsl:apply-templates mode="justcopy" select="$New/datatype"/>
          </xsl:when>
          <xsl:when test="$Old/datatype">
            <xsl:copy-of select="$Old/datatype"/>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="$New/defaultVal">
            <xsl:apply-templates mode="justcopy" select="$New/defaultVal"/>
          </xsl:when>
          <xsl:when test="$Old/defaultVal">
            <xsl:copy-of select="$Old/defaultVal"/>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="$New/valDesc">
            <xsl:apply-templates mode="justcopy" select="$New/valDesc"/>
          </xsl:when>
          <xsl:when test="$Old/valDesc">
            <xsl:copy-of select="$Old/valDesc"/>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="$New/valList[@mode eq 'delete']"/>
          <xsl:when test="$New/valList[@mode eq 'add' or @mode eq 'replace']">
            <xsl:for-each select="$New/valList[1]">
              <xsl:copy>
                <xsl:copy-of select="@type"/>
                <xsl:copy-of select="@repeatable"/>
                <xsl:copy-of select="$Old/valList/@mode"/>
                <xsl:copy-of select="*"/>
              </xsl:copy>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="$New/valList[@mode eq 'change']">
            <xsl:for-each select="$New/valList[1]">
              <xsl:copy>
                <xsl:copy-of select="@*"/>
                <xsl:for-each select="$Old/valList/valItem">
                  <xsl:variable name="thisme" select="@ident"/>
                  <xsl:choose>
                    <xsl:when test="$New/valList[1]/valItem[@ident eq $thisme and (@mode eq 'delete' or @mode eq 'replace')]"/>
                    <xsl:when test="$New/valList[1]/valItem[@ident eq $thisme and (@mode eq 'change')]">
                      <xsl:copy>
                        <xsl:copy-of select="@*"/>
                        <xsl:for-each select="$New/valList[1]/valItem[@ident=$thisme]">
                          <xsl:choose>
                            <xsl:when test="equiv">
                              <xsl:apply-templates mode="odd2odd-copy" select="equiv"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:for-each select="$Old/valList/valItem[@ident=$thisme]">
                                <xsl:apply-templates mode="odd2odd-copy" select="equiv"/>
                              </xsl:for-each>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="gloss">
                              <xsl:apply-templates mode="justcopy" select="gloss"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:for-each select="$Old/valList/valItem[@ident=$thisme]">
                                <xsl:apply-templates mode="justcopy" select="gloss"/>
                              </xsl:for-each>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="$stripped"/>
                            <xsl:when test="desc">
                              <xsl:apply-templates mode="justcopy" select="desc"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:for-each select="$Old/valList/valItem[@ident=$thisme]">
                                <xsl:apply-templates mode="justcopy" select="desc"/>
                              </xsl:for-each>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:for-each>
                      </xsl:copy>
                    </xsl:when>
                    <xsl:when test="$New/valList[1]/valItem[@ident eq $thisme and (@mode eq 'add')]">
                      <xsl:message terminate="yes">Asked to add attr <xsl:value-of select="$thisme"/> of <xsl:value-of select="$Old/@ident"/> of <xsl:value-of select="$Old/ancestor::*[@ident][1]/@ident"/> but it already exists; perhaps use @mode of 'change' or 'replace' instead.</xsl:message>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:apply-templates mode="justcopy" select="."/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
                <xsl:apply-templates mode="justcopy" select="valItem[@mode eq 'add']"/>
                <xsl:apply-templates mode="justcopy" select="valItem[@mode eq 'replace']"/>
              </xsl:copy>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="$Old/valList">
            <xsl:copy-of select="$Old/valList"/>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="$stripped"/>
          <xsl:when test="$New/exemplum">
            <xsl:apply-templates mode="justcopy" select="$New/exemplum"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="$Old">
              <xsl:apply-templates mode="justcopy" select="exemplum"/>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="$stripped"/>
          <xsl:when test="$New/remarks">
            <xsl:apply-templates mode="justcopy" select="$New/remarks"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="$Old">
              <xsl:apply-templates mode="justcopy" select="remarks"/>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
    </attDef>
  </xsl:template>
  <xsl:template match="specGrp">
    <xsl:choose>
      <xsl:when test="ancestor::schemaSpec"> </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="specGrpRef"/>
  <xsl:template match="dataSpec|macroSpec|classSpec">
    <xsl:if test="not(ancestor::schemaSpec)">
      <xsl:copy-of select="."/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="attDef[@mode]"/>

  <xsl:template match="elementSpec">
    <xsl:if test="not(//schemaSpec)">
      <xsl:copy>
        <xsl:apply-templates mode="odd2odd-copy" select="@*"/>
        <xsl:apply-templates mode="justcopy" select="altIdent"/>
        <xsl:if test="not($stripped)">
          <xsl:apply-templates mode="odd2odd-copy" select="equiv"/>
          <xsl:apply-templates mode="justcopy" select="gloss"/>
          <xsl:apply-templates mode="justcopy" select="desc"/>
        </xsl:if>
        <xsl:apply-templates mode="justcopy" select="classes"/>
        <xsl:apply-templates mode="odd2odd-copy" select="content"/>
        <xsl:apply-templates mode="odd2odd-copy" select="constraintSpec"/>
        <attList>
          <xsl:apply-templates select="attList"/>
        </attList>
        <xsl:if test="not($stripped)">
          <xsl:apply-templates mode="justcopy" select="exemplum"/>
          <xsl:apply-templates mode="justcopy" select="remarks"/>
          <xsl:apply-templates mode="justcopy" select="listRef"/>
        </xsl:if>
      </xsl:copy>
    </xsl:if>
  </xsl:template>
  <xsl:template match="moduleRef[@url]">
    <p>Include external module <xsl:value-of select="@url"/>.</p>
  </xsl:template>
  <xsl:template match="moduleRef[@key]">
    <p>Internal module <xsl:value-of select="@key"/> was located and expanded.</p>
  </xsl:template>
  <xsl:template match="@*|processing-instruction()|text()">
    <xsl:copy-of select="."/>
  </xsl:template>
  <xsl:template match="*">
    <xsl:copy>
      <xsl:apply-templates select="@*|*|processing-instruction()|text()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="odd2odd-createCopy">
    <xsl:if test="$verbose">
      <xsl:message>Create <xsl:value-of select="local-name()"/> named   <xsl:value-of select="@ident"/>   <xsl:sequence select="if
      (@module) then concat(' module: ',@module) else ''"/>         </xsl:message>
    </xsl:if>
    <xsl:element namespace="http://www.tei-c.org/ns/1.0"
                 name="{local-name()}">
      <xsl:attribute name="rend">add</xsl:attribute>
      <xsl:choose>
        <xsl:when test="@module"/>
        <xsl:when test="ancestor::schemaSpec/@module">
          <xsl:copy-of select="ancestor::schemaSpec/@module"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="module">
            <xsl:text>derived-module-</xsl:text>
            <xsl:value-of select="ancestor::schemaSpec/@ident"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="local-name()='classSpec'">
          <xsl:if test="@type eq 'model' and not(@predeclare)">
            <xsl:attribute name="predeclare">true</xsl:attribute>
          </xsl:if>
          <xsl:apply-templates mode="odd2odd-copy" select="@*|*|processing-instruction()|text()"/>
        </xsl:when>
        <xsl:when test="local-name()='macroSpec'">
          <xsl:apply-templates mode="odd2odd-copy" select="@*|*|processing-instruction()|text()"/>
        </xsl:when>
        <xsl:when test="local-name()='dataSpec'">
          <xsl:apply-templates mode="odd2odd-copy" select="@*|*|processing-instruction()|text()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="odd2odd-copyElementSpec">
            <xsl:with-param name="n" select="'2'"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template name="odd2odd-getversion">
    <xsl:choose>
      <xsl:when test="key('odd2odd-SCHEMASPECS',$selectedSchema)">
        <xsl:for-each
            select="key('odd2odd-SCHEMASPECS',$selectedSchema)">
          <xsl:variable name="source" select="tei:workOutSource(.)"/>
          <xsl:for-each select="document($source)/TEI/teiHeader/fileDesc/editionStmt/edition">
            <xsl:value-of select="."/>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="document($DEFAULTSOURCE)/TEI/teiHeader/fileDesc/editionStmt/edition">
          <xsl:value-of select="."/>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="odd2odd-processConstraints">
    <xsl:param name="ORIGINAL"/>
    <xsl:param name="elementName"/>
    <!-- first put in the ones we know take precedence -->
    <xsl:apply-templates mode="justcopy" select="constraintSpec[@mode eq 'add' or not(@mode)]"/>
    <xsl:apply-templates mode="justcopy" select="constraintSpec[@mode eq 'replace']"/>
    <xsl:apply-templates mode="justcopy" select="constraintSpec[@mode eq 'change']"/>
    <xsl:for-each select="$ORIGINAL">
      <!-- original source  context -->
      <xsl:for-each select="constraintSpec">
        <xsl:variable name="CONSTRAINT" select="."/>
        <xsl:variable name="lookingAt">
          <xsl:value-of select="concat(../@ident,'_',@ident)"/>
        </xsl:variable>
        <xsl:for-each select="$ODD">
          <xsl:choose>
            <xsl:when test="key('odd2odd-DELETECONSTRAINT',$lookingAt)"/>
            <xsl:when test="key('odd2odd-REPLACECONSTRAINT',$lookingAt)"/>
            <xsl:when test="key('odd2odd-CHANGECONSTRAINT',$lookingAt)"/>
            <xsl:otherwise>
              <xsl:copy-of select="$CONSTRAINT"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>



<!-- pass 3, clean up -->
  <xsl:template match="rng:ref" mode="pass3">
    <xsl:variable name="N">
      <xsl:value-of select="@name"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="starts-with($N,'macro.') and $stripped">
        <xsl:for-each select="key('odd2odd-MACROS',$N)/content/*">
          <xsl:call-template name="odd2odd-simplifyRelax"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <ref xmlns="http://relaxng.org/ns/structure/1.0">
          <xsl:apply-templates select="@*|*|text()|processing-instruction()" mode="pass3"/>
        </ref>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="valDesc|equiv|gloss|desc|remarks|exemplum|modelGrp|model|modelSequence|rendition|listRef" mode="pass3">
    <xsl:choose>
      <xsl:when test="$stripped"> </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|*|text()|processing-instruction()" mode="pass3"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="ptr" mode="pass3">
    <xsl:choose>
      <xsl:when test="starts-with(@target,'#') and
        (ancestor::remarks or ancestor::listRef or ancestor::valDesc) and
        not(id(substring(@target,2)))">
        <xsl:variable name="target" select="substring(@target,2)"/>
        <xsl:variable name="sourceDoc" select="tei:workOutSource(.)"/>
        <xsl:choose>
          <xsl:when test="document($sourceDoc)/id($target)">
            <!-- the chapter ID is on the highest ancestor or self div -->
            <xsl:variable name="chapter"
              select="document($sourceDoc)/id($target)/ancestor-or-self::div[not(ancestor::div)]/@xml:id"/>
            <ref 
              target="http://www.tei-c.org/release/doc/tei-p5-doc/en/html/{$chapter}.html#{$target}">
              <xsl:for-each select="document($sourceDoc)/id($target)">
                <xsl:number count="div" format="1.1.1." level="multiple"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="head"/>
              </xsl:for-each>
            </ref>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy>
              <xsl:apply-templates select="@*|*|text()|processing-instruction()" mode="pass3"/>
            </xsl:copy>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|*|text()|processing-instruction()" mode="pass3"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="schemaSpec" mode="pass3">
    <xsl:variable name="orig" select="tei:workOutSource(.)"/>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="pass3" select="text()|comment()|*"/>
      <xsl:copy-of select="document($orig)//schemaSpec/rendition"/>
      <xsl:for-each select="distinct-values(//*[@module]/@module)">
        <xsl:variable name="m" select="."/>
        <xsl:for-each select="document($orig)/key('odd2odd-MODULES',$m)">
          <xsl:copy>
            <xsl:attribute name="n"   select="ancestor::div[last()]/@xml:id"/>
            <xsl:copy-of select="@*"/>
          </xsl:copy>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|text()|comment()" mode="pass3">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="*" mode="pass3">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="pass3" select="text()|comment()|*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="content" mode="pass3">
    <xsl:variable name="content">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates mode="pass3"/>
      </xsl:copy>
    </xsl:variable>
    <xsl:apply-templates select="$content" mode="pass4"/>
  </xsl:template>


  <xsl:template match="classSpec" mode="pass3">
    <xsl:variable name="used">
      <xsl:call-template name="odd2odd-amINeeded"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$used=''">
        <xsl:if test="$verbose">
          <xsl:message>Reject unused class <xsl:value-of select="@ident"/>
          </xsl:message>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates mode="pass3"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="odd2odd-amINeeded">
    <!--
        How can a class be ok?
        a) if an element is a member of it and
        b)  its referred to in a content model
        c) some other class is a member of it, and that class is OK
        d) its a member of some other class, and that class is OK
    -->
    <xsl:variable name="k" select="@ident"/>
    <xsl:choose>
      <xsl:when test="$autoGlobal  and  starts-with(@ident,'att.global')">y</xsl:when>
      <xsl:when test="@type eq 'model' and  key('odd2odd-REFED',$k)">y</xsl:when>
      <xsl:when test="@type eq 'atts' and  key('odd2odd-ATTREFED',$k)">y</xsl:when>
      <xsl:when test="@type eq 'atts' and key('odd2odd-ELEMENT_MEMBERED',$k)">y</xsl:when>
      <xsl:when test="@type eq 'atts' and key('odd2odd-CLASS_MEMBERED',$k)">
        <xsl:for-each select="key('odd2odd-CLASS_MEMBERED',$k)">
          <xsl:call-template name="odd2odd-amINeeded"/>
        </xsl:for-each>
      </xsl:when>

      <xsl:when test="@type eq 'model' and classes/memberOf">
        <xsl:for-each
            select="classes/memberOf/key('odd2odd-IDENTS',@key)">
            <xsl:call-template name="odd2odd-amINeeded"/>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="memberOf" mode="pass3">
    <xsl:variable name="keep" select="."/>
    <xsl:choose>
      <xsl:when test="not(key('odd2odd-IDENTS',@key))">
        <xsl:if test="$verbose">
          <xsl:message>Reject unused memberOf pointing to <xsl:value-of select="@ident"/> because that doesn't exist</xsl:message>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="key('odd2odd-IDENTS',@key)[1]">
          <xsl:variable name="used">
            <xsl:call-template name="odd2odd-amINeeded"/>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$used=''">
              <xsl:if test="$verbose">
                <xsl:message>Reject unused memberOf pointing to <xsl:value-of select="@ident"/>  </xsl:message>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="$keep"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="macroSpec" mode="pass3">
    <xsl:variable name="k">
      <xsl:value-of select="@prefix"/>
      <xsl:value-of select="@ident"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$stripped  and  starts-with($k,'macro.')"/>
      <xsl:when test="key('odd2odd-REFED',$k)">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates mode="pass3"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$verbose">
          <xsl:message>Reject unused macro <xsl:value-of select="$k"/></xsl:message>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="dataSpec" mode="pass3">
    <xsl:variable name="k">
      <xsl:value-of select="@ident"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="key('odd2odd-REFED',$k)">
        <dataSpec >
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates mode="pass3"/>
        </dataSpec>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$verbose">
          <xsl:message>Reject unused dataSpec <xsl:value-of select="$k"/></xsl:message>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="processing-instruction()" mode="pass3">
    <xsl:copy-of select="."/>
  </xsl:template>


  <!-- pass 4, more clean up -->
  <xsl:template match="processing-instruction()" mode="pass4">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="@*|text()" mode="pass4">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="@mode" mode="pass4">
      <xsl:attribute name="rend" select="."/>
  </xsl:template>

  <xsl:template match="*" mode="pass4">
    <xsl:choose>
      <xsl:when test="self::rng:optional     and count(rng:zeroOrMore) eq 2    and count(*) eq 2">
        <xsl:apply-templates select="@*|*|text()|processing-instruction()" mode="pass4"/>
      </xsl:when>
      <xsl:when test="count(*) eq 1">
        <xsl:variable name="element" select="local-name()"/>
        <xsl:choose>
          <xsl:when test="*[local-name() eq $element]">
            <xsl:apply-templates select="@*|*|text()|processing-instruction()" mode="pass4"/>
          </xsl:when>
          <xsl:when test="$element eq 'optional'         and rng:zeroOrMore">
            <xsl:apply-templates select="@*|*|text()|processing-instruction()" mode="pass4"/>
          </xsl:when>
          <xsl:when test="$element eq 'optional'         and rng:oneOrMore">
            <xsl:apply-templates select="@*|*|text()|processing-instruction()" mode="pass4"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy>
              <xsl:apply-templates select="@*|*|text()|processing-instruction()" mode="pass4"/>
            </xsl:copy>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|*|text()|processing-instruction()" mode="pass4"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
