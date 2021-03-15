<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:eg="http://www.tei-c.org/ns/Examples"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:local="local"
  xmlns:i18n="i18n"
  xmlns="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="#all"
  version="2.0">
  
  <xsl:import href="../jtei.common.xsl"/>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
    <desc>
      <p>TEI stylesheet for converting TEI to the OpenEdition schema</p>
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

  <!--
    General remarks: 
      -The Lodel rendering component is *very* restrictive: any elements that occur where they're not expected (though valid) lead to swallowing of subsequent text. I'd very much like to retain as much semantic information as possible that would allow for back-conversion from OpenEdition to our own input format. For example, //tei:seg[@type='forename'] for forenames, and //seg[@type='autonumber'] for generated heading numbering. Unfortunately, this is not possible at all: tried with <hi>, <seg>, <s> and all combinations of @type, @rend, @rendition 
  -->

  <!-- an index of TEI input elements that should be converted to <hi> -->
  <xsl:key name="renditions" match="
    tei:gi
    |tei:att
    |tei:tag
    |tei:val
    |tei:ident
    |tei:code
    |tei:mentioned
    |tei:term
    |tei:list[tokenize(@rend, '\s+') = 'inline']/tei:item
    |tei:cit[tei:quote/(tei:table|tei:list)]
    |tei:list[tokenize(@rend, '\s+')  = 'simple']
    |tei:list[@type eq 'gloss']
    |tei:list[@type eq 'gloss']/tei:label
    |tei:list/tei:head
    |tei:table/tei:head
    |tei:foreign
    |tei:table
    |tei:row[@role eq 'label']/tei:cell
    |tei:cell[@role eq 'label']
    |tei:cell[xs:integer(@cols) gt 1]
    |tei:table[@rend='border']//tei:cell
    |tei:num[@type='ordinal']
    |tei:title[@level = ('m', 'j')]
    (: for paragraph indentation
    |tei:div/tei:p
    :)
    " use="local:map.styles(.)"/>
  
  <!-- an index of <rendition> definitions that are in use in the input document -->
  <xsl:key name="renditionsInUse" match="@rendition" use="substring-after(., '#')"/>
    
  <!-- a conversion table with <rendition> definitions for input elements that should be converted to <hi> -->
  <xsl:variable name="hiConversion">
    <rendition xml:id="gi" scheme="css">font-family:Courier;</rendition>
    <rendition xml:id="att" scheme="css">font-family:Courier;</rendition>
    <rendition xml:id="tag" scheme="css">font-family:Courier;</rendition>
    <rendition xml:id="val" scheme="css">font-family:Courier;</rendition>
    <rendition xml:id="code" scheme="css">font-family:Courier;white-space:pre-wrap;</rendition>
    <rendition xml:id="ident" scheme="css">font-family:Courier;</rendition>
    <rendition xml:id="mentioned" scheme="css">font-style:italic;</rendition>
    <rendition xml:id="term" scheme="css">font-style:italic;</rendition>
    <rendition xml:id="italic" scheme="css">font-style:italic;</rendition>
    <rendition xml:id="bold" scheme="css">font-weight:bold;</rendition>
    <rendition xml:id="bold-italic" scheme="css">font-style:italic;font-weight:bold;</rendition>
    <rendition xml:id="smallcaps" scheme="css">font-variant:small-caps;</rendition>
    <rendition xml:id="courier" scheme="css">font-family:Courier;</rendition>
    <rendition xml:id="sup" scheme="css">vertical-align:super;</rendition>
    <rendition xml:id="box" scheme="css">border: 1px solid black;</rendition>
    <rendition xml:id="alignleft" scheme="css">text-align:left;</rendition>        
    <rendition xml:id="listlabel" scheme="css">font-weight:bold;</rendition>        
    <rendition xml:id="p.head" scheme="css">font-weight:bold;</rendition>
    <rendition xml:id="citation" scheme="css">font:0.916em/1.636 Verdana,sans-serif;margin: 1.091em 0;padding: 0 0 0 4.363em;text-align: left;border-collapse: separate;</rendition>
    <rendition xml:id="gloss" scheme="css">list-style-type:none;</rendition>
    <rendition xml:id="inlinelabel" scheme="css">font-weight:normal;</rendition>
    <rendition xml:id="simplelist" scheme="css">list-style-type:none;</rendition>
    <rendition xml:id="glosslist" scheme="css">list-style-type:none;margin-left:4em;</rendition>
    <rendition xml:id="glosslabel" scheme="css">display:block;font-weight:bold;margin: 1em 0 1em -2em;</rendition>
    <rendition xml:id="foreign" scheme="css">font-style:italic;</rendition>
    <rendition xml:id="tr-label" scheme="css">background-color: silver;font-weight:bold;</rendition>
    <rendition xml:id="tr-label.colspan" scheme="css">background-color: silver;font-weight:bold;text-align:center;</rendition>
    <rendition xml:id="td-label" scheme="css">font-weight:bold;</rendition>
    <rendition xml:id="td-label.colspan" scheme="css">font-weight:bold;text-align:center;</rendition>
    <rendition xml:id="td.colspan" scheme="css">text-align:center;</rendition>
    
    <rendition xml:id="table.border" scheme="css">border: 1px solid black;border-collapse:collapse;</rendition>
    <rendition xml:id="tr-label.border" scheme="css">background-color: silver;font-weight:bold;border:1px solid black;</rendition>
    <rendition xml:id="tr-label.border.colspan" scheme="css">background-color: silver;font-weight:bold;border:1px solid black;text-align:center;</rendition>
    <rendition xml:id="td-label.border" scheme="css">font-weight:bold;border:1px solid black;</rendition>
    <rendition xml:id="td-label.border.colspan" scheme="css">font-weight:bold;border:1px solid black;text-align:center;</rendition>
    
    <rendition xml:id="td.border" scheme="css">border: 1px solid black;</rendition>
    <rendition xml:id="td.border.colspan" scheme="css">border: 1px solid black;text-align:center;</rendition>
    
    <!-- for paragraph indentation
    <rendition xml:id="p.indent" scheme="css">display:none;</rendition>
    -->
  </xsl:variable>
  
  <xsl:variable name="notes.type.front" select="('authorNotes', 'editorNotes')"/>
  
  <xsl:template match="tei:TEI">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="xsi:schemaLocation">
        <xsl:text>http://www.tei-c.org/ns/1.0 http://lodel.org/ns/tei/tei.openedition.1.6.2/document.xsd</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- ========= -->
  <!-- teiHeader -->
  <!-- ========= -->
  
  <!-- process <author>|<editor> name components in right order -->
  <xsl:template match="tei:titleStmt/tei:author/tei:name|tei:titleStmt/tei:editor/tei:name">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:value-of select="string-join((tei:forename, tei:nameLink, tei:surname)/normalize-space(), ' ')"></xsl:value-of>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="tei:titleStmt/tei:title[@type='main']">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:for-each select="parent::tei:titleStmt/tei:title[not(@type='main')]">
        <xsl:text>: </xsl:text>
        <xsl:apply-templates/>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="tei:titleStmt/tei:title[not(@type='main')]"/>
  
  <!-- wrap other <author>|<editor> children in <s> -->
  <xsl:template match="tei:titleStmt/tei:author/*|tei:titleStmt/tei:editor/*" priority="-0.5">
    <xsl:copy-of select="local:wrap(., 's')"/>
  </xsl:template>

  <!-- elevate <roleName>|<orgName> inside <affiliation> to siblings  -->
  <xsl:template match="tei:titleStmt/tei:author/tei:affiliation|tei:titleStmt/tei:editor/tei:affiliation">
    <xsl:copy-of select="local:wrap(., 's')"/>
    <xsl:copy-of select="(tei:roleName, tei:orgName)/local:wrap(., 's')"/>
  </xsl:template>
  
  <xsl:template match="tei:affiliation/tei:roleName|tei:affiliation/tei:orgName">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="tei:licence">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="tei:licence/*[not(self::tei:p)]">
    <p><xsl:apply-templates/></p>
  </xsl:template>
    
  <!-- add @scheme='keyword' and @xml:lang='en' if absent/empty; transform flat terms to list -->
  <xsl:template match="tei:keywords">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:if test="not(@scheme)">
        <xsl:attribute name="scheme">
          <xsl:text>keyword</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="not(@xml:lang[normalize-space()])">
        <xsl:attribute name="xml:lang">
          <xsl:text>en</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="tei:list">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
          <list>
            <xsl:apply-templates/>
          </list>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="tei:keywords/tei:term">
    <item>
      <xsl:apply-templates/>
    </item>
  </xsl:template>
  
  <xsl:template match="tei:encodingDesc">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()[not(self::tei:tagsDecl)]"/>
      <xsl:call-template name="tagsDecl"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- copy <rendition> definitions + add <rendition> definitions for input elements that are converted to <hi> -->
  <xsl:template name="tagsDecl">
    <tagsDecl>
      <xsl:apply-templates select="tei:tagsDecl/@*"/>
      <xsl:apply-templates select="tei:tagsDecl/tei:rendition[key('renditionsInUse', @xml:id, current()/root())]"/>
      <xsl:copy-of select="$hiConversion/*[key('renditions', @xml:id, current()/root())][not(key('renditionsInUse', @xml:id, current()/root()))]"/>
      <xsl:if test="local:get.SVNkeyword('Id')">
        <rendition xml:id="metadata">display:none;</rendition>
      </xsl:if>
    </tagsDecl>
  </xsl:template>
  
  <xsl:template match="tei:fileDesc/tei:seriesStmt|tei:revisionDesc"/>

  <!-- ===== -->
  <!-- front -->
  <!-- ===== -->
  
  <xsl:template match="tei:front">
    <xsl:variable name="current" select="."/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:for-each select="for $i in $div.types.front return $current/tei:div[@type = $i]">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="tei:front/tei:div[@type = $div.types.front]">
    <xsl:variable name="name" select="if (@type = $notes.type.front) then 'note' else name()"/>
    <xsl:element name="{$name}">
      <xsl:apply-templates select="@*"/>
      <!-- Lodel expects @xml:lang attribute for abstracts, so add default @xml:lang='en' if absent/emtpy -->
      <xsl:if test="@type eq 'abstract' and not(@xml:lang[normalize-space()])">
        <xsl:attribute name="xml:lang">en</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="tei:front/tei:div[@type = $div.types.front]/@type">
    <xsl:attribute name="{name()}">
      <xsl:choose>
        <xsl:when test=". eq 'authorNotes'">author</xsl:when>
        <xsl:when test=". eq 'editorNotes'">publisher</xsl:when>
        <xsl:when test=". eq 'acknowledgements'">ack</xsl:when>
        <xsl:when test=". eq 'corrections'">correction</xsl:when>
        <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!-- ==== -->
  <!-- body -->
  <!-- ==== -->
  
  <!-- body: process contents + add metadata at the end of body text -->
  <xsl:template match="tei:body[tei:div]">
    <xsl:copy>
      <xsl:call-template name="get.rendition"/>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
      <xsl:call-template name="body-metadata"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- div-less body: 
       -wrap contents in div
       -add head if that's missing too
  -->
  <xsl:template match="tei:body[not(tei:div)]">
    <xsl:copy>
      <xsl:call-template name="get.rendition"/>
      <xsl:apply-templates select="@*"/>
      <div>
        <xsl:if test="not(tei:head)">
          <head subtype="level1"><xsl:apply-templates select="//tei:fileDesc/tei:titleStmt/tei:title/node()"/></head>
        </xsl:if>
        <xsl:apply-templates/>
      </div>
      <xsl:call-template name="body-metadata"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- If (SVN) metadata are found, include them in a hidden paragraph in the body text. -->
  <xsl:template name="body-metadata">
    <xsl:variable name="metadata" select="local:get.SVNkeyword('Id')"/>
    <xsl:if test="$metadata">
      <div>
        <p rend="noindent" rendition="#metadata">
          <xsl:text>SVN keywords: </xsl:text>
          <xsl:value-of select="$metadata"/>
        </p>
      </div>
    </xsl:if>
  </xsl:template>  
  
  
  <xsl:template match="tei:body/tei:head">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="subtype">level1</xsl:attribute>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
    
  <!-- add @subtype to <head>, generate numbering -->
  <xsl:template match="tei:div/tei:head">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="subtype">
        <xsl:value-of select="concat('level', count(ancestor::tei:div))"/>        
      </xsl:attribute>
      <xsl:apply-templates select="parent::*" mode="label"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <!-- copy paragraphs, but break out nested paragraph-splitting blocks (tables, list, block quotes, ...). --> 
  <xsl:template match="tei:p">
    <xsl:for-each-group select="node()" group-starting-with="tei:cit|tei:table|tei:list[not(tokenize(@rend, '\s+') = 'inline')]|tei:figure|eg:egXML|tei:eg|tei:ptr[starts-with(@target, 'video:')]">
      <xsl:call-template name="promote.nested.blocks"/>
    </xsl:for-each-group>
  </xsl:template>

  <!-- This template groups all of the context nodes that are no paragraph-splitting blocks (tables, list, block quotes, ...) inside paragraphs, and normalizes whitespace for text preceding or following these blocks. -->
  <xsl:template name="promote.nested.blocks">
    <xsl:choose>
      <xsl:when test="current-group()[1][not(self::tei:cit|self::tei:table|self::tei:list|self::tei:figure|self::eg:egXML|self::tei:eg|self::tei:ptr[starts-with(@target, 'video:')])]">
        <xsl:if test="some $node in current-group() satisfies not($node/self::text()[not(normalize-space())])">
          <p>
            <xsl:if test="ancestor::tei:label[parent::tei:list[@type='gloss']]">
              <xsl:attribute name="rendition">#glosslabel</xsl:attribute>
            </xsl:if>
            <!-- This is strictly speaking cosmetical, to reduce spurious whitespace. If this is no concern, further processing could be simplified with
            
            <xsl:apply-templates select="current-group()"/>
            
            -->
            <xsl:for-each select="current-group()">
              <xsl:choose>
                <xsl:when test="self::text()">
                  <xsl:call-template name="process.promoted.text"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="."/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </p>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="current-group()[1]"/>
        <xsl:if test="some $node in current-group()[position() > 1] satisfies not($node/self::text()[not(normalize-space())])">
          <p rend="noindent">
            <xsl:if test="ancestor::tei:label[parent::tei:list[@type='gloss']]">
              <xsl:attribute name="rendition">#glosslabel</xsl:attribute>
            </xsl:if>
            <xsl:for-each select="current-group()[position() > 1]">
              <!-- Pre-process text() nodes only, in order to trim spurious whitespace afterwards. --> 
              <xsl:choose>
                <xsl:when test="self::text()">
                  <xsl:call-template name="process.promoted.text"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="."/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </p>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- add @n to <note> -->
  <xsl:template match="tei:text//tei:note">
    <xsl:param name="note.context" select="ancestor::*[self::tei:front|self::tei:body|self::tei:back]" tunnel="yes" as="element()?"/>
    <!-- 'pull' subsequent puntuation (if necessary) -->
    <xsl:call-template name="include.punctuation"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:if test="not(@place)">
        <xsl:attribute name="place">foot</xsl:attribute>
      </xsl:if>
      <xsl:attribute name="n">
        <!-- notes inside lists are processed in isolation; therefore add counter of notes preceding the parent list (if available) to the relative numbering -->
        <xsl:number value="local:get.note.nr(.)" format="{local:format.note.nr($note.context)}"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="tei:p">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
          <p>
            <xsl:apply-templates/>
          </p>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>  
  
  <!-- wrap <figure> inside its own <p>, elevate <head> elements to sibling <p> elements with expected value for @rend --> 
  <xsl:template match="tei:figure">
    <p rend="figure-title">
      <xsl:apply-templates select="." mode="label"/>
      <xsl:for-each select="tei:head[not(@type='license')]">
        <xsl:apply-templates select="node()"/>
        <xsl:call-template name="punctuate-head"/>
      </xsl:for-each>
    </p>
    <xsl:apply-templates select="*[not(self::tei:head)]"/>
    <xsl:for-each select="tei:head[@type eq 'license']">
      <p rend="figure-{@type}">
        <xsl:apply-templates/>
        <xsl:call-template name="punctuate-head"/>
      </p>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="tei:figure/tei:graphic">
    <xsl:variable name="current" select="."/>
    <xsl:for-each select="parent::tei:figure">
      <p>
        <xsl:copy>
          <xsl:apply-templates select="@*"/>
          <xsl:for-each select="$current">
            <xsl:copy>
              <xsl:apply-templates select="@*|node()"/>
            </xsl:copy>
          </xsl:for-each>
        </xsl:copy>
      </p>
    </xsl:for-each>
  </xsl:template>
  
  <!-- transform <egXML> to <code> -->  
  <xsl:template match="eg:egXML">
    <p rend="noindent">
      <code lang="xml">
        <xsl:apply-templates select="node()" mode="egXML"/>
      </code>
    </p>
  </xsl:template>

  <xsl:template match="tei:eg">
    <xsl:variable name="stripIndent" select="min((for $line in tokenize(., '\n')[.] return string-length(replace($line, '^(\s+).*', '$1'))))"/>
    <p rend="noindent">
      <code lang="xml">
        <xsl:analyze-string select="." regex="\n">
          <xsl:matching-substring>
            <xsl:text>&#10;</xsl:text>
          </xsl:matching-substring>
          <xsl:non-matching-substring>
            <xsl:analyze-string select="if ($stripIndent > 0) then replace(., concat('^\s{', $stripIndent, '}'), '') else ." regex="\s">
              <xsl:matching-substring>
                <!-- zero-width space + normal space gives best balance between preserve-space and wrapping -->
                <xsl:text>&#8203; </xsl:text>
              </xsl:matching-substring>
              <xsl:non-matching-substring><xsl:copy-of select="."/></xsl:non-matching-substring>
            </xsl:analyze-string>
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </code>
    </p>    
  </xsl:template>
  
  <!-- resets indentation for <code> blocks (in order to keep PDF rendering more or less happy) -->
  <!-- NOTE: ideally, an automatic routine would split lines that exceed a maximum width (in    
             order to prevent cropping in PDF) -->  
  <!-- NOTE: problem right now: long start tags (with lots of attributes / namespace declarations): unless result is serialized, there's no way to indent these ==> high risk of cropping in PDF -->  
  <xsl:template match="eg:egXML//text()[matches(., '&#10;')]" mode="egXML">
    <xsl:param name="cutoff" select="(ancestor::eg:egXML|ancestor::eg)[1]" tunnel="yes"/>
    <xsl:variable name="depth" select=" count(ancestor::*[. >> $cutoff])"/>
    <xsl:variable name="depth.endtag" select="if (not(following-sibling::node()) and not(normalize-space())) then $depth -1 else $depth"/>
    <xsl:variable name="indentString"><xsl:text>  </xsl:text></xsl:variable>
    <xsl:variable name="padding" select="string-join(('&#10;', for $i in (1 to $depth.endtag) return $indentString), '')"/>
    <xsl:value-of select="replace(local:escapeEntitiesForEgXML(.), '&#10;\s*', $padding)"/>
  </xsl:template>
  
  <xsl:template match="eg:egXML//text()" mode="egXML" priority="-0.5">
    <xsl:value-of select="local:escapeEntitiesForEgXML(.)"/>
  </xsl:template>
  
  <xsl:template match="*" mode="egXML">
    <xsl:choose>
      <xsl:when test="node()">
        <xsl:call-template name="createTag">
          <xsl:with-param name="type" select="'start'"/>
        </xsl:call-template>
        <xsl:apply-templates select="node()" mode="egXML"/>
        <xsl:call-template name="createTag">
          <xsl:with-param name="type" select="'end'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="createTag">
          <xsl:with-param name="type" select="'empty'"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="comment()" mode="egXML">
    <xsl:value-of select="local:get.delimiter('start', .)"/>
    <xsl:value-of select="."/>
    <xsl:value-of select="local:get.delimiter('end', .)"/>
  </xsl:template>
  
  <xsl:template match="processing-instruction()" mode="egXML">
    <xsl:value-of select="local:get.delimiter('start', .)"/>
    <xsl:value-of select="string-join((name(), .), ' ')"/>
    <xsl:value-of select="local:get.delimiter('end', .)"/>
  </xsl:template>

  <!-- transform <cit> to <q>, with @rend="quotation" (unless parent is <note>, to avoid ugly indentation in endnote) -->
  <xsl:template match="tei:cit">
    <xsl:apply-templates select="tei:quote"/>
  </xsl:template>
  
  <xsl:template match="tei:cit[not(ancestor::tei:note)]/tei:quote">
    <xsl:call-template name="blockquote"/>
  </xsl:template>
    
  <!-- filter out 'unquotable' content (in Lodel) -->
  <xsl:template match="tei:cit[not(ancestor::tei:note)]/tei:quote[tei:list|tei:table]" priority="1">
    <xsl:variable name="current" select="."/>
    <xsl:for-each-group select="*" group-adjacent="name()">
      <xsl:choose>
        <xsl:when test="current-group()[1][self::tei:p]">
          <xsl:call-template name="blockquote">
            <xsl:with-param name="node" select="current-group()"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="current-group()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>
  
  <!-- serialize abstract content of "blockquote" template to OpenEdition -->
  <xsl:template match="tei:seg[@type='abstract.blockquote']" mode="serialize">
    <q>
      <xsl:copy-of select="@rend|node()" copy-namespaces="no"/>
    </q>
  </xsl:template>
  
  <!-- untag <cit> in paragraph: just process contents -->
  <xsl:template match="tei:cit[ancestor::tei:note]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <!-- put parentheses around <bibl> or <ref> in <cit> -->
  <xsl:template match="tei:cit/tei:bibl|tei:cit/tei:ref">
    <xsl:if test="not(ancestor::tei:note)">
      <lb/>
    </xsl:if>
    <xsl:text>(</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>)</xsl:text>
  </xsl:template>
  
  <xsl:template match="tei:quote|tei:q">
    <xsl:variable name="quote.bool" select="if (not(parent::tei:cit) or ancestor::tei:note) then true() else false()"/>
    <xsl:variable name="quoteLevel" select="local:get.quoteLevel(.)"/>
    <xsl:if test="$quote.bool">
      <xsl:choose>
        <xsl:when test="$quoteLevel mod 2 = 1">
          <xsl:value-of select="$lsquo"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$ldquo"/>          
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:call-template name="include.punctuation"/>
    <xsl:if test="$quote.bool">
      <xsl:choose>
        <xsl:when test="$quoteLevel mod 2 = 1">
          <xsl:value-of select="$rsquo"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$rdquo"/>          
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:quote//tei:supplied|tei:q//tei:supplied">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>]</xsl:text>
  </xsl:template>
  
  <xsl:template match="tei:quote//tei:gap|tei:q//tei:gap">
    <xsl:if test="preceding-sibling::node()[1]/self::text()[matches(., '[\S-[.]]$')]">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:text>…</xsl:text>
    <xsl:if test="following-sibling::node()[1]/self::text()[matches(., '^\S')]">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:quote/tei:p">
    <xsl:apply-templates/>
    <xsl:if test="following-sibling::tei:p"><lb/></xsl:if>
  </xsl:template>
  
  <!-- skip <p> inside inline lists -->
  <xsl:template match="tei:list[tokenize(@rend, '\s+') = 'inline']/tei:item/tei:p">
    <xsl:apply-templates/>
  </xsl:template>

