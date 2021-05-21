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

        <sch:title>A FedRAMP OSCAL SSP must specify a Privacy Point of Contact</sch:title>

        <sch:rule
            context="oscal:metadata"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 49">

            <sch:assert
                id="has-privacy-poc-role"
                role="error"
                test="//oscal:metadata/oscal:role[@id = 'privacy-poc']">A FedRAMP OSCAL SSP must incorporate a Privacy Point of Contact
                role</sch:assert>

            <sch:assert
                id="has-responsible-party-privacy-poc-role"
                role="error"
                test="//oscal:metadata/oscal:responsible-party[@role-id = 'privacy-poc']">A FedRAMP OSCAL SSP must declare a Privacy Point of Contact
                responsible party role reference</sch:assert>

            <sch:assert
                id="has-responsible-privacy-poc-party-uuid"
                role="error"
                test="//oscal:metadata/oscal:responsible-party[@role-id = 'privacy-poc']/oscal:party-uuid">A FedRAMP OSCAL SSP must declare a Privacy
                Point of Contact responsible party role reference identifying the party by UUID</sch:assert>

            <sch:let
                name="poc-uuid"
                value="//oscal:metadata/oscal:responsible-party[@role-id = 'privacy-poc']/oscal:party-uuid" />
            <sch:assert
                id="has-privacy-poc"
                role="error"
                test="//oscal:metadata/oscal:party[@uuid = $poc-uuid]">A FedRAMP OSCAL SSP must define a Privacy Point of Contact</sch:assert>

        </sch:rule>

    </sch:pattern>

    <sch:pattern>

        <sch:title>A FedRAMP OSCAL SSP must incorporate a Privacy Threshold Analysis</sch:title>

        <sch:rule
            context="oscal:system-information"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 51">

            <sch:assert
                id="has-pta"
                role="error"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'pta']]">A FedRAMP OSCAL SSP must
                incorporate a Privacy Threshold Analysis</sch:assert>

        </sch:rule>

    </sch:pattern>

    <sch:pattern>

        <sch:title>A FedRAMP OSCAL SSP may need to incorporate a PIA and possibly a SORN</sch:title>

        <sch:rule
            context="oscal:system-information"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 51">

            <sch:assert
                id="has-privacy-sensitive-designation"
                role="error"
                test="//oscal:system-information/oscal:prop[@name = 'privacy-sensitive' and @value = ('yes', 'no')]">Lacks privacy-sensitive
                designation</sch:assert>

        </sch:rule>

        <sch:rule
            context="//oscal:system-information[oscal:prop[@name = 'privacy-sensitive' and @value = 'yes']]"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 51">

            <sch:assert
                id="has-pta-question-1"
                role="error"
                test="//oscal:system-information/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and class = 'pta' and @name = 'pta-1']">Missing
                PTA/PIA qualifying question #1.</sch:assert>

            <sch:assert
                id="has-pta-question-2"
                role="error"
                test="//oscal:system-information/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and class = 'pta' and @name = 'pta-2']">Missing
                PTA/PIA qualifying question #2.</sch:assert>

            <sch:assert
                id="has-pta-question-3"
                role="error"
                test="//oscal:system-information/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and class = 'pta' and @name = 'pta-3']">Missing
                PTA/PIA qualifying question #3.</sch:assert>

            <sch:assert
                id="has-pta-question-4"
                role="error"
                test="//oscal:system-information/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and class = 'pta' and @name = 'pta-4']">Missing
                PTA/PIA qualifying question #4.</sch:assert>

            <sch:assert
                id="has-pta-question-1-answered"
                role="error"
                test="//oscal:system-information/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and class = 'pta' and @name = 'pta-1' and @value = ('yes', 'no')]">The
                answer to PTA/PIA qualifying question #1 is neither yes nor no.</sch:assert>

            <sch:assert
                id="has-pta-question-2-answered"
                role="error"
                test="//oscal:system-information/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and class = 'pta' and @name = 'pta-2' and @value = ('yes', 'no')]">The
                answer to PTA/PIA qualifying question #2 is neither yes nor no.</sch:assert>

            <sch:assert
                id="has-pta-question-3-answered"
                role="error"
                test="//oscal:system-information/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and class = 'pta' and @name = 'pta-3' and @value = ('yes', 'no')]">The
                answer to PTA/PIA qualifying question #3 is neither yes nor no.</sch:assert>

            <sch:assert
                id="has-pta-question-4-answered"
                role="error"
                test="//oscal:system-information/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and class = 'pta' and @name = 'pta-4' and @value = ('yes', 'no')]">The
                answer to PTA/PIA qualifying question #4 is neither yes nor no.</sch:assert>

        </sch:rule>

        <sch:rule
            context="//oscal:system-information/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and class = 'pta' and @name = 'pta-4' and @value = 'yes']"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 51">

            <sch:assert
                id="has-sorn"
                role="error"
                test="//oscal:system-information/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and class = 'pta' and @name = 'sorn-id']">Missing
                SORN ID</sch:assert>

            <sch:assert
                id="has-sorn-id"
                role="error"
                test="//oscal:system-information/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and class = 'pta' and @name = 'sorn-id' and @value != '']">Missing
                SORN ID</sch:assert>

        </sch:rule>

    </sch:pattern>

</sch:schema>
