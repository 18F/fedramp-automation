<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:let name="attachment-types"
             value="doc('../../xml/fedramp_values.xml')//f:value-set[@name = 'attachment-type']//f:enum/@value" />
    <sch:rule context="/oscal:system-security-plan/oscal:back-matter">
        <sch:p>It seems unlikely that most if not all SSP resources require a FedRAMP-specific prop.</sch:p>
        <sch:p>The current fedramp-automation content appears to have presumed that NIST would supply (and be normative for) RMF prop types (NIST
        has/is not) as opposed to FedRAMP prop types.</sch:p>
        <sch:assert test="oscal:resource[prop[@ns = 'https://fedramp.gov/ns/oscal']]">A FedRAMP SSP must include FedRAMP-specific props in
        back-matter resources</sch:assert>
    </sch:rule>
    <sch:rule context="/oscal:system-security-plan/oscal:back-matter/oscal:resource">
        <!-- create a "path" to the context -->
        <sch:let name="path"
                 value="concat(string-join(ancestor-or-self::* ! name(), '/'), ' ', @uuid, ' &quot;', oscal:title, '&quot;')" />
        <!-- the following assertion recapitulates the XML Schema constraint -->
        <sch:assert role="error"
                    test="@uuid">A &lt; 
        <sch:name />&gt; element must have a uuid attribute</sch:assert>
        <!--<sch:assert
                role="error"
                test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type']">&lt;<sch:name/> uuid="<sch:value-of
                    select="@uuid"/>"&gt; must have a &lt;prop&gt; element in the FedRAMP namespace</sch:assert>-->
        <sch:assert id="resource-has-title"
                    role="warning"
                    test="oscal:title">&lt; 
        <sch:name />uuid=" 
        <sch:value-of select="@uuid" />"&gt; SHOULD have a title</sch:assert>
        <sch:assert id="resource-has-rlink"
                    role="error"
                    test="oscal:rlink">&lt; 
        <sch:name />uuid=" 
        <sch:value-of select="@uuid" />"&gt; must have an &lt;rlink&gt; element</sch:assert>
        <sch:assert id="resource-is-referenced"
                    role="info"
                    test="$INFO and @uuid = (//@href[matches(., '^#')] ! substring-after(., '#'))">
        <sch:value-of select="$path" />has no reference within the document</sch:assert>
    </sch:rule>
    <sch:rule context="oscal:back-matter/oscal:resource/oscal:prop[@name = 'type']">
        <sch:assert id="attachment-type-is-valid"
                    test="@value = $attachment-types">Found unknown attachment type « 
        <sch:value-of select="@value" />» in 
        <sch:value-of select="
                        if (parent::oscal:resource/oscal:title) then
                            concat('&quot;', parent::oscal:resource/oscal:title, '&quot;')
                        else
                            'untitled'" />resource</sch:assert>
    </sch:rule>
    <sch:rule context="oscal:back-matter/oscal:resource/oscal:rlink">
        <sch:assert id="rlink-has-href"
                    role="error"
                    test="@href">A &lt; 
        <sch:name />&gt; element must have an href attribute</sch:assert>
        <!-- Both doc-avail() and unparsed-text-available() are failing on arbitrary hrefs -->
        <!--<sch:assert test="unparsed-text-available(@href)">the &lt;<sch:name/>&gt; element href attribute refers to a non-existent
                document</sch:assert>-->
        <!--<sch:assert id="rlink-has-media-type"
                role="warning"
                test="$WARNING and @media-type">the &lt;<sch:name/>&gt; element SHOULD have a media-type attribute</sch:assert>-->
    </sch:rule>
</sch:pattern>
