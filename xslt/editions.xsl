<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="xsl tei xs local">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/blockquote.xsl"/>

    <xsl:variable name="prev">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="teiSource">
        <xsl:value-of select="data(tei:TEI/@xml:id)"/>
    </xsl:variable>
    <xsl:variable name="link">
        <xsl:value-of select="replace($teiSource, '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="doc_title">
        <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
    </xsl:variable>
    <xsl:variable name="volumeWritten" select=".//tei:biblScope[@unit='volume']/text()"/>
    <xsl:variable name="volume" select=".//tei:biblScope[@unit='volume']/@n"/>
    <xsl:variable name="issueWritten" select=".//tei:biblScope[@unit='issue']/text()"/>
    <xsl:variable name="issue" select=".//tei:biblScope[@unit='issue']/@n"/>
    <xsl:variable name="pageWritten" select=".//tei:biblScope[@unit='page']/text()"/>
    <xsl:variable name="page" select=".//tei:biblScope[@unit='page']/@n"/>

    <xsl:variable name="volumeUrl" select="'BR-'||$volume||'-01-01_n0001.html'"/>
    <xsl:variable name="issueUrl" select="'BR-'||$volume||$issue||'-01_n0001.html'"/>
    <xsl:variable name="facs-url">
        <xsl:value-of select="replace(replace($teiSource, '.xml', ''), 'BR-', '')"/>
    </xsl:variable>
    <xsl:variable name="brenner-url" select="'https://brenner.oeaw.ac.at/php/getPage.php?keyString='"/>


    <xsl:template match="/">
        <html class="h-100" lang="{$default_lang}">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="'Der Brenner: '||$doc_title"></xsl:with-param>
                </xsl:call-template>
            </head>
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0 flex-grow-1">
                    <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="ps-5 p-3">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="index.html"><xsl:value-of select="$project_short_title"/></a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="{$volumeUrl}"><xsl:value-of select="$volumeWritten"/></a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="#"><xsl:value-of select="$issueWritten"/></a>
                            </li>
                        </ol>
                    </nav>
                    <div class="container">
                        <div class="row">
                            <div class="col-md-2 col-lg-2 col-sm-12 text-start">
                                <xsl:if test="ends-with($prev,'.html')">
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$prev"/>
                                        </xsl:attribute>
                                        <i class="fs-2 bi bi-chevron-left" title="Zurück zum vorigen Dokument" visually-hidden="true">
                                            <span class="visually-hidden">Zurück zum vorigen Dokument</span>
                                        </i>
                                    </a>
                                </xsl:if>
                            </div>
                            <div class="col-md-8 col-lg-8 col-sm-12 text-center">
                                <h1 class="text-center">
                                    <xsl:value-of select="$doc_title"/>
                                </h1>
                                <div>
                                    <a href="{$teiSource}">
                                        <i class="bi bi-download fs-2" title="Zum TEI/XML Dokument" visually-hidden="true">
                                            <span class="visually-hidden">Zum TEI/XML Dokument</span>
                                        </i>
                                    </a>
                                </div>
                            </div>
                            <div class="col-md-2 col-lg-2 col-sm-12 text-start">
                                <xsl:if test="ends-with($next, '.html')">
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$next"/>
                                        </xsl:attribute>
                                        <i class="fs-2 bi bi-chevron-right" title="Weiter zum nächsten Dokument" visually-hidden="true">
                                            <span class="visually-hidden">Weiter zum nächsten Dokument</span>
                                        </i>
                                    </a>
                                </xsl:if>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-7">
                                <div id="osd_viewer"/>
                                <figcaption class="figure-caption text-center">Der Brenner, <xsl:value-of select="$doc_title"/></figcaption>
                                <div class="text-center">
                                    <a href="{$brenner-url||$facs-url||'&amp;type=xml'}">original XML</a> | <a href="{$brenner-url||$facs-url||'&amp;type=html'}">original HTML</a>
                                </div>
                            </div>
                            <div class="col-md-5">
                                <xsl:apply-templates select=".//tei:body"/>
                            </div>
                        </div>

                        <div class="text-center p-4">
                            <xsl:call-template name="blockquote">
                                <xsl:with-param name="pageId" select="$link"/>
                            </xsl:call-template>
                        </div>
                        <span id="url" class="visually-hidden" aria-hidden="true"><xsl:value-of select="$brenner-url||$facs-url||'&amp;type=img'"/></span>

                    </div>
                    <xsl:for-each select="//tei:back">
                        <div class="tei-back">
                            <xsl:apply-templates/>
                        </div>
                    </xsl:for-each>
                </main>
                <xsl:call-template name="html_footer"/>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.1.0/openseadragon.min.js"/>
                <script src="js/facs.js"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
