<?xml version="1.0" encoding="UTF-8"?>
<sch:schema
    queryBinding="xslt2"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">

    <sch:ns
        prefix="oscal"
        uri="http://csrc.nist.gov/ns/oscal/1.0" />

    <sch:pattern>

        <sch:rule
            context="oscal:back-matter/oscal:resource">

            <sch:assert
                id="resource-has-base64"
                role="warning"
                test="oscal:base64"><sch:name /> should have a base64 element.</sch:assert>

            <sch:assert
                id="resource-base64-cardinality"
                role="error"
                test="not(oscal:base64[2])"><sch:name /> must not have more than one base64 element.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:back-matter/oscal:resource/oscal:base64">

            <sch:assert
                id="base64-has-filename"
                role="error"
                test="@filename"><sch:name /> must have filename attribute.</sch:assert>

            <sch:assert
                id="base64-has-media-type"
                role="error"
                test="@media-type"><sch:name /> must have media-type attribute.</sch:assert>

            <!-- TODO: add IANA media type check using https://www.iana.org/assignments/media-types/media-types.xml-->
            <!-- TODO: decide whether to use the IANA resource directly, or cache a local copy -->

            <sch:assert
                id="base64-has-content"
                role="error"
                test="normalize-space() != ''">base64 element must have text content.</sch:assert>

            <!-- FYI: http://expath.org/spec/binary#decode-string handles base64 but Saxon-PE or higher is necessary -->

        </sch:rule>

    </sch:pattern>

</sch:schema>
