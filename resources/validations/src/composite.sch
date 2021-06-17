<?xml version="1.0" encoding="UTF-8"?>
<sch:schema
    queryBinding="xslt2"
    xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
    xmlns:oscal="http://csrc.nist.gov/ns/oscal/1.0"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:ns
        prefix="oscal"
        uri="http://csrc.nist.gov/ns/oscal/1.0" />
    <sch:ns
        prefix="oscal"
        uri="http://csrc.nist.gov/ns/oscal/1.0" />
    <sch:ns
        prefix="oscal"
        uri="http://csrc.nist.gov/ns/oscal/1.0" />
    <sch:ns
        prefix="oscal"
        uri="http://csrc.nist.gov/ns/oscal/1.0" />
    <sch:ns
        prefix="oscal"
        uri="http://csrc.nist.gov/ns/oscal/1.0" />
    <sch:ns
        prefix="fedramp-it"
        uri="https://fedramp.gov/ns" />
    <sch:ns
        prefix="fedramp"
        uri="https://fedramp.gov/ns/oscal" />
    <sch:ns
        prefix="fedramp"
        uri="https://fedramp.gov/ns/oscal" />
    <sch:ns
        prefix="fedramp"
        uri="https://fedramp.gov/ns/oscal" />
    <sch:ns
        prefix="fedramp"
        uri="https://fedramp.gov/ns/oscal" />
    <sch:ns
        prefix="oscal"
        uri="http://csrc.nist.gov/ns/oscal/1.0" />
    <sch:ns
        prefix="fedramp"
        uri="https://fedramp.gov/ns/oscal" />
    <sch:ns
        prefix="f"
        uri="https://fedramp.gov/ns/oscal" />
    <!--pattern from file:/Users/gapinski/Projects/github/18F/fedramp-automation/resources/validations/src/ssp/attachments-general.sch-->
    <sch:pattern>
        <!-- gratuitous warnings off by default -->
        <!--<sch:let
            name="WARNING"
            value="false()" />-->
        <!-- gratuitous info off by default -->
        <!--<sch:let
            name="INFO"
            value="false()" />-->
        <sch:let
            name="attachment-types"
            value="doc('file:../../xml/fedramp_values.xml')//f:value-set[@name = 'attachment-type']//f:enum/@value" />
        <sch:rule
            context="/oscal:system-security-plan/oscal:back-matter">
            <sch:p>It seems unlikely that most if not all SSP resources require a FedRAMP-specific prop.</sch:p>
            <sch:p>The current fedramp-automation content appears to have presumed that NIST would supply (and be normative for) RMF prop types (NIST
                has/is not) as opposed to FedRAMP prop types.</sch:p>
            <sch:assert
                test="oscal:resource[prop[@ns = 'https://fedramp.gov/ns/oscal']]">A FedRAMP SSP must include FedRAMP-specific props in back-matter
                resources</sch:assert>
        </sch:rule>
        <sch:rule
            context="/oscal:system-security-plan/oscal:back-matter/oscal:resource">
            <!-- create a "path" to the context -->
            <sch:let
                name="path"
                value="concat(string-join(ancestor-or-self::* ! name(), '/'), ' ', @uuid, ' &#34;', oscal:title, '&#34;')" />
            <!-- the following assertion recapitulates the XML Schema constraint -->
            <sch:assert
                role="error"
                test="@uuid">A &lt;<sch:name />&gt; element must have a uuid attribute</sch:assert>
            <!--<sch:assert
                role="error"
                test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type']">&lt;<sch:name/> uuid="<sch:value-of
                    select="@uuid"/>"&gt; must have a &lt;prop&gt; element in the FedRAMP namespace</sch:assert>-->
            <sch:assert
                id="resource-has-title"
                role="warning"
                test="oscal:title">&lt; <sch:name />uuid=" <sch:value-of
                    select="@uuid" />"&gt; SHOULD have a title</sch:assert>
            <sch:assert
                id="resource-has-rlink"
                role="error"
                test="oscal:rlink">&lt; <sch:name />uuid=" <sch:value-of
                    select="@uuid" />"&gt; must have an &lt;rlink&gt; element</sch:assert>
            <sch:assert
                id="resource-is-referenced"
                role="info"
                test="@uuid = (//@href[matches(., '^#')] ! substring-after(., '#'))">
                <sch:value-of
                    select="$path" />has no reference within the document</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:back-matter/oscal:resource/oscal:prop[@name = 'type']">
            <sch:assert
                id="attachment-type-is-valid"
                test="@value = $attachment-types">Found unknown attachment type « <sch:value-of
                    select="@value" />» in <sch:value-of
                    select="
                        if (parent::oscal:resource/oscal:title) then
                            concat('&#34;', parent::oscal:resource/oscal:title, '&#34;')
                        else
                            'untitled'" />resource</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:back-matter/oscal:resource/oscal:rlink">
            <sch:assert
                id="rlink-has-href"
                role="error"
                test="@href">A &lt; <sch:name />&gt; element must have an href attribute</sch:assert>
            <!-- Both doc-avail() and unparsed-text-available() are failing on arbitrary hrefs -->
            <!--<sch:assert test="unparsed-text-available(@href)">the &lt;<sch:name/>&gt; element href attribute refers to a non-existent
                document</sch:assert>-->
            <!--<sch:assert id="rlink-has-media-type"
                role="warning"
                test="$WARNING and @media-type">the &lt;<sch:name/>&gt; element SHOULD have a media-type attribute</sch:assert>-->
        </sch:rule>
    </sch:pattern>
    <!--pattern from file:/Users/gapinski/Projects/github/18F/fedramp-automation/resources/validations/src/ssp/attachments-base64.sch-->
    <sch:pattern>
        <sch:rule
            context="oscal:back-matter/oscal:resource">
            <sch:assert
                diagnostics="resource-has-base64-diagnostic "
                id="resource-has-base64"
                role="warning"
                test="oscal:base64">A resource should have a base64 element.</sch:assert>
            <doc:original-assertion>
                <sch:name /> should have a base64 element.</doc:original-assertion>
            <sch:assert
                diagnostics="resource-base64-cardinality-diagnostic "
                id="resource-base64-cardinality"
                role="error"
                test="not(oscal:base64[2])">A resource must have only one base64 element.</sch:assert>
            <doc:original-assertion>
                <sch:name /> must not have more than one base64 element.</doc:original-assertion>
        </sch:rule>
        <sch:rule
            context="oscal:back-matter/oscal:resource/oscal:base64">
            <sch:assert
                diagnostics="base64-has-filename-diagnostic "
                id="base64-has-filename"
                role="error"
                test="@filename">A base64 element has a filename attribute</sch:assert>
            <doc:original-assertion>
                <sch:name /> must have filename attribute.</doc:original-assertion>
            <sch:assert
                diagnostics="base64-has-media-type-diagnostic "
                id="base64-has-media-type"
                role="error"
                test="@media-type">A base64 element has a media-type attribute</sch:assert>
            <doc:original-assertion>
                <sch:name /> must have media-type attribute.</doc:original-assertion>
            <!-- TODO: add IANA media type check using https://www.iana.org/assignments/media-types/media-types.xml-->
            <!-- TODO: decide whether to use the IANA resource directly, or cache a local copy -->
            <!-- TODO: determine what media types will be acceptable for FedRAMP SSP submissions -->
            <sch:assert
                diagnostics="base64-has-content-diagnostic "
                id="base64-has-content"
                role="error"
                test="normalize-space() != ''">A base64 element has content.</sch:assert>
            <doc:original-assertion>base64 element must have text content.</doc:original-assertion>
            <!-- FYI: http://expath.org/spec/binary#decode-string handles base64 but Saxon-PE or higher is necessary -->
        </sch:rule>
    </sch:pattern>
    <!--pattern from file:/Users/gapinski/Projects/github/18F/fedramp-automation/resources/validations/src/ssp/attachments-specific.sch-->
    <sch:pattern>
        <sch:title>Constraints for specific attachments</sch:title>
        <sch:rule
            context="oscal:back-matter"
            see="https://github.com/18F/fedramp-automation/blob/master/documents/Guide_to_OSCAL-based_FedRAMP_System_Security_Plans_(SSP).pdf">
            <!-- TODO: ensure multiple Policy and Procedure attachments are present>
        <sch:assert id="lacks-policies-and-procedures" role=" error" test=" oscal:resource[oscal:prop[@ns='https://fedramp.gov/ns/oscal' and @name='type' and @value= ('Policy' ,'Procedure' )]]">
                        A FedRAMP OSCAL SSP must attach Information Security Policies and Procedures</sch:assert -->
            <sch:assert
                id="lacks-fedramp-acronyms"
                role="error"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-acronyms']]">A FedRAMP
                OSCAL SSP must attach the FedRAMP Master Acronym and Glossary</sch:assert>
            <sch:assert
                id="lacks-fedramp-citations"
                role="error"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-citations']]">A FedRAMP
                OSCAL SSP must attach the FedRAMP Applicable Laws and Regulations</sch:assert>
            <sch:assert
                id="lacks-fedramp-logo"
                role="error"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-logo']]">A FedRAMP OSCAL
                SSP must attach the FedRAMP Logo</sch:assert>
            <sch:assert
                id="lacks-user-guide"
                role="error"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'user-guide']]">A FedRAMP OSCAL
                SSP must attach a User Guide</sch:assert>
            <sch:assert
                id="lacks-privacy-impact-assessment"
                role="error"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'privacy-impact-assessment']]"> A
                FedRAMP OSCAL SSP must attach a Privacy Impact Assessment</sch:assert>
            <sch:assert
                id="lacks-rules-of-behavior"
                role="error"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'rules-of-behavior']]">A FedRAMP
                OSCAL SSP must attach Rules of Behavior</sch:assert>
            <sch:assert
                id="lacks-information-system-contingency-plan"
                role="error"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'information-system-contingency-plan']]">
                A FedRAMP OSCAL SSP must attach a Contingency Plan</sch:assert>
            <sch:assert
                id="lacks-configuration-management-plan"
                role="error"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'configuration-management-plan']]">
                A FedRAMP OSCAL SSP must attach a Configuration Management Plan</sch:assert>
            <sch:assert
                id="lacks-incident-response-plan"
                role="error"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'incident-response-plan']]"> A
                FedRAMP OSCAL SSP must attach an Incident Response Plan</sch:assert>
            <sch:assert
                id="lacks-separation-of-duties-matrix"
                role="error"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'separation-of-duties-matrix']]">
                A FedRAMP OSCAL SSP must attach a Separation of Duties Matrix</sch:assert>
        </sch:rule>
    </sch:pattern>
    <!--pattern from file:/Users/gapinski/Projects/github/18F/fedramp-automation/resources/validations/src/ssp/policy-and-procedure.sch-->
    <sch:pattern />
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
                test="descendant::oscal:by-component/oscal:link[@rel = 'policy']">
                <sch:value-of
                    select="local-name()" />
                <sch:value-of
                    select="@control-id" />
                <sch:span
                    class="message"> lacks policy reference(s) (via by-component link)</sch:span>
            </sch:assert>

            <sch:let
                name="policy-hrefs"
                value="distinct-values(descendant::oscal:by-component/oscal:link[@rel = 'policy']/@href ! substring-after(., '#'))" />

            <sch:assert
                id="has-policy-attachment-resource"
                role="error"
                test="
                    every $ref in $policy-hrefs
                        satisfies exists(//oscal:resource[oscal:prop[@name = 'type' and @value = 'policy']][@uuid = $ref])">
                <sch:value-of
                    select="local-name()" />
                <sch:value-of
                    select="@control-id" />
                <sch:span
                    class="message"> lacks policy attachment resource(s) </sch:span>
                <sch:value-of
                    select="string-join($policy-hrefs, ', ')" />
            </sch:assert>

            <!-- TODO: ensure resource has an rlink -->

            <sch:assert
                id="has-procedure-link"
                role="error"
                test="descendant::oscal:by-component/oscal:link[@rel = 'procedure']">
                <sch:value-of
                    select="local-name()" />
                <sch:value-of
                    select="@control-id" />
                <sch:span
                    class="message"> lacks procedure reference(s) (via by-component link)</sch:span>
            </sch:assert>

            <sch:let
                name="procedure-hrefs"
                value="distinct-values(descendant::oscal:by-component/oscal:link[@rel = 'procedure']/@href ! substring-after(., '#'))" />

            <sch:assert
                id="has-procedure-attachment-resource"
                role="error"
                test="
                    (: targets of links exist in the document :)
                    every $ref in $procedure-hrefs
                        satisfies exists(//oscal:resource[oscal:prop[@name = 'type' and @value = 'procedure']][@uuid = $ref])">
                <sch:value-of
                    select="local-name()" />
                <sch:value-of
                    select="@control-id" />
                <sch:span
                    class="message"> lacks procedure attachment resource(s) </sch:span>
                <sch:value-of
                    select="string-join($procedure-hrefs, ', ')" />
            </sch:assert>

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
                    @href = (: all controls except the current :) (//oscal:implemented-requirement[matches(@control-id, '^[a-z]{2}-1$')] except $ir) (: all their @hrefs :)/descendant::oscal:by-component/oscal:link[@rel = 'policy']/@href"><sch:value-of
                    select="@rel" /> document <sch:value-of
                    select="substring-after(@href, '#')" /> is used in other controls (i.e., it is not unique to implemented-requirement <sch:value-of
                    select="$ir/@control-id" />)</sch:report>

        </sch:rule>

    </sch:pattern>
    <!--pattern from file:/Users/gapinski/Projects/github/18F/fedramp-automation/resources/validations/src/ssp/privacy-attachments.sch-->
    <sch:pattern>

        <sch:title>A FedRAMP OSCAL SSP must specify a Privacy Point of Contact</sch:title>

        <sch:rule
            context="oscal:metadata"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 49">

            <sch:assert
                id="has-privacy-poc-role"
                role="error"
                test="/oscal:system-security-plan/oscal:metadata/oscal:role[@id = 'privacy-poc']">A FedRAMP OSCAL SSP must incorporate a Privacy Point
                of Contact role</sch:assert>

            <sch:assert
                id="has-responsible-party-privacy-poc-role"
                role="error"
                test="/oscal:system-security-plan/oscal:metadata/oscal:responsible-party[@role-id = 'privacy-poc']">A FedRAMP OSCAL SSP must declare a
                Privacy Point of Contact responsible party role reference</sch:assert>

            <sch:assert
                id="has-responsible-privacy-poc-party-uuid"
                role="error"
                test="/oscal:system-security-plan/oscal:metadata/oscal:responsible-party[@role-id = 'privacy-poc']/oscal:party-uuid">A FedRAMP OSCAL
                SSP must declare a Privacy Point of Contact responsible party role reference identifying the party by UUID</sch:assert>

            <sch:let
                name="poc-uuid"
                value="/oscal:system-security-plan/oscal:metadata/oscal:responsible-party[@role-id = 'privacy-poc']/oscal:party-uuid" />

            <sch:assert
                id="has-privacy-poc"
                role="error"
                test="/oscal:system-security-plan/oscal:metadata/oscal:party[@uuid = $poc-uuid]">A FedRAMP OSCAL SSP must define a Privacy Point of
                Contact</sch:assert>

        </sch:rule>

    </sch:pattern>
    <sch:pattern>

        <sch:title>A FedRAMP OSCAL SSP may need to incorporate a PIA and possibly a SORN</sch:title>

        <!-- The "PTA" appears to be just a few questions, not an attachment -->

        <sch:rule
            context="oscal:prop[@name = 'privacy-sensitive'] | oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and matches(@name, '^pta-\d$')]"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 51">

            <sch:assert
                id="has-correct-yes-or-no-answer"
                test="current()/@value = ('yes', 'no')">incorrect value: should be "yes" or "no"</sch:assert>

        </sch:rule>

        <sch:rule
            context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 51">

            <sch:assert
                id="has-privacy-sensitive-designation"
                role="error"
                test="oscal:prop[@name = 'privacy-sensitive']">Lacks privacy-sensitive designation</sch:assert>

            <sch:assert
                id="has-pta-question-1"
                role="error"
                test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-1']">Missing PTA/PIA qualifying question
                #1.</sch:assert>

            <sch:assert
                id="has-pta-question-2"
                role="error"
                test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-2']">Missing PTA/PIA qualifying question
                #2.</sch:assert>

            <sch:assert
                id="has-pta-question-3"
                role="error"
                test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-3']">Missing PTA/PIA qualifying question
                #3.</sch:assert>

            <sch:assert
                id="has-pta-question-4"
                role="error"
                test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-4']">Missing PTA/PIA qualifying question
                #4.</sch:assert>

            <sch:assert
                id="has-all-pta-questions"
                test="
                    every $name in ('pta-1', 'pta-2', 'pta-3', 'pta-4')
                        satisfies exists(oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = $name])">One
                or more of the four PTA questions is missing</sch:assert>

            <sch:assert
                id="has-correct-pta-question-cardinality"
                test="
                    not(some $name in ('pta-1', 'pta-2', 'pta-3', 'pta-4')
                        satisfies exists(oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = $name][2]))">One
                or more of the four PTA questions is a duplicate</sch:assert>

        </sch:rule>

        <sch:rule
            context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 51">

            <sch:assert
                id="has-sorn"
                role="error"
                test="/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-4' and @value = 'yes'] and oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'sorn-id' and @value != '']">Missing
                SORN ID</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:back-matter"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 51">

            <sch:assert
                id="has-pia"
                role="error"
                test="
                    every $answer in //oscal:system-information/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and matches(@name, '^pta-\d$')]
                        satisfies $answer = 'no' or oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'pia']] (: a PIA is attached :)">This
                FedRAMP OSCAL SSP must incorporate a Privacy Impact Analysis</sch:assert>

        </sch:rule>
    </sch:pattern>
    <!--pattern from file:/Users/gapinski/Projects/github/18F/fedramp-automation/resources/validations/src/ssp/system-inventory.sch-->
    <sch:pattern>

        <sch:let
            name="fedramp-values"
            value="doc('file:../../xml/fedramp_values.xml')" />

        <sch:title>A FedRAMP OSCAL SSP must specify system inventory items</sch:title>

        <sch:rule
            context="/oscal:system-security-plan/oscal:system-implementation"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans pp52-60">

            <sch:p>A FedRAMP OSCAL SSP must populate the system inventory</sch:p>

            <!-- FIXME: determine if essential items are present -->
            <doc:rule>A FedRAMP OSCAL SSP must incorporate inventory-item elements</doc:rule>

            <sch:assert
                diagnostics="has-inventory-items-diagnostic"
                id="has-inventory-items"
                role="error"
                test="oscal:inventory-item">A FedRAMP OSCAL SSP must incorporate inventory-item elements.</sch:assert>

        </sch:rule>

        <sch:title>FedRAMP SSP value constraints</sch:title>

        <sch:rule
            context="oscal:prop[@name = 'asset-id']">
            <sch:p>asset-id property is unique</sch:p>
            <sch:assert
                diagnostics="has-unique-asset-id-diagnostic"
                id="has-unique-asset-id"
                role="error"
                test="count(//oscal:prop[@name = 'asset-id'][@value = current()/@value]) = 1">asset-id must be unique.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:prop[@name = 'asset-type']">
            <sch:p>asset-type property has an allowed value</sch:p>
            <sch:let
                name="asset-types"
                value="$fedramp-values//fedramp:value-set[@name = 'asset-type']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="has-allowed-asset-type-diagnostic"
                id="has-allowed-asset-type"
                role="warning"
                test="@value = $asset-types">asset-type property has an allowed value.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:prop[@name = 'virtual']">
            <sch:p>virtual property has an allowed value</sch:p>
            <sch:let
                name="virtuals"
                value="$fedramp-values//fedramp:value-set[@name = 'virtual']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="has-allowed-virtual-diagnostic"
                id="has-allowed-virtual"
                role="error"
                test="@value = $virtuals">virtual property has an allowed value.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:prop[@name = 'public']">
            <sch:p>public property has an allowed value</sch:p>
            <sch:let
                name="publics"
                value="$fedramp-values//fedramp:value-set[@name = 'public']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="has-allowed-public-diagnostic"
                id="has-allowed-public"
                role="error"
                test="@value = $publics">public property has an allowed value.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:prop[@name = 'allows-authenticated-scan']">
            <sch:p>allows-authenticated-scan property has an allowed value</sch:p>
            <sch:let
                name="allows-authenticated-scans"
                value="$fedramp-values//fedramp:value-set[@name = 'allows-authenticated-scan']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="has-allowed-allows-authenticated-scan-diagnostic"
                id="has-allowed-allows-authenticated-scan"
                role="error"
                test="@value = $allows-authenticated-scans">allows-authenticated-scan property has an allowed value.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:prop[@name = 'is-scanned']">
            <sch:p>is-scanned property has an allowed value</sch:p>
            <sch:let
                name="is-scanneds"
                value="$fedramp-values//fedramp:value-set[@name = 'is-scanned']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="has-allowed-is-scanned-diagnostic"
                id="has-allowed-is-scanned"
                role="error"
                test="@value = $is-scanneds">is-scanned property has an allowed value.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'scan-type']">
            <sch:p>scan-type property has an allowed value</sch:p>
            <sch:let
                name="scan-types"
                value="$fedramp-values//fedramp:value-set[@name = 'scan-type']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="inventory-item-has-allowed-scan-type-diagnostic"
                id="inventory-item-has-allowed-scan-type"
                role="error"
                test="@value = $scan-types">scan-type property has an allowed value.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:component">
            <sch:p>component has an allowed type</sch:p>
            <sch:let
                name="component-types"
                value="$fedramp-values//fedramp:value-set[@name = 'component-type']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="component-has-allowed-type-diagnostic"
                id="component-has-allowed-type"
                role="error"
                test="@type = $component-types">component has an allowed type.</sch:assert>

        </sch:rule>

        <sch:title>FedRAMP OSCAL SSP inventory items</sch:title>

        <sch:rule
            context="oscal:inventory-item"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans pp52-60">

            <sch:p>All FedRAMP OSCAL SSP inventory-item elements</sch:p>

            <sch:p>inventory-item has a uuid</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-uuid-diagnostic"
                id="inventory-item-has-uuid"
                role="error"
                test="@uuid">inventory-item has a uuid.</sch:assert>

            <sch:p>inventory-item has an asset-id</sch:p>
            <sch:assert
                diagnostics="has-asset-id-diagnostic"
                id="has-asset-id"
                role="error"
                test="oscal:prop[@name = 'asset-id']">inventory-item has an asset-id.</sch:assert>

            <sch:p>inventory-item has only one asset-id</sch:p>
            <sch:assert
                diagnostics="has-one-asset-id-diagnostic"
                id="has-one-asset-id"
                role="error"
                test="count(oscal:prop[@name = 'asset-id']) = 1">inventory-item has only one asset-id.</sch:assert>

            <sch:p>inventory-item has an asset-type</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-asset-type-diagnostic"
                id="inventory-item-has-asset-type"
                role="error"
                test="oscal:prop[@name = 'asset-type']">inventory-item has an asset-type.</sch:assert>

            <sch:p>inventory-item has only one asset-type</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-one-asset-type-diagnostic"
                id="inventory-item-has-one-asset-type"
                role="error"
                test="count(oscal:prop[@name = 'asset-type']) = 1">inventory-item has only one asset-type.</sch:assert>

            <sch:p>inventory-item has virtual property</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-virtual-diagnostic"
                id="inventory-item-has-virtual"
                role="error"
                test="oscal:prop[@name = 'virtual']">inventory-item has virtual property.</sch:assert>

            <sch:p>inventory-item has only one virtual property</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-one-virtual-diagnostic"
                id="inventory-item-has-one-virtual"
                role="error"
                test="count(oscal:prop[@name = 'virtual']) = 1">inventory-item has only one virtual property.</sch:assert>

            <sch:p>inventory-item has public property</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-public-diagnostic"
                id="inventory-item-has-public"
                role="error"
                test="oscal:prop[@name = 'public']">inventory-item has public property.</sch:assert>

            <sch:p>inventory-item has only one public property</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-one-public-diagnostic"
                id="inventory-item-has-one-public"
                role="error"
                test="count(oscal:prop[@name = 'public']) = 1">inventory-item has only one public property.</sch:assert>

            <sch:p>inventory-item has scan-type property</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-scan-type-diagnostic"
                id="inventory-item-has-scan-type"
                role="error"
                test="oscal:prop[@name = 'scan-type']">inventory-item has scan-type property.</sch:assert>

            <sch:p>inventory-item has only one scan-type property</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-one-scan-type-diagnostic"
                id="inventory-item-has-one-scan-type"
                role="error"
                test="count(oscal:prop[@name = 'scan-type']) = 1">inventory-item has only one scan-type property.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:inventory-item[oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')]]">

            <sch:p>"infrastructure" inventory-item has allows-authenticated-scan</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-allows-authenticated-scan-diagnostic"
                id="inventory-item-has-allows-authenticated-scan"
                role="error"
                test="oscal:prop[@name = 'allows-authenticated-scan']">"infrastructure" inventory-item has allows-authenticated-scan.</sch:assert>

            <sch:p>"infrastructure" inventory-item has only one allows-authenticated-scan property</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-one-allows-authenticated-scan-diagnostic"
                id="inventory-item-has-one-allows-authenticated-scan"
                role="error"
                test="count(oscal:prop[@name = 'allows-authenticated-scan']) = 1">inventory-item has only one one-allows-authenticated-scan
                property.</sch:assert>

            <sch:p>"infrastructure" inventory-item has baseline-configuration-name</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-baseline-configuration-name-diagnostic"
                id="inventory-item-has-baseline-configuration-name"
                role="error"
                test="oscal:prop[@name = 'baseline-configuration-name']">"infrastructure" inventory-item has baseline-configuration-name.</sch:assert>

            <sch:p>"infrastructure" inventory-item has only one baseline-configuration-name</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-one-baseline-configuration-name-diagnostic"
                id="inventory-item-has-one-baseline-configuration-name"
                role="error"
                test="count(oscal:prop[@name = 'baseline-configuration-name']) = 1">"infrastructure" inventory-item has only one
                baseline-configuration-name.</sch:assert>

            <sch:p>"infrastructure" inventory-item has a vendor-name property</sch:p>
            <!-- FIXME: Documentation says vendor name is in FedRAMP @ns -->
            <sch:assert
                diagnostics="inventory-item-has-vendor-name-diagnostic"
                id="inventory-item-has-vendor-name"
                role="error"
                test="oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'vendor-name']">"infrastructure" inventory-item has a
                vendor-name property.</sch:assert>

            <sch:p>"infrastructure" inventory-item has a vendor-name property</sch:p>
            <!-- FIXME: Documentation says vendor name is in FedRAMP @ns -->
            <sch:assert
                diagnostics="inventory-item-has-one-vendor-name-diagnostic"
                id="inventory-item-has-one-vendor-name"
                role="error"
                test="not(oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'vendor-name'][2])">"infrastructure" inventory-item has
                only one vendor-name property.</sch:assert>

            <sch:p>"infrastructure" inventory-item has a hardware-model property</sch:p>
            <!-- FIXME: perversely, hardware-model is not in FedRAMP @ns -->
            <sch:assert
                diagnostics="inventory-item-has-hardware-model-diagnostic"
                id="inventory-item-has-hardware-model"
                role="error"
                test="oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'hardware-model']">"infrastructure" inventory-item has a
                hardware-model property.</sch:assert>

            <sch:p>"infrastructure" inventory-item has one hardware-model property</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-one-hardware-model-diagnostic"
                id="inventory-item-has-one-hardware-model"
                role="error"
                test="not(oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'hardware-model'][2])">"infrastructure" inventory-item has
                only one hardware-model property.</sch:assert>

            <sch:p>"infrastructure" inventory-item has is-scanned property</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-is-scanned-diagnostic"
                id="inventory-item-has-is-scanned"
                role="error"
                test="oscal:prop[@name = 'is-scanned']">"infrastructure" inventory-item has is-scanned property.</sch:assert>

            <sch:assert
                diagnostics="inventory-item-has-one-is-scanned-diagnostic"
                id="inventory-item-has-one-is-scanned"
                role="error"
                test="not(oscal:prop[@name = 'is-scanned'][2])">"infrastructure" inventory-item has only one is-scanned property.</sch:assert>

            <sch:p>has a scan-type property</sch:p>
            <!-- FIXME: DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 53 has typo -->
        </sch:rule>

        <sch:rule
            context="oscal:inventory-item[oscal:prop[@name = 'asset-type']/@value = ('software', 'database')]">
            <!-- FIXME: Software/Database Vendor -->

            <sch:p>"software or database" inventory-item has software-name property</sch:p>
            <!-- FIXME: vague asset categories -->

            <sch:assert
                diagnostics="inventory-item-has-software-name-diagnostic"
                id="inventory-item-has-software-name"
                role="error"
                test="oscal:prop[@name = 'software-name']">"software or database" inventory-item has software-name property.</sch:assert>

            <sch:assert
                diagnostics="inventory-item-has-one-software-name-diagnostic"
                id="inventory-item-has-one-software-name"
                role="error"
                test="not(oscal:prop[@name = 'software-name'][2])">"software or database" inventory-item has software-name property.</sch:assert>

            <sch:p>"software or database" inventory-item has software-version property</sch:p>
            <!-- FIXME: vague asset categories -->

            <sch:assert
                diagnostics="inventory-item-has-software-version-diagnostic"
                id="inventory-item-has-software-version"
                role="error"
                test="oscal:prop[@name = 'software-version']">"software or database" inventory-item has software-version property.</sch:assert>

            <sch:assert
                diagnostics="inventory-item-has-one-software-version-diagnostic"
                id="inventory-item-has-one-software-version"
                role="error"
                test="not(oscal:prop[@name = 'software-version'][2])">"software or database" inventory-item has one software-version
                property.</sch:assert>

            <sch:p>"software or database" inventory-item has function</sch:p>
            <!-- FIXME: vague asset categories -->
            <sch:assert
                diagnostics="inventory-item-has-function-diagnostic"
                id="inventory-item-has-function"
                role="error"
                test="oscal:prop[@name = 'function']">"software or database" inventory-item has function property.</sch:assert>

            <sch:assert
                diagnostics="inventory-item-has-one-function-diagnostic"
                id="inventory-item-has-one-function"
                role="error"
                test="not(oscal:prop[@name = 'function'][2])">"software or database" inventory-item has one function property.</sch:assert>

        </sch:rule>
        <sch:title>FedRAMP OSCAL SSP components</sch:title>

        <sch:rule
            context="/oscal:system-security-plan/oscal:system-implementation/oscal:component[(: a component referenced by any inventory-item :)@uuid = //oscal:inventory-item/oscal:implemented-component/@component-uuid]"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 54">

            <sch:p>A FedRAMP OSCAL SSP component</sch:p>

            <sch:assert
                diagnostics="component-has-asset-type-diagnostic"
                id="component-has-asset-type"
                role="error"
                test="oscal:prop[@name = 'asset-type']">component has an asset type.</sch:assert>

            <sch:assert
                diagnostics="component-has-one-asset-type-diagnostic"
                id="component-has-one-asset-type"
                role="error"
                test="oscal:prop[@name = 'asset-type']">component has one asset type.</sch:assert>

        </sch:rule>
    </sch:pattern>
    <!--pattern from file:/Users/gapinski/Projects/github/18F/fedramp-automation/resources/validations/src/ssp/misc.sch-->
    <sch:pattern>

        <sch:rule
            context="oscal:system-implementation"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 62">

            <sch:p>There must be a component that represents the entire system itself. It should be the only component with the component-type set to
                "system".</sch:p>

            <sch:assert
                id="has-system-component"
                role="error"
                test="oscal:component[@type = 'system']">Missing system component</sch:assert>

            <!-- required @uuid is defined in XML Schema -->

        </sch:rule>


        <sch:rule
            context="oscal:system-characteristics"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 9">

            <sch:p>Information System Name, Title, and FedRAMP Identifier</sch:p>

            <sch:assert
                id="has-system-id"
                role="error"
                test="oscal:system-id[@identifier-type = 'https://fedramp.gov/']">Missing system-id</sch:assert>

            <sch:assert
                id="has-system-name"
                role="error"
                test="oscal:system-name">Missing system-name</sch:assert>

            <sch:assert
                id="has-system-name-short"
                role="error"
                test="oscal:system-name-short">Missing system-name-short</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:system-characteristics"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 10">

            <sch:p>Information System Categorization and FedRAMP Baselines</sch:p>

            <sch:assert
                test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'authorization-type' and @value = ('fedramp-jab', 'fedramp-agency', 'fedramp-li-saas')]">Missing
                FedRAMP authorization type</sch:assert>

            <sch:let
                name="security-sensitivity-levels"
                value="doc('../../xml/fedramp-values.xml')//fedramp:value-set[@name = 'security-sensitivity-level']//fedramp:enum/@value" />

            <sch:assert
                test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'security-sensitivity-level' and @value = $security-sensitivity-levels]">Missing
                security-sensitivity-level</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:system-information/descendant::oscal:information-type-id"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 11">

            <sch:p>Information Types</sch:p>

            <sch:let
                name="information-types"
                value="doc('file:../../xml/information-types.xml')" />

            <!-- note the variant namespace and associated prefix -->
            <sch:assert
                test="current()[. = $information-types//fedramp-it:information-type/@id]">Invalid information type</sch:assert>

        </sch:rule>

    </sch:pattern>
    <sch:diagnostics>
        <!--diagnostics from file:/Users/gapinski/Projects/github/18F/fedramp-automation/resources/validations/src/ssp/attachments-general.sch -->
        <!--diagnostics from file:/Users/gapinski/Projects/github/18F/fedramp-automation/resources/validations/src/ssp/attachments-base64.sch -->
        <sch:diagnostic
            doc:assertion="resource-has-base64"
            id="resource-has-base64-diagnostic"
            xmlns="http://csrc.nist.gov/ns/oscal/1.0">
            <sch:value-of
                select="name()" /> should have a base64 element.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="resource-base64-cardinality"
            id="resource-base64-cardinality-diagnostic"
            xmlns="http://csrc.nist.gov/ns/oscal/1.0">
            <sch:value-of
                select="name()" /> must not have more than one base64 element.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="base64-has-filename"
            id="base64-has-filename-diagnostic"
            xmlns="http://csrc.nist.gov/ns/oscal/1.0">
            <sch:value-of
                select="name()" /> must have a filename attribute.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="base64-has-media-type"
            id="base64-has-media-type-diagnostic"
            xmlns="http://csrc.nist.gov/ns/oscal/1.0">
            <sch:value-of
                select="name()" /> must have a media-type attribute.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="base64-has-content"
            id="base64-has-content-diagnostic"
            xmlns="http://csrc.nist.gov/ns/oscal/1.0"><sch:value-of
                select="name()" /> must have content.</sch:diagnostic>
        <!--diagnostics from file:/Users/gapinski/Projects/github/18F/fedramp-automation/resources/validations/src/ssp/attachments-specific.sch -->
        <!--diagnostics from file:/Users/gapinski/Projects/github/18F/fedramp-automation/resources/validations/src/ssp/policy-and-procedure.sch -->
        <!--diagnostics from file:/Users/gapinski/Projects/github/18F/fedramp-automation/resources/validations/src/ssp/privacy-attachments.sch -->
        <!--diagnostics from file:/Users/gapinski/Projects/github/18F/fedramp-automation/resources/validations/src/ssp/system-inventory.sch -->

        <!--<sch:diagnostic
            id="XPath-diagnostic">XPath: The context for this error is <sch:value-of
                select="replace(path(), 'Q\{[^\}]+\}', '')" />
        </sch:diagnostic>-->

        <sch:diagnostic
            doc:assertion="has-inventory-items"
            id="has-inventory-items-diagnostic">A FedRAMP OSCAL SSP must incorporate inventory-item elements.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="has-unique-asset-id"
            id="has-unique-asset-id-diagnostic">This asset id <sch:value-of
                select="@asset-id" /> is not unique. An asset id must be unique within the scope of a FedRAMP OSCAL SSP document.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="has-allowed-asset-type"
            id="has-allowed-asset-type-diagnostic">
            <sch:value-of
                select="name()" /> should have a FedRAMP asset type <sch:value-of
                select="string-join($asset-types, ' ∨ ')" /> (not "<sch:value-of
                select="@value" />").</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="has-allowed-virtual"
            id="has-allowed-virtual-diagnostic">
            <sch:value-of
                select="name()" /> must have an allowed value <sch:value-of
                select="string-join($virtuals, ' ∨ ')" /> (not "<sch:value-of
                select="@value" />").</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="has-allowed-public"
            id="has-allowed-public-diagnostic">
            <sch:value-of
                select="name()" /> must have an allowed value <sch:value-of
                select="string-join($publics, ' ∨ ')" /> (not "<sch:value-of
                select="@value" />").</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="has-allowed-allows-authenticated-scan"
            id="has-allowed-allows-authenticated-scan-diagnostic">
            <sch:value-of
                select="name()" /> must have an allowed value <sch:value-of
                select="string-join($allows-authenticated-scans, ' ∨ ')" /> (not "<sch:value-of
                select="@value" />").</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="has-allowed-is-scanned"
            id="has-allowed-is-scanned-diagnostic">
            <sch:value-of
                select="name()" /> must have an allowed value <sch:value-of
                select="string-join($is-scanneds, ' ∨ ')" /> (not "<sch:value-of
                select="@value" />").</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-allowed-scan-type"
            id="inventory-item-has-allowed-scan-type-diagnostic">
            <sch:value-of
                select="name()" /> must have an allowed value <sch:value-of
                select="string-join($scan-types, ' ∨ ')" /> (not "<sch:value-of
                select="@value" />").</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="component-has-allowed-type"
            id="component-has-allowed-type-diagnostic">
            <sch:value-of
                select="name()" /> must have an allowed component type <sch:value-of
                select="string-join($component-types, ' ∨ ')" /> (not "<sch:value-of
                select="@type" />").</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-uuid"
            id="inventory-item-has-uuid-diagnostic">
            <sch:value-of
                select="name()" /> must have a uuid attribute.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="has-asset-id"
            id="has-asset-id-diagnostic">
            <sch:value-of
                select="name()" /> must have an asset-id property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="has-one-asset-id"
            id="has-one-asset-id-diagnostic">
            <sch:value-of
                select="name()" /> must have only one asset-id property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-asset-type"
            id="inventory-item-has-asset-type-diagnostic">
            <sch:value-of
                select="name()" /> must have an asset-type property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-one-asset-type"
            id="inventory-item-has-one-asset-type-diagnostic">
            <sch:value-of
                select="name()" /> must have only one asset-type property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-virtual"
            id="inventory-item-has-virtual-diagnostic">
            <sch:value-of
                select="name()" /> must have virtual property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-one-virtual"
            id="inventory-item-has-one-virtual-diagnostic">
            <sch:value-of
                select="name()" /> must have only one virtual property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-public"
            id="inventory-item-has-public-diagnostic">
            <sch:value-of
                select="name()" /> must have public property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-one-public"
            id="inventory-item-has-one-public-diagnostic">
            <sch:value-of
                select="name()" /> must have only one public property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-scan-type"
            id="inventory-item-has-scan-type-diagnostic">
            <sch:value-of
                select="name()" /> must have scan-type property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-one-scan-type"
            id="inventory-item-has-one-scan-type-diagnostic">
            <sch:value-of
                select="name()" /> must have only one scan-type property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-allows-authenticated-scan"
            id="inventory-item-has-allows-authenticated-scan-diagnostic">
            <sch:value-of
                select="name()" /> must have allows-authenticated-scan property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-one-allows-authenticated-scan"
            id="inventory-item-has-one-allows-authenticated-scan-diagnostic">
            <sch:value-of
                select="name()" /> must have only one allows-authenticated-scan property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-baseline-configuration-name"
            id="inventory-item-has-baseline-configuration-name-diagnostic">
            <sch:value-of
                select="name()" /> must have baseline-configuration-name property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-one-baseline-configuration-name"
            id="inventory-item-has-one-baseline-configuration-name-diagnostic">
            <sch:value-of
                select="name()" /> must have only one baseline-configuration-name property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-vendor-name"
            id="inventory-item-has-vendor-name-diagnostic">
            <sch:value-of
                select="name()" /> must have a vendor-name property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-one-vendor-name"
            id="inventory-item-has-one-vendor-name-diagnostic">
            <sch:value-of
                select="name()" /> must have only one vendor-name property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-hardware-model"
            id="inventory-item-has-hardware-model-diagnostic">
            <sch:value-of
                select="name()" /> must have a hardware-model property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-one-hardware-model"
            id="inventory-item-has-one-hardware-model-diagnostic">
            <sch:value-of
                select="name()" /> must have only one hardware-model property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-is-scanned"
            id="inventory-item-has-is-scanned-diagnostic">
            <sch:value-of
                select="name()" /> must have is-scanned property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-one-is-scanned"
            id="inventory-item-has-one-is-scanned-diagnostic">
            <sch:value-of
                select="name()" /> must have only one is-scanned property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-software-name"
            id="inventory-item-has-software-name-diagnostic">
            <sch:value-of
                select="name()" /> must have software-name property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-one-software-name"
            id="inventory-item-has-one-software-name-diagnostic">
            <sch:value-of
                select="name()" /> must have only one software-name property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-software-version"
            id="inventory-item-has-software-version-diagnostic">
            <sch:value-of
                select="name()" /> must have software-version property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-one-software-version"
            id="inventory-item-has-one-software-version-diagnostic">
            <sch:value-of
                select="name()" /> must have only one software-version property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-function"
            id="inventory-item-has-function-diagnostic">
            <sch:value-of
                select="name()" /> "<sch:value-of
                select="oscal:prop[@name = 'asset-type']/@value" />" must have function property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-one-function"
            id="inventory-item-has-one-function-diagnostic">
            <sch:value-of
                select="name()" /> "<sch:value-of
                select="oscal:prop[@name = 'asset-type']/@value" />" must have only one function property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="component-has-asset-type"
            id="component-has-asset-type-diagnostic">
            <sch:value-of
                select="name()" /> must have an asset-type property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="component-has-one-asset-type"
            id="component-has-one-asset-type-diagnostic">
            <sch:value-of
                select="name()" /> must have only one asset-type property.</sch:diagnostic>

        <!--diagnostics from file:/Users/gapinski/Projects/github/18F/fedramp-automation/resources/validations/src/ssp/misc.sch -->
    </sch:diagnostics>
</sch:schema>
