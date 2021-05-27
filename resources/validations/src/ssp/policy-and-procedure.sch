<?xml version="1.0" encoding="UTF-8"?>
<sch:schema
    queryBinding="xslt2"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">

    <sch:ns
        prefix="oscal"
        uri="http://csrc.nist.gov/ns/oscal/1.0" />
    <sch:ns
        prefix="fedramp"
        uri="https://fedramp.gov/ns/oscal" />

    <sch:title>FedRAMP SSP tests</sch:title>

    <sch:pattern>

        <sch:title>A FedRAMP SSP must incorporate one policy document and one procedure document for each of the 17 NIST SP 800-54r4 control
            families</sch:title>

        <!-- TODO: handle attachments declared by component (see implemented-requirement ac-1 for an example) -->

        <!-- FIXME: XSpec testing malfunctions when the following rule context is constrained to XX-1 control-ids -->
        <sch:rule
            context="oscal:implemented-requirement[matches(@control-id, '^[a-z]{2}-1$')]"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 48">

            <sch:assert
                id="has-policy-link"
                role="error"
                test="descendant::oscal:by-component/oscal:link[@rel = 'policy']"><sch:value-of
                    select="local-name()" />
                <sch:value-of
                    select="@control-id" />
                <sch:span
                    class="message"> lacks policy reference(s) (via by-component link)</sch:span></sch:assert>

            <sch:let
                name="policy-hrefs"
                value="distinct-values(descendant::oscal:by-component/oscal:link[@rel = 'policy']/@href ! substring-after(., '#'))" />

            <sch:assert
                id="has-policy-attachment-resource"
                role="error"
                test="
                    every $ref in $policy-hrefs
                        satisfies exists(//oscal:resource[oscal:prop[@name = 'type' and @value = 'policy']][@uuid = $ref])"><sch:value-of
                    select="local-name()" />
                <sch:value-of
                    select="@control-id" />
                <sch:span
                    class="message"> lacks policy attachment resource(s) </sch:span><sch:value-of
                    select="string-join($policy-hrefs, ', ')" /></sch:assert>

            <!-- TODO: ensure resource has an rlink -->

            <sch:assert
                id="has-procedure-link"
                role="error"
                test="descendant::oscal:by-component/oscal:link[@rel = 'procedure']"><sch:value-of
                    select="local-name()" />
                <sch:value-of
                    select="@control-id" />
                <sch:span
                    class="message"> lacks procedure reference(s) (via by-component link)</sch:span></sch:assert>

            <sch:let
                name="procedure-hrefs"
                value="distinct-values(descendant::oscal:by-component/oscal:link[@rel = 'procedure']/@href ! substring-after(., '#'))" />

            <sch:assert
                id="has-procedure-attachment-resource"
                role="error"
                test="
                    (: targets of links exist in the document :)
                    every $ref in $procedure-hrefs
                        satisfies exists(//oscal:resource[oscal:prop[@name = 'type' and @value = 'procedure']][@uuid = $ref])"><sch:value-of
                    select="local-name()" />
                <sch:value-of
                    select="@control-id" />
                <sch:span
                    class="message"> lacks procedure attachment resource(s) </sch:span><sch:value-of
                    select="string-join($procedure-hrefs, ', ')" /></sch:assert>

            <!-- TODO: ensure resource has an rlink -->

        </sch:rule>

        <sch:rule
            context="oscal:by-component/oscal:link[@rel = ('policy', 'procedure')]">

            <sch:p>Each SP 800-53 control family must have unique policy and unique procedure documents</sch:p>

            <sch:let
                name="ir"
                value="ancestor::oscal:implemented-requirement" />

            <sch:report
                id="has-reuse"
                role="error"
                test="
                    (: the current @href is in :)
                    @href =
                    (: all controls except the current :) (//oscal:implemented-requirement[matches(@control-id, '^[a-z]{2}-1$')] except $ir)
                    (: all their @hrefs :)/descendant::oscal:by-component/oscal:link[@rel = 'policy']/@href"><sch:value-of
                    select="@rel" /> document <sch:value-of
                    select="substring-after(@href, '#')" /> is used in other controls (i.e., it is not unique to implemented-requirement <sch:value-of
                    select="$ir/@control-id" />)</sch:report>

        </sch:rule>

    </sch:pattern>
</sch:schema>
