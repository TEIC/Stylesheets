<xsl:stylesheet 
    version="2.0"
	xmlns:excerpt="http://wordpress.org/export/1.2/excerpt/"
	xmlns:content="http://purl.org/rss/1.0/modules/content/"
	xmlns:wfw="http://wellformedweb.org/CommentAPI/"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:wp="http://wordpress.org/export/1.2/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all">

<xsl:output indent="yes"/>
 <xsl:template match="rss">
   <TEI>
     <teiHeader>
       <fileDesc>
	 <titleStmt>
           <title><xsl:value-of select="channel/title"/></title>
           <title type="subtitle"><xsl:value-of
	   select="channel/description"/></title>
	   <author><xsl:value-of select="channel/wp:author[1]/wp:author_display_name"/></author>
	 </titleStmt>
	 <publicationStmt>
           <p>from wordpress</p>
	 </publicationStmt>
	 <sourceDesc>
           <p>new born </p>
      </sourceDesc>
       </fileDesc>
     </teiHeader>
     <text>
       <body>
     <xsl:for-each select="channel/item">
       <xsl:sort select="wp:post_date"/>
       <div>
	 <head><xsl:apply-templates select="title"/>
	 (<xsl:apply-templates select="wp:post_date"/>)</head>
	 <xsl:apply-templates select="wp:attachment_url"/>
	 <xsl:apply-templates select="content:encoded"/>
	 <cit><xsl:apply-templates select="link"/></cit>
	 </div>
     </xsl:for-each>
       </body>
     </text>
   </TEI>
 </xsl:template>

 <xsl:template match="wp:attachment_url">
   <p><graphic url="."/></p>
 </xsl:template>

 <xsl:template match="content:encoded">
   <xsl:apply-templates/>
</xsl:template>
</xsl:stylesheet> 
