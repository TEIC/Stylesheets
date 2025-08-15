<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:teix="http://www.tei-c.org/ns/Examples"
                xmlns:xi=  "http://www.w3.org/2001/XInclude"
                xmlns:xs=  "http://www.w3.org/2001/XMLSchema"
                xmlns:rng= "http://relaxng.org/ns/structure/1.0"
                xmlns:tei= "http://www.tei-c.org/ns/1.0"
                xmlns:sqf= "http://www.schematron-quickfix.com/validator/process"
                xmlns:sch= "http://purl.oclc.org/dsdl/schematron"
                xmlns=     "http://purl.oclc.org/dsdl/schematron"
                xmlns:xsl= "http://www.w3.org/1999/XSL/Transform"
                xmlns:d=   "http://www.oxygenxml.com/ns/doc/xsl"
                version="3.0"
                xpath-default-namespace="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="#all">
  <xsl:import href="../common/functions.xsl"/>

  <d:doc scope="stylesheet" type="stylesheet">
    <d:desc>
      <d:p>TEI stylesheet for extracting Schematron rules from TEI ODD</d:p>
      <d:p>This software is dual-licensed:

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
</d:p>
      <d:p>Author: See AUTHORS</d:p>
      <d:p>Copyright: 2014, TEI Consortium</d:p>
      <d:p/>
      <d:p>Modified 2024-01-13 by Syd Bauman:
      Bug fix. Stop copying tei:constraint/@* onto &lt;sch:rule>.</d:p>
      <d:p>Modified 2018-09-25 by Syd Bauman:
      Bug fix. Handle sqf: namespace semi-intelligently.</d:p>
      <d:p>Modified 2016-07-22 by Syd Bauman &amp; Martin Holmes: ...</d:p>
      <d:p>Modified 2016-07-09 by Syd Bauman:
      Bug fix. Changing the language processing last month means that many Schematron constructs
      are not copied over from an ODD that does <d:i>not</d:i> delcare its language explicitly
      with an xml:lang= attribute on or above the &lt;constraint>. So we cheat, and add
      an xml:lang=en to the outermost element iff it does not already have an xml:lang=. Thus
      if there already is a xml:lang= specified anywhere on or above the &lt;constraint>, this
      change does nothing; if there isn't, it tells the extraction that the ODD is in English,
      so English Schematron should be extracted.</d:p>
      <d:p>Modified 2016-06-18/26 by Syd Bauman:
        <d:ul>
          <d:li>re-work how constraint processing is handled so that
          <d:b>//schemaSpec/constraintSpec/constraint[sch:* except ( sch:pattern, sch:rule ) ]</d:b>
          gets processed such that the Schematron elements are copied over (they weren't being copied). This bug
          discovered by Elisa E. Beshero-Bondar.</d:li>
          <d:li>re-work how language processing is handled, just to make code more consistent and readable.</d:li>
        </d:ul>
      </d:p>
      <d:p>Modified 2014-01-01/09 by Syd Bauman:
      <d:ul>
        <d:li>rely on xpath-default-namespace</d:li>
        <d:li>re-work how we support non-TEI namespaces</d:li>
        <d:li>re-work how we generate context= attrs</d:li>
      </d:ul>
      </d:p>
      <d:p>Modified 2013-12-31 by Syd Bauman:
        <d:ul>
          <d:li>change documentation prefix</d:li>
          <d:li>add code to support deprecation of constructs declared to
          be in non-TEI namespaces, part 1: elements, and attrs &amp; valItems delcared in elements</d:li>
        </d:ul>
      </d:p>
      <d:p>Modified 2013-12 by Syd Bauman:
      <d:ul>
        <d:li>generate checks for validUntil= on some constructs:
          <d:ul>
            <d:li><tt>&lt;attDef></tt> when inside either <tt>&lt;elementSpec></tt>
            or <tt>&lt;classSpec></tt></d:li>
            <d:li><tt>&lt;elementSpec></tt> itself</d:li>
            <d:li><tt>&lt;valItem></tt> when inside an <tt>&lt;elementSpec></tt></d:li>
          </d:ul>
        </d:li>
        <d:li>move ancestor::egXML test to key-building time (rather
          than testing in template that matches keys)</d:li>
        <d:li>add comment of metadata to output (perhaps this should be improved in future
        by passing in useful information via a parameter or parsing input <tt>&lt;teiHeader></tt>
        or some such)</d:li>
        <d:li>make output section comments into blocks that are pretty, at least
          if output is indentend nicely (e.g. via <tt>xmllint --format</tt>)</d:li>
      </d:ul>
      </d:p>
      <d:p>Modified 2012-05 by Syd Bauman: It seems that ISO Schematron does not have
        a <d:pre>&lt;key></d:pre> element. In fact, ISO 19757-3:2006 explicitly
        says “The XSLT key element may be used, in the XSLT namespace, before the pattern
        elements.” So we could just ignore <d:pre>&lt;key></d:pre> elements in
        the (ISO) Schematron namespace, but since then the user will likely not be
        getting what is intended, we’ll issue an error message as well.</d:p>
      <d:p>Modified 2010-07-03 by Syd Bauman: Add code to handle the case in which <d:pre>&lt;constraintSpec></d:pre>
        is a direct child of <d:pre>&lt;schemaSpec</d:pre>.</d:p>
    </d:desc>
  </d:doc>
  <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
  <xsl:param name="verbose" select="'false'"/>
  <xsl:variable name="root" select="/"/>
  <d:doc>
    <d:desc>The parameter $lang is the language tag for which we will extract
      constraints (ignoring constraints in other languages). To determine a
      default we check to see what language(s) the constraints are in. If there
      is only 1, that is the default. If there are none we presume "en". If
      there are more than 1, throw an error, advising the user that $lang has
      to be specified.</d:desc>
    <!-- WARNING to Syd — comment above no longer matches code below, but since
    I think I want to re-write whole thing so that CONSTRAINTs is a key that uses
    langauge, not 1 … -->
  </d:doc>
  <xsl:param name="lang">
    <xsl:variable name="languages" select="distinct-values( //@xml:lang )"/>
    <xsl:variable name="constraint_languages" as="xs:string*">
      <xsl:for-each select="key('CONSTRAINTs', $languages, $root ) | key('SCHQCKFIXs', $languages, $root )">
        <xsl:sequence select="( ./ancestor-or-self::*[@xml:lang][1]/@xml:lang, 'en')[1]"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="distinct_constraint_languages" select="distinct-values( $constraint_languages )"/>
    <xsl:choose>
      <xsl:when test="count( $distinct_constraint_languages ) eq 0">
        <xsl:message terminate="yes">Internal fatal ERROR: Unable to determine the language (i.e., @xml:lang) of any constraints.</xsl:message>
      </xsl:when>
      <xsl:when test="count( $distinct_constraint_languages ) eq 1">
        <xsl:sequence select="$distinct_constraint_languages"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="yes"
                     select="'ERROR: constraints present in '
                            ||count($distinct_constraint_languages)
                            ||' different languages ('
                            ||string-join( $distinct_constraint_languages, ', ')
                            ||') but no language to process specified. (Set $lang parameter, e.g. with --lang switch.)'"/>
      </xsl:otherwise>
    </xsl:choose>      
  </xsl:param>
  <d:doc>
    <d:desc>“langs” is the set of languages that should be extracted. It is a parameter,
    rather than a variable, for debugging. That said, it may be useful to some users to
    specify multiple languages at times.</d:desc>
  </d:doc>
  <xsl:param name="langs" select="( $lang, 'und', 'mul', 'zxx')" as="xs:string+"/>
  <d:doc>
    <d:desc>For the prefix for prefixes the default “esp” stands for
     “Extract Schematron Prefix”. Silly, I know, but my first thought
     (honestly) was "Tei Extract Isoschematron" :-|</d:desc>
  </d:doc>
  <xsl:param name="ns-prefix-prefix" select="'esp-'"/>
  <xsl:param name="tei-ns" select="'http://www.tei-c.org/ns/1.0'"/>
  <xsl:param name="teix-ns" select="'http://www.tei-c.org/ns/Examples'"/>
  <xsl:variable name="xsl-ns">http://www.w3.org/1999/XSL/Transform</xsl:variable>
  
  <xsl:mode on-no-match="shallow-copy" />
  <xsl:mode on-no-match="shallow-copy" name="copy"/>
  <xsl:mode on-no-match="shallow-copy" name="NSdecoration"/>
  
  <d:doc>
    <d:desc>Note on keys: should not really need the "[not(ancestor::teix:egXML)]"
    predicate on DEPRECATEDs, CONSTRAINTs, and SCHQCKFIXs, as the elements matched
    (tei:*, tei:constraintSpec/tei:constraint, and tei:constraintSpec//sqf:fixes,
    respectively) should never be inside a &lt;teix:egXML>.</d:desc>
  </d:doc>
  <xsl:key name="DECLARED_NSs" 
           match="constraintDecl//sch:ns[ not( ancestor::teix:egXML ) ]"
           use="'*'"/>  
  <xsl:key name="DECLARED_NSs" 
           match="constraintSpec[ @scheme eq 'schematron']/constraint//sch:ns[ not( ancestor::teix:egXML ) ]"
           use="( ancestor-or-self::*[@xml:lang][1]/@xml:lang, 'en')[1] => normalize-space()"/>
  
  <xsl:key name="KEYs" 
           match="xsl:key[ not( ancestor::teix:egXML ) ]"
           use="1"/>

  <xsl:key name="badKEYs" 
           match="sch:key[ not( ancestor::teix:egXML ) ]"
           use="1"/>
  
  <xsl:key name="DEPRECATEDs"
           match="//tei:*[@validUntil][ not( ancestor::teix:egXML ) ]"
           use="1"/>

  <!--
      The CONSTRAINTs key contains the <constraint> elements from
      within <constraintSpec>s plus whatever Schematron elements
      are in the <constraintDecl>.
  -->
  <xsl:key name="CONSTRAINTs"
           match="constraintSpec[ @scheme eq 'schematron' ]/constraint
                                [ not( ancestor::teix:egXML ) ]"
           use="( ancestor-or-self::*[@xml:lang][1]/@xml:lang, 'en')[1] => normalize-space()"/>
  <xsl:key name="CONSTRAINTs"
           match="constraintDecl[ @scheme eq 'schematron' ]/sch:*
                                [ not( ancestor::teix:egXML ) ]"
           use="( ancestor-or-self::*[@xml:lang][1]/@xml:lang, 'en')[1] => normalize-space()"/>

  <xsl:key name="SCHQCKFIXs"
           match="(constraintSpec|constraintDecl)[ @scheme eq 'schematron' ]//sqf:fixes
                                [ not( ancestor::teix:egXML ) ]"
           use="( ancestor-or-self::*[@xml:lang][1]/@xml:lang, 'en')[1] => normalize-space()"/>
  
  <xsl:template match="/">
    <!-- first, decorate tree with namespace info; also add an @xml:lang to -->
    <!-- the outermost element iff needed. -->
    <xsl:variable name="input-with-NSs">
      <xsl:apply-templates select="node()" mode="NSdecoration"/>
    </xsl:variable>
    <!-- then process decorated tree -->
    <xsl:apply-templates select="$input-with-NSs" mode="schematron-extraction">
      <xsl:with-param name="decorated" select="$input-with-NSs/tei:*"/>
    </xsl:apply-templates>
    <!-- Note: to see decorated tree for debugging, change mode of above -->
    <!-- from "schematron-extraction" to "copy". -->
  </xsl:template>
 
  <d:doc>
    <d:desc>First pass ... elements that might have an ns= attribute
    get new nsu= (namespace URI) and nsp= (namespace prefix) attributes</d:desc>
  </d:doc>
  <xsl:template match="tei:attDef|tei:elementSpec|tei:schemaSpec" mode="NSdecoration">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:variable name="nsu">
        <xsl:choose>
          <xsl:when test="self::tei:attDef">
            <xsl:value-of select="if ( @ns ) then @ns else ''"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="if ( ancestor-or-self::*[@ns] ) then ancestor-or-self::*[@ns][1]/@ns else $tei-ns"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:attribute name="nsp">
        <xsl:variable name="DECLARED_NSs_with_this_uri" as="element(sch:ns)*"
                      select="key('DECLARED_NSs', ( '*', $langs ), $root )[@uri eq $nsu]"/>
        <xsl:choose>
          <xsl:when test="$nsu eq ''"/>
          <xsl:when test="$nsu eq $tei-ns">tei:</xsl:when>
          <xsl:when test="$nsu eq $teix-ns">teix:</xsl:when>
          <xsl:when test="$DECLARED_NSs_with_this_uri">
            <xsl:if test="count( $DECLARED_NSs_with_this_uri ) gt 1">
              <xsl:message select="'WARNING: there are '
                                  ||count( $DECLARED_NSs_with_this_uri )
                                  ||' &lt;sch:ns> elements that have an @uri of '
                                  ||$nsu
                                  ||'; using the prefix bound in the first one, '
                                  ||'and ignoring the other(s).'"/>
            </xsl:if>
            <xsl:sequence select="($DECLARED_NSs_with_this_uri)[1]/@prefix => normalize-space()||':'"/>
          </xsl:when>
          <xsl:when test="namespace::* = $nsu">
            <xsl:value-of select="concat( local-name( namespace::*[ . eq $nsu ][1] ), ':')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat( $ns-prefix-prefix, generate-id(), ':')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="nsu" select="$nsu"/>
      <xsl:apply-templates select="node()" mode="NSdecoration"/>
    </xsl:copy>
  </xsl:template>
  
  <d:doc>
    <d:desc>Second pass does most the work ...</d:desc>
  </d:doc>
  <xsl:template match="/" mode="schematron-extraction">
    <xsl:param name="decorated" as="element()"/>
    <xsl:variable name="qb" select="( //tei:constraintDecl[ @scheme eq 'schematron']/@queryBinding, 'xslt2')[1]"/>
    <schema queryBinding="{$qb}">
      <title>ISO Schematron rules</title>
      <xsl:comment> This file generated <xsl:sequence select="tei:whatsTheDate()"/> by 'extract-isosch.xsl'. </xsl:comment>

      <xsl:if test="key('DECLARED_NSs', ( '*', $langs ), $root )[ not( @prefix eq 'xsl') ]">
        <xsl:call-template name="blockComment">
          <xsl:with-param name="content" select="'namespaces, declared:'"/>
        </xsl:call-template>
        <xsl:for-each select="key('DECLARED_NSs', ( '*', $langs ), $root )[ not( @prefix eq 'xsl') ]">
          <ns><xsl:apply-templates select="@*|node()" mode="copy"/></ns>
        </xsl:for-each>
      </xsl:if>
      
      <!-- To get implicit namespaces, start by generating a sequence
           of all the prefix-URI pairs that we calculated in the 1st
           pass. For easy parsing later, we separate each pair with a
           ‘␝’, which is a character we know will never occur within
           either a namespace prefix or a namespace URI (because it
           is not allowed in an xs:NCName, and is not allowed in a URI
           (per RFC 3986), even though xs:anyURI does not object to it). -->
      <xsl:variable name="allNSs" as="xs:string+">
        <xsl:sequence select="( $decorated//tei:*[@nsu]/concat( @nsp, '␝', @nsu ) )"/>
        <!-- if desired, other NSs can be added manually here -->
      </xsl:variable>
      <xsl:variable name="NSs" select="distinct-values( $allNSs )"/>
      <!-- Weed out those that are empty — and thus are now just
           a single ‘␝’ character — or those that are the XSL
           namespace. (Not sure why we ditch those in the XSL
           namespace. —Syd, 2024-10-23.) -->
      <xsl:variable name="selected_NSs" select="$NSs[ not( . eq '␝'  or  matches( ., '␝'||$xsl-ns||'$') ) ]"/>
      <!-- Look through that set of namespaces and generate <sch:ns> elements
           for those that are not also explicitly declared (and thus already
           put into output). -->
      <xsl:variable name="not_declared_NSs" as="element(sch:ns)*">
        <xsl:for-each select="$NSs[ not( . eq '␝'  or  matches( ., '␝'||$xsl-ns||'$') ) ]">
          <xsl:sort/>
          <!-- ... parse out the prefix and the URI (using that never-occurs character) -->
          <xsl:variable name="nsp" select="substring-before( .,':␝')"/>
          <xsl:variable name="nsu" select="substring-after( .,'␝')"/>
          <!-- Unless this same namespace was already output as "declared" ... -->
          <xsl:if test="not( key('DECLARED_NSs', ('*', $langs ), $decorated )[ @prefix eq $nsp  and  @uri eq $nsu ] )">
            <!-- ... generate and output a Schematron declaration for it -->
            <ns prefix="{$nsp}" uri="{$nsu}"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:if test="count( $not_declared_NSs ) gt 0">
        <xsl:call-template name="blockComment">
          <xsl:with-param name="content" select="'namespaces, implicit:'"/>
        </xsl:call-template>
        <xsl:copy-of select="$not_declared_NSs"/>
      </xsl:if>
      
      <xsl:if test="key('KEYs', 1, $root )[ ( for $L in $langs return lang($L) ) = true() ]">
        <xsl:call-template name="blockComment">
          <xsl:with-param name="content" select="'keys:'"/>
        </xsl:call-template>
        <xsl:for-each select="key('KEYs', 1, $root )[ ( for $L in $langs return lang($L) ) = true() ]">
          <xsl:apply-templates select="."/>
        </xsl:for-each>
      </xsl:if>

      <xsl:if test="key('badKEYs', 1, $root )">
        <xsl:message>WARNING: You have <xsl:value-of select="count( key('badKEYs', 1, $root) )"/> &lt;key> elements in the ISO Schematron
          namespace — but ISO Schematron does not have a &lt;key> element, so they
          are being summarily ignored. This will likely result in an ISO Schematron
          schema that does not perform the desired constraint tests properly.</xsl:message>
      </xsl:if>

      <xsl:if test="key('CONSTRAINTs', $langs )[ not( self::sch:ns ) ]">
        <xsl:variable name="N"
                      select="', of which there are '||count( key('CONSTRAINTs', $langs, $root )/*[ not( self::sch:ns ) ] )"/>
        <xsl:call-template name="blockComment">
          <xsl:with-param name="content" select="'constraints in '||string-join( $langs, ', ')||$N"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:apply-templates select="$root/key('CONSTRAINTs', $langs )[ not( self::sch:ns ) ]"/>

      <xsl:if test="key('DEPRECATEDs',1)">
        <xsl:call-template name="blockComment">
          <xsl:with-param name="content" select="'deprecation tests:'"/>
        </xsl:call-template>
      </xsl:if>
      <!-- Things that can be deprecated: -->
      <!--   attDef classSpec constraintSpec elementSpec macroSpec -->
      <!--   moduleSpec schemaSpec valDesc valItem valList -->
      <!--   and now defaultVal, too -->
      <!-- right now we only handle the few that actually appear -->
      <xsl:for-each select="key('DEPRECATEDs',1)">
        <xsl:variable name="amsg1" select="'WARNING: use of deprecated attribute —'"/>
        <xsl:variable name="vmsg1" select="'WARNING: use of deprecated attribute value — The'"/>
        <xsl:variable name="msg2" select="'will be removed from the TEI on '"/>
        <xsl:variable name="nsp" select="ancestor-or-self::tei:*[@nsp][1]/@nsp"/>
        <xsl:choose>
          <xsl:when test="self::attDef[ancestor::elementSpec]">
            <xsl:variable name="gi" select="ancestor::elementSpec/@ident"/>
            <xsl:variable name="ginsp" select="ancestor::elementSpec/@nsp"/>
            <pattern>
              <rule context="{tei:generate-context(.)}">
                <report test="@{concat($nsp,@ident)}" role="nonfatal">
                   <xsl:value-of select="$amsg1"/> @<xsl:value-of select="@ident"/> of the <xsl:value-of
                     select="concat( if ($ginsp ne 'tei:') then $ginsp else '', $gi )"/> element <xsl:value-of select="$msg2"/> <xsl:value-of select="@validUntil"/>.
                </report>
              </rule>
            </pattern>
          </xsl:when>
          <xsl:when test="self::attDef[ancestor::classSpec]">
            <xsl:variable name="class" select="ancestor::classSpec/@ident"/>
            <xsl:variable name="fqgis">
              <xsl:choose>
                <xsl:when test="contains( $class,'global')">tei:*</xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$decorated//elementSpec[classes/memberOf[@key=$class]]/concat( @nsp, @ident )" separator="|"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="giPattern">
              <xsl:value-of select="$fqgis" separator="|"/>
            </xsl:variable>
            <pattern>
              <rule context="{$giPattern}">
                <report test="@{@ident}" role="nonfatal">
                  <xsl:value-of select="$amsg1"/> @<xsl:value-of select="@ident"/> of the <name/> element <xsl:value-of select="$msg2"/> <xsl:value-of select="@validUntil"/>.
                </report>
              </rule>
            </pattern>
          </xsl:when>
          <xsl:when test="self::elementSpec">
            <pattern>
              <rule context="{concat($nsp,@ident)}">
                <report test="true()" role="nonfatal">
                  WARNING: use of deprecated element — The <name/> element <xsl:value-of select="$msg2"/> <xsl:value-of select="@validUntil"/>. 
                </report>
              </rule>
            </pattern>
          </xsl:when>
          <xsl:when test="self::valItem[ancestor::elementSpec]">
            <xsl:variable name="gi" select="ancestor::elementSpec/@ident"/>
            <xsl:variable name="attrName" select="ancestor::attDef/@ident"/>
            <pattern>
              <rule context="{concat($nsp,$gi)}">
                <report test="@{$attrName} eq '{@ident}'" role="nonfatal">
                  <xsl:value-of select="$vmsg1"/> the value '<xsl:value-of select="@ident"/>' of @<xsl:value-of select="$attrName"/> of the <xsl:value-of select="$gi"/> element <xsl:value-of select="$msg2"/> <xsl:value-of select="@validUntil"/>.
                </report>
              </rule>
            </pattern>
          </xsl:when>
          <xsl:when test="self::macroSpec">
            <pattern>
              <rule context="tei:dataRef|rng:ref">
                <report test="concat(normalize-space(@key), normalize-space(@name)) eq '{@ident}'" role="nonfatal">WARNING: reference to deprecated macro — '<xsl:value-of select="@ident"/>' <xsl:value-of select="$msg2"/> <xsl:value-of select="@validUntil"/>.</report>
              </rule>
            </pattern>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>

      <xsl:if test="$decorated//paramList">
        <xsl:call-template name="blockComment">
          <xsl:with-param name="content">parameter lists:</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates select="$decorated//paramList"/>
      </xsl:if>
      
      <xsl:if test="key('SCHQCKFIXs', $langs )">
        <xsl:call-template name="blockComment">
          <xsl:with-param name="content">schematron quick fixes:</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates select="key('SCHQCKFIXs', $langs )" mode="copy"/>
      </xsl:if>

    </schema>
  </xsl:template>

  <xsl:template match="tei:constraint[ ../@scheme eq 'schematron' ]/(sch:report|sch:assert)">
    <xsl:message select="'WARNING: Ignoring invalid '||name(.)||' found directly within &lt;constraint>.'"/>
  </xsl:template>

  <xsl:template match="tei:constraint">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <xsl:template match="tei:constraint/sch:pattern[ @is-a ]">
    <!--
        This is an instance of an abstract pattern: only extract it if
        the abstract pattern of which this is an instance is present
        (it might not be, a customization may have removed it).
    -->
    <xsl:variable name="patID" select="tei:makePatternID(.)"/>
    <!-- (Note that makePatternID() will use the @id of <pattern>, if there is one.) -->
    <xsl:if test="//sch:pattern[@abstract='true'][@id=current()/@is-a]">
      <pattern id="{$patID}">
        <xsl:apply-templates select="@*|node()"/>
      </pattern>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:constraint/sch:pattern[ not( @is-a ) ]">
    <xsl:variable name="patID" select="tei:makePatternID(.)"/>
    <!-- (Note that makePatternID() will use the @id of <pattern>, if there is one.) -->
    <pattern id="{$patID}">
      <xsl:apply-templates select="@*|node()"/>
    </pattern>
  </xsl:template>

  <xsl:template match="tei:constraint/sch:rule|tei:constraintDecl/sch:rule">
    <xsl:variable name="patID" select="tei:makePatternID(.)"/>
    <!-- IF there is no <pattern>, but there is a <rule>, copy over all children -->
    <!-- into a newly created <pattern> wrapper -->
    <pattern id="{$patID}">
      <rule>
        <xsl:apply-templates select="@*|node()"/>
      </rule>
    </pattern>
  </xsl:template>
  
  <xsl:template match="sch:*|xsl:*">
    <xsl:element name="{local-name()}" namespace="{namespace-uri(.)}">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="sch:key|sch:ns"/>
  
  <xsl:template match="sqf:*"/>

  <xsl:template name="blockComment">
    <xsl:param name="content"/>
    <xsl:variable name="myContent" select="normalize-space($content)"/>
    <xsl:variable name="border" select="replace($myContent,'.','*')"/>
    <xsl:variable name="useContent" select="concat(' ',$myContent,' ')"/>
    <xsl:variable name="useBorder" select="concat(' ',$border,' ')"/>
    <xsl:text>&#x0A;&#x0A;</xsl:text>
    <xsl:comment><xsl:value-of select="$useBorder"/></xsl:comment>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:comment><xsl:value-of select="$useContent"/></xsl:comment>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:comment><xsl:value-of select="$useBorder"/></xsl:comment>
    <xsl:text>&#x0A;</xsl:text>
  </xsl:template>
  
  <xsl:function name="tei:generate-context">
    <xsl:param name="here"/>
    <xsl:for-each select="$here">
      <xsl:choose>
        <!-- attDef classSpec elementSpec macroSpec schemaSpec -->
        <xsl:when test="ancestor::attDef[ancestor::classSpec]">
          <!-- this is WRONG: need to run around and get the -->
          <!-- members of the class, and for each use its -->
          <!-- @nsp:@ident -->
          <xsl:variable name="me">
            <xsl:text>@</xsl:text>
            <xsl:value-of select="ancestor::attDef/@nsp"/>
            <xsl:value-of select="ancestor::attDef/@ident"/>
          </xsl:variable>
          <xsl:message>INFO: constraint for <xsl:value-of select="$me"/> of the <xsl:value-of select="ancestor::classSpec/@ident"/> class does not have a context=. Resulting rule is applied to *all* occurences of <xsl:value-of select="$me"/>.</xsl:message>
          <xsl:value-of select="$me"/>
        </xsl:when>
        <xsl:when test="ancestor::attDef[ancestor::elementSpec]">
          <xsl:value-of select="ancestor::elementSpec/@nsp"/>
          <xsl:value-of select="ancestor::elementSpec/@ident"/>
          <xsl:text>/@</xsl:text>
          <xsl:value-of select="ancestor::attDef/@nsp"/>
          <xsl:value-of select="ancestor::attDef/@ident"/>
        </xsl:when>
        <xsl:when test="ancestor::classSpec">
          <!-- this is WRONG: need to run around and get the -->
          <!-- members of the class, and for each use its -->
          <!-- @nsp:@ident -->
          <xsl:message>INFO: constraint for <xsl:value-of select="ancestor::classSpec/@ident"/> class does not have a context=. Resulting rule is applied to *all* elements.</xsl:message>
          <xsl:text>*</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor::elementSpec">
          <xsl:value-of select="ancestor::elementSpec/@nsp"/>
          <xsl:value-of select="ancestor::elementSpec/@ident"/>
        </xsl:when>
        <!-- this should not happen: -->
        <xsl:when test="ancestor::macroSpec"/>
        <!-- root seems the least problematic: -->
        <xsl:when test="ancestor::schemaSpec">
          <xsl:text>/</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:function>
  
  <xsl:template match="tei:TEI">
    <xsl:apply-templates/>
  </xsl:template>

  <d:doc>
    <desc>work out unique ID for generated Schematron</desc>
  </d:doc>
  <xsl:function name="tei:makePatternID" as="xs:string">
    <xsl:param name="context"/>
    <xsl:variable name="scheme" select="$context/ancestor-or-self::constraintSpec/@scheme|$context/ancestor-or-self::constraintDecl/@scheme"/>
    <xsl:for-each select="$context">
      <xsl:variable name="id" select="( ancestor-or-self::*[@ident][1]/@ident,
                                        ancestor-or-self::*[@id][1]/@id,
                                        ancestor-or-self::*[@xml:id][1]/@xml:id,
                                        ancestor-or-self::constraintDecl!local-name(.)
                                      )[1]!translate( .,':','')"/>
      <xsl:variable name="num">
        <xsl:number level="any"/>
      </xsl:variable>
      <xsl:value-of select="( $scheme, 'constraint', $id, $num )" separator="-"/>
    </xsl:for-each>
  </xsl:function>
  
  <xsl:template match="paramList">
    <xsl:variable name="N">
      <xsl:number from="elementSpec" level="any"/>
    </xsl:variable>
    <xsl:variable name="B">
      <xsl:value-of select="parent::valItem/@ident"/>
    </xsl:variable>
    <pattern id="teipm-{ancestor::elementSpec/@ident}-paramList-{$N}">
      <rule context="tei:param[parent::tei:model/@behaviour='{$B}']">
        <assert role="error">
          <xsl:attribute name="test">
            <xsl:text>@name='</xsl:text>
            <xsl:value-of select="(paramSpec/@ident)" separator="'   or  @name='"/>
            <xsl:text>'</xsl:text>
          </xsl:attribute>
          Parameter name '<value-of select="@name"/>'  (on <value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: <xsl:value-of separator=", " select="(paramSpec/@ident)" />
        </assert>
      </rule>
    </pattern>
    
  </xsl:template>

</xsl:stylesheet>
