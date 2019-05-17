<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
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
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="a fo html i rng s sch xi xs xsl"
    version="2.0">
  <xsl:import href="teiodds.xsl"/>
  <xsl:import href="classatts.xsl"/>
  <xsl:import href="../common/functions.xsl"/>
  <xsl:import href="../common/i18n.xsl"/>
  <xsl:import href="../common/common_param.xsl"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>
         <p> TEI stylesheet for making Relax NG schema from ODD </p>
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
  <xsl:output encoding="utf-8" indent="yes" method="xml"/>
  <xsl:key name="PATTERNS" match="rng:define[rng:element/@name]" use="'true'"/>
  <xsl:key name="XPATTERNS" match="rng:define[rng:element/@name]" use="@name"/>
  <xsl:key name="REFED" match="rng:ref" use="@name"/>
  <xsl:key name="DEFED" match="rng:define" use="@name"/>
  <xsl:key name="EDEF" match="rng:define[rng:element]" use="1"/>
  <xsl:param name="verbose"/>
  <xsl:param name="outputDir"/>
  <xsl:param name="appendixWords"/>
  <xsl:template name="makeAnchor">
      <xsl:param name="name"/>
  </xsl:template>
  <xsl:param name="splitLevel">-1</xsl:param>
  <xsl:variable name="oddmode">dtd</xsl:variable>
  <xsl:variable name="filesuffix"/>
   <!-- get list of output files -->
  <xsl:variable name="linkColor"/>
  <xsl:template match="tei:moduleSpec[@type='decls']"/>
  <xsl:template match="/">
    <xsl:variable name="resolvedClassatts">
      <xsl:apply-templates  mode="classatts"/>
    </xsl:variable>
    <xsl:for-each select="$resolvedClassatts">
      <xsl:choose>
         <xsl:when test="key('SCHEMASPECS',1)">
            <xsl:apply-templates select="key('LISTSCHEMASPECS',$whichSchemaSpec)"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="key('Modules',1)"/>
         </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="tei:schemaSpec">
    <xsl:if test="$verbose='true'">
      <xsl:message> 
        <xsl:text>I18N setup: Pattern prefix: </xsl:text>
        <xsl:value-of select="$generalPrefix"/> 
        <xsl:text>. Target  language: </xsl:text>
        <xsl:value-of select="$targetLanguage"/>
        <xsl:text>. Documentation language: </xsl:text>
        <xsl:value-of select="tei:generateDocumentationLang(.)"/>
      </xsl:message>
    </xsl:if>
    <xsl:variable name="filename" select="@ident"/>
    <xsl:if test="$verbose='true'">
      <xsl:message> process schemaSpec [<xsl:value-of select="@ident"/>] </xsl:message>
    </xsl:if>
    <xsl:variable name="rng">
      <xsl:choose>
        <xsl:when test="tei:specGrpRef">
          <xsl:variable name="SPECS">
            <tei:schemaSpec>
              <xsl:copy-of select="@*"/>
              <xsl:apply-templates mode="expandSpecs"/>
            </tei:schemaSpec>
          </xsl:variable>
          <xsl:for-each select="$SPECS/tei:schemaSpec">
            <xsl:call-template name="schemaSpecBody"/>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="schemaSpecBody"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="tei:constraintSpec"/>
    </xsl:variable>
    <xsl:call-template name="generateOutput">
      <xsl:with-param name="method">xml</xsl:with-param>
      <xsl:with-param name="suffix">.rng</xsl:with-param>
      <xsl:with-param name="body">
        <grammar xmlns="http://relaxng.org/ns/structure/1.0"
          xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
          xmlns:xlink="http://www.w3.org/1999/xlink"
          datatypeLibrary="http://www.w3.org/2001/XMLSchema-datatypes">
          <xsl:attribute name="ns">
            <xsl:choose>
              <xsl:when test="@ns">
                <xsl:value-of select="@ns"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>http://www.tei-c.org/ns/1.0</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:comment>
            <xsl:text>&#10;Schema generated from ODD source </xsl:text>
            <xsl:sequence select="tei:whatsTheDate()"/>
            <xsl:text>. </xsl:text>
            <xsl:value-of
              select="(/tei:TEI/tei:text/tei:front/tei:titlePage/tei:docDate,'.')"
              separator=""/>
            <xsl:call-template name="makeTEIVersion"/>
            <xsl:sequence select="tei:makeDescription(., true(), true())"/>
            <xsl:text>&#10;</xsl:text>
          </xsl:comment>
          <xsl:comment>
            <xsl:call-template name="copyright"/>
          </xsl:comment>
          <xsl:if test="not($rng//sch:ns[@prefix='tei'])">
            <sch:ns prefix="tei"
              uri="http://www.tei-c.org/ns/1.0"/>
          </xsl:if>
          <xsl:copy-of select="$rng"/>
        </grammar>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="schemaSpecBody">
    <xsl:variable name="original" select="."/>
    <xsl:variable name="pass1">
      <root>
        <xsl:if test="$verbose='true'">
          <xsl:message>start importing moduleRef components</xsl:message>
        </xsl:if>
        <xsl:apply-templates mode="tangle" select="tei:moduleRef"/>
        <xsl:for-each select="tei:macroSpec|tei:dataSpec">
          <xsl:apply-templates mode="tangle" select="."/>
        </xsl:for-each>
        <xsl:for-each select=".//tei:anyElement">
          <xsl:call-template name="anyElement"/>
        </xsl:for-each>
        <xsl:apply-templates mode="tangle" select="tei:elementSpec|tei:classSpec"/>
        <xsl:choose>
          <xsl:when test="@start and @start=''"/>
          <xsl:when test="@start">
            <start xmlns="http://relaxng.org/ns/structure/1.0">
              <choice>
                <xsl:for-each select="tokenize(@start,' ')">
                  <ref xmlns="http://relaxng.org/ns/structure/1.0" name="{.}"/>
                </xsl:for-each>
              </choice>
            </start>
          </xsl:when>
          <xsl:when test="key('IDENTS','teiCorpus')">
            <start xmlns="http://relaxng.org/ns/structure/1.0">
              <choice>
                <ref name="{$generalPrefix}TEI"/>
                <ref name="{$generalPrefix}teiCorpus"/>
              </choice>
            </start>
          </xsl:when>
          <xsl:otherwise>
            <start xmlns="http://relaxng.org/ns/structure/1.0">
              <ref name="{$generalPrefix}TEI"/>
            </start>
          </xsl:otherwise>
        </xsl:choose>
      </root>
    </xsl:variable>
    
    <!-- in 2nd and 3rd  passes, throw away any RNG <define> elements
      which do not have a <ref>, any <ref> which has no <define>
      to point to, and any empty <choice> -->
    <xsl:variable name="pass2">
      <xsl:for-each select="$pass1/root">
        <root>
          <xsl:apply-templates mode="pass2"/>
        </root>
      </xsl:for-each>
    </xsl:variable>
    <xsl:for-each select="$pass2/root">
      <xsl:apply-templates mode="pass3"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tei:moduleSpec">
      <xsl:if test="@ident and not(@mode='change' or @mode='replace' or   @mode='delete')">
         <xsl:choose>
            <xsl:when test="parent::tei:schemaSpec">
               <xsl:call-template name="moduleSpec-body"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:call-template name="generateOutput">
                  <xsl:with-param name="method">xml</xsl:with-param>
                  <xsl:with-param name="suffix">.rng</xsl:with-param>
                  <xsl:with-param name="body">
                     <grammar xmlns="http://relaxng.org/ns/structure/1.0"
                              datatypeLibrary="http://www.w3.org/2001/XMLSchema-datatypes">
                        <xsl:comment>
                           <xsl:text>Schema generated </xsl:text>
                           <xsl:sequence select="tei:whatsTheDate()"/>
                           <xsl:call-template name="makeTEIVersion"/>
			   <xsl:call-template name="copyright"/>
                           <xsl:sequence select="tei:makeDescription(., true(), true())"/>
                        </xsl:comment>
                        <xsl:call-template name="moduleSpec-body"/>
                     </grammar>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
  </xsl:template>
  <xsl:template name="moduleSpec-body">
    <xsl:variable name="filename" select="@ident"/>
    <xsl:comment>Definitions from module <xsl:value-of select="@ident"/>
    </xsl:comment>
    <xsl:comment>Set global predeclared macros</xsl:comment>
    <xsl:if test="@type='core'">
      <xsl:call-template name="NameList"/>
      <xsl:for-each select="key('PredeclareAllMacros',1)">
        <define xmlns="http://relaxng.org/ns/structure/1.0" name="{@ident}">
          <choice>
            <notAllowed/>
          </choice>
        </define>
      </xsl:for-each>
    </xsl:if>
    <xsl:comment>Set predeclared macros</xsl:comment>
    <xsl:for-each select="key('PredeclareMacrosModule',@ident)">
      <xsl:apply-templates mode="tangle" select="."/>
    </xsl:for-each>
    <xsl:if test="@type='core'">
      <xsl:call-template name="predeclare-classes"/>
      <xsl:for-each select="//tei:anyElement">
        <xsl:call-template name="anyElement"/>
      </xsl:for-each>
    </xsl:if>
    <xsl:comment>0. predeclared macros</xsl:comment>
    <xsl:for-each select="key('PredeclareMacrosModule',@ident)">
      <xsl:apply-templates mode="tangle" select="."/>
    </xsl:for-each>
    <xsl:comment>1. classes</xsl:comment>
    <xsl:for-each select="key('ClassModule',@ident)">
      <xsl:choose>
        <xsl:when test="@module='core' and @predeclare='true'"> </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="tangle" select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:comment>2. elements</xsl:comment>
    <xsl:apply-templates mode="tangle" select="key('ElementModule',@ident)">
      <xsl:sort select="@ident"/>
    </xsl:apply-templates>
    <xsl:comment>3. macros</xsl:comment>
    <xsl:for-each select="key('MacroModule',@ident)">
      <xsl:choose>
        <xsl:when test="@predeclare='true'"/>
        <!--	<xsl:when test="key('PredeclareMacros',@ident)"/>-->
        <xsl:otherwise>
          <xsl:apply-templates mode="tangle" select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="copyright">
    <xsl:for-each
	select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability">
      <xsl:if test="count(tei:licence)&gt;1">
	<xsl:text>This material is dual-licensed.&#10;</xsl:text>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tei:licence">
    <xsl:if test="@target">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="@target"/>
      <xsl:text>] </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="NameList">
