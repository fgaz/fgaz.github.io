<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:atom="http://www.w3.org/2005/Atom">
  <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
      <!--
        It seems like this version of zola doesn't like xml templates,
        so I can't {% include %} the head/header/nav.
        Instead, here's a stripped down version.
      -->
      <head>
        <meta charset="utf-8" />

        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="color-scheme" content="light dark" />
        <title>Feed - fgaz</title>
        <link rel="stylesheet" href="/main.css" />

        <link rel="icon" sizes="32x32" href="/favicon.png" />
        <link rel="icon" sizes="512x512" href="/favicon512.png" />
      </head>
      <body>
        <header><h1><a href="/">fgaz</a></h1></header>
        <nav>
          <a href="/" accesskey="1">Home</a>
          <a href="/about/" accesskey="9 s">About</a>
          <a href="/projects/">Projects</a>
          <a href="/posts/" accesskey="b">Archive</a>
        </nav>
        <main>
          <h2 class="page-title">Web Feed</h2>
          <div class="posts">
            <xsl:for-each select="/rss/channel/item">
              <div class="post-preview">
                <h2 class="post-title"><a href="{link}"><xsl:value-of select="title"/></a></h2>
                <time datetime="{pubDate}"><xsl:value-of select="pubDate"/></time>
                <!--
                  Firefox doesn't support disable-output-escaping so the description
                  will appear as raw HTML code. This is unavoidable because HTML
                  in the RSS <description> _has_ to be escaped/CDATA'd.
                -->
                <p><xsl:value-of select="description" disable-output-escaping="yes"/></p>
                <p><a href="{link}#continue-reading">Continue reading…</a></p>
              </div>
            </xsl:for-each>
            <p>...and possibly more on <a href="/posts">the archive</a>!</p>
          </div>
        </main>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
