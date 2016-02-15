<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xd="http://www.pnp-software.com/XSLTdoc"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  xmlns:eg="http://www.tei-c.org/ns/Examples"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:i18n="i18n"
  exclude-result-prefixes="#all">
  
  <xsl:variable name="i18n-lookup">
    <i18n>
      <entry xml:id="abstract-label">
        <text xml:lang="eng">Abstract</text>
        <text xml:lang="es">Resumen</text>
        <text xml:lang="fr">Résumé</text>
        <text xml:lang="it">Sommario</text>        
        <text xml:lang="nl">Samenvatting</text>
      </entry>
    </i18n>
  </xsl:variable>
  
  <xsl:key name="i18n" match="entry" use="@xml:id"/>

  <xsl:function name="i18n:key">
    <xsl:param name="string"/>
    <xsl:param name="lang"/>
    <xsl:value-of select="(key('i18n', $string, $i18n-lookup)/text[@xml:lang = $lang]/text(),concat('*',$string,'*'))[1]"/>
  </xsl:function>

</xsl:stylesheet>