<!-- walk over all the elementSpec elements and make list of 
       elements -->
    <xsl:for-each select="key('ELEMENTDOCS',1)">
         <xsl:sort select="@ident"/>
         <define xmlns="http://relaxng.org/ns/structure/1.0" combine="choice" name="{@ident}">
            <notAllowed/>
         </define>
      </xsl:for-each>
  </xsl:template>

  <xsl:template name="predeclare-classes">
      <xsl:comment>0. predeclared classes</xsl:comment>
      <xsl:for-each select="key('predeclaredClasses',1)">
         <xsl:choose>
            <xsl:when test="@type='model'">
               <xsl:apply-templates mode="processModel" select=".">
                  <xsl:with-param name="declare">true</xsl:with-param>
               </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="@type='atts'">
               <xsl:apply-templates mode="processDefaultAtts" select="."/>
            </xsl:when>
         </xsl:choose>
      </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="anyElement">
    <xsl:variable name="apos">'</xsl:variable>
    <xsl:variable name="spec" select="ancestor::tei:elementSpec|ancestor::tei:macroSpec"/>
    <xsl:variable name="current" select="."/>
    <xsl:variable name="id" select="concat('anyElement-',$spec/@ident)"/>
    <xsl:variable name="exclude">
      <xsl:choose>
        <xsl:when test="@exclude"><xsl:value-of select="@exclude"/></xsl:when>
        <xsl:when test="ancestor::tei:schemaSpec/@defaultExceptions">
          <xsl:value-of select="ancestor::tei:schemaSpec/@defaultExceptions"/>
        </xsl:when>
        <xsl:otherwise>http://www.tei-c.org/ns/1.0 teix:egXML</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <define name="{$id}" xmlns="http://relaxng.org/ns/structure/1.0">
      <element>
        <anyName>
          <except>
            <xsl:for-each select="distinct-values(tokenize(normalize-space($exclude), '\s+'))">
              <xsl:choose>
                <xsl:when test=". = 'teix:egXML'">
                  <name ns="http://www.tei-c.org/ns/Examples">egXML</name>
                </xsl:when>
                <xsl:when test="matches(.,'\w+:\w+')">
                  <xsl:choose>
                    <xsl:when test="namespace-uri-for-prefix(substring-before(.,':'),$current)">
                      <name ns="{namespace-uri-for-prefix(substring-before(.,':'),$current)}"><xsl:value-of select="substring-after(.,':')"/></name>
                    </xsl:when>
                    <xsl:otherwise><nsName ns="{.}"/></xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <nsName ns="{.}"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </except>
        </anyName>
        <zeroOrMore>
          <attribute>
            <anyName/>
          </attribute>
        </zeroOrMore>
        <zeroOrMore>
          <choice>
            <text/>
            <ref name="{$id}"/>
          </choice>
        </zeroOrMore>
      </element>
      <xsl:if test="@require and ancestor::tei:elementSpec">
        <xsl:variable name="ns"><xsl:if
          test="ancestor::tei:content//tei:*">, 'http://www.tei-c.org/ns/1.0'</xsl:if></xsl:variable>
        <xsl:variable name="computed-prefix">
          <xsl:for-each select="in-scope-prefixes($current)">
            <xsl:if test="$spec/@ns = namespace-uri-for-prefix(., $current)">
              <xsl:value-of select="."/>
            </xsl:if>
          </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="prefix">
          <xsl:choose>
            <xsl:when test="ancestor::tei:elementSpec/@ns"><xsl:value-of select="$computed-prefix"/></xsl:when>
            <xsl:otherwise>tei</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:if test="$spec/@ns"><ns xmlns="http://purl.oclc.org/dsdl/schematron" prefix="{$prefix}" uri="{ancestor::tei:elementSpec/@ns}"/></xsl:if>
        <pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="{concat(generate-id(),'-constraint')}">
          <rule context="{$prefix}:{ancestor::tei:elementSpec/@ident}">
            <report test="descendant::*[not(namespace-uri(.) =
              ({concat($apos,string-join(tokenize(current()/@require, ' '),concat($apos,', ',$apos)),$apos,$ns)}))]">
              <xsl:value-of select="ancestor::tei:elementSpec/@ident"/> descendants must be in the
              namespace<xsl:if test="contains(@require, ' ') or $ns ne ''">s</xsl:if><xsl:text>
              </xsl:text><xsl:value-of select="concat($apos,string-join(tokenize(current()/@require,
                ' '),concat($apos,', ',$apos)),$apos,$ns)"/></report>
          </rule>
        </pattern>
      </xsl:if>
    </define>
  </xsl:template>
  
  <xsl:template match="tei:specGrpRef" mode="tangle">
      <xsl:param name="filename"/>
      <xsl:if test="$verbose='true'">
         <xsl:message> specGrpRef to <xsl:value-of select="@target"/>
         </xsl:message>
      </xsl:if>
      <xsl:choose>
         <xsl:when test="starts-with(@target,'#')">
            <xsl:for-each select="id(substring(@target,2))">
               <xsl:apply-templates mode="ok" select=".">
                  <xsl:with-param name="filename" select="$filename"/>
               </xsl:apply-templates>
            </xsl:for-each>
         </xsl:when>
         <xsl:otherwise>
            <xsl:for-each select="document(@target)/tei:specGrp">
               <xsl:apply-templates mode="ok" select=".">
                  <xsl:with-param name="filename" select="$filename"/>
               </xsl:apply-templates>
            </xsl:for-each>
         </xsl:otherwise>
      </xsl:choose>
  </xsl:template>
  <xsl:template name="schemaOut">
      <xsl:param name="grammar"/>
      <xsl:param name="element"/>
      <xsl:param name="content"/>
      <xsl:for-each select="$content/Wrapper">
         <xsl:apply-templates mode="justcopy" select="*"/>
      </xsl:for-each>
  </xsl:template>
  <xsl:template name="refdoc"/>
  <xsl:template name="typewriter">
      <xsl:param name="text"/>
  </xsl:template>

  <xsl:template match="processing-instruction()" mode="tangle">
    <xsl:copy-of select="."/>
  </xsl:template>

