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
    <xsl:variable name="halbbandWritten" select=".//tei:biblScope[@unit='halbband']/text()"/>
    <xsl:variable name="halbband" select=".//tei:biblScope[@unit='halbband']/@n"/>
    <xsl:variable name="firstHalbband">
        <xsl:choose>
            <xsl:when test=".//tei:biblScope[@unit='halbband']/text()">
                <xsl:value-of select="'01'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'00'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="issueWritten" select=".//tei:biblScope[@unit='issue']/text()"/>
    <xsl:variable name="firstIssue">
        <xsl:choose>
            <xsl:when test=".//tei:biblScope[@unit='issue']/text()">
                <xsl:value-of select="'01'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'00'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="issue" select=".//tei:biblScope[@unit='issue']/@n"/>
    <xsl:variable name="pageWritten" select=".//tei:biblScope[@unit='page']/text()"/>
    <xsl:variable name="page" select=".//tei:biblScope[@unit='page']/@n"/>

    <xsl:variable name="volumeUrl" select="'BR-'||$volume||'-'||$firstHalbband||'-'||$firstIssue||'_a0001.html'"/>
    <xsl:variable name="issueUrl" select="'BR-'||$volume||'-'||$halbband||'-'||$issue||'_a0001.html'"/>
    
    
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
                            <xsl:if test="$halbbandWritten">
                                <li class="breadcrumb-item">
                                    <a href="{$issueUrl}"><xsl:value-of select="$halbbandWritten"/></a>
                                </li>
                            </xsl:if>
                            <xsl:if test="$issueWritten">
                                <li class="breadcrumb-item">
                                    <a href="{$issueUrl}"><xsl:value-of select="$issueWritten"/></a>
                                </li>
                            </xsl:if>
                            <xsl:for-each select=".//tei:bibl[@n='current text']">
                                <li class="breadcrumb-item">
                                    <a href="{replace(./tei:idno, '.xml', '.html')}">
                                        <xsl:value-of select="./tei:title/@n"/>
                                    </a>
                                </li>
                            </xsl:for-each>
                        </ol>
                    </nav>
                    <div class="container">
                        <div class="row">
                            <div class="col-md-1 col-lg-1 col-sm-12 text-start">
                                <xsl:for-each select=".//tei:bibl[@n='previous issue']">
                                    <xsl:variable name="title">
                                        <xsl:value-of select="./tei:title"/>
                                    </xsl:variable>
                                    <a data-bs-toggle="tooltip" data-bs-title="Voriges Heft: {$title}">
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="replace(./tei:idno, '.xml', '.html')"/>
                                        </xsl:attribute>
                                        <i class="fs-2 bi-chevron-double-left" visually-hidden="true">
                                            <span class="visually-hidden"><xsl:value-of select="$title"/></span>
                                        </i>
                                    </a>
                                </xsl:for-each>
                            </div>
                            <div class="col-md-1 col-lg-1 col-sm-12 text-start">
                                <xsl:if test="ends-with($prev,'.html')">
                                    <a data-bs-toggle="tooltip" data-bs-title="Vorige Seite">
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$prev"/>
                                        </xsl:attribute>
                                        <i class="fs-2 bi bi-chevron-left" title="Vorige Seite" visually-hidden="true">
                                            <span class="visually-hidden">Vorige Seite</span>
                                        </i>
                                    </a>
                                </xsl:if>
                            </div>
                            <div class="col-md-8 col-lg-8 col-sm-12 text-center">
                                <h1 class="text-center">
                                    <xsl:value-of select="$doc_title"/>
                                </h1>
                               
                                    <xsl:if test=".//tei:bibl[@n='current text']">
                                        <div class="row">
                                            <div class="col-md-2 col-lg-2 col-sm-12 text-start">
                                                <xsl:if test=".//tei:bibl[@n='previous text'][1]">
                                                    <a href="{replace(.//tei:bibl[@n='previous text'][1]/tei:idno, '.xml', '.html')}" data-bs-toggle="tooltip" data-bs-title="Voriger Text">
                                                        <xsl:value-of select=".//tei:bibl[@n='previous text'][1]/tei:title/@n"/>
                                                    </a>
                                                </xsl:if>
                                            </div>
                                            <div class="col-md-8 col-lg-8 col-sm-12 text-center">
                                                <h2 class="text-center fs-3 text-muted">
                                                    <xsl:value-of select=".//tei:bibl[@n='current text']/tei:author"/>, <xsl:value-of select=".//tei:bibl[@n='current text']/tei:title"/>
                                                </h2>
                                            </div>
                                            
                                            <div class="col-md-2 col-lg-2 col-sm-12 text-end">
                                                <xsl:if test=".//tei:bibl[@n='next text'][1]">
                                                    <a href="{replace(.//tei:bibl[@n='next text'][1]/tei:idno, '.xml', '.html')}" data-bs-toggle="tooltip" data-bs-title="Nächster Text">
                                                        <xsl:value-of select=".//tei:bibl[@n='next text'][1]/tei:title/@n"/>
                                                    </a>
                                                </xsl:if>
                                            </div>
                                        </div>
                                    </xsl:if>
                                <div>
                                    <a href="{$teiSource}">
                                        <i class="bi bi-download fs-2" title="Zum TEI/XML Dokument" visually-hidden="true">
                                            <span class="visually-hidden">Zum TEI/XML Dokument</span>
                                        </i>
                                    </a>
                                </div>
                            </div>
                            <div class="col-md-1 col-lg-1 col-sm-12 text-end">
                                <xsl:if test="ends-with($next, '.html')">
                                    <a data-bs-toggle="tooltip" data-bs-title="Nächste Seite">
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$next"/>
                                        </xsl:attribute>
                                        <i class="fs-2 bi bi-chevron-right" visually-hidden="true">
                                            <span class="visually-hidden">Nächste Seite</span>
                                        </i>
                                    </a>
                                </xsl:if>
                            </div>
                            <div class="col-md-1 col-lg-1 col-sm-12 text-end">
                                <xsl:for-each select=".//tei:bibl[@n='next issue']">
                                    <xsl:variable name="title">
                                        <xsl:value-of select="./tei:title"/>
                                    </xsl:variable>
                                    <a data-bs-toggle="tooltip" data-bs-title="Nächstes Heft: {$title}">
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="replace(./tei:idno, '.xml', '.html')"/>
                                        </xsl:attribute>
                                        <i class="fs-2 bi-chevron-double-right" visually-hidden="true">
                                            <span class="visually-hidden"><xsl:value-of select="$title"/></span>
                                        </i>
                                    </a>
                                </xsl:for-each>
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
