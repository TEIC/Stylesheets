<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:s="http://www.ascc.net/xml/schematron"
  xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:rng="http://relaxng.org/ns/structure/1.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:teix="http://www.tei-c.org/ns/Examples"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="fo s a tei html rng teix xs sch" version="2.0">
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet"
    type="stylesheet">
    <desc>
      <p> TEI stylesheet for weaving TEI ODD documents</p>
      <p>This software is dual-licensed: 1. Distributed under a Creative Commons
        Attribution-ShareAlike 3.0 Unported License
        http://creativecommons.org/licenses/by-sa/3.0/ 2.
        http://www.opensource.org/licenses/BSD-2-Clause Redistribution and use
        in source and binary forms, with or without modification, are permitted
        provided that the following conditions are met: * Redistributions of
        source code must retain the above copyright notice, this list of
        conditions and the following disclaimer. * Redistributions in binary
        form must reproduce the above copyright notice, this list of conditions
        and the following disclaimer in the documentation and/or other materials
        provided with the distribution. This software is provided by the
        copyright holders and contributors "as is" and any express or implied
        warranties, including, but not limited to, the implied warranties of
        merchantability and fitness for a particular purpose are disclaimed. In
        no event shall the copyright holder or contributors be liable for any
        direct, indirect, incidental, special, exemplary, or consequential
        damages (including, but not limited to, procurement of substitute goods
        or services; loss of use, data, or profits; or business interruption)
        however caused and on any theory of liability, whether in contract,
        strict liability, or tort (including negligence or otherwise) arising in
        any way out of the use of this software, even if advised of the
        possibility of such damage. </p>
      <p>Author: See AUTHORS</p>
      <p>Copyright: 2013, TEI Consortium</p>
    </desc>
  </doc>
  <xsl:key name="CHILDMOD" match="Element" use="@module"/>
  <xsl:variable name="Original" select="/"/>
  <xsl:param name="teiWeb">
    <xsl:text>http://www.tei-c.org/release/doc/tei-p5-doc/</xsl:text>
  </xsl:param>
  <xsl:template match="tei:ptr | tei:ref" mode="weave">
    <xsl:choose>
      <xsl:when
        test="ancestor::tei:remarks or ancestor::tei:listRef or ancestor::tei:valDesc">
        <xsl:choose>
          <xsl:when test="starts-with(@target, '#')">
            <xsl:variable name="Ancestor">
              <xsl:value-of
                select="id(substring(@target, 2))/ancestor::tei:div[last()]/@xml:id"
              />
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="id(substring(@target, 2))">
                <xsl:call-template name="makeInternalLink">
                  <xsl:with-param name="target" select="substring(@target, 2)"/>
                  <xsl:with-param name="ptr"
                    select="
                      if (self::tei:ptr)
                      then
                        true()
                      else
                        false()"/>
                  <xsl:with-param name="dest">
                    <xsl:call-template name="generateEndLink">
                      <xsl:with-param name="where">
                        <xsl:value-of select="substring(@target, 2)"/>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:when>
              <xsl:when
                test="
                  index-of(('AB',
                  'AI',
                  'CC',
                  'CE',
                  'CH',
                  'CO',
                  'DI',
                  'DR',
                  'DS',
                  'FS',
                  'FT',
                  'GD',
                  'HD',
                  'MS',
                  'ND',
                  'NH',
                  'PH',
                  'SA',
                  'SG',
                  'ST',
                  'TC',
                  'TD',
                  'TS',
                  'USE',
                  'VE',
                  'WD'), $Ancestor) > 0">
                <xsl:call-template name="makeExternalLink">
                  <xsl:with-param name="ptr"
                    select="
                      if (self::tei:ptr)
                      then
                        true()
                      else
                        false()"/>
                  <xsl:with-param name="dest">
                    <xsl:value-of select="$teiWeb"/>
                    <xsl:value-of select="tei:generateDocumentationLang(.)"/>
                    <xsl:text>/html/</xsl:text>
                    <xsl:value-of select="$Ancestor"/>
                    <xsl:text>.html</xsl:text>
                    <xsl:value-of select="@target"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>«</xsl:text>
                <xsl:value-of select="@target"/>
                <xsl:text>»</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-imports/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-imports/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="tei:attDef" mode="summary">
    <xsl:variable name="name" select="tei:createSpecName(.)"/>
    <xsl:element namespace="{$outputNS}" name="{$rowName}">
      <xsl:element namespace="{$outputNS}" name="{$cellName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>odd_label</xsl:text>
        </xsl:attribute>
        <xsl:element namespace="{$outputNS}" name="{$codeName}">
          <xsl:attribute name="{$rendName}">
            <xsl:text>att</xsl:text>
          </xsl:attribute>
          <xsl:value-of select="$name"/>
        </xsl:element>
      </xsl:element>
      <xsl:element namespace="{$outputNS}" name="{$cellName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>odd_value</xsl:text>
        </xsl:attribute>
        <xsl:sequence select="tei:makeDescription(., true(), true())"/>
        <xsl:apply-templates select="tei:valList"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="tei:attRef" mode="summary"/>
  <xsl:template match="tei:classSpec | tei:elementSpec" mode="summary">
    <xsl:variable name="name" select="tei:createSpecName(.)"/>
    <xsl:variable name="linkname"
      select="concat(tei:createSpecPrefix(.), $name)"/>
    <xsl:element namespace="{$outputNS}" name="{$rowName}">
      <xsl:element namespace="{$outputNS}" name="{$cellName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>odd_label</xsl:text>
        </xsl:attribute>
        <xsl:element namespace="{$outputNS}" name="{$xrefName}">
          <xsl:attribute name="{$urlName}">
            <xsl:choose>
              <xsl:when test="number($splitLevel) = -1">
                <xsl:text>#</xsl:text>
                <xsl:value-of select="$idPrefix"/>
                <xsl:value-of select="$name"/>
              </xsl:when>
              <xsl:when test="$STDOUT = 'true'">
                <xsl:for-each select="key('IDENTS', $name)">
                  <xsl:call-template name="getSpecURL">
                    <xsl:with-param name="name">
                      <xsl:value-of select="$name"/>
                    </xsl:with-param>
                    <xsl:with-param name="type">
                      <xsl:value-of
                        select="substring-before(local-name(), 'Spec')"/>
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>ref-</xsl:text>
                <xsl:value-of select="$linkname"/>
                <xsl:text>.html</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:value-of select="$name"/>
          <xsl:for-each select="key('IDENTS', $name)">
            <xsl:if test="tei:content/rng:empty">
              <xsl:text>/</xsl:text>
            </xsl:if>
          </xsl:for-each>
        </xsl:element>
      </xsl:element>
      <xsl:element namespace="{$outputNS}" name="{$cellName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>odd_value</xsl:text>
        </xsl:attribute>
        <xsl:sequence select="tei:makeDescription(., false(), true())"/>
        <xsl:apply-templates select="tei:valList"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element attDef</desc>
  </doc>
  <xsl:template match="tei:attDef">
    <xsl:variable name="name" select="tei:createSpecName(.)"/>
    <xsl:element namespace="{$outputNS}" name="{$rowName}">
      <xsl:element namespace="{$outputNS}" name="{$cellName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>odd_label</xsl:text>
        </xsl:attribute>
        <xsl:value-of select="$name"/>
        <!-- Addition by Martin Holmes 2012-07-14 for ticket http://purl.org/tei/fr/3511134     -->
        <!-- Add a pilcrow with a link.      -->
        <xsl:call-template name="attDefHook">
          <xsl:with-param name="attName">
            <xsl:value-of select="$name"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:element>
      <xsl:element namespace="{$outputNS}" name="{$cellName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>odd_value</xsl:text>
        </xsl:attribute>
        <!-- MDH 2018-01-21: setting third param ($makeMiniList) to 
          false so we can stop building ugly and superfluous lists 
          in Guidelines ref pages. See issue #296. -->
        <xsl:sequence select="tei:makeDescription(., true(), false())"/>
        <xsl:element namespace="{$outputNS}" name="{$tableName}">
          <xsl:attribute name="{$rendName}">
            <xsl:text>attDef</xsl:text>
          </xsl:attribute>
          <xsl:if test="@corresp">
            <xsl:element namespace="{$outputNS}" name="{$rowName}">
              <xsl:element namespace="{$outputNS}" name="{$cellName}">
                <xsl:attribute name="{$rendName}">
                  <xsl:text>odd_label</xsl:text>
                </xsl:attribute>
                <xsl:element namespace="{$outputNS}" name="{$hiName}">
                  <xsl:attribute name="{$rendName}">
                    <xsl:text>label</xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="{$langAttributeName}">
                    <xsl:value-of select="$documentationLanguage"/>
                  </xsl:attribute>
                  <xsl:sequence select="tei:i18n('Derivedfrom')"/>
                </xsl:element>
              </xsl:element>
              <xsl:element namespace="{$outputNS}" name="{$cellName}">
                <xsl:attribute name="{$rendName}">
                  <xsl:text>odd_value</xsl:text>
                </xsl:attribute>
                <xsl:call-template name="linkTogether">
                  <xsl:with-param name="name" select="substring(@corresp, 2)"/>
                  <xsl:with-param name="reftext">
                    <xsl:value-of select="substring(@corresp, 2)"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:element>
            </xsl:element>
          </xsl:if>
          <xsl:call-template name="validUntil"/>
          <xsl:element namespace="{$outputNS}" name="{$rowName}">
            <xsl:element namespace="{$outputNS}" name="{$cellName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>odd_label</xsl:text>
              </xsl:attribute>
              <xsl:element namespace="{$outputNS}" name="{$hiName}">
                <xsl:attribute name="{$rendName}">
                  <xsl:text>label</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="{$langAttributeName}">
                  <xsl:value-of select="$documentationLanguage"/>
                </xsl:attribute>
                <xsl:sequence select="tei:i18n('Status')"/>
              </xsl:element>
              <xsl:text> </xsl:text>
            </xsl:element>
            <xsl:element namespace="{$outputNS}" name="{$cellName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>odd_value</xsl:text>
              </xsl:attribute>
              <xsl:element namespace="{$outputNS}" name="{$segName}">
                <xsl:attribute name="{$langAttributeName}">
                  <xsl:value-of select="$documentationLanguage"/>
                </xsl:attribute>
                <xsl:choose>
                  <xsl:when test="@usage = 'mwa'">
                    <xsl:sequence select="tei:i18n('Mandatory when applicable')"
                    />
                  </xsl:when>
                  <xsl:when test="@usage = 'opt'">
                    <xsl:sequence select="tei:i18n('Optional')"/>
                  </xsl:when>
                  <xsl:when test="@usage = 'rec'">
                    <xsl:sequence select="tei:i18n('Recommended')"/>
                  </xsl:when>
                  <xsl:when test="@usage = 'req'">
                    <xsl:element namespace="{$outputNS}" name="{$hiName}">
                      <xsl:attribute name="{$rendName}">
                        <xsl:text>required</xsl:text>
                      </xsl:attribute>
                      <xsl:sequence select="tei:i18n('Required')"/>
                    </xsl:element>
                  </xsl:when>
                  <xsl:when test="@usage = 'rwa'">
                    <xsl:sequence
                      select="tei:i18n('Recommended when applicable')"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:sequence select="tei:i18n('Optional')"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
            </xsl:element>
          </xsl:element>
          <xsl:apply-templates mode="weave"/>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element attDef/tei:datatype</desc>
  </doc>
  <xsl:template match="tei:attDef/tei:datatype" mode="weave">
    <xsl:element namespace="{$outputNS}" name="{$rowName}">
      <xsl:element namespace="{$outputNS}" name="{$cellName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>odd_label</xsl:text>
        </xsl:attribute>
        <xsl:element namespace="{$outputNS}" name="{$hiName}">
          <xsl:attribute name="{$langAttributeName}">
            <xsl:value-of select="$documentationLanguage"/>
          </xsl:attribute>
          <xsl:attribute name="{$rendName}">
            <xsl:text>label</xsl:text>
          </xsl:attribute>
          <xsl:sequence select="tei:i18n('Datatype')"/>
        </xsl:element>
        <xsl:text> </xsl:text>
      </xsl:element>
      <xsl:element namespace="{$outputNS}" name="{$cellName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>odd_value</xsl:text>
        </xsl:attribute>
        <!-- Convert @minOccurs and @maxOccurs to integers, giving them -->
        <!-- a default of 1, and converting "unbounded" to -1. -->
        <!-- We should probably use the function tei:minOmaxO() instead. -->
        <xsl:variable name="minOccurs" select="( @minOccurs, '1' )[1] cast as xs:integer"/>
        <xsl:variable name="maxOccurs" as="xs:integer">
          <xsl:choose>
            <xsl:when test="normalize-space( @maxOccurs ) eq 'unbounded'">
              <xsl:value-of select="-1"/>
            </xsl:when>
            <xsl:when test="@maxOccurs">
              <xsl:value-of select="@maxOccurs cast as xs:integer"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="1"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:if test="( $minOccurs, $maxOccurs ) != 1">
          <xsl:text> </xsl:text>
          <xsl:value-of select="$minOccurs"/>
          <xsl:text>–</xsl:text>
          <xsl:value-of select="if ($maxOccurs eq -1) then '∞' else $maxOccurs"/>
          <xsl:text> </xsl:text>
          <xsl:element namespace="{$outputNS}" name="{$segName}">
            <xsl:attribute name="{$langAttributeName}">
              <xsl:value-of select="$documentationLanguage"/>
            </xsl:attribute>
            <xsl:sequence select="tei:i18n('occurrences of')"/>
          </xsl:element>
          <xsl:value-of select="$spaceCharacter"/>
        </xsl:if>
        <!-- <xsl:call-template name="schemaOut">
          <xsl:with-param name="grammar"/>
          <xsl:with-param name="element">code</xsl:with-param>
          <xsl:with-param name="content">
            <Wrapper>
              <xsl:copy-of select="rng:*"/>
            </Wrapper>
          </xsl:with-param>
        </xsl:call-template>-->
    
        <!-- we assume that datatype contains only a single dataRef -->
        <!-- (I don't like the above assumption, but I just tested, -->
        <!-- and as of now (2016-11-15) it's true for P5. -Syd)     -->
        <!-- MDH tweaked this again 2016-12-29 to deal with remaining
             rng:data elements not yet PURE-ified. -->
        <xsl:call-template name="showElement">
          <xsl:with-param name="name" select="if (tei:dataRef/@key) then tei:dataRef/@key else if (tei:dataRef/@name) then tei:dataRef/@name else if (rng:data/@type) then rng:data/@type else ''"/>
        </xsl:call-template>
        <xsl:if test="1 != ( $minOccurs, $maxOccurs )">
          <xsl:text> </xsl:text>
          <xsl:element namespace="{$outputNS}" name="{$segName}">
            <xsl:attribute name="{$langAttributeName}">
              <xsl:value-of select="$documentationLanguage"/>
            </xsl:attribute>
            <xsl:sequence select="tei:i18n('separated by whitespace')"/>
          </xsl:element>
        </xsl:if>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element classSpec</desc>
  </doc>
  <xsl:template match="tei:classSpec">
    <xsl:if test="parent::tei:specGrp">
      <xsl:element namespace="{$outputNS}" name="{$dtName}">
        <xsl:element namespace="{$outputNS}" name="{$hiName}">
          <xsl:attribute name="{$rendName}"
            ><xsl:text>label</xsl:text></xsl:attribute>
          <xsl:attribute name="{$langAttributeName}">
            <xsl:value-of select="$documentationLanguage"/>
          </xsl:attribute>
          <xsl:sequence select="tei:i18n('Class')"/>
        </xsl:element>: <xsl:value-of select="@ident"/></xsl:element>
      <xsl:element namespace="{$outputNS}" name="{$ddName}">
        <xsl:apply-templates mode="tangle" select="."/>
        <xsl:text>(</xsl:text>
        <xsl:element namespace="{$outputNS}" name="{$segName}">
          <xsl:attribute name="{$langAttributeName}">
            <xsl:value-of select="$documentationLanguage"/>
          </xsl:attribute>
          <xsl:sequence select="tei:i18n('Members')"/>
        </xsl:element>
        <xsl:text>: </xsl:text>
        <xsl:call-template name="generateMembers"/>
        <xsl:text>)</xsl:text>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element classSpec</desc>
  </doc>
  <xsl:template match="tei:classSpec" mode="weavebody">
    <xsl:variable name="name" select="tei:createSpecName(.)"/>
    <xsl:element namespace="{$outputNS}" name="{$sectionName}">
      <xsl:call-template name="makeSectionHead">
        <xsl:with-param name="id">
          <xsl:value-of select="concat(tei:createSpecPrefix(.), $name)"/>
        </xsl:with-param>
        <xsl:with-param name="name">
          <xsl:value-of select="$name"/>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:element namespace="{$outputNS}" name="{$tableName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>wovenodd</xsl:text>
        </xsl:attribute>
        <xsl:element namespace="{$outputNS}" name="{$rowName}">
          <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:attribute name="{$colspan}">2</xsl:attribute>
            <xsl:attribute name="{$rendName}">
              <xsl:text>wovenodd-col2</xsl:text>
            </xsl:attribute>
            <xsl:element namespace="{$outputNS}" name="{$hiName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>label</xsl:text>
              </xsl:attribute>
              <xsl:value-of select="$name"/>
            </xsl:element>
            <xsl:call-template name="specHook">
              <xsl:with-param name="name">
                <xsl:value-of select="$name"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:text>&#160;</xsl:text>
            <xsl:sequence select="tei:makeDescription(., true(), true())"/>
          </xsl:element>
        </xsl:element>
        <xsl:if test="@generate">
          <xsl:element namespace="{$outputNS}" name="{$rowName}">
            <xsl:element namespace="{$outputNS}" name="{$cellName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>wovenodd-col1</xsl:text>
              </xsl:attribute>
              <xsl:element namespace="{$outputNS}" name="{$segName}">
                <xsl:attribute name="{$langAttributeName}">
                  <xsl:value-of select="$documentationLanguage"/>
                </xsl:attribute>
                <xsl:sequence select="tei:i18n('Classes defined')"/>
              </xsl:element>
            </xsl:element>
            <xsl:element namespace="{$outputNS}" name="{$cellName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>wovenodd-col2</xsl:text>
              </xsl:attribute>
              <xsl:value-of select="@generate"/>
            </xsl:element>
          </xsl:element>
        </xsl:if>
        <xsl:call-template name="validUntil"/>
        <xsl:call-template name="moduleInfo"/>
        <xsl:if test="@type = 'model'">
          <xsl:element namespace="{$outputNS}" name="{$rowName}">
            <xsl:element namespace="{$outputNS}" name="{$cellName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>wovenodd-col1</xsl:text>
              </xsl:attribute>
              <xsl:element namespace="{$outputNS}" name="{$hiName}">
                <xsl:attribute name="{$rendName}">
                  <xsl:text>label</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="{$langAttributeName}">
                  <xsl:value-of select="$documentationLanguage"/>
                </xsl:attribute>
                <xsl:sequence select="tei:i18n('Used by')"/>
              </xsl:element>
            </xsl:element>
            <xsl:element namespace="{$outputNS}" name="{$cellName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>wovenodd-col2</xsl:text>
              </xsl:attribute>
              <xsl:call-template name="generateModelParents">
                <xsl:with-param name="showElements">true</xsl:with-param>
              </xsl:call-template>
            </xsl:element>
          </xsl:element>
        </xsl:if>
        <xsl:element namespace="{$outputNS}" name="{$rowName}">
          <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:attribute name="{$rendName}">
              <xsl:text>wovenodd-col1</xsl:text>
            </xsl:attribute>
            <xsl:element namespace="{$outputNS}" name="{$hiName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>label</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="{$langAttributeName}">
                <xsl:value-of select="$documentationLanguage"/>
              </xsl:attribute>
              <xsl:sequence select="tei:i18n('Members')"/>
            </xsl:element>
          </xsl:element>
          <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:attribute name="{$rendName}">
              <xsl:text>wovenodd-col2</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="generateMembers"/>
          </xsl:element>
        </xsl:element>
        <xsl:if test="@type = 'atts'">
          <xsl:element namespace="{$outputNS}" name="{$rowName}">
            <xsl:element namespace="{$outputNS}" name="{$cellName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>wovenodd-col1</xsl:text>
              </xsl:attribute>
              <xsl:element namespace="{$outputNS}" name="{$hiName}">
                <xsl:attribute name="{$rendName}">
                  <xsl:text>label</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="{$langAttributeName}">
                  <xsl:value-of select="$documentationLanguage"/>
                </xsl:attribute>
                <xsl:sequence select="tei:i18n('Attributes')"/>
              </xsl:element>
            </xsl:element>
            <xsl:element namespace="{$outputNS}" name="{$cellName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>wovenodd-col2</xsl:text>
              </xsl:attribute>
              <xsl:choose>
                <xsl:when test="not(tei:attList)">
                  <xsl:call-template name="showAttClasses"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="tei:attList">
                    <xsl:call-template name="displayAttList">
                      <xsl:with-param name="mode">all</xsl:with-param>
                    </xsl:call-template>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>
          </xsl:element>
        </xsl:if>
        <xsl:apply-templates mode="weave"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element classes</desc>
  </doc>
  <xsl:template match="tei:classes" mode="weave"> </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element elementSpec</desc>
  </doc>
  <xsl:template match="tei:elementSpec">
    <xsl:if test="parent::tei:specGrp">
      <xsl:element namespace="{$outputNS}" name="{$dtName}">
        <xsl:element namespace="{$outputNS}" name="{$segName}">
          <xsl:attribute name="{$langAttributeName}">
            <xsl:value-of select="$documentationLanguage"/>
          </xsl:attribute>
          <xsl:sequence select="tei:i18n('Element')"/>
          <xsl:value-of select="$spaceCharacter"/>
          <xsl:value-of select="@ident"/>
        </xsl:element>
      </xsl:element>
      <xsl:element namespace="{$outputNS}" name="{$ddName}">
        <xsl:apply-templates mode="tangle" select="."/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element elementSpec</desc>
  </doc>
  <xsl:template match="tei:elementSpec" mode="weavebody">
    <xsl:variable name="name" select="tei:createSpecName(.)"/>
    <xsl:element namespace="{$outputNS}" name="{$sectionName}">
      <xsl:call-template name="makeSectionHead">
        <xsl:with-param name="id">
          <xsl:value-of select="concat(tei:createSpecPrefix(.), $name)"/>
        </xsl:with-param>
        <xsl:with-param name="name">
          <xsl:text>&lt;</xsl:text>
          <xsl:choose>
            <xsl:when test="tei:content/rng:empty">
              <xsl:call-template name="emptySlash">
                <xsl:with-param name="name">
                  <xsl:value-of select="$name"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$name"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text>&gt;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="specHook">
        <xsl:with-param name="name">
          <xsl:value-of select="$name"/>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:element namespace="{$outputNS}" name="{$tableName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>wovenodd</xsl:text>
        </xsl:attribute>
        <xsl:element namespace="{$outputNS}" name="{$rowName}">
          <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:attribute name="{$colspan}">2</xsl:attribute>
            <xsl:attribute name="{$rendName}">
              <xsl:text>wovenodd-col2</xsl:text>
            </xsl:attribute>
            <xsl:element namespace="{$outputNS}" name="{$hiName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>label</xsl:text>
              </xsl:attribute>
              <xsl:text>&lt;</xsl:text>
              <xsl:choose>
                <xsl:when test="tei:content/rng:empty">
                  <xsl:call-template name="emptySlash">
                    <xsl:with-param name="name">
                      <xsl:value-of select="$name"/>
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$name"/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text>&gt; </xsl:text>
            </xsl:element>
            <xsl:sequence select="tei:makeDescription(., true(), true())"/>
          </xsl:element>
        </xsl:element>
        <xsl:call-template name="validUntil"/>
        <xsl:call-template name="moduleInfo"/>
        <xsl:variable name="myatts">
          <a>
            <xsl:choose>
              <xsl:when test="not(tei:attList)">
                <xsl:call-template name="showAttClasses"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each select="tei:attList">
                  <xsl:call-template name="displayAttList">
                    <xsl:with-param name="mode">all</xsl:with-param>
                  </xsl:call-template>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          </a>
        </xsl:variable>
        <xsl:if test="count($myatts/a/*) > 0">
          <xsl:element namespace="{$outputNS}" name="{$rowName}">
            <xsl:element namespace="{$outputNS}" name="{$cellName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>wovenodd-col1</xsl:text>
              </xsl:attribute>
              <xsl:element namespace="{$outputNS}" name="{$hiName}">
                <xsl:attribute name="{$rendName}">
                  <xsl:text>label</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="{$langAttributeName}">
                  <xsl:value-of select="$documentationLanguage"/>
                </xsl:attribute>
                <xsl:sequence select="tei:i18n('Attributes')"/>
              </xsl:element>
            </xsl:element>
            <xsl:element namespace="{$outputNS}" name="{$cellName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>wovenodd-col2</xsl:text>
              </xsl:attribute>
              <xsl:choose>
                <xsl:when test="not(tei:attList)">
                  <xsl:call-template name="showAttClasses"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="tei:attList">
                    <xsl:call-template name="displayAttList">
                      <xsl:with-param name="mode">all</xsl:with-param>
                    </xsl:call-template>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
              <!--
	      <xsl:for-each select="$myatts/a">
		<xsl:copy-of select="*|text()"/>
	      </xsl:for-each>
-->
            </xsl:element>
          </xsl:element>
        </xsl:if>
        <xsl:variable name="memberclasses">
          <xsl:call-template name="generateModelParents">
            <xsl:with-param name="showElements">false</xsl:with-param>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="count($memberclasses/*/*) > 0">
          <xsl:element namespace="{$outputNS}" name="{$rowName}">
            <xsl:element namespace="{$outputNS}" name="{$cellName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>wovenodd-col1</xsl:text>
              </xsl:attribute>
              <xsl:element namespace="{$outputNS}" name="{$hiName}">
                <xsl:attribute name="{$rendName}">
                  <xsl:text>label</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="{$langAttributeName}">
                  <xsl:value-of select="$documentationLanguage"/>
                </xsl:attribute>
                <xsl:sequence select="tei:i18n('Member of')"/>
              </xsl:element>
            </xsl:element>
            <xsl:element namespace="{$outputNS}" name="{$cellName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>wovenodd-col2</xsl:text>
              </xsl:attribute>
              <xsl:copy-of select="$memberclasses"/>
            </xsl:element>
          </xsl:element>
        </xsl:if>
        <xsl:element namespace="{$outputNS}" name="{$rowName}">
          <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:attribute name="{$rendName}">
              <xsl:text>wovenodd-col1</xsl:text>
            </xsl:attribute>
            <xsl:element namespace="{$outputNS}" name="{$hiName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>label</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="{$langAttributeName}">
                <xsl:value-of select="$documentationLanguage"/>
              </xsl:attribute>
              <xsl:sequence select="tei:i18n('Contained by')"/>
            </xsl:element>
          </xsl:element>
          <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:attribute name="{$rendName}">
              <xsl:text>wovenodd-col2</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="generateIndirectParents"/>
          </xsl:element>
        </xsl:element>
        <xsl:element namespace="{$outputNS}" name="{$rowName}">
          <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:attribute name="{$rendName}">
              <xsl:text>wovenodd-col1</xsl:text>
            </xsl:attribute>
            <xsl:element namespace="{$outputNS}" name="{$hiName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>label</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="{$langAttributeName}">
                <xsl:value-of select="$documentationLanguage"/>
              </xsl:attribute>
              <xsl:sequence select="tei:i18n('May contain')"/>
            </xsl:element>
          </xsl:element>
          <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:attribute name="{$rendName}">
              <xsl:text>wovenodd-col2</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="generateChildren"/>
          </xsl:element>
        </xsl:element>
        <xsl:variable name="remarks">
          <xsl:apply-templates mode="weave" select="tei:remarks"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="string-length($remarks) = 0">
            <xsl:apply-templates mode="doc" select="tei:remarks[@xml:lang='en']"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$remarks"/>
          </xsl:otherwise>
        </xsl:choose>        
        <xsl:apply-templates mode="weave" select="tei:exemplum"/>
        <xsl:apply-templates mode="weave" select="tei:constraintSpec"/>
        <xsl:apply-templates mode="weave" select="tei:content"/>
        <xsl:if test="tei:model | tei:modeGrp | tei:modelSequence">
          <xsl:element namespace="{$outputNS}" name="{$rowName}">
            <xsl:element namespace="{$outputNS}" name="{$cellName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>wovenodd-col1</xsl:text>
              </xsl:attribute>
              <xsl:element namespace="{$outputNS}" name="{$hiName}">
                <xsl:attribute name="{$rendName}">
                  <xsl:text>label</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="{$langAttributeName}">
                  <xsl:value-of select="$documentationLanguage"/>
                </xsl:attribute>
                <xsl:sequence select="tei:i18n('ProcessingModel')"/>
              </xsl:element>
            </xsl:element>
            <xsl:element namespace="{$outputNS}" name="{$cellName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>wovenodd-col2</xsl:text>
              </xsl:attribute>
              <xsl:call-template name="PMOut">
                <xsl:with-param name="content"><xsl:apply-templates select="tei:model | tei:modeGrp | tei:modelSequence" mode="PureODD"/></xsl:with-param>
              </xsl:call-template>
            </xsl:element>
          </xsl:element>
        </xsl:if>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="tei:*" mode="PureODD">
    <xsl:element name="{local-name(.)}">
      <xsl:for-each select="@*">
        <xsl:copy/>
      </xsl:for-each>
      <xsl:apply-templates mode="PureODD"/>
    </xsl:element>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element elementSpec/tei:content</desc>
  </doc>
  <xsl:template match="tei:elementSpec/tei:content" mode="weave">
    <xsl:variable name="name" select="tei:createSpecName(..)"/>
    <xsl:element namespace="{$outputNS}" name="{$rowName}">
      <xsl:element namespace="{$outputNS}" name="{$cellName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>wovenodd-col1</xsl:text>
        </xsl:attribute>
        <xsl:element namespace="{$outputNS}" name="{$hiName}">
          <xsl:attribute name="{$rendName}">
            <xsl:text>label</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="{$langAttributeName}">
            <xsl:value-of select="$documentationLanguage"/>
          </xsl:attribute>
          <xsl:sequence select="tei:i18n('ContentModel')"/>
        </xsl:element>
      </xsl:element>
      <xsl:element namespace="{$outputNS}" name="{$cellName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>wovenodd-col2</xsl:text>
        </xsl:attribute>
        <xsl:call-template name="pureODDOut">
          <xsl:with-param name="grammar"/>
          <xsl:with-param name="content">
            <PureODD>
              <xsl:apply-templates select="." mode="PureODD"/>
            </PureODD>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:for-each select="tei:valList[@type='closed']">
          <xsl:sequence select="tei:i18n('Legal values are')"/>
          <xsl:text>:</xsl:text>
          <xsl:call-template name="valListItems"/>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
    <xsl:element namespace="{$outputNS}" name="{$rowName}">
      <xsl:element namespace="{$outputNS}" name="{$cellName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>wovenodd-col1</xsl:text>
        </xsl:attribute>
        <xsl:element namespace="{$outputNS}" name="{$hiName}">
          <xsl:attribute name="{$rendName}">
            <xsl:text>label</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="{$langAttributeName}">
            <xsl:value-of select="$documentationLanguage"/>
          </xsl:attribute>
          <xsl:sequence select="tei:i18n('Schema Declaration')"/>
        </xsl:element>
      </xsl:element>
      <xsl:element namespace="{$outputNS}" name="{$cellName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>wovenodd-col2</xsl:text>
        </xsl:attribute>
        <xsl:variable name="content">
          <Wrapper>
            <rng:element name="{$name}">
              <xsl:if test="not(key('SCHEMASPECS',1))">
                <xsl:if test="$autoGlobal='true'">
                  <rng:ref name="att.global.attributes"/>
                </xsl:if>
                <xsl:for-each select="..">
                  <xsl:call-template name="showClassAtts"/>
                </xsl:for-each>
              </xsl:if>
              <xsl:apply-templates mode="tangle"
                select="../tei:attList"/>
              <xsl:for-each select="..">
                <xsl:call-template name="defineContent"/>
              </xsl:for-each>
            </rng:element>
          </Wrapper>
        </xsl:variable>
        <xsl:call-template name="schemaOut">
          <xsl:with-param name="grammar"/>
          <xsl:with-param name="content" select="$content"/>
        </xsl:call-template>
        <xsl:for-each select="tei:valList[@type = 'closed']">
          <xsl:sequence select="tei:i18n('Legal values are')"/>
          <xsl:text>:</xsl:text>
          <xsl:call-template name="valListItems"/>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template
    match="
      tei:constraintSpec[parent::tei:schemaSpec or parent::tei:elementSpec or
      parent::tei:classSpec or parent::tei:dataSpec or parent::tei:attDef]"
    mode="weave">
    <xsl:element namespace="{$outputNS}" name="{$rowName}">
      <xsl:element namespace="{$outputNS}" name="{$cellName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>wovenodd-col1</xsl:text>
        </xsl:attribute>
        <xsl:element namespace="{$outputNS}" name="{$hiName}">
          <xsl:attribute name="{$rendName}">
            <xsl:text>label</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="{$langAttributeName}">
            <xsl:value-of select="$documentationLanguage"/>
          </xsl:attribute>
          <xsl:text>Schematron</xsl:text>
        </xsl:element>
      </xsl:element>
      <xsl:element namespace="{$outputNS}" name="{$cellName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>wovenodd-col2</xsl:text>
        </xsl:attribute>
        <xsl:sequence select="tei:makeDescription(., true(), true())"/>
        <xsl:for-each select="tei:constraint">
          <xsl:element namespace="{$outputNS}" name="{$divName}">
            <xsl:attribute name="xml:space">preserve</xsl:attribute>
            <xsl:attribute name="{$rendName}">
              <xsl:text>pre</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates mode="verbatim"/>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template name="showClassAtts">
    <xsl:for-each select="tei:classes/tei:memberOf">
      <xsl:for-each select="key('IDENTS', @key)">
        <xsl:if test="tei:attList">
          <rng:ref name="{@ident}.attributes"/>
        </xsl:if>
        <xsl:call-template name="showClassAtts"/>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process the specification elements elements, classes and macros<param
        name="atts">attributes we have been asked to display</param>
    </desc>
  </doc>
  <xsl:template
    match="tei:elementSpec | tei:classSpec | tei:macroSpec | tei:dataSpec"
    mode="show">
    <xsl:param name="atts"/>
    <xsl:variable name="name" select="tei:createSpecName(.)"/>
    <xsl:variable name="linkname"
      select="concat(tei:createSpecPrefix(.), $name)"/>
    <xsl:element namespace="{$outputNS}" name="{$hiName}">
      <xsl:attribute name="{$rendName}">
        <xsl:text>specList-</xsl:text>
        <xsl:value-of select="local-name(.)"/>
      </xsl:attribute>
      <xsl:element namespace="{$outputNS}" name="{$xrefName}">
        <xsl:attribute name="{$urlName}">
          <xsl:choose>
            <xsl:when test="number($splitLevel) = -1">
              <xsl:text>#</xsl:text>
              <xsl:value-of select="$idPrefix"/>
              <xsl:value-of select="$name"/>
            </xsl:when>
            <xsl:when test="$STDOUT = 'true'">
              <xsl:for-each select="key('IDENTS', $name)">
                <xsl:call-template name="getSpecURL">
                  <xsl:with-param name="name">
                    <xsl:value-of select="$name"/>
                  </xsl:with-param>
                  <xsl:with-param name="type">
                    <xsl:value-of
                      select="substring-before(local-name(), 'Spec')"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>ref-</xsl:text>
              <xsl:value-of select="$linkname"/>
              <xsl:text>.html</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:value-of select="$name"/>
        <xsl:for-each select="key('IDENTS', $name)">
          <xsl:if test="tei:content/rng:empty">
            <xsl:text>/</xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
    <xsl:call-template name="showSpace"/>
    <xsl:sequence select="tei:makeDescription(., false(), true())"/>
    <xsl:choose>
      <xsl:when test="self::tei:classSpec and @type = 'model'">
        <xsl:if test="key('CLASSMEMBERS-CLASSES', @ident)">
          <xsl:element namespace="{$outputNS}" name="{$tableName}">
            <xsl:attribute name="{$rendName}">
              <xsl:text>classList</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates mode="summary"
              select="key('CLASSMEMBERS-CLASSES', @ident)">
              <xsl:sort select="lower-case(@ident)"/>
            </xsl:apply-templates>
          </xsl:element>
        </xsl:if>
        <xsl:if test="key('CLASSMEMBERS-ELEMENTS', @ident)">
          <xsl:element namespace="{$outputNS}" name="{$tableName}">
            <xsl:attribute name="{$rendName}">
              <xsl:text>elementList</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates mode="summary"
              select="key('CLASSMEMBERS-ELEMENTS', @ident)">
              <xsl:sort select="lower-case(@ident)"/>
            </xsl:apply-templates>
          </xsl:element>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$atts = '-' or $atts = ''"/>
      <xsl:when test="string-length($atts) > 0">
        <xsl:element namespace="{$outputNS}" name="{$tableName}">
          <xsl:attribute name="{$rendName}">
            <xsl:text>specDesc</xsl:text>
          </xsl:attribute>
          <xsl:variable name="HERE" select="."/>
          <xsl:for-each select="tokenize($atts, ' ')">
            <xsl:variable name="TOKEN" select="."/>
            <!-- Show a selected attribute where "$HERE" is the
	    starting node 
	    and $TOKEN is attribute we have been asked to display-->
            <xsl:for-each select="$HERE">
              <xsl:choose>
                <xsl:when test="$TOKEN = '+'">
                  <xsl:element namespace="{$outputNS}" name="{$rowName}">
                    <xsl:element namespace="{$outputNS}" name="{$cellName}">
                      <xsl:attribute name="{$rendName}">
                        <xsl:text>odd_value</xsl:text>
                      </xsl:attribute>
                      <xsl:attribute name="{$colspan}">
                        <xsl:text>2</xsl:text>
                      </xsl:attribute>
                      <xsl:call-template name="showAttClasses">
                        <xsl:with-param name="minimal">true</xsl:with-param>
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:element>
                </xsl:when>
                <xsl:when test="tei:attList//tei:attDef[@ident = $TOKEN]">
                  <xsl:for-each
                    select="tei:attList//tei:attDef[@ident = $TOKEN]">
                    <xsl:call-template name="showAnAttribute"/>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <!--Look for it in class hierarchy -->
                  <xsl:call-template name="checkClassesForAttribute">
                    <xsl:with-param name="TOKEN" select="$TOKEN"/>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="tei:attList//tei:attDef">
          <xsl:element namespace="{$outputNS}" name="{$tableName}">
            <xsl:attribute name="{$rendName}">
              <xsl:text>attList</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates mode="summary" select="tei:attList//tei:attDef"
            />
          </xsl:element>
        </xsl:if>
        <xsl:call-template name="showAttClasses">
          <xsl:with-param name="minimal">true</xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Recursively check class membership, looking for the definition of an
      attribute</desc>
  </doc>
  <xsl:template name="checkClassesForAttribute">
    <xsl:param name="TOKEN"/>
    <xsl:for-each select="tei:classes/tei:memberOf/key('IDENTS', @key)">
      <xsl:choose>
        <xsl:when test="tei:attList//tei:attDef[@ident = $TOKEN]">
          <xsl:for-each select="tei:attList//tei:attDef[@ident = $TOKEN]">
            <xsl:call-template name="showAnAttribute">
              <xsl:with-param name="showClass">true</xsl:with-param>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="checkClassesForAttribute">
            <xsl:with-param name="TOKEN" select="$TOKEN"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Display of an attribute</desc>
  </doc>
  <xsl:template name="showAnAttribute">
    <xsl:param name="showClass">false</xsl:param>
    <xsl:element namespace="{$outputNS}" name="{$rowName}">
      <xsl:element namespace="{$outputNS}" name="{$cellName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>Attribute</xsl:text>
        </xsl:attribute>
        <xsl:element namespace="{$outputNS}" name="{$hiName}">
          <xsl:attribute name="{$rendName}">
            <xsl:text>att</xsl:text>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="tei:altIdent">
              <xsl:value-of select="tei:altIdent"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@ident"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="$showClass = 'true'">
            <xsl:text> [</xsl:text>
            <xsl:value-of select="ancestor::tei:classSpec/@ident"/>
            <xsl:text>]</xsl:text>
          </xsl:if>
        </xsl:element>
      </xsl:element>
      <xsl:element namespace="{$outputNS}" name="{$cellName}">
        <xsl:sequence select="tei:makeDescription(., true(), true())"/>
        <xsl:if test="$verboseSpecDesc = 'true' and tei:valList">
          <xsl:element namespace="{$outputNS}" name="{$tableName}">
            <xsl:attribute name="{$rendName}">
              <xsl:text>attDef</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="tei:valList" mode="contents"/>
          </xsl:element>
        </xsl:if>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element exemplum</desc>
  </doc>
  <xsl:template match="tei:exemplum" mode="doc">
    <xsl:variable name="documentationLanguage">
      <xsl:sequence select="tei:generateDocumentationLang(.)"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="parent::tei:exemplum">
        <xsl:call-template name="showExample"/>
      </xsl:when>
      <xsl:when test="not(@xml:lang)">
        <xsl:call-template name="showExample"/>
      </xsl:when>
      <xsl:when test="@xml:lang = 'und'">
        <xsl:call-template name="showExample"/>
      </xsl:when>
      <xsl:when
        test="@xml:lang = 'mul' and not($documentationLanguage = 'zh-TW')">
        <!-- will need to generalize this if other langs come along like
		chinese -->
        <xsl:call-template name="showExample"/>
      </xsl:when>
      <xsl:when test="@xml:lang = $documentationLanguage">
        <xsl:call-template name="showExample"/>
      </xsl:when>
      <xsl:when
        test="not(../tei:exemplum[@xml:lang = $documentationLanguage]) and (@xml:lang = 'en' or @xml:lang = 'und' or @xml:lang = 'mul')">
        <xsl:call-template name="showExample"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process an example</desc>
  </doc>
  <xsl:template name="showExample">
    <xsl:choose>
      <xsl:when test="parent::tei:attDef">
        <xsl:element namespace="{$outputNS}" name="{$rowName}">
          <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:attribute name="{$colspan}">
              <xsl:text>2</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element namespace="{$outputNS}" name="{$rowName}">
          <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:attribute name="{$rendName}">
              <xsl:text>wovenodd-col1</xsl:text>
            </xsl:attribute>
            <xsl:element namespace="{$outputNS}" name="{$hiName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>label</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="{$langAttributeName}">
                <xsl:value-of select="$documentationLanguage"/>
              </xsl:attribute>
              <xsl:sequence select="tei:i18n('Example')"/>
            </xsl:element>
          </xsl:element>
          <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:attribute name="{$rendName}">
              <xsl:text>wovenodd-col2</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
          </xsl:element>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element macroSpec</desc>
  </doc>
  <xsl:template match="tei:macroSpec">
    <xsl:if test="parent::tei:specGrp">
      <xsl:element namespace="{$outputNS}" name="{$dtName}">
        <xsl:value-of select="@ident"/>
      </xsl:element>
      <xsl:element namespace="{$outputNS}" name="{$ddName}">
        <xsl:apply-templates mode="tangle" select="."/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element dataSpec</desc>
  </doc>
  <xsl:template match="tei:dataSpec">
    <xsl:if test="parent::tei:specGrp">
      <xsl:element namespace="{$outputNS}" name="{$dtName}">
        <xsl:value-of select="@ident"/>
      </xsl:element>
      <xsl:element namespace="{$outputNS}" name="{$ddName}">
        <xsl:apply-templates mode="tangle" select="."/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element macroSpec in weavebody mode</desc>
  </doc>
  <xsl:template match="tei:macroSpec" mode="weavebody">
    <xsl:variable name="name" select="tei:createSpecName(.)"/>
    <xsl:element namespace="{$outputNS}" name="{$sectionName}">
      <xsl:call-template name="makeSectionHead">
        <xsl:with-param name="id">
          <xsl:value-of select="concat(tei:createSpecPrefix(.), $name)"/>
        </xsl:with-param>
        <xsl:with-param name="name">
          <xsl:value-of select="$name"/>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="specHook">
        <xsl:with-param name="name">
          <xsl:value-of select="$name"/>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:element namespace="{$outputNS}" name="{$tableName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>wovenodd</xsl:text>
        </xsl:attribute>
        <xsl:element namespace="{$outputNS}" name="{$rowName}">
          <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:attribute name="{$colspan}">2</xsl:attribute>
            <xsl:element namespace="{$outputNS}" name="{$hiName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>label</xsl:text>
              </xsl:attribute>
              <xsl:value-of select="$name"/>
            </xsl:element>
            <xsl:text>&#160;</xsl:text>
            <xsl:sequence select="tei:makeDescription(., true(), true())"/>
          </xsl:element>
        </xsl:element>
        <xsl:call-template name="validUntil"/>
        <xsl:call-template name="moduleInfo"/>
        <xsl:element namespace="{$outputNS}" name="{$rowName}">
          <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:attribute name="{$rendName}">
              <xsl:text>wovenodd-col1</xsl:text>
            </xsl:attribute>
            <xsl:element namespace="{$outputNS}" name="{$hiName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>label</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="{$langAttributeName}">
                <xsl:value-of select="$documentationLanguage"/>
              </xsl:attribute>
              <xsl:sequence select="tei:i18n('Used by')"/>
            </xsl:element>
          </xsl:element>
          <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:attribute name="{$rendName}">
              <xsl:text>wovenodd-col2</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="generateModelParents">
              <xsl:with-param name="showElements">true</xsl:with-param>
            </xsl:call-template>
          </xsl:element>
        </xsl:element>
        <xsl:apply-templates mode="weave"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element dataSpec in weavebody mode</desc>
  </doc>
  <xsl:template match="tei:dataSpec" mode="weavebody">
    <xsl:variable name="name" select="tei:createSpecName(.)"/>
    <xsl:element namespace="{$outputNS}" name="{$sectionName}">
      <xsl:call-template name="makeSectionHead">
        <xsl:with-param name="id">
          <xsl:value-of select="concat(tei:createSpecPrefix(.), $name)"/>
        </xsl:with-param>
        <xsl:with-param name="name">
          <xsl:value-of select="$name"/>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="specHook">
        <xsl:with-param name="name">
          <xsl:value-of select="$name"/>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:element namespace="{$outputNS}" name="{$tableName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>wovenodd</xsl:text>
        </xsl:attribute>
        <xsl:element namespace="{$outputNS}" name="{$rowName}">
          <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:attribute name="{$colspan}">2</xsl:attribute>
            <xsl:element namespace="{$outputNS}" name="{$hiName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>label</xsl:text>
              </xsl:attribute>
              <xsl:value-of select="$name"/>
            </xsl:element>
            <xsl:text>&#160;</xsl:text>
            <xsl:sequence select="tei:makeDescription(., true(), true())"/>
          </xsl:element>
        </xsl:element>
        <xsl:call-template name="validUntil"/>
        <xsl:call-template name="moduleInfo"/>
        <xsl:element namespace="{$outputNS}" name="{$rowName}">
          <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:attribute name="{$rendName}">
              <xsl:text>wovenodd-col1</xsl:text>
            </xsl:attribute>
            <xsl:element namespace="{$outputNS}" name="{$hiName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>label</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="{$langAttributeName}">
                <xsl:value-of select="$documentationLanguage"/>
              </xsl:attribute>
              <xsl:sequence select="tei:i18n('Used by')"/>
            </xsl:element>
          </xsl:element>
          <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:attribute name="{$rendName}">
              <xsl:text>wovenodd-col2</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="generateModelParents">
              <xsl:with-param name="showElements">true</xsl:with-param>
            </xsl:call-template>
          </xsl:element>
        </xsl:element>
        <xsl:apply-templates mode="weave"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element macroSpec/tei:content</desc>
  </doc>
  <xsl:template match="tei:macroSpec/tei:content" mode="weave">
    <!-- TODO: Macros aren't 100% "pure" yet. anyXML, e.g., still uses RNG -->
    <xsl:if test="tei:*">
      <xsl:element namespace="{$outputNS}" name="{$rowName}">
        <xsl:element namespace="{$outputNS}" name="{$cellName}">
          <xsl:attribute name="{$rendName}">
            <xsl:text>wovenodd-col1</xsl:text>
          </xsl:attribute>
          <xsl:element namespace="{$outputNS}" name="{$hiName}">
            <xsl:attribute name="{$rendName}">
              <xsl:text>label</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="{$langAttributeName}">
              <xsl:value-of select="$documentationLanguage"/>
            </xsl:attribute>
            <xsl:sequence select="tei:i18n('ContentModel')"/>
          </xsl:element>
        </xsl:element>
        <xsl:element namespace="{$outputNS}" name="{$cellName}">
          <xsl:attribute name="{$rendName}">
            <xsl:text>wovenodd-col2</xsl:text>
          </xsl:attribute>
          <xsl:call-template name="pureODDOut">
            <xsl:with-param name="grammar">true</xsl:with-param>
            <xsl:with-param name="content">
              <PureODD>
                <xsl:apply-templates select="." mode="PureODD"/>
              </PureODD>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:element>
      </xsl:element>
    </xsl:if>
    <xsl:element namespace="{$outputNS}" name="{$rowName}">
      <xsl:element namespace="{$outputNS}" name="{$cellName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>wovenodd-col1</xsl:text>
        </xsl:attribute>
        <xsl:element namespace="{$outputNS}" name="{$hiName}">
          <xsl:attribute name="{$rendName}">
            <xsl:text>label</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="{$langAttributeName}">
            <xsl:value-of select="$documentationLanguage"/>
          </xsl:attribute>
          <xsl:sequence select="tei:i18n('Declaration')"/>
        </xsl:element>
      </xsl:element>
      <xsl:element namespace="{$outputNS}" name="{$cellName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>wovenodd-col2</xsl:text>
        </xsl:attribute>
        <xsl:apply-templates select="parent::*" mode="tangle"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
    
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element dataSpec/tei:content</desc>
  </doc>
  <xsl:template match="tei:dataSpec/tei:content" mode="weave">
    <xsl:element namespace="{$outputNS}" name="{$rowName}">
      <xsl:element namespace="{$outputNS}" name="{$cellName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>wovenodd-col1</xsl:text>
        </xsl:attribute>
        <xsl:element namespace="{$outputNS}" name="{$hiName}">
          <xsl:attribute name="{$rendName}">
            <xsl:text>label</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="{$langAttributeName}">
            <xsl:value-of select="$documentationLanguage"/>
          </xsl:attribute>
          <xsl:sequence select="tei:i18n('ContentModel')"/>
        </xsl:element>
      </xsl:element>
      <xsl:element namespace="{$outputNS}" name="{$cellName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>wovenodd-col2</xsl:text>
        </xsl:attribute>
        <xsl:call-template name="pureODDOut">
          <xsl:with-param name="grammar">true</xsl:with-param>
          <xsl:with-param name="content">
            <PureODD>
              <xsl:apply-templates select="." mode="PureODD"/>
            </PureODD>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:element>
    </xsl:element>
    <xsl:element namespace="{$outputNS}" name="{$rowName}">
      <xsl:element namespace="{$outputNS}" name="{$cellName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>wovenodd-col1</xsl:text>
        </xsl:attribute>
        <xsl:element namespace="{$outputNS}" name="{$hiName}">
          <xsl:attribute name="{$rendName}">
            <xsl:text>label</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="{$langAttributeName}">
            <xsl:value-of select="$documentationLanguage"/>
          </xsl:attribute>
          <xsl:sequence select="tei:i18n('Declaration')"/>
        </xsl:element>
      </xsl:element>
      <xsl:element namespace="{$outputNS}" name="{$cellName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>wovenodd-col2</xsl:text>
        </xsl:attribute>
        <xsl:apply-templates select="parent::*" mode="tangle"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element moduleSpec</desc>
  </doc>
  <xsl:template match="tei:moduleSpec">
    <xsl:element namespace="{$outputNS}" name="{$dlName}">
      <xsl:attribute name="{$rendName}">
        <xsl:text>moduleSpec</xsl:text>
      </xsl:attribute>
      <xsl:element namespace="{$outputNS}" name="{$labelName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>moduleSpecHead</xsl:text>
        </xsl:attribute>
        <xsl:element namespace="{$outputNS}" name="{$segName}">
          <xsl:attribute name="{$langAttributeName}">
            <xsl:value-of select="$documentationLanguage"/>
          </xsl:attribute>
          <xsl:sequence select="tei:i18n('Module')"/>
        </xsl:element>
        <xsl:value-of select="$spaceCharacter"/>
        <xsl:value-of select="@ident"/>
        <xsl:text>: </xsl:text>
        <xsl:sequence select="tei:makeDescription(., true(), true())"/>
      </xsl:element>
      <xsl:element namespace="{$outputNS}" name="{$ddName}">
        <xsl:element namespace="{$outputNS}" name="{$ulName}">
          <xsl:if test="key('ElementModule', @ident)">
            <xsl:element namespace="{$outputNS}" name="{$itemName}">
              <xsl:element namespace="{$outputNS}" name="{$hiName}">
                <xsl:attribute name="{$langAttributeName}">
                  <xsl:value-of select="$documentationLanguage"/>
                </xsl:attribute>
                <xsl:sequence select="tei:i18n('Elements defined')"/>
              </xsl:element>
              <xsl:text>: </xsl:text>
              <xsl:variable name="list">
                <List>
                  <xsl:for-each select="key('ElementModule', @ident)">
                    <xsl:sort select="@ident"/>
                    <Item>
                      <xsl:call-template name="linkTogether">
                        <xsl:with-param name="name"
                          select="concat(@prefix, @ident)"/>
                        <xsl:with-param name="reftext">
                          <xsl:value-of select="tei:createSpecName(.)"/>
                        </xsl:with-param>
                      </xsl:call-template>
                    </Item>
                  </xsl:for-each>
                </List>
              </xsl:variable>
              <xsl:for-each select="$list/List/Item">
                <xsl:if test="position() > 1">
                  <xsl:call-template name="showSpaceBetweenItems"/>
                </xsl:if>
                <xsl:copy-of select="* | text()"/>
              </xsl:for-each>
            </xsl:element>
          </xsl:if>
          <xsl:if test="key('ClassModule', @ident)">
            <xsl:element namespace="{$outputNS}" name="{$itemName}">
              <xsl:element namespace="{$outputNS}" name="{$hiName}">
                <xsl:attribute name="{$langAttributeName}">
                  <xsl:value-of select="$documentationLanguage"/>
                </xsl:attribute>
                <xsl:sequence select="tei:i18n('Classes defined')"/>
              </xsl:element>
              <xsl:text>: </xsl:text>
              <xsl:variable name="list">
                <List>
                  <xsl:for-each select="key('ClassModule', @ident)">
                    <xsl:sort select="@ident"/>
                    <Item>
                      <xsl:call-template name="linkTogether">
                        <xsl:with-param name="name" select="@ident"/>
                        <xsl:with-param name="reftext">
                          <xsl:value-of select="tei:createSpecName(.)"/>
                        </xsl:with-param>
                      </xsl:call-template>
                    </Item>
                  </xsl:for-each>
                </List>
              </xsl:variable>
              <xsl:for-each select="$list/List/Item">
                <xsl:if test="position() > 1">
                  <xsl:call-template name="showSpaceBetweenItems"/>
                </xsl:if>
                <xsl:copy-of select="* | text()"/>
              </xsl:for-each>
            </xsl:element>
          </xsl:if>
          <xsl:if test="key('MacroModule', @ident)">
            <xsl:element namespace="{$outputNS}" name="{$itemName}">
              <xsl:element namespace="{$outputNS}" name="{$segName}">
                <xsl:attribute name="{$langAttributeName}">
                  <xsl:value-of select="$documentationLanguage"/>
                </xsl:attribute>
                <xsl:sequence select="tei:i18n('Macros defined')"/>
              </xsl:element>
              <xsl:text>: </xsl:text>
              <xsl:variable name="list">
                <List>
                  <xsl:for-each select="key('MacroModule', @ident)">
                    <xsl:sort select="@ident"/>
                    <Item>
                      <xsl:call-template name="linkTogether">
                        <xsl:with-param name="name" select="@ident"/>
                        <xsl:with-param name="reftext">
                          <xsl:value-of select="tei:createSpecName(.)"/>
                        </xsl:with-param>
                      </xsl:call-template>
                    </Item>
                  </xsl:for-each>
                </List>
              </xsl:variable>
              <xsl:for-each select="$list/List/Item">
                <xsl:if test="position() > 1">
                  <xsl:call-template name="showSpaceBetweenItems"/>
                </xsl:if>
                <xsl:copy-of select="* | text()"/>
              </xsl:for-each>
            </xsl:element>
          </xsl:if>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process tei:remarks</desc>
  </doc>
  <xsl:template match="tei:remarks" mode="doc">
    <xsl:if test="string-length(.) > 0">
      <xsl:element namespace="{$outputNS}" name="{$rowName}">
        <xsl:element namespace="{$outputNS}" name="{$cellName}">
          <xsl:attribute name="{$rendName}">
            <xsl:text>wovenodd-col1</xsl:text>
          </xsl:attribute>
          <xsl:element namespace="{$outputNS}" name="{$hiName}">
            <xsl:attribute name="{$rendName}">
              <xsl:text>label</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="{$langAttributeName}">
              <xsl:value-of select="$documentationLanguage"/>
            </xsl:attribute>
            <xsl:sequence select="tei:i18n('Note')"/>
          </xsl:element>
        </xsl:element>
        <xsl:element namespace="{$outputNS}" name="{$cellName}">
          <xsl:attribute name="{$rendName}">
            <xsl:text>wovenodd-col2</xsl:text>
          </xsl:attribute>
          <xsl:comment>&#160;</xsl:comment>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process a specDesc</desc>
  </doc>
  <xsl:template match="tei:specDesc">
    <xsl:element namespace="{$outputNS}" name="{$itemName}">
      <xsl:variable name="name">
        <xsl:value-of select="@key"/>
      </xsl:variable>
      <xsl:variable name="atts">
        <xsl:choose>
          <xsl:when test="tei:match(@rend, 'noatts')">-</xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="normalize-space(@atts)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$name = ''">
          <xsl:message>ERROR: no key attribute on specDesc</xsl:message>
        </xsl:when>
        <xsl:when test="key('IDENTS', $name)">
          <xsl:apply-templates mode="show" select="key('IDENTS', $name)">
            <xsl:with-param name="atts" select="$atts"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="not($localsource = '')">
          <xsl:for-each select="document($localsource)/tei:TEI">
            <xsl:apply-templates mode="show" select="tei:*[@ident = $name]">
              <xsl:with-param name="atts" select="$atts"/>
            </xsl:apply-templates>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>UNKNOWN ELEMENT </xsl:text>
          <xsl:value-of select="$name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process a specGrp</desc>
  </doc>
  <xsl:template match="tei:specGrp"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process a specGrpRef</desc>
  </doc>
  <xsl:template match="tei:specGrpRef"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process a specList</desc>
  </doc>
  <xsl:template match="tei:specList">
    <xsl:element namespace="{$outputNS}" name="{$ulName}">
      <xsl:attribute name="{$rendName}">specList</xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process a valDesc</desc>
  </doc>
  <xsl:template match="tei:valDesc" mode="weave">
    <xsl:variable name="documentationLanguage">
      <xsl:sequence select="tei:generateDocumentationLang(.)"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@xml:lang and not(@xml:lang = $documentationLanguage)"> </xsl:when>
      <xsl:when
        test="not(@xml:lang) and not($documentationLanguage = 'en') and ../tei:valDesc[@xml:lang = $documentationLanguage]"> </xsl:when>
      <xsl:otherwise>
        <xsl:element namespace="{$outputNS}" name="{$rowName}">
          <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:attribute name="{$rendName}">
              <xsl:text>odd_label</xsl:text>
            </xsl:attribute>
            <xsl:element namespace="{$outputNS}" name="{$hiName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>label</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="{$langAttributeName}">
                <xsl:value-of select="$documentationLanguage"/>
              </xsl:attribute>
              <xsl:sequence select="tei:i18n('Values')"/>
            </xsl:element>
            <xsl:text> </xsl:text>
          </xsl:element>
          <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:attribute name="{$rendName}">
              <xsl:text>attribute</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
          </xsl:element>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element val</desc>
  </doc>
  <xsl:template match="tei:val">
    <xsl:element namespace="{$outputNS}" name="{$hiName}">
      <xsl:attribute name="{$rendName}">
        <xsl:text>val</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element att</desc>
  </doc>
  <xsl:template match="tei:att">
    <xsl:element namespace="{$outputNS}" name="{$hiName}">
      <xsl:attribute name="{$rendName}">
        <xsl:text>att</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element tag</desc>
  </doc>
  <xsl:template match="tei:tag">
    <xsl:element namespace="{$outputNS}" name="{$hiName}">
      <xsl:attribute name="{$rendName}">
        <xsl:text>tag</xsl:text>
      </xsl:attribute>
      <xsl:text>&lt;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&gt;</xsl:text>
    </xsl:element>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element valList</desc>
  </doc>
  <xsl:template match="tei:valList" mode="contents">
    <xsl:element namespace="{$outputNS}" name="{$rowName}">
      <xsl:element namespace="{$outputNS}" name="{$cellName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>odd_label</xsl:text>
        </xsl:attribute>
        <xsl:element namespace="{$outputNS}" name="{$hiName}">
          <xsl:attribute name="{$rendName}">
            <xsl:text>label</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="{$langAttributeName}">
            <xsl:value-of select="$documentationLanguage"/>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="@type = 'semi'">
              <xsl:sequence select="tei:i18n('Suggested values include')"/>
              <xsl:text>:</xsl:text>
            </xsl:when>
            <xsl:when test="@type = 'open'">
              <xsl:sequence select="tei:i18n('Sample values include')"/>
              <xsl:text>:</xsl:text>
            </xsl:when>
            <xsl:when test="@type = 'closed'">
              <xsl:sequence select="tei:i18n('Legal values are')"/>
              <xsl:text>:</xsl:text>
            </xsl:when>
            <xsl:otherwise>Sample values include</xsl:otherwise>
          </xsl:choose>
        </xsl:element>
      </xsl:element>
      <xsl:element namespace="{$outputNS}" name="{$cellName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>odd_value</xsl:text>
        </xsl:attribute>
        <xsl:call-template name="valListItems"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>[odds] all the values in a valList</desc>
  </doc>
  <xsl:template name="valListItems">
    <xsl:variable name="defaultVal_validUntil" select="../tei:defaultVal/@validUntil"/>
    <!-- above variable, and the use of it below, added 2016-07-22 by Syd and Martin -->
    <!-- to address issue #158. -->
    <xsl:element namespace="{$outputNS}" name="{$dlName}">
      <xsl:attribute name="{$rendName}">
        <xsl:text>valList</xsl:text>
      </xsl:attribute>
      <xsl:for-each select="tei:valItem">
        <xsl:variable name="name" select="( tei:altIdent, @ident )[1]"/>
        <xsl:element namespace="{$outputNS}" name="{$dtName}">
          <xsl:attribute name="{$rendName}">
            <xsl:text>odd_label</xsl:text>
          </xsl:attribute>
          <xsl:value-of select="$name"/>
          <xsl:call-template name="validUntil">
            <xsl:with-param name="inline" select="true()"/>
          </xsl:call-template>
        </xsl:element>
        <xsl:element namespace="{$outputNS}" name="{$ddName}">
          <xsl:attribute name="{$rendName}">
            <xsl:text>odd_value</xsl:text>
          </xsl:attribute>
          <xsl:if test="tei:paramList">
            <xsl:text>(</xsl:text>
            <xsl:value-of select="tei:paramList/tei:paramSpec/@ident"
              separator=", "/>
            <xsl:text>) </xsl:text>
          </xsl:if>
          <xsl:sequence select="tei:makeDescription(., true(), true())"/>
          <xsl:if test="@ident = ../../tei:defaultVal">
            <xsl:element namespace="{$outputNS}" name="{$hiName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>defaultVal</xsl:text>
                <xsl:if test="$defaultVal_validUntil">
                  <xsl:text> deprecated</xsl:text>
                </xsl:if>
              </xsl:attribute>
              <xsl:attribute name="{$langAttributeName}">
                <xsl:value-of select="$documentationLanguage"/>
              </xsl:attribute>
              <xsl:value-of select="concat(' [',tei:i18n('Default'),'] ' )"/>
              <xsl:if test="$defaultVal_validUntil">
                <xsl:variable name="duck">
                  <tei:seg>
                    <xsl:sequence select="tei:i18n('deprecated')"/>
                  </tei:seg>
                </xsl:variable>
                <xsl:for-each select="$duck">
                  <xsl:call-template name="makeExternalLink">
                    <xsl:with-param name="ptr" select="false()"/>
                    <xsl:with-param name="dest">
                      <xsl:text>http://www.tei-c.org/Activities/Council/Working/tcw27.xml</xsl:text>
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:for-each>
                <xsl:value-of select="concat('. ',tei:i18n('defaultValValidUntil'), ' ', $defaultVal_validUntil,'.' )"/>
              </xsl:if>
            </xsl:element>
          </xsl:if>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>[odds] </desc>
  </doc>
  <xsl:template name="moduleInfo">
    <xsl:if test="@ns">
      <xsl:element namespace="{$outputNS}" name="{$rowName}">
        <xsl:element namespace="{$outputNS}" name="{$cellName}">
          <xsl:attribute name="{$rendName}">
            <xsl:text>wovenodd-col1</xsl:text>
          </xsl:attribute>
          <xsl:element namespace="{$outputNS}" name="{$hiName}">
            <xsl:attribute name="{$rendName}">
              <xsl:text>label</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="{$langAttributeName}">
              <xsl:value-of select="$documentationLanguage"/>
            </xsl:attribute>
            <xsl:sequence select="tei:i18n('Namespace')"/>
          </xsl:element>
        </xsl:element>
        <xsl:element namespace="{$outputNS}" name="{$cellName}">
          <xsl:attribute name="{$rendName}">
            <xsl:text>wovenodd-col2</xsl:text>
          </xsl:attribute>
          <xsl:value-of select="@ns"/>
        </xsl:element>
      </xsl:element>
    </xsl:if>
    <xsl:if test="@module and not($oddWeaveLite = 'true')">
      <xsl:element namespace="{$outputNS}" name="{$rowName}">
        <xsl:element namespace="{$outputNS}" name="{$cellName}">
          <xsl:attribute name="{$rendName}">
            <xsl:text>wovenodd-col1</xsl:text>
          </xsl:attribute>
          <xsl:element namespace="{$outputNS}" name="{$hiName}">
            <xsl:attribute name="{$rendName}">
              <xsl:text>label</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="{$langAttributeName}">
              <xsl:value-of select="$documentationLanguage"/>
            </xsl:attribute>
            <xsl:sequence select="tei:i18n('Module')"/>
          </xsl:element>
        </xsl:element>
        <xsl:element namespace="{$outputNS}" name="{$cellName}">
          <xsl:attribute name="{$rendName}">
            <xsl:text>wovenodd-col2</xsl:text>
          </xsl:attribute>
          <xsl:call-template name="makeTagsetInfo"/>
        </xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>[odds] display attribute list </desc>
  </doc>
  <xsl:template name="displayAttList">
    <xsl:param name="mode"/>
    <xsl:call-template name="showAttClasses"/>
    <xsl:for-each-group select="tei:attRef[not(tei:match(@rend, 'none'))]"
      group-by="@class">
      <xsl:call-template name="linkTogether">
        <xsl:with-param name="name" select="current-grouping-key()"/>
        <xsl:with-param name="reftext">
          <xsl:value-of select="current-grouping-key()"/>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:text> (</xsl:text>
      <xsl:for-each
        select="$Original//tei:classSpec[@ident = current-grouping-key()]/tei:attList/tei:attDef">
        <xsl:variable name="me" select="@ident"/>
        <xsl:if test="not(current-group()[@name = $me])">
          <xsl:element namespace="{$outputNS}" name="{$segName}">
            <xsl:attribute name="{$rendName}">unusedattribute</xsl:attribute>
            <xsl:value-of select="$me"/>
          </xsl:element>
          <xsl:text>, </xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:for-each select="current-group()">
        <xsl:text>@</xsl:text>
        <xsl:value-of select="@name"/>
        <xsl:if test="position() != last()">, </xsl:if>
      </xsl:for-each>
      <xsl:text>) </xsl:text>
    </xsl:for-each-group>
    <xsl:if test=".//tei:attDef">
      <xsl:element namespace="{$outputNS}" name="{$tableName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>attList</xsl:text>
        </xsl:attribute>
        <xsl:choose>
          <xsl:when test="$mode = 'all'">
            <xsl:apply-templates/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="summary"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>[odds] display list of model parents </desc>
  </doc>
  <xsl:template name="generateModelParents">
    <xsl:param name="showElements">true</xsl:param>
    <xsl:variable name="here" select="."/>
    <xsl:element namespace="{$outputNS}" name="{$divName}">
      <xsl:attribute name="{$rendName}">parent</xsl:attribute>
      <xsl:variable name="Parents">
        <xsl:for-each
          select="key('REFS', concat(@prefix, @ident))/ancestor::tei:content/parent::*">
          <Element prefix="{@prefix}" type="{local-name()}"
            name="{tei:createSpecName(.)}" module="{@module}"/>
        </xsl:for-each>
        <xsl:for-each select="tei:classes/tei:memberOf">
          <xsl:for-each select="key('CLASSES', @key)">
            <xsl:if test="@type = 'model'">
              <Element prefix="{@prefix}" type="classSpec" module="{@module}"
                name="{tei:createSpecName(.)}"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:variable>
      <xsl:if test="count($Parents/*) > 0">
        <xsl:for-each-group select="$Parents/*" group-by="@name">
          <xsl:sort select="@name"/>
          <xsl:variable name="name" select="concat(@prefix, @name)"/>
          <xsl:variable name="display" select="@name"/>
          <xsl:variable name="type" select="@type"/>
          <xsl:if test="not(@type = 'elementSpec' and $showElements = 'false')">
            <xsl:for-each select="$here">
              <xsl:call-template name="linkTogether">
                <xsl:with-param name="name" select="$name"/>
                <xsl:with-param name="reftext" select="$display"/>
                <xsl:with-param name="class">link_odd_<xsl:value-of
                    select="$type"/></xsl:with-param>
              </xsl:call-template>
            </xsl:for-each>
            <xsl:if test="not(position() = last())">
              <xsl:call-template name="showSpaceBetweenItems"/>
            </xsl:if>
          </xsl:if>
        </xsl:for-each-group>
      </xsl:if>
      <xsl:call-template name="generateParentsByAttribute"/>
    </xsl:element>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>[odds] display list of generated parents (via models) </desc>
  </doc>
  <xsl:template name="generateIndirectParents">
    <xsl:element namespace="{$outputNS}" name="{$divName}">
      <xsl:attribute name="{$rendName}">parent</xsl:attribute>
      <xsl:variable name="Parents">
        <xsl:call-template name="ProcessDirectRefs"/>
        <!-- now look at class membership -->
        <xsl:for-each select="tei:classes/tei:memberOf">
          <xsl:for-each select="key('CLASSES', @key)">
            <xsl:if test="@type = 'model'">
              <xsl:call-template name="ProcessClass"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:variable>
      <xsl:call-template name="displayElementsByModule">
        <xsl:with-param name="context">parents</xsl:with-param>
        <xsl:with-param name="List">
          <xsl:copy-of select="$Parents"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:element>
  </xsl:template>
  <xsl:template name="ProcessDirectRefs">
    <!-- direct parents -->
    <xsl:for-each
      select="key('REFS', concat(@prefix, @ident))/ancestor::tei:content/parent::tei:*">
      <xsl:choose>
        <xsl:when test="self::tei:elementSpec">
          <Element prefix="{@prefix}" type="{local-name()}" module="{@module}"
            name="{tei:createSpecName(.)}"/>
        </xsl:when>
        <xsl:when test="self::tei:macroSpec">
          <xsl:call-template name="ProcessDirectRefs"/>
        </xsl:when>
        <xsl:when test="self::tei:dataSpec">
          <xsl:call-template name="ProcessDirectRefs"/>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="ProcessClass">
    <xsl:for-each
      select="key('REFS', concat(@prefix, @ident))/ancestor::tei:content/parent::tei:*">
      <xsl:choose>
        <xsl:when test="self::tei:elementSpec">
          <Element prefix="{@prefix}" type="{local-name()}" module="{@module}"
            name="{tei:createSpecName(.)}"/>
        </xsl:when>
        <xsl:when test="self::tei:macroSpec | self::tei:dataSpec">
          <xsl:call-template name="ProcessDirectRefs"/>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:for-each select="tei:classes/tei:memberOf">
      <xsl:for-each select="key('CLASSES', @key)">
        <xsl:if test="@type = 'model'">
          <xsl:call-template name="ProcessClass"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="generateMembers">
    <xsl:param name="depth">1</xsl:param>
    <xsl:param name="me"/>
    <xsl:variable name="this" select="@ident"/>
    <xsl:if test="not($this = $me) and key('CLASSMEMBERS', $this)">
      <xsl:element namespace="{$outputNS}" name="{$hiName}">
        <xsl:attribute name="{$rendName}">
          <xsl:text>showmembers</xsl:text>
          <xsl:value-of select="$depth"/>
        </xsl:attribute>
        <xsl:if test="$depth > 1"> [</xsl:if>
        <xsl:variable name="list">
          <ClassList>
            <xsl:for-each select="key('CLASSMEMBERS', $this)">
              <Item type="{local-name()}" ident="{@ident}">
                <xsl:call-template name="linkTogether">
                  <xsl:with-param name="name" select="concat(@prefix, @ident)"/>
                  <xsl:with-param name="reftext">
                    <xsl:value-of select="tei:createSpecName(.)"/>
                  </xsl:with-param>
                  <xsl:with-param name="class">
                    <xsl:text>link_odd_</xsl:text>
                    <xsl:value-of select="local-name()"/>
                  </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="generateMembers">
                  <xsl:with-param name="depth">
                    <xsl:value-of select="$depth + 1"/>
                  </xsl:with-param>
                </xsl:call-template>
              </Item>
            </xsl:for-each>
          </ClassList>
        </xsl:variable>
        <xsl:for-each select="$list/ClassList/Item">
          <xsl:sort select="@type"/>
          <xsl:sort select="@ident"/>
          <xsl:if test="position() > 1">
            <xsl:call-template name="showSpaceBetweenItems"/>
          </xsl:if>
          <xsl:copy-of select="* | text()"/>
        </xsl:for-each>
        <xsl:if test="$depth > 1">] </xsl:if>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <xsl:template name="generateParentsByAttribute">
    <xsl:variable name="this" select="@ident"/>
    <xsl:variable name="list">
      <PattList>
        <xsl:for-each select="key('REFSTO-CLASS', $this)">
          <xsl:sort select="ancestor::tei:classSpec/@ident"/>
          <xsl:sort select="@ident"/>
          <xsl:element namespace="{$outputNS}" name="{$itemName}">
            <xsl:for-each select="ancestor::tei:classSpec">
              <Item>
                <xsl:call-template name="linkTogether">
                  <xsl:with-param name="name">
                    <xsl:value-of select="@ident"/>
                  </xsl:with-param>
                  <xsl:with-param name="class">
                    <xsl:text>link_odd_classSpec</xsl:text>
                  </xsl:with-param>
                </xsl:call-template>
              </Item>
            </xsl:for-each>
            <xsl:text>/@</xsl:text>
            <xsl:value-of select="ancestor::tei:attDef/@ident"/>
          </xsl:element>
        </xsl:for-each>
      </PattList>
    </xsl:variable>
    <xsl:if test="count($list/PattList/Item) > 0">
      <xsl:element namespace="{$outputNS}" name="{$segName}">
        <xsl:attribute name="{$langAttributeName}">
          <xsl:value-of select="$documentationLanguage"/>
        </xsl:attribute>
        <xsl:sequence select="tei:i18n('Class')"/>
      </xsl:element>
      <xsl:text>: </xsl:text>
      <xsl:element namespace="{$outputNS}" name="{$ulName}">
        <xsl:for-each select="$list/PattList/Item">
          <xsl:copy-of select="* | text()"/>
        </xsl:for-each>
      </xsl:element>
    </xsl:if>
    <xsl:variable name="list2">
      <PattList>
        <xsl:for-each select="key('REFSTO-ELEMENT', $this)">
          <xsl:sort select="ancestor::tei:elementSpec/@ident"/>
          <xsl:sort select="@ident"/>
          <Item>
            <xsl:element namespace="{$outputNS}" name="{$itemName}">
              <xsl:for-each select="ancestor::tei:elementSpec">
                <xsl:call-template name="linkTogether">
                  <xsl:with-param name="name">
                    <xsl:value-of select="concat(@prefix, @ident)"/>
                  </xsl:with-param>
                  <xsl:with-param name="reftext">
                    <xsl:value-of select="tei:createSpecName(.)"/>
                  </xsl:with-param>
                  <xsl:with-param name="class">
                    <xsl:text>link_odd_elementSpec</xsl:text>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
              <xsl:text>/@</xsl:text>
              <xsl:for-each select="ancestor::tei:attDef">
                <xsl:value-of select="(tei:altIdent | @ident)[last()]"/>
              </xsl:for-each>
            </xsl:element>
          </Item>
        </xsl:for-each>
      </PattList>
    </xsl:variable>
    <xsl:if test="count($list2/PattList/Item) > 0">
      <xsl:element namespace="{$outputNS}" name="{$segName}">
        <xsl:attribute name="{$langAttributeName}">
          <xsl:value-of select="$documentationLanguage"/>
        </xsl:attribute>
        <xsl:sequence select="tei:i18n('Element')"/>
        <xsl:text>: </xsl:text>
      </xsl:element>
      <xsl:element namespace="{$outputNS}" name="{$ulName}">
        <xsl:for-each select="$list2/PattList/Item">
          <xsl:copy-of select="* | text()"/>
        </xsl:for-each>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <xsl:template
    match="tei:classSpec | tei:elementSpec | tei:macroSpec | tei:dataSpec"
    mode="weave">
    <xsl:call-template name="refdoc"/>
  </xsl:template>
  <xsl:template match="tei:divGen[@type = 'modelclasscat']">
    <xsl:apply-templates mode="weave" select="key('MODELCLASSDOCS', 1)">
      <xsl:sort select="lower-case(@ident)"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="tei:divGen[@type = 'attclasscat']">
    <xsl:apply-templates mode="weave" select="key('ATTCLASSDOCS', 1)">
      <xsl:sort select="lower-case(@ident)"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="tei:divGen[@type = 'macrocat']">
    <xsl:apply-templates mode="weave" select="key('MACRODOCS', 1)">
      <xsl:sort select="lower-case(@ident)"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="tei:divGen[@type = 'elementcat']">
    <xsl:apply-templates mode="weave" select="key('ELEMENTDOCS', 1)">
      <xsl:sort select="lower-case(@ident)"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="tei:divGen[@type = 'attcat']">
    <xsl:element namespace="{$outputNS}" name="{$tableName}">
      <xsl:attribute name="{$rendName}">
        <xsl:text>attcat</xsl:text>
      </xsl:attribute>
      <xsl:for-each select="key('ATTDOCS', 1)">
        <xsl:sort select="lower-case(@ident)"/>
        <xsl:variable name="this" select="@ident"/>
        <xsl:if test="generate-id() = generate-id(key('ATTRIBUTES', $this)[1])">
          <xsl:element namespace="{$outputNS}" name="{$rowName}">
            <xsl:call-template name="identifyElement">
              <xsl:with-param name="id">
                <xsl:value-of select="translate($this, ':', '_')"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:element namespace="{$outputNS}" name="{$cellName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>attcat-col1</xsl:text>
              </xsl:attribute>
              <xsl:value-of select="$this"/>
            </xsl:element>
            <xsl:element namespace="{$outputNS}" name="{$cellName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>attcat-col2</xsl:text>
              </xsl:attribute>
              <xsl:for-each select="key('ATTRIBUTES-CLASS', $this)">
                <xsl:sort select="ancestor::tei:classSpec/@ident"/>
                <xsl:for-each
                  select="ancestor::tei:classSpec | ancestor::elementSpec">
                  <xsl:call-template name="linkTogether">
                    <xsl:with-param name="name">
                      <xsl:value-of select="concat(@prefix, @ident)"/>
                    </xsl:with-param>
                    <xsl:with-param name="reftext">
                      <xsl:value-of select="tei:createSpecName(.)"/>
                    </xsl:with-param>
                    <xsl:with-param name="class">
                      <xsl:text>link_odd</xsl:text>
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:for-each>
                <xsl:text> </xsl:text>
              </xsl:for-each>
              <xsl:for-each select="key('ATTRIBUTES-ELEMENT', $this)">
                <xsl:sort select="ancestor::tei:elementSpec/@ident"/>
                <xsl:for-each select="ancestor::tei:elementSpec">
                  <xsl:call-template name="linkTogether">
                    <xsl:with-param name="name">
                      <xsl:value-of select="concat(@prefix, @ident)"/>
                    </xsl:with-param>
                    <xsl:with-param name="reftext">
                      <xsl:value-of select="tei:createSpecName(.)"/>
                    </xsl:with-param>
                    <xsl:with-param name="class">
                      <xsl:text>link_odd</xsl:text>
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:for-each>
                <xsl:value-of select="$spaceCharacter"/>
                <xsl:text> </xsl:text>
              </xsl:for-each>
            </xsl:element>
          </xsl:element>
        </xsl:if>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  
  <!-- MDH & SB working on ticket #1657 2018-09-10. -->
  <xsl:template match="tei:divGen[@type = 'deprecationcat']">
    <xsl:element namespace="{$outputNS}" name="{$tableName}">
      <xsl:attribute name="{$rendName}">
        <xsl:text>deprecationcat</xsl:text>
      </xsl:attribute>
      <xsl:element namespace="{$outputNS}" name="{$rowName}">
        <xsl:element namespace="{$outputNS}" name="{$cellName}">
          <xsl:element namespace="{$outputNS}" name="{$hiName}">
            <xsl:attribute name="{$rendName}">
              <xsl:text>label</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="{$langAttributeName}">
              <xsl:value-of select="$documentationLanguage"/>
            </xsl:attribute>
            <xsl:sequence select="tei:i18n('Identifier')"/>
          </xsl:element>
        </xsl:element>
        <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:element namespace="{$outputNS}" name="{$hiName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>label</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="{$langAttributeName}">
                <xsl:value-of select="$documentationLanguage"/>
              </xsl:attribute>
              <xsl:sequence select="tei:i18n('ComponentType')"/>
            </xsl:element>
        </xsl:element>
        <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:element namespace="{$outputNS}" name="{$hiName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>label</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="{$langAttributeName}">
                <xsl:value-of select="$documentationLanguage"/>
              </xsl:attribute>
              <xsl:sequence select="tei:i18n('validuntil')"/>
            </xsl:element>
        </xsl:element>
        <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:element namespace="{$outputNS}" name="{$hiName}">
              <xsl:attribute name="{$rendName}">
                <xsl:text>label</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="{$langAttributeName}">
                <xsl:value-of select="$documentationLanguage"/>
              </xsl:attribute>
              <xsl:sequence select="tei:i18n('Description')"/>
            </xsl:element>
        </xsl:element>
      </xsl:element>
      <xsl:for-each select="//tei:*[@validUntil]">
        <xsl:sort select="@validUntil"/>
        <xsl:element namespace="{$outputNS}" name="{$rowName}">
          <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:choose>
              <xsl:when test="self::tei:attDef or self::tei:constraintSpec">
                <xsl:variable name="targetIdent" select="ancestor::*[ends-with(local-name(), 'Spec')][1]/@ident"/>
                  <xsl:call-template name="linkTogether">
                    <xsl:with-param name="name">
                      <xsl:value-of select="$targetIdent"/>
                    </xsl:with-param>
                    <xsl:with-param name="reftext">
                      <xsl:value-of select="concat($targetIdent, ' / ', if (self::attDef) then '@' else '', @ident)"/>
                    </xsl:with-param>
                    <xsl:with-param name="class">
                      <xsl:text>link_odd</xsl:text>
                    </xsl:with-param>
                  </xsl:call-template>
              </xsl:when>
              <xsl:when test="self::tei:valItem or self::tei:valDesc">
                <xsl:variable name="targetIdent" select="ancestor::*[ends-with(local-name(), 'Spec')][1]/@ident"/>
                  <xsl:call-template name="linkTogether">
                    <xsl:with-param name="name">
                      <xsl:value-of select="$targetIdent"/>
                    </xsl:with-param>
                    <xsl:with-param name="reftext">
                      <xsl:value-of select="concat($targetIdent, ' / ', ancestor::tei:attDef[1]/@ident, ' / ', @ident)"/>
                    </xsl:with-param>
                    <xsl:with-param name="class">
                      <xsl:text>link_odd</xsl:text>
                    </xsl:with-param>
                  </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="linkTogether">
                    <xsl:with-param name="name">
                      <xsl:value-of select="@ident"/>
                    </xsl:with-param>
                    <xsl:with-param name="reftext">
                      <xsl:value-of select="@ident"/>
                    </xsl:with-param>
                    <xsl:with-param name="class">
                      <xsl:text>link_odd</xsl:text>
                    </xsl:with-param>
                  </xsl:call-template></xsl:otherwise>
            </xsl:choose>
          </xsl:element>
          <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:value-of select="local-name(.)"/>
          </xsl:element>
          <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:value-of select="@validUntil"/>
            <xsl:if test="xs:date(@validUntil) lt current-date()">!!!</xsl:if>
          </xsl:element>
          <xsl:element namespace="{$outputNS}" name="{$cellName}">
            <xsl:apply-templates select="descendant::tei:desc[@type='deprecationInfo'][1]"/>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="tei:exemplum" mode="weave">
    <xsl:if test="teix:egXML/* or teix:egXML/text() or text()">
      <xsl:apply-templates select="." mode="doc"/>
    </xsl:if>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>No-op processing of elements tei:gloss and tei:desc in normal modes,
      as they will always be called explicitly if needed.</desc>
  </doc>
  <xsl:template match="tei:desc | tei:gloss" mode="weave"/>
  <xsl:template match="tei:remarks" mode="weave">
    <xsl:variable name="langs">
      <xsl:value-of
        select="concat(normalize-space(tei:generateDocumentationLang(.)), ' ')"
      />
    </xsl:variable>
    <xsl:variable name="firstLang">
      <xsl:value-of select="substring-before($langs, ' ')"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@xml:lang = $firstLang">
        <xsl:apply-templates select="." mode="doc"/>
      </xsl:when>
      <xsl:when
        test="not(@xml:lang) and tei:generateDocumentationLang(.) = 'en'">
        <xsl:apply-templates select="." mode="doc"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="currentLang" select="tei:findLanguage(.)"/>
        <xsl:if test="$currentLang = ($langs)">
          <xsl:apply-templates select="." mode="doc"/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element valList</desc>
  </doc>
  <xsl:template match="tei:valList" mode="weave">
    <xsl:apply-templates mode="contents" select="."/>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element attList</desc>
  </doc>
  <xsl:template match="tei:attList" mode="weave"/>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element defaultVal</desc>
  </doc>
  <xsl:template match="tei:defaultVal" mode="weave">
    <xsl:if test="not(../tei:valList)">
      <xsl:element namespace="{$outputNS}" name="{$rowName}">
        <xsl:element namespace="{$outputNS}" name="{$cellName}">
          <xsl:attribute name="{$rendName}">
            <xsl:text>odd_label</xsl:text>
          </xsl:attribute>
          <xsl:element namespace="{$outputNS}" name="{$hiName}">
            <xsl:attribute name="{$langAttributeName}">
              <xsl:value-of select="$documentationLanguage"/>
            </xsl:attribute>
            <xsl:attribute name="{$rendName}">
              <xsl:text>label</xsl:text>
            </xsl:attribute>
            <xsl:sequence select="tei:i18n('Default')"/>
          </xsl:element>
          <xsl:text> </xsl:text>
        </xsl:element>
        <xsl:element namespace="{$outputNS}" name="{$cellName}">
          <xsl:attribute name="{$rendName}">
            <xsl:text>odd_value</xsl:text>
          </xsl:attribute>
          <xsl:value-of select="."/>
          <xsl:if test="@validUntil">
	    <!-- This clause added 2016-07-22 by Syd and Martin so that -->
	    <!-- default values can be deprecated. See issue #158.      -->
            <xsl:element namespace="{$outputNS}" name="{$tableName}">
              <xsl:call-template name="validUntil"/>
            </xsl:element>
          </xsl:if>
        </xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element desc</desc>
  </doc>
  <xsl:template match="tei:desc">
    <xsl:apply-templates/>
  </xsl:template>
  <!-- pretty printing of RNC -->
  <xsl:template match="nc" mode="keep">
    <xsl:call-template name="showRNC">
      <xsl:with-param name="style">
        <xsl:text>rnc_nc</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:value-of select="."/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="declaration" mode="keep">
    <xsl:call-template name="showRNC">
      <xsl:with-param name="style">
        <xsl:text>rnc_decl</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:value-of select="."/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="prefix" mode="keep">
    <xsl:call-template name="showRNC">
      <xsl:with-param name="style">
        <xsl:text>rnc_prefix</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:value-of select="."/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="param" mode="keep">
    <xsl:call-template name="showRNC">
      <xsl:with-param name="style">
        <xsl:text>rnc_param</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:value-of select="."/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="op" mode="keep">
    <xsl:value-of select="translate(., ' ', '&#160;')"/>
  </xsl:template>
  <xsl:template match="atom" mode="keep">
    <xsl:call-template name="showRNC">
      <xsl:with-param name="style">
        <xsl:text>rnc_atom</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:value-of select="."/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="t" mode="keep">
    <xsl:choose>
      <xsl:when test=". = '[' or . = ']'">
        <xsl:call-template name="showRNC">
          <xsl:with-param name="style">
            <xsl:text>rnc_annot</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="contents">
            <xsl:value-of select="."/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="doc" mode="keep">
    <xsl:call-template name="showRNC">
      <xsl:with-param name="style">
        <xsl:text>rnc_comment</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:value-of select="."/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="annot" mode="keep">
    <xsl:call-template name="showRNC">
      <xsl:with-param name="style">
        <xsl:text>rnc_annot</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:value-of select="."/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="type" mode="keep">
    <xsl:call-template name="showRNC">
      <xsl:with-param name="style">
        <xsl:text>rnc_type</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:value-of select="."/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="keyword" mode="keep">
    <xsl:call-template name="showRNC">
      <xsl:with-param name="style">
        <xsl:text>rnc_keyword</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:value-of select="."/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="tei:attList[@org = 'choice']">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template name="showAttClasses">
    <xsl:param name="minimal">false</xsl:param>
    <xsl:variable name="clatts">
      <xsl:for-each
        select="ancestor-or-self::tei:elementSpec | ancestor-or-self::tei:classSpec">
        <xsl:call-template name="attClassDetails"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$minimal = 'true' and not($clatts = '')">
        <xsl:text> [+ </xsl:text>
        <xsl:copy-of select="$clatts"/>
        <xsl:text>]</xsl:text>
      </xsl:when>
      <xsl:when test="not($clatts = '')">
        <xsl:if test="ancestor::tei:schemaSpec and key('CLASSES', 'att.global')">
          <xsl:element namespace="{$outputNS}" name="{$segName}">
            <xsl:attribute name="{$langAttributeName}">
              <xsl:value-of select="$documentationLanguage"/>
            </xsl:attribute>
            <xsl:variable name="word">
              <xsl:choose>
                <xsl:when test="not($autoGlobal = 'true')">Attributes</xsl:when>
                <xsl:when test=".//tei:attDef">In addition to global attributes
                  and those inherited from</xsl:when>
                <xsl:otherwise>Global attributes and those inherited
                  from</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:sequence select="tei:i18n($word)"/>
            <xsl:value-of select="$spaceCharacter"/>
          </xsl:element>
        </xsl:if>
        <xsl:copy-of select="$clatts"/>
      </xsl:when>
      <xsl:when
        test="ancestor::tei:schemaSpec and not(key('CLASSES', 'att.global'))"> </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="word">
          <xsl:choose>
            <xsl:when test="not($autoGlobal = 'true')">Attributes</xsl:when>
            <xsl:when test=".//tei:attDef">In addition to global
              attributes</xsl:when>
            <xsl:otherwise>Global attributes only</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="tei:i18n($word)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="attClassDetails">
    <xsl:param name="depth">1</xsl:param>
    <xsl:for-each select="tei:classes/tei:memberOf">
      <xsl:choose>
        <xsl:when test="key('CLASSES', @key)">
          <xsl:for-each select="key('CLASSES', @key)">
            <xsl:if test="@type = 'atts'">
              <xsl:if test="$depth > 1"> (</xsl:if>
              <xsl:call-template name="linkTogether">
                <xsl:with-param name="name" select="@ident"/>
              </xsl:call-template>
              <xsl:if test=".//tei:attDef">
                <xsl:text> (</xsl:text>
                <xsl:for-each select=".//tei:attDef">
                  <xsl:call-template name="emphasize">
                    <xsl:with-param name="class">attribute</xsl:with-param>
                    <xsl:with-param name="content">
                      <xsl:text>@</xsl:text>
                      <xsl:value-of select="tei:createSpecName(.)"/>
                    </xsl:with-param>
                  </xsl:call-template>
                  <xsl:if test="following-sibling::tei:attDef">
                    <xsl:text>, </xsl:text>
                  </xsl:if>
                </xsl:for-each>
                <xsl:text>)</xsl:text>
                <xsl:if test="$depth = 1">
                  <xsl:call-template name="showSpace"/>
                </xsl:if>
              </xsl:if>
              <xsl:call-template name="attClassDetails">
                <xsl:with-param name="depth">
                  <xsl:value-of select="$depth + 1"/>
                </xsl:with-param>
              </xsl:call-template>
              <xsl:if test="$depth > 1">) </xsl:if>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="ancestor::tei:schemaSpec"> </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@key"/>
          <xsl:call-template name="showSpace"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="showElement">
    <xsl:param name="name"/>
    <xsl:variable name="linkname"
      select="concat(tei:createSpecPrefix(.), $name)"/>
    <xsl:choose>
      <xsl:when test="$oddmode = 'tei'">
        <xsl:choose>
          <xsl:when test="starts-with($name, 'teidata')">
            <tei:ref target="#{concat($idPrefix, $name)}">
              <xsl:value-of select="$name"/>
            </tei:ref>
          </xsl:when>
          <xsl:otherwise>
            <tei:ref target="{concat('https://www.w3.org/TR/xmlschema-2/#', $name)}">
              <xsl:value-of select="$name"/>
            </tei:ref>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$oddmode = 'html'">
        <xsl:choose>
          <xsl:when test="key('IDENTS', $name) and number($splitLevel) = -1">
            <a xmlns="http://www.w3.org/1999/xhtml" class="link_element"
              href="#{$name}">
              <xsl:value-of select="$name"/>
            </a>
          </xsl:when>
          <xsl:when test="key('IDENTS', $name) and $STDOUT = 'true'">
            <a xmlns="http://www.w3.org/1999/xhtml" class="link_element">
              <xsl:attribute name="href">
                <xsl:call-template name="getSpecURL">
                  <xsl:with-param name="name">
                    <xsl:value-of select="$name"/>
                  </xsl:with-param>
                  <xsl:with-param name="type">
                    <xsl:value-of
                      select="substring-before(local-name(), 'Spec')"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:value-of select="$name"/>
            </a>
          </xsl:when>
          <xsl:when test="key('IDENTS', $name)">
            <a xmlns="http://www.w3.org/1999/xhtml" class="link_element"
              href="ref-{$linkname}{$outputSuffix}">
              <xsl:value-of select="$name"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$name"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$oddmode = 'pdf'">
        <fo:inline font-style="italic">
          <xsl:value-of select="$name"/>
        </fo:inline>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$name"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="processatts">
    <xsl:param name="values"/>
    <xsl:variable name="here" select="."/>
    <xsl:for-each select="tokenize($values, ' ')">
      <xsl:variable name="v" select="."/>
      <xsl:for-each select="$here">
        <xsl:apply-templates select="key('IDENTS', .)"/>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Process element attList</desc>
  </doc>
  <xsl:template match="tei:attList" mode="show">
    <xsl:call-template name="displayAttList">
      <xsl:with-param name="mode">summary</xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="makeTagsetInfo">
    <xsl:value-of select="@module"/>
    <xsl:for-each select="key('MODULES', @module)/ancestor::tei:div[last()]">
      <xsl:if test="@xml:id">
        <xsl:text> — </xsl:text>
        <xsl:call-template name="makeInternalLink">
          <xsl:with-param name="dest" select="@xml:id"/>
          <xsl:with-param name="ptr" select="true()"/>
          <xsl:with-param name="body">
            <xsl:value-of select="tei:head"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="generateChildren">
    <xsl:variable name="name" select="concat(@prefix, @ident)"/>
    <xsl:choose>
      <xsl:when test="tei:content//rng:ref[@name = 'macro.anyXML']">
        <xsl:element namespace="{$outputNS}" name="{$segName}">
          <xsl:attribute name="{$langAttributeName}">
            <xsl:value-of select="$documentationLanguage"/>
          </xsl:attribute>
          <xsl:text>ANY</xsl:text>
        </xsl:element>
      </xsl:when>
      <xsl:when test="tei:content/tei:textNode and count(tei:content/*) = 1">
        <xsl:element namespace="{$outputNS}" name="{$segName}">
          <xsl:attribute name="{$langAttributeName}">
            <xsl:value-of select="$documentationLanguage"/>
          </xsl:attribute>
          <xsl:sequence select="tei:i18n('Character data only')"/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="tei:content/rng:text and count(tei:content/rng:*) = 1">
        <xsl:element namespace="{$outputNS}" name="{$segName}">
          <xsl:attribute name="{$langAttributeName}">
            <xsl:value-of select="$documentationLanguage"/>
          </xsl:attribute>
          <xsl:sequence select="tei:i18n('Character data only')"/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="tei:content/rng:empty">
        <xsl:element namespace="{$outputNS}" name="{$segName}">
          <xsl:attribute name="{$langAttributeName}">
            <xsl:value-of select="$documentationLanguage"/>
          </xsl:attribute>
          <xsl:sequence select="tei:i18n('Empty element')"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="Children">
          <xsl:for-each select="tei:content">
            <xsl:call-template name="followRef"/>
          </xsl:for-each>
        </xsl:variable>
        <xsl:call-template name="displayElementsByModule">
          <xsl:with-param name="context">children</xsl:with-param>
          <xsl:with-param name="List">
            <xsl:copy-of select="$Children"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="displayElementsByModule">
    <xsl:param name="List"/>
    <xsl:param name="context"/>
    <xsl:variable name="here" select="."/>
    <xsl:for-each select="$List">
      <xsl:choose>
        <xsl:when test="$context = 'parents' and count(Element) = 0">
          <xsl:text>—</xsl:text>
        </xsl:when>
        <xsl:when test="Element[@type = 'TEXT'] and count(Element) = 1">
          <xsl:element namespace="{$outputNS}" name="{$segName}">
            <xsl:attribute name="{$langAttributeName}">
              <xsl:value-of select="$documentationLanguage"/>
            </xsl:attribute>
            <xsl:sequence select="tei:i18n('Character data only')"/>
          </xsl:element>
        </xsl:when>
        <xsl:when test="count(Element) = 0">
          <xsl:element namespace="{$outputNS}" name="{$segName}">
            <xsl:attribute name="{$langAttributeName}">
              <xsl:value-of select="$documentationLanguage"/>
            </xsl:attribute>
            <xsl:sequence select="tei:i18n('Empty element')"/>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:element namespace="{$outputNS}" name="{$divName}">
            <xsl:attribute name="{$rendName}">
              <xsl:text>specChildren</xsl:text>
            </xsl:attribute>
            <xsl:for-each-group select="*" group-by="@module">
              <xsl:sort select="@module"/>
              <xsl:element namespace="{$outputNS}" name="{$divName}">
                <xsl:attribute name="{$rendName}">
                  <xsl:text>specChild</xsl:text>
                </xsl:attribute>
                <xsl:choose>
                  <xsl:when test="@type='TEXT'">
                    <xsl:sequence select="tei:i18n('character data')"/>
                  </xsl:when>
                  <xsl:when test="@type='ANYXML'">
                    <xsl:for-each select="$here">
                      <xsl:call-template name="linkTogether">
                        <xsl:with-param name="name">macro.anyXML</xsl:with-param>
                        <xsl:with-param name="class">link_odd</xsl:with-param>
                      </xsl:call-template>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="string-length(current-grouping-key()) > 0">
                      <xsl:element namespace="{$outputNS}" name="{$segName}">
                        <xsl:attribute name="{$rendName}">
                          <xsl:text>specChildModule</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="current-grouping-key()"/>
                        <xsl:text>: </xsl:text>
                      </xsl:element>
                    </xsl:if>
                    <xsl:element namespace="{$outputNS}" name="{$segName}">
                      <xsl:attribute name="{$rendName}">
                        <xsl:text>specChildElements</xsl:text>
                      </xsl:attribute>
                      <xsl:for-each-group select="current-group()" group-by="@name">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="me" select="concat(@prefix, @name)"/>
                        <xsl:variable name="display" select="@name"/>
                        <xsl:variable name="type" select="@type"/>
                        <xsl:for-each select="$here">
                          <xsl:call-template name="linkTogether">
                            <xsl:with-param name="name" select="$me"/>
                            <xsl:with-param name="reftext" select="$display"/>
                            <xsl:with-param name="class">link_odd_<xsl:value-of
                                select="$type"/></xsl:with-param>
                          </xsl:call-template>
                        </xsl:for-each>
                        <xsl:if test="not(position() = last())">
                          <xsl:call-template name="showSpaceBetweenItems"/>
                        </xsl:if>
                      </xsl:for-each-group>
                    </xsl:element>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
            </xsl:for-each-group>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="followRef">
    <xsl:if test=".//rng:text or .//rng:data or .//tei:textNode">
      <Element prefix="{@prefix}" type="TEXT" module="~TEXT"/>
    </xsl:if>
    <xsl:for-each
      select=".//rng:ref | .//tei:elementRef | .//tei:classRef | .//tei:macroRef | .//tei:dataRef">
      <xsl:if
        test="not(starts-with(@name, 'any') or starts-with(@name, 'macro.any') or starts-with(@key, 'macro.any') or @name = 'AnyThing')">
        <xsl:variable name="Name"
          select="replace(@name | @key, '_(alternation|sequenceOptionalRepeatable|sequenceOptional|sequenceRepeatable|sequence)', '')"/>
        <xsl:variable name="except" select="@except"/>
        <xsl:variable name="include" select="@include"/>
        <xsl:for-each select="key('IDENTS', $Name)">
          <xsl:choose>
            <xsl:when test="self::tei:elementSpec">
              <Element prefix="{@prefix}" module="{@module}"
                type="{local-name()}" name="{tei:createSpecName(.)}"/>
            </xsl:when>
            <xsl:when test="self::tei:macroSpec">
              <xsl:for-each select="tei:content">
                <xsl:choose>
                  <xsl:when test="(rng:text or rng:data) and count(rng:*) = 1">
                    <Element prefix="{@prefix}" type="TEXT" module="~TEXT"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="followRef"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="self::tei:dataSpec">
              <xsl:for-each select="tei:content">
                <xsl:choose>
                  <xsl:when test="(rng:text or rng:data) and count(rng:*) = 1">
                    <Element prefix="{@prefix}" type="TEXT" module="~TEXT"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="followRef"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="self::tei:classSpec">
              <xsl:call-template name="followMembers">
                <xsl:with-param name="include" select="$include"/>
                <xsl:with-param name="except" select="$except"/>
              </xsl:call-template>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:if>
      <xsl:if test="@key = 'macro.anyXML'">
        <Element type="ANYXML" module="~anyXML"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="followMembers">
    <xsl:param name="include"/>
    <xsl:param name="except"/>
    <xsl:for-each select="key('CLASSMEMBERS', @ident)">
      <xsl:choose>
        <xsl:when test="self::tei:elementSpec">
          <xsl:if test="tei:includeMember(@ident, $except, $include)">
            <Element prefix="{@prefix}" module="{@module}" type="{local-name()}"
              name="{tei:createSpecName(.)}"/>
          </xsl:if>
        </xsl:when>
        <xsl:when test="self::tei:classSpec">
          <xsl:call-template name="followMembers">
            <xsl:with-param name="include" select="$include"/>
            <xsl:with-param name="except" select="$except"/>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="validUntil">
    <xsl:param name="inline" select="false()"/>
    <!-- The above parameter, and the screwy use of it below, added 2016-12-09 -->
    <!-- by Martin and Syd in an attempt to get phrase-level deprecation warnings -->
    <xsl:variable name="rowName" select="if ($inline) then $segName else $rowName"/>
    <xsl:variable name="cellName" select="if ($inline) then $hiName else $cellName"/>
    <xsl:if test="@validUntil">
      <xsl:if test="$inline">&#xA0;&#xA0;</xsl:if>
      <xsl:element namespace="{$outputNS}" name="{$rowName}">
        <xsl:element namespace="{$outputNS}" name="{$cellName}">
          <xsl:attribute name="{$rendName}">
            <xsl:sequence
              select="
                if (ancestor::tei:attDef) then
                  'odd_label'
                else
                  'wovenodd-col1'"
            />
          </xsl:attribute>
          <xsl:element namespace="{$outputNS}" name="{$segName}">
            <xsl:attribute name="{$langAttributeName}">
              <xsl:value-of select="$documentationLanguage"/>
            </xsl:attribute>
            <xsl:attribute name="{$rendName}">
              <xsl:text>deprecated</xsl:text>
            </xsl:attribute>
            <xsl:variable name="m">
              <tei:seg>
                <xsl:sequence select="tei:i18n('deprecated')"/>
              </tei:seg>
            </xsl:variable>
            <xsl:for-each select="$m">
              <xsl:call-template name="makeExternalLink">
                <xsl:with-param name="ptr" select="false()"/>
                <xsl:with-param name="dest">
                  <xsl:text>http://www.tei-c.org/Activities/Council/Working/tcw27.xml</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
        <xsl:element namespace="{$outputNS}" name="{$cellName}">
          <xsl:if test="not($inline)">
            <xsl:attribute name="{$colspan}"
              select="
                if (ancestor-or-self::tei:attDef or self::tei:elementSpec)
                then
                  1
                else
                  2"/>
            <xsl:attribute name="{$rendName}">
              <xsl:sequence
                select="
                  if (ancestor::tei:attDef) then
                    'odd_value'
                  else
                    'wovenodd-col2'"
              />
            </xsl:attribute>
          </xsl:if>
          <xsl:element namespace="{$outputNS}" name="{$segName}">
            <xsl:attribute name="{$langAttributeName}">
              <xsl:value-of select="$documentationLanguage"/>
            </xsl:attribute>
            <xsl:attribute name="{$rendName}">
              <xsl:text>deprecated</xsl:text>
            </xsl:attribute>
            <xsl:value-of
              select="if (self::tei:defaultVal)
                      then tei:i18n('defaultValValidUntil')
                      else tei:i18n('validuntil')"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="@validUntil"/>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <xsl:template name="processSchematron"/>
</xsl:stylesheet>
