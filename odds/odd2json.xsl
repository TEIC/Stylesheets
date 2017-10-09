<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:j="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <xsl:import href="../common/functions.xsl"/>
    <xsl:key match="tei:elementSpec|tei:classSpec|tei:macroSpec|tei:dataSpec" name="IDENTS" use="concat(@prefix,@ident)"/>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
        <desc>
            <p> TEI stylesheet for making JSON from ODD </p>
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
            
            <p>Copyright: 2017, TEI Consortium</p>
        </desc>
    </doc>
    
    <xsl:output method="text"/>
    
    <xsl:param name="lang" select="'en'">
        <!-- Set this to 'all' to include documentation in all languages. -->
    </xsl:param>
    <xsl:param name="serializeDocs" select="true()"/>
    
    <xsl:template match="/">
        <xsl:variable name="structure">
            <j:map>
                <j:string key="title">
                    <xsl:sequence select="tei:generateMetadataTitle(*)"/>
                </j:string>
                <j:string key="edition">
                    <xsl:sequence select="tei:generateEdition(*)"/>
                </j:string>
                <j:string key="generator">odd2json3</j:string>
                <j:string key="date"><xsl:sequence select="tei:whatsTheDate()"/></j:string>
                <j:array key="modules">
                    <xsl:for-each select="//tei:moduleSpec">
                        <xsl:sort select="@ident"/>
                        <j:map>
                            <j:string key="ident"><xsl:value-of select="@ident"/></j:string>
                            <j:string key="id">
                                <xsl:choose>
                                    <xsl:when test="@n">
                                        <xsl:value-of select="@n">
                                        </xsl:value-of>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="ancestor::tei:div[last()]/@xml:id"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </j:string>
                            <xsl:call-template name="desc"/>
                            <j:string key="altIdent">
                                <xsl:value-of select="tei:altIdent"/>
                            </j:string>
                        </j:map>
                    </xsl:for-each>
                </j:array>
                <j:array key="moduleRefs">
                    <xsl:for-each select="//tei:moduleRef">
                        <xsl:sort select="@key"/>
                        <j:map>
                            <j:string key="key"><xsl:value-of select="@key"/></j:string>
                            <xsl:call-template name="desc"/>
                            <xsl:call-template name="mode"/>
                        </j:map>
                    </xsl:for-each>
                </j:array>
                <j:array key="members">
                    <xsl:for-each select="//tei:elementSpec|//tei:classSpec[@type='atts']">
                        <xsl:sort select="@ident"/>
                        <j:map>
                            <j:string key="ident"><xsl:value-of select="@ident"/></j:string>
                            <xsl:variable name="nspace"
                                select="(@ns,  ancestor::tei:schemaSpec[1]/@ns)[1]"/>
                            <xsl:if test="$nspace">
                                <j:string key="ns"><xsl:value-of select="$nspace"/></j:string>
                            </xsl:if>
                            <j:string key="type"><xsl:value-of select="local-name()"/></j:string>
                            <j:string key="module"><xsl:value-of select="@module"/></j:string>
                            <xsl:call-template name="desc"/>
                            <j:string key="altIdent">
                                <xsl:value-of select="tei:altIdent"/>
                            </j:string>
                            <xsl:if test="tei:classes">
                                <j:array key="classes">
                                    <xsl:for-each select="tei:classes/tei:memberOf">
                                        <j:map>
                                            <j:array key="{@key}">
                                                <xsl:for-each select="key('IDENTS',@key)">
                                                    <j:string><xsl:value-of select="@type"/></j:string>
                                                </xsl:for-each>
                                            </j:array>
                                        </j:map>
                                    </xsl:for-each>
                                </j:array>
                            </xsl:if>
                            <xsl:call-template name="attributes"/>
                            <xsl:if test="tei:classes">
                                <j:array key="classattributes">
                                    <xsl:call-template name="classattributes"/>
                                </j:array>
                            </xsl:if>
                        </j:map>
                    </xsl:for-each>
                </j:array>
                <j:array key="elementRefs">
                    <xsl:for-each select="//tei:elementRef[not(ancestor::tei:content)]">
                        <xsl:sort select="@key"/>
                        <j:map>
                            <j:string key="key">
                                <xsl:value-of select="@key"/>
                            </j:string>
                            <xsl:call-template name="desc"/>
                            <xsl:call-template name="mode"/>
                        </j:map>
                    </xsl:for-each>
                </j:array>
                <j:array key="modelclasses">
                    <xsl:for-each select="//tei:classSpec[@type='model']">
                        <xsl:sort select="@ident"/>
                        <j:map>
                            <j:string key="ident">
                                <xsl:value-of select="@ident"/>
                            </j:string>
                            <j:string key="module">
                                <xsl:value-of select="@module"/>
                            </j:string>
                            <xsl:call-template name="desc"/>
                            <xsl:call-template name="mode"/>
                        </j:map>
                    </xsl:for-each>
                </j:array>
                <j:array key="classRefs">
                    <xsl:for-each select="//tei:classRef[not(ancestor::tei:content)]">
                        <xsl:sort select="@key"/>
                        <j:map>
                            <j:string key="key">
                                <xsl:value-of select="@key"/>
                            </j:string>
                            <xsl:call-template name="desc"/>
                            <xsl:call-template name="mode"/>
                        </j:map>
                    </xsl:for-each>
                </j:array>
                <j:array key="macros">
                    <xsl:for-each select="//tei:macroSpec|//tei:dataSpec">
                        <xsl:sort select="@ident"/>
                        <j:map>
                            <j:string key="ident">
                                <xsl:value-of select="@ident"/>
                            </j:string>
                            <j:string key="module">
                                <xsl:value-of select="@module"/>
                            </j:string>
                            <j:string key="type">
                                <xsl:value-of select="@type"/>
                            </j:string>
                            <xsl:call-template name="desc"/>
                            <xsl:call-template name="mode"/>
                        </j:map>
                    </xsl:for-each>
                </j:array>
                <j:array key="macroRefs">
                    <xsl:for-each select="//tei:macroRef[not(ancestor::tei:content)]">
                        <xsl:sort select="@key"/>
                        <j:map>
                            <j:string key="key">
                                <xsl:value-of select="@key"/>
                            </j:string>
                            <xsl:call-template name="desc"/>
                            <xsl:call-template name="mode"/>
                        </j:map>
                    </xsl:for-each>
                </j:array>
            </j:map>
        </xsl:variable>
        <xsl:value-of select="xml-to-json($structure, map{'indent':true()})"/>
    </xsl:template>
    
    <xsl:template name="mode">
        <xsl:if test="@mode">
            <j:string key="key">
                <xsl:value-of select="@mode"/>
            </j:string>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="attributes">
        <j:array key="attributes">
            <xsl:for-each select=".//tei:attDef">
                <j:map>
                    <j:string key="ident">
                        <xsl:value-of select="@ident"/>
                    </j:string>
                    <xsl:if test="@ns">
                        <j:string key="ns">
                            <xsl:value-of select="@ns"/>
                        </j:string>
                    </xsl:if>
                    <xsl:call-template name="desc"/>
                    <xsl:if test="tei:valList">
                        <j:array key="values">
                            <xsl:for-each select="tei:valList/tei:valItem">
                                <j:string>
                                    <xsl:value-of select="@ident"/>
                                </j:string>
                            </xsl:for-each>
                        </j:array>                                            
                    </xsl:if>
                </j:map>
            </xsl:for-each>
        </j:array>
    </xsl:template>
    
    <xsl:template name="classattributes">
        <xsl:variable name="caller" select="@ident"/>
        <xsl:for-each select="tei:classes/tei:memberOf">
            <xsl:for-each select="key('IDENTS',@key)">
                <xsl:if test="@type='atts'">
                    <j:map>
                        <j:string key="class">
                            <xsl:value-of select="@ident"/>
                        </j:string>
                        <j:string key="module">
                            <xsl:value-of select="@module"/>
                        </j:string>
                        <j:string key="usedBy">
                            <xsl:value-of select="$caller"/>
                        </j:string>
                    </j:map>
                    <xsl:call-template name="classattributes"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="serializeElement">
        <xsl:variable name="simplified">
            <xsl:copy-of copy-namespaces="no" select="."/>
        </xsl:variable>
        <j:string><xsl:value-of select="serialize($simplified)"/></j:string>
    </xsl:template>
    
    <xsl:template name="makeDesc">
        <xsl:choose>
            <xsl:when test="$serializeDocs">
                <xsl:call-template name="serializeElement"/>
            </xsl:when>
            <xsl:otherwise>
                <j:string><xsl:sequence select="tei:makeDescription(parent::*,false())"/></j:string>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="desc">
        <j:array key="desc">
            <xsl:for-each select="tei:desc">
                <xsl:choose>
                    <xsl:when test="@xml:lang and ($lang='all' or @xml:lang = $lang)">
                        <xsl:call-template name="makeDesc"/>                  
                    </xsl:when>
                    <xsl:when test="not(@xml:lang)">
                        <xsl:call-template name="makeDesc"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>                
            </xsl:for-each>
        </j:array>  
        <xsl:if test="$serializeDocs">
            <j:array key="gloss">
                <xsl:for-each select="tei:gloss">
                    <xsl:choose>
                        <xsl:when test="@xml:lang and ($lang='all' or @xml:lang = $lang)">
                            <xsl:call-template name="serializeElement"/>
                        </xsl:when>
                        <xsl:when test="not(@xml:lang)">
                            <xsl:call-template name="serializeElement"/>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>                
                </xsl:for-each>
            </j:array>
        </xsl:if>        
    </xsl:template>
    
</xsl:stylesheet>