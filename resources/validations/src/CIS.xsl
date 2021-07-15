<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    exclude-result-prefixes="xs math oscal"
    version="3.0"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:oscal="http://csrc.nist.gov/ns/oscal/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">

    <xsl:output
        html-version="5"
        method="html"
        indent="false" />

    <!-- Define a document node for the SSP to be analyzed -->
    <!-- (Useful when the context is not the SSP) -->
    <xsl:variable
        as="document-node()"
        name="ssp"
        select="/" />

    <!-- There are three catalogs to be used based on FIPS 199 categorization -->
    <xsl:variable
        name="catalog-urls"
        select="
            map {
                'fips-199-low': 'https://raw.githubusercontent.com/18F/fedramp-automation/master/baselines/rev4/xml/FedRAMP_rev4_LOW-baseline-resolved-profile_catalog.xml',
                'fips-199-moderate': 'https://raw.githubusercontent.com/18F/fedramp-automation/master/baselines/rev4/xml/FedRAMP_rev4_MODERATE-baseline-resolved-profile_catalog.xml',
                'fips-199-high': 'https://raw.githubusercontent.com/18F/fedramp-automation/master/baselines/rev4/xml/FedRAMP_rev4_HIGH-baseline-resolved-profile_catalog.xml'
            }" />
    <!-- Choose the relevant catalog URL -->
    <xsl:variable
        as="xs:string"
        name="catalog-url"
        select="$catalog-urls($ssp//security-sensitivity-level)" />
    <!-- Obtain the catalog -->
    <xsl:variable
        as="document-node()"
        name="catalog"
        select="doc($catalog-url)" />

    <xsl:variable
        as="xs:string*"
        name="statuses"
        select="
            (
            'implemented',
            'partial',
            'planned',
            'alternative',
            'not-applicable'
            )" />

    <xsl:variable
        name="implementation-status"
        select="
            map {
                'implemented': map {
                    'class': 'implementation-full',
                    'symbol': '✓',
                    'phrase': 'fully implemented'
                },
                'unimplemented': map {
                    'class': 'unimplemented',
                    'symbol': '⁇',
                    'phrase': 'not implemented'
                },
                'partial': map {
                    'class': 'implementation-partial',
                    'symbol': '◐',
                    'phrase': 'partially implemented'
                },
                'planned': map {
                    'class': 'implementation-planned',
                    'symbol': '⏳',
                    'phrase': 'planned but not yet implemented'
                },
                'alternative': map {
                    'class': 'implementation-alternative',
                    'symbol': '➬',
                    'phrase': 'alternatively implemented'
                },
                'not-applicable': map {
                    'class': 'implementation-not-applicable',
                    'symbol': 'NA',
                    'phrase': 'considered inapplicable'
                }
            }" />

    <xsl:variable
        as="xs:string"
        expand-text="true"
        name="document-title">{/system-security-plan/system-characteristics/system-name} Control Implementation Summary</xsl:variable>

    <xsl:template
        match="/">

        <xsl:if
            test="not(exists($catalog-urls($ssp//security-sensitivity-level)))">
            <xsl:message
                expand-text="true"
                terminate="true">System security plan has invalid security-sensitivity-level "{$ssp//security-sensitivity-level}".</xsl:message>
        </xsl:if>

        <html>
            <head>
                <title>
                    <xsl:value-of
                        select="$document-title" />
                </title>
                <xsl:variable
                    as="xs:string"
                    name="css-href"
                    select="replace(static-base-uri(), '\.xsl$', '.css')" />
                <xsl:if
                    test="unparsed-text-available($css-href)">
                    <xsl:variable
                        name="css"
                        select="unparsed-text($css-href)" />
                    <style><xsl:value-of disable-output-escaping="true" select="replace($css, '\s+', ' ')" /></style>
                </xsl:if>
            </head>
            <body>
                <h1>
                    <xsl:value-of
                        select="$document-title" />
                </h1>
                <p>
                    <xsl:text expand-text="true">This summary was produced { format-dateTime(current-dateTime(), '[MNn] [D] [Y] [H01]:[m01] [ZN,*-3]') }.</xsl:text>
                </p>
                <p>
                    <xsl:text>The system security plan analyzed is </xsl:text>
                    <cite>
                        <xsl:value-of
                            select="$ssp//metadata/title" />
                    </cite>
                    <xsl:text> last modified </xsl:text>
                    <xsl:value-of
                        select="format-dateTime($ssp//metadata/last-modified, '[MNn] [D] [Y]')" />
                    <xsl:text>.</xsl:text>
                </p>
                <p>The <code>security-sensitivity-level</code> of this system security plan is <code><xsl:value-of
                            select="$ssp//security-sensitivity-level" /></code>.</p>
                <p>
                    <xsl:text>The FedRAMP reference catalog is </xsl:text>
                    <a
                        target="_blank"
                        href="{$catalog-url} ">
                        <cite
                            class="url"
                            title="{$catalog-url}">
                            <xsl:value-of
                                select="$catalog//metadata/title" />
                        </cite>
                    </a>
                    <xsl:text>: version </xsl:text>
                    <code
                        class="version">
                        <xsl:value-of
                            select="$catalog//metadata/version" />
                    </code>
                    <xsl:text> last modified </xsl:text>
                    <xsl:value-of
                        select="format-dateTime($catalog//metadata/last-modified, '[MNn] [D] [Y]')" />
                    <xsl:text>.</xsl:text>
                </p>
                <p>There are <xsl:value-of
                        select="count($catalog//control)" /> required controls at that security-sensitivity-level having a total of <xsl:value-of
                        select="
                            count($catalog//prop[@name = 'response-point']/parent::part[matches(@id, 'smt')])" /> response
                    points.</p>

                <xsl:call-template
                    name="nested" />

            </body>

        </html>
    </xsl:template>

    <xsl:template
        name="nested">
        <h2>Nested Control Implementation Summary</h2>
        <details>
            <summary>Legend</summary>
            <table>
                <caption>Symbol Usage</caption>
                <thead>
                    <tr>
                        <th
                            class="c">Symbol</th>
                        <th>Denotation</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td
                            class="c">⦿</td>
                        <td>A FedRAMP Core (<a
                                target="_blank"
                                href="https://www.fedramp.gov/assets/resources/documents/CSP_Annual_Assessment_Guidance.pdf"><cite>FedRAMP Annual
                                    Assessment Guidance</cite></a> §2.3.1) control</td>
                    </tr>
                    <tr>
                        <td
                            class="c implemented">✓</td>
                        <td>A control has an implementation</td>
                    </tr>
                    <tr>
                        <td
                            class="c partially-implemented">◐</td>
                        <td>A control has a partial implementation</td>
                    </tr>
                    <tr>
                        <td
                            class="c planned">⏳</td>
                        <td>A control has a planned implementation</td>
                    </tr>
                    <tr>
                        <td
                            class="c not-implemented">⁇</td>
                        <td>A control lacks an implementation</td>
                    </tr>
                    <tr>
                        <td
                            class="c response-point-stated">☛</td>
                        <td>A FedRAMP response point with proper statement explanation</td>
                    </tr>
                    <tr>
                        <td
                            class="c response-point-missing">☛</td>
                        <td>A FedRAMP response point with missing statement explanation</td>
                    </tr>
                </tbody>
            </table>
        </details>
        <details
            open="open">
            <summary>
                <cite><xsl:value-of
                        select="$ssp//metadata/title" /></cite> — <xsl:value-of
                    select="count(//implemented-requirement[prop[@name = 'implementation-status']/@value = 'implemented'])" /> fully implemented
                controls, <xsl:value-of
                    select="count(//implemented-requirement[prop[@name = 'implementation-status']/@value = 'partial'])" /> partially implemented
                controls, <xsl:value-of
                    select="count(//implemented-requirement[prop[@name = 'implementation-status']/@value = 'planned'])" /> not yet implemented
                (planned) controls, <xsl:value-of
                    select="count(//implemented-requirement[prop[@name = 'implementation-status']/@value = 'alternative'])" /> alternative controls, <xsl:value-of
                    select="count(//implemented-requirement[prop[@name = 'implementation-status']/@value = 'not-applicable'])" /> controls considered
                not applicable </summary>
            <!-- Display each control in each family -->
            <xsl:for-each
                select="$catalog//group">
                <details>
                    <summary>
                        <xsl:value-of
                            select="title" />
                        <xsl:text> family - </xsl:text>
                        <xsl:value-of
                            select="count(descendant::control)" />
                        <xsl:text> required controls</xsl:text>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of
                            select="count(control[prop[@name = 'CORE']])" />
                        <xsl:text> core controls</xsl:text>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of
                            select="count(control/part[matches(@id, 'smt')]/descendant-or-self::part[matches(@id, 'smt')][prop[@name = 'response-point']])" />
                        <xsl:text> response points</xsl:text>
                    </summary>
                    <!-- Display each control (enhancement) in each control -->
                    <xsl:for-each
                        select="control">
                        <xsl:call-template
                            name="control" />
                        <xsl:for-each
                            select="control">
                            <xsl:call-template
                                name="control" />
                        </xsl:for-each>
                    </xsl:for-each>
                </details>
            </xsl:for-each>
        </details>
    </xsl:template>

    <xsl:template
        name="control">
        <xsl:variable
            name="ir"
            as="element()*"
            select="$ssp//implemented-requirement[@control-id = current()/@id]" />
        <xsl:variable
            name="iris"
            as="element()*"
            select="$ir/prop[@name = 'implementation-status']" />
        <xsl:variable
            name="status"
            as="xs:string*"
            select="$iris/@value" />
        <details>
            <summary>
                <xsl:choose>
                    <xsl:when
                        test="prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'CORE']">
                        <span
                            style="color:inherit">
                            <xsl:text>⦿</xsl:text>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span
                            style="color:white">
                            <xsl:text>⦿</xsl:text>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text> </xsl:text>
                <xsl:value-of
                    select="prop[@name = 'label']/@value" />
                <xsl:text> </xsl:text>
                <xsl:value-of
                    select="title" />
                <xsl:text> - </xsl:text>
                <xsl:value-of
                    select="count(part[@name = 'statement']/descendant::prop[@name = 'response-point'])" />
                <xsl:text expand-text="true"> response point{if (count(part[@name = 'statement']/descendant::prop[@name = 'response-point']) gt 1) then 's' else ''}</xsl:text>
                <xsl:choose>
                    <xsl:when
                        test="exists($ir)">
                        <xsl:text> </xsl:text>
                        <span
                            class="{$implementation-status($status)?class}"
                            title="{$implementation-status($status)?phrase}">
                            <xsl:value-of
                                select="$implementation-status($status)?symbol" />
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> </xsl:text>
                        <span
                            class="{$implementation-status?unimplemented?class}"
                            title="{$implementation-status($status)?phrase}">
                            <xsl:value-of
                                select="$implementation-status?unimplemented?symbol" />
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </summary>
            <div
                class="statement">
                <xsl:if
                    test="exists($ir) and $status ne 'implemented'">
                    <div
                        class="statement">
                        <xsl:text expand-text="true">Control is not fully implemented ({$implementation-status($status)?phrase}).</xsl:text>
                        <div
                            class="statement">
                            <xsl:value-of
                                select="$iris/remarks" />
                        </div>
                    </div>
                </xsl:if>
                <xsl:apply-templates
                    mode="statement"
                    select="part[@name = 'statement']" />
            </div>
        </details>
    </xsl:template>

    <xsl:template
        mode="statement"
        match="part[matches(@id, 'smt')]">
        <div
            class="statement">
            <xsl:attribute
                name="title"
                select="@id" />
            <xsl:choose>
                <xsl:when
                    test="prop[@name = 'response-point']">
                    <span>
                        <xsl:choose>
                            <xsl:when
                                test="$ssp//implemented-requirement[@control-id = current()/ancestor::control/@id]/statement[@statement-id = current()/@id]">
                                <xsl:attribute
                                    name="class">response-point-stated</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute
                                    name="class">response-point-missing</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>☛</xsl:text>
                    </span>
                </xsl:when>
            </xsl:choose>
            <xsl:text> </xsl:text>
            <xsl:variable
                name="prose"
                as="node()*">
                <xsl:apply-templates
                    mode="statement" />
            </xsl:variable>
            <xsl:copy-of
                select="$prose" />
        </div>
    </xsl:template>

    <xsl:template
        match="prop[@name = 'label']"
        mode="statement">
        <xsl:value-of
            select="@value" />
    </xsl:template>

    <xsl:template
        mode="statement"
        match="p">
        <xsl:apply-templates
            mode="statement"
            select="node()" />
    </xsl:template>

    <xsl:template
        match="insert"
        mode="statement">
        <span
            class="insert"
            title="{@id-ref}">
            <xsl:value-of
                select="$ssp//implemented-requirement[@control-id = current()/ancestor::control/@id]/set-parameter[@param-id = current()/@id-ref]/value" />
        </span>
        <xsl:if
            test="ancestor::control/param[@id = current()/@id-ref]/constraint">
            <span
                class="parameter-constraint"
                title="constraint">
                <xsl:text> [Constraint: </xsl:text>
                <xsl:value-of
                    select="ancestor::control/param[@id = current()/@id-ref]/constraint" />
                <xsl:text>]</xsl:text>
            </span>
        </xsl:if>
    </xsl:template>

    <xsl:template
        mode="statement"
        match="text()">
        <span>
            <xsl:copy />
        </span>
    </xsl:template>

    <xsl:template
        mode="statement"
        match="node()"
        priority="-1">
        <!-- ignore -->
    </xsl:template>

</xsl:stylesheet>
