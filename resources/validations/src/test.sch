<?xml version="1.0" encoding="UTF-8"?>
<sch:schema
    queryBinding="xslt2"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:ns
        prefix="oscal"
        uri="http://csrc.nist.gov/ns/oscal/1.0"/>
    <sch:ns
        prefix="fedramp"
        uri="https://fedramp.gov/ns/oscal"/>

    <sch:title>FedRAMP SSP tests</sch:title>

    <!-- gratuitous warnings off by default -->
    <sch:let
        name="WARNING"
        value="false()"/>

    <!-- gratuitous info off by default -->
    <sch:let
        name="INFO"
        value="false()"/>

    <!-- get attchment types from fedramp_values.xml -->
    <!-- FIXME: the attchment types from fedramp_values.xml need attention -->
    <sch:let
        name="attachment-types"
        value="doc('../../xml/fedramp_values.xml')//fedramp:value-set[@name = 'attachment-type']//fedramp:enum/@value"/>

    <sch:pattern>

        <sch:rule
            context="/">
            <sch:p>Show distinct names used in props</sch:p>
            <sch:report
                role="INFO"
                test="$INFO">Distinct prop names: <sch:value-of
                    select="string-join(distinct-values(//oscal:prop/@name), ' ')"/></sch:report>
        </sch:rule>

        <sch:rule
            context="oscal:*[starts-with(@href, '#')]">
            <sch:p>Ensure all intra-document @hrefs have an intra-document target</sch:p>
            <sch:let
                name="ref"
                value="substring-after(@href, '#')"/>
            <sch:assert
                role="ERROR"
                test="$ref = //@uuid"><sch:value-of
                    select="@rel"/>
                <sch:name/> has invalid intra-document href <sch:value-of
                    select="@href"/></sch:assert>
            <sch:report
                role="INFO"
                test="$INFO and $ref = //@uuid"><sch:value-of
                    select="@rel"/>
                <sch:name/> has valid intra-document href to <sch:value-of
                    select="local-name(//oscal:*[@uuid = $ref])"/>
                <sch:value-of
                    select="
                        if (//oscal:*[@uuid = $ref]/oscal:title) then
                            concat('&quot;', //oscal:*[@uuid = $ref]/oscal:title, '&quot;')
                        else
                            $ref"/></sch:report>
        </sch:rule>

    </sch:pattern>

    <sch:pattern>

        <sch:rule
            context="oscal:back-matter">
            <sch:p>It seems unlikely that most if not all SSP resources require a FedRAMP-specific prop.</sch:p>
            <sch:p>The current fedramp-automation content appears to have presumed that NIST would supply (and be normative for) RMF prop types (NIST
                has/is not) as opposed to FedRAMP prop types.</sch:p>
            <sch:assert
                test="oscal:resource[prop[@ns = 'https://fedramp.gov/ns/oscal']]">A FedRAMP SSP MUST include FedRAMP-specific props in back-matter
                resources</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:back-matter/oscal:resource">
            
            <!-- create a "path" to the context -->
            <sch:let
                name="path"
                value="concat(string-join(ancestor-or-self::* ! name(), '/'), ' ', @uuid, ' &quot;', oscal:title, '&quot;')"/>

            <!-- the following assertion recapitulates the XML Schema constraint -->
            <sch:assert
                role="ERROR"
                test="@uuid">A &lt;<sch:name/>&gt; element MUST have a uuid attribute </sch:assert>

            <!--<sch:assert
                role="ERROR"
                test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type']">&lt;<sch:name/> uuid="<sch:value-of
                    select="@uuid"/>"&gt; MUST have a &lt;prop&gt; element in the FedRAMP namespace</sch:assert>-->

            <sch:assert
                role="WARNING"
                test="oscal:title">&lt;<sch:name/> uuid="<sch:value-of
                    select="@uuid"/>"&gt; SHOULD have a title</sch:assert>

            <sch:assert
                role="ERROR"
                test="oscal:rlink">&lt;<sch:name/> uuid="<sch:value-of
                    select="@uuid"/>"&gt; MUST have an &lt;rlink&gt; element</sch:assert>

            <sch:report
                role="INFO"
                test="$INFO and @uuid = //@href[matches(., '^#')] ! substring-after(., '#')"><sch:value-of
                    select="$path"/> has no reference within the document</sch:report>

        </sch:rule>

        <sch:rule
            context="oscal:back-matter/oscal:resource/oscal:prop[@name = 'type']">
            <sch:assert
                test="@value = $attachment-types">Found unknown attachment type «<sch:value-of
                    select="@value"/>» in <sch:value-of
                    select="
                        if (parent::oscal:resource/oscal:title) then
                            concat('&quot;', parent::oscal:resource/oscal:title, '&quot;')
                        else
                            'untitled'"/> resource</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:back-matter/oscal:resource/oscal:rlink">
            <sch:assert
                role="ERROR"
                test="@href">A &lt;<sch:name/>&gt; element MUST have an href attribute</sch:assert>

            <!-- Both doc-avail() and unparsed-text-available() are failing on arbitrary hrefs -->
            <!--<sch:assert test="unparsed-text-available(@href)">the &lt;<sch:name/>&gt; element href attribute refers to a non-existent
                document</sch:assert>-->

            <!--<sch:assert
                role="WARNING"
                test="$WARNING and @media-type">the &lt;<sch:name/>&gt; element SHOULD have a media-type attribute</sch:assert>-->

        </sch:rule>



    </sch:pattern>

    <sch:pattern>

        <sch:title>Constraints for specific attachments</sch:title>

        <!-- FIXME: a few examples - not complete -->

        <sch:rule
            context="oscal:back-matter"
            see="https://github.com/18F/fedramp-automation/blob/master/documents/Guide_to_OSCAL-based_FedRAMP_System_Security_Plans_(SSP).pdf">

            <!-- Note: The following assertions require a prop in FedRAMP "namespace" -->
            <!-- That is a requirement worthy of discussion -->

            <sch:assert
                role="ERROR"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-citations']]">A FedRAMP
                OSCAL SSP MUST attach the FedRAMP Applicable Laws and Regulations</sch:assert>

            <sch:assert
                role="ERROR"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-acronyms']]">A FedRAMP
                OSCAL SSP MUST attach the FedRAMP Master Acronym and Glossary</sch:assert>

            <sch:assert
                role="ERROR"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-logo']]">A FedRAMP OSCAL
                SSP MUST attach the FedRAMP Master Acronym and Glossary</sch:assert>

            <!-- TODO: ensure multiple Policy and Procedure attachments are present -->
            <sch:assert
                role="ERROR"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = ('Policy', 'Procedure')]]">A
                FedRAMP OSCAL SSP MUST attach Information Security Policies and Procedures</sch:assert>

            <!-- Contrast with the "Separation of Duties Matrix" assertion -->
            <sch:assert
                role="ERROR"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'user-guide']]">A FedRAMP OSCAL
                SSP MUST attach a User Guide</sch:assert>

            <!-- Contrast with the "Separation of Duties Matrix" assertion -->
            <sch:assert
                role="ERROR"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'pia']]">A FedRAMP OSCAL SSP MUST
                attach a Privacy Impact Assessment</sch:assert>

            <!-- Contrast with the "Separation of Duties Matrix" assertion -->
            <sch:assert
                role="ERROR"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'rules-of-behavior']]">A FedRAMP
                OSCAL SSP MUST attach Rules of Behavior</sch:assert>

            <!-- This assertion is currently failing because the target resource lacks a specific type (has just "plan") -->
            <!-- Contrast with the "Separation of Duties Matrix" assertion -->
            <sch:assert
                role="ERROR"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'contingency-plan']]">A FedRAMP
                OSCAL SSP MUST attach a Contingency plan</sch:assert>

            <!-- This assertion is currently failing because the target resource lacks a specific type (has just "plan") -->
            <!-- Contrast with the "Separation of Duties Matrix" assertion -->
            <sch:assert
                role="ERROR"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'configuration-management-plan']]">A
                FedRAMP OSCAL SSP MUST attach a Configuration Management plan</sch:assert>

            <!-- This assertion is currently failing because the target resource lacks a specific type (has just "plan") -->
            <!-- Contrast with the "Separation of Duties Matrix" assertion -->
            <sch:assert
                role="ERROR"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'incident-response-plan']]">A
                FedRAMP OSCAL SSP MUST attach an Incident Response plan</sch:assert>

            <sch:assert
                role="ERROR"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'separation-of-duties-matrix']]">A
                FedRAMP OSCAL SSP MUST attach a Separation of Duties Matrix</sch:assert>

        </sch:rule>

    </sch:pattern>

</sch:schema>
