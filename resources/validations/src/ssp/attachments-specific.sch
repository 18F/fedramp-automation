<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:title>Constraints for specific attachments</sch:title>
    <!-- FIXME: a few examples - not complete -->
    <sch:rule context="oscal:back-matter" see="https://github.com/18F/fedramp-automation/blob/master/documents/Guide_to_OSCAL-based_FedRAMP_System_Security_Plans_(SSP).pdf">
        <!-- Note: The following assertions require a prop in FedRAMP "namespace" -->
        <!-- That is a requirement worthy of discussion -->
        <sch:assert id="lacks-fedramp-citations" role="error" test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-citations']]">A
                        FedRAMP OSCAL SSP must attach the FedRAMP Applicable Laws and Regulations</sch:assert>
        <sch:assert id="lacks-fedramp-acronyms" role="error" test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-acronyms']]">A
                        FedRAMP OSCAL SSP must attach the FedRAMP Master Acronym and Glossary</sch:assert>
        <sch:assert id="lacks-fedramp-logo" role="error" test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-logo']]">A
                        FedRAMP OSCAL SSP must attach the FedRAMP Master Acronym and Glossary</sch:assert>

        <!-- TODO: ensure multiple Policy and Procedure attachments are present -->
        <sch:assert role="error" test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = ('Policy', 'Procedure')]]">
                        A FedRAMP OSCAL SSP must attach Information Security Policies and Procedures</sch:assert>

        <!-- Contrast with the "Separation of Duties Matrix" assertion -->
        <sch:assert id="lacks-user-guide" role="error" test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'user-guide']]">A
                        FedRAMP OSCAL SSP must attach a User Guide</sch:assert>
        <!-- Contrast with the "Separation of Duties Matrix" assertion -->
        <sch:assert id="lacks-pia" role="error" test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'pia']]">A FedRAMP OSCAL
                        SSP must attach a Privacy Impact Assessment</sch:assert>
        <!-- Contrast with the "Separation of Duties Matrix" assertion -->
        <sch:assert id="lacks-rules-of-behavior" role="error" test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'rules-of-behavior']]">A
                        FedRAMP OSCAL SSP must attach Rules of Behavior</sch:assert>
        <!-- This assertion is currently failing because the target resource lacks a specific type (has just "plan") -->
        <!-- Contrast with the "Separation of Duties Matrix" assertion -->
        <sch:assert id="lacks-contingency-plan" role="error" test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'contingency-plan']]">A
                        FedRAMP OSCAL SSP must attach a Contingency Plan</sch:assert>
        <!-- This assertion is currently failing because the target resource lacks a specific type (has just "plan") -->
        <!-- Contrast with the "Separation of Duties Matrix" assertion -->
        <sch:assert id="lacks-configuration-management-plan" role="error" test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'configuration-management-plan']]">
                        A FedRAMP OSCAL SSP must attach a Configuration Management Plan</sch:assert>
        <!-- This assertion is currently failing because the target resource lacks a specific type (has just "plan") -->
        <!-- Contrast with the "Separation of Duties Matrix" assertion -->
        <sch:assert id="lacks-incident-response-plan" role="error" test="
                    oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'incident-response-plan']]">
            A FedRAMP OSCAL SSP must attach an Incident Response Plan</sch:assert>
        <sch:assert id="lacks-separation-of-duties-matrix" role="error" test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'separation-of-duties-matrix']]">
                        A FedRAMP OSCAL SSP must attach a Separation of Duties Matrix</sch:assert>
    </sch:rule>
</sch:pattern>
