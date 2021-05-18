<sch:pattern xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:title>Document level rules</sch:title>
    <sch:rule context="/">
        <sch:p>Show distinct names used in props</sch:p>
        <sch:report role="info"
                    test="$INFO">Distinct prop names: 
        <sch:value-of select="string-join(distinct-values(//oscal:prop/@name), ' ')" /></sch:report>
    </sch:rule>
    <sch:rule context="/">
        <sch:let name="id"
                 value="@id" />
        <sch:assert id="duplicate-ids"
                    role="error"
                    test="
                    every $id in //@id
                        satisfies not(@id[. = $id][2])">id 
        <sch:value-of select="@id" />has duplicates</sch:assert>
    </sch:rule>
    <sch:rule context="oscal:*[@uuid]">
        <sch:let name="uuid"
                 value="@uuid" />
        <sch:report id="duplicate-uuids"
                    role="warning"
                    test="oscal:*[@uuid = $uuid][2]">uuid 
        <sch:value-of select="@uuid" />has duplicates</sch:report>
    </sch:rule>
    <sch:rule context="oscal:*[starts-with(@href, '#')]"
              id="intra-document-hrefs-have-target">
        <sch:p>Ensure all intra-document @hrefs have an intra-document target</sch:p>
        <sch:let name="ref"
                 value="substring-after(@href, '#')" />
        <sch:assert id="invalid-href-target"
                    role="error"
                    test="$ref = //@uuid">
        <sch:value-of select="@rel" />
        <sch:name />has invalid intra-document href 
        <sch:value-of select="@href" /></sch:assert>
        <sch:report role="info"
                    test="$INFO and $ref = //@uuid">
        <sch:value-of select="@rel" />
        <sch:name />has valid intra-document href to 
        <sch:value-of select="local-name(//oscal:*[@uuid = $ref])" />
        <sch:value-of select="if (//oscal:*[@uuid = $ref]/oscal:title) then
                                concat('&quot;', //oscal:*[@uuid = $ref]/oscal:title, '&quot;')
                              else
                                $ref" /></sch:report>
    </sch:rule>
</sch:pattern>
