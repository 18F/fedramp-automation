<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    exclude-result-prefixes="xs math"
    version="3.0"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- create a Schematron fragment consisting solely of patterns -->
    <xsl:output
        method="xml" />
    <xsl:mode
        on-no-match="deep-copy" />
    <xsl:template
        match="/">
        <xsl:apply-templates
            select="//sch:pattern" />
    </xsl:template>
</xsl:stylesheet>
