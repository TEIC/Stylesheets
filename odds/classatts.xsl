<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
  xmlns:rng="http://relaxng.org/ns/structure/1.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:teix="http://www.tei-c.org/ns/Examples"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0" exclude-result-prefixes="#all">
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
    <desc>
      <p> TEI stylesheet for processing overriding of class attributes in ODD</p>
      <p>This software is dual-licensed: 1. Distributed under a Creative Commons
        Attribution-ShareAlike 3.0 Unported License http://creativecommons.org/licenses/by-sa/3.0/
        2. http://www.opensource.org/licenses/BSD-2-Clause Redistribution and use in source and
        binary forms, with or without modification, are permitted provided that the following
        conditions are met: * Redistributions of source code must retain the above copyright notice,
        this list of conditions and the following disclaimer. * Redistributions in binary form must
        reproduce the above copyright notice, this list of conditions and the following disclaimer
        in the documentation and/or other materials provided with the distribution. This software is
        provided by the copyright holders and contributors "as is" and any express or implied
        warranties, including, but not limited to, the implied warranties of merchantability and
        fitness for a particular purpose are disclaimed. In no event shall the copyright holder or
        contributors be liable for any direct, indirect, incidental, special, exemplary, or
        consequential damages (including, but not limited to, procurement of substitute goods or
        services; loss of use, data, or profits; or business interruption) however caused and on any
        theory of liability, whether in contract, strict liability, or tort (including negligence or
        otherwise) arising in any way out of the use of this software, even if advised of the
        possibility of such damage. </p>
      <p>Author: See AUTHORS</p>
      <p>Id: $Id: odd2odd.xsl 10667 2012-07-19 09:04:45Z rahtz $</p>
      <p>Copyright: 2013, TEI Consortium</p>
    </desc>
  </doc>
  <xsl:output encoding="utf-8" indent="no"/>
  <xsl:param name="verbose"/>
  <xsl:param name="stripped">false</xsl:param>
  <xsl:variable name="All" select="/"/>
  <xsl:key name="ATTCLASSES" match="classSpec[@type = 'atts']" use="@ident"/>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Elements which have an attribute child with a mode attribute. Process their attList and
      class list separately, to identify attributes overriding those inherited from a class.</desc>
  </doc>
  <xsl:template match="elementSpec" mode="classatts">
    <xsl:variable name="E" select="."/>
    <xsl:copy>
      <xsl:apply-templates select="@*[not(name() = 'mode')]" mode="classatts"/>
      <xsl:apply-templates select="
          *[not(self::classes or
          self::attList)]"
        mode="classatts"/>
      <xsl:variable name="results">
        <xsl:sequence select="tei:attclasses(.)"/>
      </xsl:variable>
      <classes>
        <xsl:copy-of select="$results//memberOf"/>
      </classes>
      <attList>
        <xsl:copy-of select="$results//attRef"/>
        <xsl:copy-of select="$results//attDef"/>
        <xsl:for-each select="$E/attList/*">
          <xsl:call-template name="process-attList-children">
            <xsl:with-param name="results" tunnel="yes" select="$results"/>
          </xsl:call-template>
        </xsl:for-each>
      </attList>
    </xsl:copy>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Explicitly process (nested) attList within elementSpec/attList.</desc>
  </doc>
  <xsl:template match="attList" mode="classatts">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:for-each select="*">
        <xsl:call-template name="process-attList-children"/>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Helper template for the "elementSpec" template. The code has been moved here to make 
      it accesible for the "attList" template.</desc>
  </doc>
  <xsl:template name="process-attList-children" as="node()*">
    <xsl:param name="results" tunnel="yes" as="node()*"/>
    <xsl:choose>
      <xsl:when
        test="
        @mode = 'replace' and
        not($results/encounter[@ident = current()/@ident])">
        <xsl:apply-templates select="." mode="classatts"/>
      </xsl:when>
      <xsl:when test="@mode and not(@mode = 'add')"/>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="classatts"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Walk over each class membership; visit that class; see if it has attributes; check each of
      these against an override in original element. If so, merge the two together and make a local
      copy. If a class has triggered this behaviour, return pointers to untouched class attributes,
      and a set of attDefs. Otherwise, return a memberOf. A note is made of any class attribute
      (encounter element), so that we can distinguish overridding attributes as to whether or not
      they are from a class.</desc>
  </doc>
  <xsl:function name="tei:attclasses" as="node()+">
    <xsl:param name="here" as="element()"/>
    <!-- 
	 On entry, we are sitting on an <elementSpec>
	 and seeing if we have overrides on class attributes.
    -->
    <xsl:variable name="E" select="$here"/>
    <null/>
    <xsl:if test="$autoGlobal = 'true'">
      <attRef rend="none" class="att.global"/>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="not($E//attDef)">
        <xsl:for-each select="$here/classes/memberOf">
          <memberOf>
            <xsl:copy-of select="@*"/>
          </memberOf>
          <xsl:if test="key('ATTCLASSES', @key) and not($parameterize = 'true')">
            <attRef rend="none" class="{@key}"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="$here/classes/memberOf">
          <xsl:choose>
            <xsl:when test="not(key('ATTCLASSES', @key))">
              <memberOf>
                <xsl:copy-of select="@*"/>
              </memberOf>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="overrides">
                <xsl:call-template name="classAttributes">
                  <xsl:with-param name="E" select="$E"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:choose>
                <xsl:when test="not($overrides/override)">
                  <memberOf>
                    <xsl:copy-of select="@*"/>
                  </memberOf>
                  <xsl:if test="not($parameterize = 'true')">
                    <attRef rend="none" class="{@key}"/>
                  </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:copy-of select="$overrides/encounter"/>
                  <xsl:copy-of select="$overrides/attRef"/>
                  <xsl:copy-of select="$overrides/attDef"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:template name="classAttributes">
    <xsl:param name="E" as="element()">
      <x/>
    </xsl:param>
    <xsl:variable name="k" select="current()/@key"/>
    <xsl:for-each select="key('ATTCLASSES', $k)">
      <xsl:for-each select=".//attDef">
        <encounter ident="{@ident}"/>
        <xsl:variable name="A" select="."/>
        <xsl:choose>
          <xsl:when test="$E//attDef[@ident = current()/@ident]">
            <override/>
            <xsl:for-each select="$E//attDef[@ident = current()/@ident]">
              <xsl:choose>
                <xsl:when test="@mode = 'delete'"/>
                <xsl:when test="not(@mode) or @mode = 'replace'">
                  <xsl:copy-of select="."/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="mergeClassAttribute">
                    <xsl:with-param name="Old" select="$A"/>
                    <xsl:with-param name="New" select="."/>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <attRef class="{ancestor::classSpec/@ident}" name="{@ident}"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <xsl:for-each select="classes/memberOf">
        <xsl:call-template name="classAttributes">
          <xsl:with-param name="E" select="$E"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>Go over each component of an original attribute, and a change spec, and get the best
      combination of old and new.</desc>
  </doc>
  <xsl:template name="mergeClassAttribute">
    <xsl:param name="New"/>
    <xsl:param name="Old"/>

    <attDef corresp="#{$Old/ancestor::classSpec/@ident}">
      <xsl:attribute name="ident" select="$Old/@ident"/>
      <xsl:attribute name="usage">
        <xsl:choose>
          <xsl:when test="$New/@usage">
            <xsl:value-of select="$New/@usage"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$Old/@usage"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="$New/altIdent">
        <xsl:apply-templates mode="classatts" select="$New/altIdent"/>
      </xsl:if>
      <!-- equiv, gloss, desc trio -->
      <xsl:choose>
        <xsl:when test="$New/equiv">
          <xsl:apply-templates mode="classatts" select="$New/equiv"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="classatts" select="$Old/equiv"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="$New/gloss">
          <xsl:apply-templates mode="classatts" select="$New/gloss"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="classatts" select="$Old/gloss"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="$New/desc">
          <xsl:apply-templates mode="classatts" select="$New/desc"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="classatts" select="$Old/desc"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="$New/constraintSpec">
          <xsl:apply-templates mode="classatts" select="$New/constraintSpec"/>
        </xsl:when>
        <xsl:when test="$Old/constraintSpec">
          <xsl:copy-of select="$Old/constraintSpec"/>
        </xsl:when>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="$New/datatype">
          <xsl:apply-templates mode="classatts" select="$New/datatype"/>
        </xsl:when>
        <xsl:when test="$Old/datatype">
          <xsl:copy-of select="$Old/datatype"/>
        </xsl:when>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="$New/defaultVal">
          <xsl:apply-templates mode="classatts" select="$New/defaultVal"/>
        </xsl:when>
        <xsl:when test="$Old/defaultVal">
          <xsl:copy-of select="$Old/defaultVal"/>
        </xsl:when>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="$New/valDesc">
          <xsl:apply-templates mode="classatts" select="$New/valDesc"/>
        </xsl:when>
        <xsl:when test="$Old/valDesc">
          <xsl:copy-of select="$Old/valDesc"/>
        </xsl:when>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="$New/valList[@mode = 'delete']"/>
        <xsl:when test="$New/valList[@mode = 'add' or @mode = 'replace']">
          <xsl:for-each select="$New/valList[1]">
            <xsl:copy>
              <xsl:copy-of select="@type"/>
              <xsl:copy-of select="@repeatable"/>
              <xsl:copy-of select="*"/>
            </xsl:copy>
          </xsl:for-each>
        </xsl:when>
        <xsl:when
          test="
            $New/valList[@mode = 'change'] and
            not($Old/valList)">
          <xsl:for-each select="$New/valList[1]">
            <xsl:copy>
              <xsl:copy-of select="@type"/>
              <xsl:copy-of select="@repeatable"/>
              <xsl:copy-of select="*"/>
            </xsl:copy>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="$New/valList[@mode = 'change']">
          <xsl:for-each select="$New/valList[1]">
            <xsl:copy>
              <xsl:copy-of select="@*"/>
              <xsl:for-each select="$Old/valList/valItem">
                <xsl:variable name="thisme" select="@ident"/>
                <xsl:if
                  test="not($New/valList[1]/valItem[@ident = $thisme and (@mode = 'delete' or @mode = 'replace')])">
                  <xsl:copy>
                    <xsl:copy-of select="@*"/>
                    <xsl:for-each select="$New/valList[1]/valItem[@ident = $thisme]">
                      <xsl:choose>
                        <xsl:when test="equiv">
                          <xsl:apply-templates mode="classatts" select="equiv"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:for-each select="$Old/valList/valItem[@ident = $thisme]">
                            <xsl:apply-templates mode="classatts" select="equiv"/>
                          </xsl:for-each>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:choose>
                        <xsl:when test="gloss">
                          <xsl:apply-templates mode="classatts" select="gloss"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:for-each select="$Old/valList/valItem[@ident = $thisme]">
                            <xsl:apply-templates mode="classatts" select="gloss"/>
                          </xsl:for-each>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:choose>
                        <xsl:when test="desc">
                          <xsl:apply-templates mode="classatts" select="desc"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:for-each select="$Old/valList/valItem[@ident = $thisme]">
                            <xsl:apply-templates mode="classatts" select="desc"/>
                          </xsl:for-each>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </xsl:copy>
                </xsl:if>
              </xsl:for-each>
              <xsl:apply-templates mode="classatts" select="valItem[@mode = 'add']"/>
              <xsl:apply-templates mode="classatts" select="valItem[@mode = 'replace']"/>
            </xsl:copy>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="$Old/valList">
          <xsl:copy-of select="$Old/valList"/>
        </xsl:when>
      </xsl:choose>
      <xsl:if test="$New/exemplum">
        <xsl:apply-templates mode="classatts" select="$New/exemplum"/>
      </xsl:if>
      <xsl:if test="$New/remarks">
        <xsl:apply-templates mode="classatts" select="$New/remarks"/>
      </xsl:if>
    </attDef>
  </xsl:template>

  <xsl:template match="*" mode="classatts">
    <xsl:copy>
      <xsl:apply-templates select="* | @* | comment() | processing-instruction() | text()"
        mode="classatts"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@* | text() | comment() | processing-instruction()" mode="classatts">
    <xsl:copy-of select="."/>
  </xsl:template>

</xsl:stylesheet>