<!-- pass 2, clean up unused elements -->
  <xsl:template  match="rng:anyName[parent::rng:define]"
		 mode='pass2'>
    <zeroOrMore xmlns="http://relaxng.org/ns/structure/1.0">
      <choice>
	<xsl:for-each select="key('EDEF',1)">	  
	  <ref name="{@name}"/>
	</xsl:for-each>
      </choice>
    </zeroOrMore>
  </xsl:template>

  <xsl:template match="processing-instruction()" mode="pass2">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="@*|text()|comment()" mode="pass2">
      <xsl:copy-of select="."/>
  </xsl:template>
    
  <xsl:template match="*" mode="pass2">
      <xsl:copy>
         <xsl:apply-templates select="*|@*|processing-instruction()|comment()|text()" mode="pass2"/>
      </xsl:copy>
  </xsl:template>

  <xsl:template match="rng:define" mode="pass2">
    <xsl:choose>
      <xsl:when test="key('REFED',@name) or 
        key('REFED',substring-after(@name,$generalPrefix))">
        <define xmlns="http://relaxng.org/ns/structure/1.0" >
          <xsl:apply-templates  select="@*"    mode="pass2"/>
          <xsl:apply-templates  select="*|processing-instruction()|comment()|text()"
            mode="pass2"/>
        </define>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$verbose='true'">
          <xsl:message>ZAP definition of unused pattern <xsl:value-of select="@name"/></xsl:message>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="rng:ref" mode="pass2">
    <xsl:choose>
      <xsl:when test="parent::rng:choice/parent::rng:start">
        <ref xmlns="http://relaxng.org/ns/structure/1.0" name="{@name}"/>
      </xsl:when>
      <xsl:when test="key('DEFED',@name)">
        <ref xmlns="http://relaxng.org/ns/structure/1.0" name="{@name}"/>
      </xsl:when>
      <xsl:when test="ancestor::tei:content[@autoPrefix='false']">
        <ref xmlns="http://relaxng.org/ns/structure/1.0" name="{@name}"/>
      </xsl:when>
      <xsl:when test="count(parent::*/*)=1">
        <xsl:if test="$verbose='true'">
          <xsl:message>ZAP reference to undefined [<xsl:value-of select="@name"/>] and leave empty behind</xsl:message>
        </xsl:if>
        <empty xmlns="http://relaxng.org/ns/structure/1.0"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$verbose='true'">
          <xsl:message>ZAP reference to undefined [<xsl:value-of select="@name"/>]</xsl:message>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- and again -->
  
  <xsl:template match="rng:list|rng:element" mode="pass3">
    <xsl:element name="{name()}" namespace="http://relaxng.org/ns/structure/1.0">
      <xsl:apply-templates  select="@*"  mode="pass3"/>
      <xsl:variable name="Contents">
	<xsl:apply-templates  select="*|processing-instruction()|comment()|text()"
			      mode="pass3"/>
      </xsl:variable>
      <xsl:choose>
	<xsl:when test="$Contents//rng:text or $Contents//rng:ref or
			$Contents//rng:anyName or
			$Contents//rng:attribute or
			$Contents//rng:data or $Contents//rng:name or $Contents//rng:value">
	  <xsl:copy-of select="$Contents"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:copy-of select="$Contents/a:*"/>
	  <rng:empty/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="rng:group[count(*)=1]" mode="pass3">
    <xsl:apply-templates select="*|@*|processing-instruction()|comment()|text()" mode="pass3"/>
  </xsl:template>

  <xsl:template match="rng:choice|rng:group" mode="pass3">
    <xsl:choose>
      <xsl:when test="rng:value|rng:name|.//rng:ref|.//rng:text|.//rng:data">
        <xsl:element name="{name()}" namespace="http://relaxng.org/ns/structure/1.0">
          <xsl:apply-templates select="*|@*|processing-instruction()|comment()|text()" mode="pass3"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$verbose='true'">
          <xsl:message>KILLED <xsl:copy-of select="."/></xsl:message>
        </xsl:if>
        <empty xmlns="http://relaxng.org/ns/structure/1.0"/>
      </xsl:otherwise>
    </xsl:choose>			   
  </xsl:template>

  <xsl:template match="rng:optional|rng:zeroOrMore|rng:oneOrMore"
    mode="pass3">
    <xsl:choose>
      <xsl:when test="not(*)"/>
      <xsl:when test="count(*)=1 and rng:empty"/>
      <xsl:when test="count(*)=1">
        <xsl:variable name="what" select="rng:ref/@name"/>
        <xsl:choose>
          <xsl:when test="$what=following-sibling::*[1][count(*)=1]/rng:*/rng:ref/@name">
            <xsl:if test="$verbose='true'"><xsl:message>Kill <xsl:value-of
              select="(ancestor::rng:element/@name,rng:ref/@name)"/> because it's repeated in following rule</xsl:message></xsl:if>
          </xsl:when>
          <xsl:when test="$what=following-sibling::*[1][count(*)=1]/rng:group[count(*)=1]/rng:*/rng:ref/@name">
            <xsl:if test="$verbose='true'"><xsl:message>Kill <xsl:value-of
              select="(ancestor::rng:element/@name,rng:ref/@name)"/> because it's repeated in following rule</xsl:message></xsl:if>
          </xsl:when>
          <xsl:when test="rng:zeroOrMore">
            <xsl:apply-templates select="*|@*|processing-instruction()|comment()|text()" mode="pass3"/>
          </xsl:when>
          <xsl:when test="rng:group[count(*)=1 and rng:zeroOrMore]">
            <xsl:apply-templates select="*|@*|processing-instruction()|comment()|text()" mode="pass3"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="{name()}" namespace="http://relaxng.org/ns/structure/1.0">
              <xsl:apply-templates
                select="*|@*|processing-instruction()|comment()|text()"
                mode="pass3"/>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{name()}" namespace="http://relaxng.org/ns/structure/1.0">
          <xsl:apply-templates
            select="*|@*|processing-instruction()|comment()|text()"
            mode="pass3"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>			   
  </xsl:template>

  <xsl:template match="processing-instruction()" mode="pass3">
    <xsl:choose>
      <xsl:when test="name()='NameList'">
        <xsl:if test="$verbose='true'">
          <xsl:message>Expand 'NameList' processing-instruction</xsl:message>
        </xsl:if>
        <choice xmlns="http://relaxng.org/ns/structure/1.0">
          <xsl:for-each select="key('PATTERNS','true')">
            <xsl:sort select="@name"/>
            <ref name="{@name}" />
          </xsl:for-each>
        </choice>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="rng:start/rng:choice" mode="pass3">
    <!-- look at start patterns and see if they need prepending with
    prefix -->
    <choice xmlns="http://relaxng.org/ns/structure/1.0">
      <xsl:for-each select="rng:ref">
	  <xsl:variable name="name" select="if (key('DEFED',@name))
	    then @name
	    else if (key('DEFED',concat($generalPrefix,@name))) then
	    concat($generalPrefix,@name) else ''"/>
	    <xsl:if test="not($name='')">
	      <ref xmlns="http://relaxng.org/ns/structure/1.0" name="{$name}"/>
	    </xsl:if>
      </xsl:for-each>
    </choice>
  </xsl:template>

  <xsl:template match="rng:define" mode="pass3">
    <xsl:choose>
      <xsl:when test="key('REFED',@name) or
        key('XPATTERNS',@name)">
        <xsl:choose>
          <xsl:when test="count(key('DEFED',@name))=1 or @combine='choice'">
            <define xmlns="http://relaxng.org/ns/structure/1.0" >
              <xsl:apply-templates  select="@*"    mode="pass3"/>
              <xsl:apply-templates  select="*|processing-instruction()|comment()|text()"
                mode="pass3"/>
            </define>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="others">
              <xsl:for-each select="key('DEFED',@name)">
                <n><xsl:value-of select="count(ancestor::rng:div)"/></n>
              </xsl:for-each>
            </xsl:variable>
            <xsl:if test="count(ancestor::rng:div)     &lt; max($others/*)">
              <define xmlns="http://relaxng.org/ns/structure/1.0" >
                <xsl:apply-templates  select="@*"    mode="pass3"/>
                <xsl:apply-templates  select="*|processing-instruction()|comment()|text()"
                  mode="pass3"/>
              </define>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$verbose='true'">
          <xsl:message>ZAP definition of unused pattern <xsl:value-of select="@name"/></xsl:message>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@*|text()|comment()" mode="pass3">
      <xsl:copy-of select="."/>
  </xsl:template>
    
  <xsl:template match="*" mode="pass3">
      <xsl:copy>
         <xsl:apply-templates select="*|@*|processing-instruction()|comment()|text()" mode="pass3"/>
      </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:dataRef" mode="#default tangle">
    <xsl:choose>
      <xsl:when test="@name">
        <rng:data type="{@name}">
          <xsl:choose>
            <xsl:when test="tei:dataFacet">
              <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@restriction">
              <rng:param name="pattern">
                <xsl:value-of select="@restriction"/>
              </rng:param>
            </xsl:when>
          </xsl:choose>
        </rng:data>
      </xsl:when>
      <xsl:when test="@key">
        <xsl:for-each select="key('LOCALIDENTS', @key)">
          <xsl:choose>
            <xsl:when test="tei:content">
              <xsl:apply-templates select="tei:content/*"/>
            </xsl:when>
            <xsl:when test="tei:datatype">
              <xsl:apply-templates select="tei:datatype/*"/>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template> 
  
  <xsl:template match="tei:dataFacet" mode="#default tangle">
    <rng:param name="{@name}"><xsl:value-of select="@value"/></rng:param>
  </xsl:template>

</xsl:stylesheet>