<!--
  <xsl:template match="tei:cit/tei:quote/*" priority="0">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:call-template name="get.rendition"/>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
-->
  
  <!-- replace external <ptr/> with <ref>, whose label = @target -->
  <xsl:template match="tei:ptr[not(@type = ('crossref','bibl'))]|tei:ref[not(@type = ('crossref','bibl'))]">
    <ref>
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
        <xsl:when test="normalize-space()">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
          <!-- Inject a zero-width space after slashes and periods to add more places where browsers
               can wrap long URLs. 
               Note: in order to avoid breaking in between repeated slashes and periods, and within 
               '../',  this replacement has to happen in two passes.
          -->
          <xsl:value-of select="
            replace(
              replace(
                @target,
                '([/])([^/])',
                '$1&#8203;$2')
            , '([\.])([^\./])',
            '$1&#8203;$2')
          "/>
        </xsl:otherwise>
      </xsl:choose>
    </ref>
  </xsl:template>
  
  <xsl:template match="tei:ptr[starts-with(@target, 'video:')]" priority="1">
    <p>
      <xsl:value-of select="concat('[', @target, ']')"/>
    </p>
  </xsl:template>
  

  <xsl:template match="tei:ptr[@type eq 'crossref']">
    <xsl:variable name="labels">
      <xsl:call-template name="get.crossref.labels"/>
    </xsl:variable>
    <xsl:for-each-group select="$labels/*" group-adjacent="@type">
      <xsl:variable name="counter.group" select="position()"/>
      <xsl:call-template name="enumerate"/>
      <xsl:for-each select="current-group()">
        <xsl:call-template name="enumerate"/>
        <xsl:choose>
          <xsl:when test="normalize-space()">
            <xsl:variable name="label.formatted">
              <xsl:call-template name="format.crossref.labels"/>
            </xsl:variable>
            <xsl:value-of select="if ($counter.group = 1 and position() = 1 or $jtei.lang = ('de')) then $label.formatted else lower-case($label.formatted)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat('[bad link to item: ', @n, ']')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:for-each-group>
  </xsl:template>

  <xsl:template match="tei:soCalled">
    <xsl:variable name="quoteLevel" select="local:get.quoteLevel(.)"/>
    <xsl:choose>
      <xsl:when test="$quoteLevel mod 2 = 1">
        <xsl:value-of select="$lsquo"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$ldquo"/>          
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates/>
    <xsl:call-template name="include.punctuation"/>
    <xsl:choose>
      <xsl:when test="$quoteLevel mod 2 = 1">
        <xsl:value-of select="$rsquo"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$rdquo"/>          
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- @xml:id apparently isn't copied in Lodel's HTML, so local hyperlinks 
       only produce a hyperlink that leads nowhere -->
  <xsl:template match="tei:*[@target][every $i in tokenize(@target, '\s+') satisfies starts-with(@target, '#')]" priority="0">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- transform <gi>|<att>|<val> to hi with corresponding @rendition, and additional text that can't be generated via <rendition> and CSS -->
  <xsl:template match="tei:gi|tei:att|tei:val">
    <hi>
      <xsl:call-template name="get.rendition"/>
      <xsl:apply-templates select="@*[not(name() = ('scheme'))]"/>
      <!--<seg type="delimiter">-->
      <xsl:value-of select="local:get.delimiter('start', .)"/>
      <!--</seg>-->
      <xsl:apply-templates/>
      <!--<seg type="delimiter">-->
      <xsl:value-of select="local:get.delimiter('end', .)"/>
      <!--</seg>-->
    </hi>
  </xsl:template>
  
  <!-- transform <tag> to hi with corresponding @rendition, and additional text that can't be generated via <rendition> and CSS -->
  <xsl:template match="tei:tag">
    <hi>
      <xsl:call-template name="get.rendition"/>
      <xsl:apply-templates select="@*[not(name() = ('scheme', 'type'))]"/>
      <!--<seg type="delimiter">-->
      <xsl:value-of select="local:get.delimiter('start', .)"/>
      <!--</seg>-->
      <xsl:apply-templates/>
      <!--<seg type="delimiter">-->
      <xsl:value-of select="local:get.delimiter('end', .)"/>
      <!--</seg>-->
    </hi>
  </xsl:template>
  
  <xsl:template match="tei:num[@type='ordinal']">
    <xsl:variable name="current" select="."/>
    <xsl:analyze-string regex="^\d+" select="text()">
      <xsl:matching-substring>
        <xsl:value-of select="."/>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <hi>
          <xsl:for-each select="$current">
            <xsl:call-template name="get.rendition"/>
          </xsl:for-each>
          <xsl:value-of select="."/>
        </hi>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>
  
  <xsl:template match="tei:emph">
    <hi>
      <xsl:copy-of select="@rendition"/>
      <xsl:if test="not(@rendition)">
        <xsl:attribute name="rendition">#italic</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </hi>
  </xsl:template>
  
  <xsl:template match="tei:orgName">
    <xsl:apply-templates/>
  </xsl:template>
  
  <!-- transform other 'flagged' elements (see index in 'hi' key) to hi with corresponding @rendition -->
  <xsl:template match="*[key('renditions', local-name())]" priority="-.5">
    <hi>
      <xsl:apply-templates select="@*"/>
      <xsl:call-template name="get.rendition"/>
      <xsl:apply-templates/>
    </hi>
  </xsl:template>
  
  <!-- only highlight //title[@level = ('m', 'j')] -->
  <xsl:template match="tei:title[@level = ('m', 'j')]">
    <hi>
      <xsl:call-template name="get.rendition"/>
      <xsl:apply-templates/>
    </hi>
  </xsl:template>
  
  <xsl:template match="tei:title[@level = ('a', 'u')]">
    <xsl:variable name="quoteLevel" select="local:get.quoteLevel(.)"/>
    <xsl:choose>
      <xsl:when test="$quoteLevel mod 2 = 1">
        <xsl:value-of select="$lsquo"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$ldquo"/>          
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates/>
    <xsl:call-template name="include.punctuation"/>
    <xsl:choose>
      <xsl:when test="$quoteLevel mod 2 = 1">
        <xsl:value-of select="$rsquo"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$rdquo"/>          
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
      
  <!-- skip all other titles in the text -->
  <xsl:template match="tei:text//tei:title[not(@level = ('a','u', 'm', 'j'))]">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- untag bibliographical elements (except title or ref) in running text/notes: just process contents -->
  <xsl:template match="tei:bibl[not(ancestor::tei:div[@type='bibliography']|ancestor::tei:cit)]|tei:bibl[not(ancestor::tei:div[@type='bibliography'])]/*[not(self::tei:title or self::tei:ref or self::tei:ptr)]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="tei:idno[not(ancestor::tei:teiHeader)][not(parent::tei:bibl)]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <!-- in order to 'escape' problematic list renderings in Lodel, lists flagged as @rend='inline' will be transformed into running text, with the markers hardcoded in the text -->
  <xsl:template match="tei:list[tokenize(@rend, '\s+') = 'inline']">
    <xsl:for-each select="tei:item">
      <xsl:variable name="marker">
        <xsl:call-template name="get.inline.list.marker"/>
      </xsl:variable>
      <xsl:if test="normalize-space($marker)">
        <hi>
          <xsl:call-template name="get.rendition"/>
          <xsl:value-of select="$marker"/>
        </hi>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates/>
      <xsl:if test="following-sibling::tei:item">
        <xsl:text> </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
      
  <xsl:template match="tei:table/tei:head">
    <p rend="noindent">
      <xsl:call-template name="get.rendition"/>
      <xsl:apply-templates select="parent::*" mode="label"/>
      <xsl:apply-templates/>
      <xsl:call-template name="punctuate-head"/>
    </p>
  </xsl:template>
  
  <!-- don't generate a label for list headings -->
  <!-- (could be very confusing if only 1 list has a heading) -->
  <xsl:template match="tei:list/tei:head">
    <p rend="noindent">
      <xsl:call-template name="get.rendition"/>
      <xsl:apply-templates/>
      <xsl:call-template name="punctuate-head"/>
    </p>
  </xsl:template>
  
  <!-- process <head> as paragraph preceding the <list> -->
  <xsl:template match="tei:list">
    <xsl:apply-templates select="tei:head"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:call-template name="get.rendition"/>        
      <xsl:apply-templates select="node()[not(self::tei:head)]"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- output list <item> and <label> as <item> elements; group everything that's not inside a paragraph or paragraph-splitting block inside paragraphs -->
  <xsl:template match="tei:list[not(matches(@rend, 'inline'))]/tei:item|tei:list[not(matches(@rend, 'inline'))]/tei:label">
    <item>
      <xsl:copy-of select="@*"/>
      <!-- start by grouping on <p> also, to catch mixed cases -->
      <xsl:for-each-group select="node()" group-starting-with="tei:p|tei:cit|tei:table|tei:list[not(tokenize(@rend, '\s+') = 'inline')]|tei:figure|eg:egXML|tei:eg|tei:ptr[starts-with(@target, 'video:')]">
        <xsl:choose>
          <!-- when first group starts with <p>, copy that and promote following text to <p> -->
          <xsl:when test="current-group()[1][self::tei:p]">
            <!-- copy existing <p> -->
            <xsl:apply-templates select="current-group()[1]"/>
            <!-- wrap remaining text in <p> -->
            <xsl:if test="count(current-group()[not(self::text()[not(normalize-space())])]) > 1">
              <p>
                <!-- trim remaining text; copy other content -->
                <xsl:for-each select="current-group()[position() > 1]">
                  <xsl:choose>
                    <xsl:when test="self::text()">
                      <xsl:call-template name="process.promoted.text"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:apply-templates select="."/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </p>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="promote.nested.blocks"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each-group>
    </item>
  </xsl:template>

  <xsl:template match="tei:list/@rend">
    <xsl:attribute name="type">
      <xsl:choose>
        <xsl:when test="not(tokenize(., '\s+') = 'ordered')">
          <xsl:text>unordered</xsl:text>          
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>ordered</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!-- labeled lists:
      -transform list to simple list
      -transform label to item
      -assign rendition class to label contents
   -->
  <xsl:template match="tei:list/@type[. = 'gloss']">
    <xsl:attribute name="type">unordered</xsl:attribute>
  </xsl:template>
  
  <xsl:template match="tei:table">
    <xsl:apply-templates select="tei:head"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:call-template name="get.rendition"/>
      <xsl:apply-templates select="node()[not(self::tei:head)]"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:cell">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:call-template name="get.rendition"/>
      <xsl:apply-templates/>      
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="tei:text//tei:date" priority="0">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="tei:text//tei:email">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- ==== -->
  <!-- back -->
  <!-- ==== -->
  
  <!-- transform listBibl/head to <bibl type="head" subtype="levelN"> -->
  <xsl:template match="tei:listBibl/tei:head">
    <xsl:variable name="level" select="count(ancestor::tei:listBibl)" as="xs:integer"/>
    <head subtype="level{min(($level, 6))}">
      <xsl:apply-templates select="node()"/>
    </head>
  </xsl:template>
  
  <!-- untag all other <bibl> contents (except for <ref>) -->
  <xsl:template match="tei:listBibl//tei:bibl/*" priority="-0.5">
    <xsl:apply-templates/>
  </xsl:template>
  
  <!-- check if author(ing instance/s) are the same as for preceding bibliographical entry -->
  <xsl:template match="tei:listBibl//tei:bibl">
    <xsl:variable name="dateOrTitle" select="(tei:date|tei:title)[1]"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:call-template name="get.author.instance">
        <xsl:with-param name="dateOrTitle" select="$dateOrTitle"/>
      </xsl:call-template>
      <xsl:apply-templates select="$dateOrTitle|node()[. >> ($dateOrTitle,current())[1]]"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- ================== -->
  <!-- default processing -->
  <!-- ================== -->  
  
  <!-- Further processing of text is done in jtei.common.xsl, in order to guarantee uniform 
       processing of punctuation following quotation marks or footnote markers. -->  
  <xsl:template match="text()">
    <xsl:apply-imports/>
  </xsl:template>
  
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:call-template name="get.rendition"/>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="tei:TEI/@rend[. = ('jTEI', 'jTEI.internal')]"/>
  <xsl:template match="comment()|processing-instruction()"/>
  
  <xsl:template match="tei:code/@lang|tei:row/@role|tei:row/@rows|tei:row/@cols|tei:cell/@role|tei:graphic/@width|tei:graphic/@height"/>

  <!-- ========= -->
  <!-- functions -->
  <!-- ========= -->
  
  <xsl:template name="get.rendition">
    <xsl:for-each select="$hiConversion/tei:rendition/@xml:id[. eq local:map.styles(current())]">
      <xsl:attribute name="rendition">
        <xsl:value-of select="concat('#', .)"/>
      </xsl:attribute>
    </xsl:for-each>
  </xsl:template>
      
  <xsl:function name="local:wrap">
    <xsl:param name="context"/>
    <xsl:param name="wrapper"/>
    <xsl:for-each select="$context">
      <xsl:copy>
        <xsl:apply-templates select="@*"/>
        <xsl:element name="{$wrapper}">
          <xsl:apply-templates select="node()"/>
        </xsl:element>
      </xsl:copy>
    </xsl:for-each>
  </xsl:function>
  
  <!-- function for mapping original element names with output rendition definitions -->
  <!-- note: if multiple rendition definitions apply, the last is chosen, so make sure to put the one that should take precedence last -->
  <xsl:function name="local:map.styles" as="xs:string?">
    <xsl:param name="node"/>
    <xsl:choose>
      <xsl:when test="$node/self::tei:item/parent::tei:list[tokenize(@rend, '\s+') = 'inline'][not(tokenize(@rend, '\s+') = 'simple')]">inlinelabel</xsl:when>
      <xsl:when test="$node/self::tei:head/(parent::tei:list|parent::tei:table)">p.head</xsl:when>
      <xsl:when test="$node/self::tei:list[tokenize(@rend, '\s+') = 'inline'][not(tokenize(@rend, '\s+') = 'simple')]">simplelist</xsl:when>
      <xsl:when test="$node/self::tei:list[@type eq 'gloss']">glosslist</xsl:when>
      <xsl:when test="$node[self::tei:list or self::tei:table]/parent::tei:quote/parent::tei:cit or $node/self::tei:cit[tei:quote/(tei:table|tei:list)]">citation</xsl:when>
      <xsl:when test="$node[self::tei:label[parent::tei:list[@type eq 'gloss']]]">glosslabel</xsl:when>
      <xsl:when test="$node/self::tei:table[@rend='border']">table.border</xsl:when>
      <xsl:when test="$node/self::tei:cell[xs:integer(@cols) gt 1 or ancestor::tei:table[1][@rend eq 'border'] or @role eq 'label' or parent::tei:row[@role eq 'label']]">
        <xsl:variable name="parts">
          <xsl:choose>
            <xsl:when test="$node/parent::tei:row[@role eq 'label']">
              <xsl:text>tr-label</xsl:text>
            </xsl:when>
            <xsl:when test="$node[@role eq 'label']">
              <xsl:text>td-label</xsl:text>
            </xsl:when>
            <xsl:otherwise>td</xsl:otherwise>
          </xsl:choose>
          <xsl:if test="$node/ancestor::tei:table[1][@rend eq 'border']">
            <xsl:text>.border</xsl:text>
          </xsl:if>
          <xsl:if test="$node[xs:integer(@cols) gt 1]">
            <xsl:text>.colspan</xsl:text>
          </xsl:if>
        </xsl:variable>
        <xsl:value-of select="string-join($parts, '')"/>
      </xsl:when>
      <xsl:when test="$node/self::tei:table">table</xsl:when>
      <xsl:when test="$node/self::tei:num[@type eq 'ordinal']">sup</xsl:when>
      <xsl:when test="$node/self::tei:title[@level = ('m', 'j')]">italic</xsl:when>
      <!-- for paragraph indentation
      <xsl:when test="$node/self::tei:p[parent::tei:div]">p.indent</xsl:when>
      -->
            
      <xsl:otherwise><xsl:value-of select="$node/local-name()"/></xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
</xsl:stylesheet>