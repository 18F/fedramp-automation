<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:title>Constraints for specific attachments</sch:title>
    <sch:rule context="oscal:back-matter"
              see="https://github.com/18F/fedramp-automation/blob/master/documents/Guide_to_OSCAL-based_FedRAMP_System_Security_Plans_(SSP).pdf">
        <!-- TODO: ensure multiple Policy and Procedure attachments are present>
        <sch:assert id="lacks-policies-and-procedures" role=" error" test=" oscal:resource[oscal:prop[@ns='https://fedramp.gov/ns/oscal' and @name='type' and @value= ('Policy' ,'Procedure' )]]">
                        A FedRAMP OSCAL SSP must attach Information Security Policies and Procedures</sch:assert -->
        <sch:assert id="lacks-fedramp-acronyms"
                    role="error"
                    test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-acronyms']]">A
                    FedRAMP OSCAL SSP must attach the FedRAMP Master Acronym and Glossary</sch:assert>
        <sch:assert id="lacks-fedramp-citations"
                    role="error"
                    test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-citations']]">A
                    FedRAMP OSCAL SSP must attach the FedRAMP Applicable Laws and Regulations</sch:assert>
        <sch:assert id="lacks-fedramp-logo"
                    role="error"
                    test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-logo']]">A FedRAMP
                    OSCAL SSP must attach the FedRAMP Logo</sch:assert>
        <sch:assert id="lacks-user-guide"
                    role="error"
                    test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'user-guide']]">A FedRAMP
                    OSCAL SSP must attach a User Guide</sch:assert>
        <sch:assert id="lacks-privacy-impact-assessment"
                    role="error"
                    test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'privacy-impact-assessment']]">
                    A FedRAMP OSCAL SSP must attach a Privacy Impact Assessment</sch:assert>
        <sch:assert id="lacks-rules-of-behavior"
                    role="error"
                    test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'rules-of-behavior']]">A
                    FedRAMP OSCAL SSP must attach Rules of Behavior</sch:assert>
        <sch:assert id="lacks-information-system-contingency-plan"
                    role="error"
                    test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'information-system-contingency-plan']]">
        A FedRAMP OSCAL SSP must attach a Contingency Plan</sch:assert>
        <sch:assert id="lacks-configuration-management-plan"
                    role="error"
                    test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'configuration-management-plan']]">
                    A FedRAMP OSCAL SSP must attach a Configuration Management Plan</sch:assert>
        <sch:assert id="lacks-incident-response-plan"
                    role="error"
                    test="
                    oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'incident-response-plan']]">
        A FedRAMP OSCAL SSP must attach an Incident Response Plan</sch:assert>
        <sch:assert id="lacks-separation-of-duties-matrix"
                    role="error"
                    test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'separation-of-duties-matrix']]">
                    A FedRAMP OSCAL SSP must attach a Separation of Duties Matrix</sch:assert>
    </sch:rule>
</sch:pattern>
