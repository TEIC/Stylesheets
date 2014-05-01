<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:excerpt="http://wordpress.org/export/1.2/excerpt/" xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:wfw="http://wellformedweb.org/CommentAPI/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:wp="http://wordpress.org/export/1.2/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0" version="2.0" exclude-result-prefixes="#all">
  <xsl:variable name="allowedtags">
    <address/>
    <blockquote/>
    <cite/>
    <col/>
    <dl/>
    <dd/>
    <dt/>
    <h1/>
    <h2/>
    <h3/>
    <hr/>
    <i/>
    <ol/>
    <sup/>
    <table/>
    <tr/>
    <td>
      <colspan/>
    </td>
    <tbody/>
    <em/>
    <b/>
    <strong/>
    <div/>
    <img>
      <width/>
      <height/>
      <class/>
      <src/>
      <alt/>
    </img>
    <li/>
    <ul/>
    <br/>
    <p/>
    <span/>
    <a>
      <href/>
      <name/>
      <target/>
    </a>
  </xsl:variable>
  <xsl:output indent="yes"/>
  <xsl:template match="rss">
    <TEI>
      <teiHeader>
        <fileDesc>
          <titleStmt>
            <title>
              <xsl:value-of select="channel/title"/>
            </title>
            <title type="subtitle">
              <xsl:value-of select="channel/description"/>
            </title>
            <author>
              <xsl:value-of select="channel/wp:author[1]/wp:author_display_name"/>
            </author>
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
          <xsl:for-each select="channel/item[wp:status='publish']">
            <xsl:sort select="wp:post_date" order="ascending"/>
            <xsl:if test="normalize-space(content:encoded)!='' or wp:attachment_url">
              <div>
                <head><xsl:apply-templates select="title"/>
		  (<xsl:apply-templates select="wp:post_date"/>)
		</head>
                <xsl:apply-templates select="wp:attachment_url"/>
                <xsl:apply-templates select="content:encoded"/>
                <closer>
                  <xsl:apply-templates select="link"/>
                </closer>
              </div>
            </xsl:if>
          </xsl:for-each>
        </body>
      </text>
    </TEI>
  </xsl:template>
  <xsl:template match="wp:attachment_url">
    <p>
      <graphic url="{.}"/>
    </p>
  </xsl:template>
  <xsl:template match="content:encoded[string-length(.)&gt;0]">
    <xsl:variable name="content">
      <xsl:call-template name="unescape">
        <xsl:with-param name="str">
          <xsl:choose>
            <xsl:when test="starts-with(.,'&lt;p&gt;')">
              <xsl:value-of select="."/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('&lt;p&gt;',replace(.,'&#10;&#10;','&lt;/p&gt;&lt;p&gt;'),'&lt;/p&gt;')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:for-each-group select="$content/*|$content/text()" group-starting-with="p|text()">
      <xsl:choose>
        <xsl:when test="not(*) and normalize-space(.)=''"/>
        <xsl:when test="self::p">
          <xsl:apply-templates select="current-group()"/>
        </xsl:when>
        <xsl:otherwise>
          <p>
            <xsl:apply-templates select="current-group()"/>
          </p>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>
  <xsl:template match="p">
    <xsl:if test="* or not(normalize-space(.)='')">
      <p>
        <xsl:apply-templates/>
      </p>
    </xsl:if>
  </xsl:template>
  <xsl:template match="b|strong">
    <hi rend="bold">
      <xsl:apply-templates/>
    </hi>
  </xsl:template>
  <xsl:template match="address"/>
  <xsl:template match="blockquote">
    <xsl:choose>
      <xsl:when test="parent::ol or parent::ul">
	<xsl:apply-templates/>
	</xsl:when>
      <xsl:when test="li">
	<list>
	  <xsl:apply-templates/>
	</list>
      </xsl:when>
      <xsl:otherwise>
	<quote type="display">
	  <xsl:apply-templates/>
	</quote>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="cite"/>
  <xsl:template match="dt">
    <label>
      <xsl:apply-templates/>
    </label>
  </xsl:template>
  <xsl:template match="dd">
    <item>
      <xsl:apply-templates/>
    </item>
  </xsl:template>
  <xsl:template match="dl">
    <xsl:if test="not(normalize-space(.)='')">
      <list type="gloss">
      <xsl:apply-templates/>
      </list>
    </xsl:if>
  </xsl:template>
  <xsl:template match="h1|h2|h3">
    <xsl:choose>
      <xsl:when test="ancestor::p">
	<hi rend="bold">
	  <xsl:apply-templates/>
	</hi>
      </xsl:when>
      <xsl:otherwise>
	<p rend="bold">
	  <xsl:apply-templates/>
	</p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="hr"/>
  <xsl:template match="sup">
    <hi rend="sup">
      <xsl:apply-templates/>
    </hi>
  </xsl:template>
  <xsl:template match="sub">
    <hi rend="sub">
      <xsl:apply-templates/>
    </hi>
  </xsl:template>
  <xsl:template match="col"/>
  <xsl:template match="table">
    <table>
      <xsl:apply-templates/>
    </table>
  </xsl:template>
  <xsl:template match="tbody">
      <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="tr">
    <row>
      <xsl:apply-templates/>
    </row>
  </xsl:template>
  <xsl:template match="td">
    <cell>
      <xsl:if test="@colspan"><xsl:attribute name="cols" select="@colspan"/></xsl:if>
      <xsl:apply-templates/>
    </cell>
  </xsl:template>
  <xsl:template match="div|span">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="em|i">
    <hi rend="italic">
      <xsl:apply-templates/>
    </hi>
  </xsl:template>
  <xsl:template match="img">
    <graphic url="{@src}">
      <xsl:if test="@class">
        <xsl:attribute name="rend" select="replace(@class,'class=&quot;','')"/>
      </xsl:if>
      <xsl:if test="@width">
        <xsl:attribute name="width" select=" if          (matches(@width,'^[0-9]+$'))          then concat(@width,'pt')          else @width"/>
      </xsl:if>
      <xsl:if test="@height">
        <xsl:attribute name="height" select=" if          (matches(@height,'^[0-9]+$'))          then concat(@height,'pt')          else @height"/>
      </xsl:if>
      <xsl:if test="@alt">
        <desc>
          <xsl:value-of select="@alt"/>
        </desc>
      </xsl:if>
    </graphic>
  </xsl:template>
  <xsl:template match="ul|ol">
    <list type="{if (self::ul) then 'ordered' else 'unordered'}">
      <xsl:apply-templates/>
    </list>
  </xsl:template>
  <xsl:template match="li">
    <xsl:if test="* or not(normalize-space(.)='')">
      <item>
        <xsl:apply-templates/>
      </item>
    </xsl:if>
  </xsl:template>
  <xsl:template match="a[@name]"/>
  <xsl:template match="a[@href]">
    <ref target="{@href}">
      <xsl:apply-templates/>
    </ref>
  </xsl:template>
  <!-- from
     http://stackoverflow.com/questions/2463155/how-to-unescape-xml-characters-with-help-of-xslt -->
  <xsl:template name="unescape">
    <xsl:param name="str"/>
    <xsl:variable name="start" select="substring-before($str,'&lt;')"/>
    <xsl:variable name="rest" select="substring-after($str,'&lt;')"/>
    <xsl:variable name="fulltag" select="substring-before($rest,'&gt;')"/>
    <xsl:variable name="tagparts" select="tokenize($fulltag,'[  &#10;]')"/>
    <xsl:variable name="tag" select="$tagparts[1]"/>
    <xsl:variable name="aftertag"  select="substring-after($rest,'&gt;')"/>
    <xsl:variable name="endtag" select="concat('&lt;/',$tag,'&gt;')"/>
    <xsl:variable name="intag" select="substring-before($aftertag,$endtag)"/>
    <xsl:variable name="afterall" select="substring-after($aftertag,$endtag)"/>
    <xsl:value-of select="$start"/>
    <xsl:choose>
      <xsl:when test="starts-with($tag,'/')"/>
      <xsl:when test="starts-with($tag,'!--')"/>
      <xsl:when test="$tag">
        <xsl:variable name="currtag" select="$allowedtags/*[$tag =           local-name()]"/>
        <xsl:choose>
          <xsl:when test="$currtag">
            <xsl:element xmlns="" name="{$currtag/local-name()}">
              <xsl:for-each select="$tagparts[position()&gt;1]">
                <xsl:variable name="anstring" select="replace(.,'^([^ &#10;=]*)=.*$','$1')"/>
                <xsl:variable name="antag" select="$currtag/*[$anstring = local-name()]"/>
                <xsl:if test="$antag">
                  <xsl:attribute name="{$antag/local-name()}">
                    <xsl:value-of select="replace(.,'^.*[^ &quot;]*&quot;([^&quot;]*)&quot;.*','$1')"/>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
	      <xsl:if test="$intag">
                  <xsl:call-template name="unescape">
                    <xsl:with-param name="str">
                      <xsl:value-of select="$intag"/>
                    </xsl:with-param>
                  </xsl:call-template>
	      </xsl:if>
	    </xsl:element>
	    <xsl:if test="$tagparts[last()]='/'"><!-- empty element -->
              <xsl:call-template name="unescape">
                <xsl:with-param name="str">
                  <xsl:value-of select="$aftertag"/>
                </xsl:with-param>
              </xsl:call-template>	      
	    </xsl:if>	    
          </xsl:when>
          <xsl:otherwise>
            <xsl:message>Error: tag <xsl:value-of select="$tag"/> not  recognized</xsl:message>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$afterall">
          <xsl:call-template name="unescape">
            <xsl:with-param name="str">
              <xsl:value-of select="$afterall"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$str"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
