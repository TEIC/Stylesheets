<xsl:stylesheet
        version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:tei="http://www.tei-c.org/ns/1.0"
        xpath-default-namespace="http://www.tei-c.org/ns/1.0">

    <xsl:import href="tei-to-markdown.xsl"/>
    <xsl:template match="note/p">
        <xsl:text>+++(</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>)+++</xsl:text>
    </xsl:template>

</xsl:stylesheet>
