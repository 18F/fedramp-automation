<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml">
    
    <sch:ns prefix="o" uri="http://csrc.nist.gov/ns/oscal/1.0"/>
    <sch:ns prefix="f" uri="https://fedramp.gov/ns/oscal"/>
    
    <!-- This Schematron shows XSLT mix-in, which we can do since Schematron is implemented as a 'shell'
         for an XSLT transformation. The Schematron processor must have $allow-other 'true'. -->
    
    <!-- XSLT variable has as='element()*' to bind it to an element set in the OSCAL namespace   -->
    <xsl:variable name="control-list" as="element()*" xmlns="http://csrc.nist.gov/ns/oscal/1.0">
        <control>ac-1</control>
        <control>ac-2</control>
        <control>ac-2.1</control>
        <control>XYZ</control>
    </xsl:variable>
        
    <sch:let name="FedRAMP-lookup"     value="document('../../../baselines/xml/FedRAMP_LOW-baseline-resolved-profile_catalog.xml')"/>
    <sch:let name="FedRAMP-value-sets" value="$FedRAMP-lookup/*/f:value-set"/>
    
    
    <sch:let name="diagnostic" value="true()"/>
    
    <sch:pattern>
        <sch:rule id="coverage-checks" context="o:system-security-plan">
            <sch:assert test="exists($FedRAMP-lookup)">No FedRAMP values set lookup file found.</sch:assert>
                <sch:report test="exists($FedRAMP-lookup) and empty($FedRAMP-value-sets)">no values sets found</sch:report>
            <sch:report test="$diagnostic"><xsl:value-of select="$FedRAMP-lookup/*/*/name()" separator=", "/></sch:report>
            <sch:let name="implementations" value=".//o:implemented-requirement"/>
            <sch:let name="missing" value="$control-list[not(.=$implementations/@control-id)]"/>
            <!-- Report the $missing if there are none. -->
            <sch:assert test="empty($missing)">We are missing coverage for <xsl:apply-templates select="$missing" mode="report-missing"/>.</sch:assert>
    
            <sch:assert test="exists($implementations)">[S001]: No implemented requirements are given in this SSP.</sch:assert>
            <sch:report test="exists($implementations)">This SSP gives <sch:value-of select="count($implementations)"/> implemented requirement<sch:value-of select="'s'[exists($implementations)]"/>.</sch:report>
            
        </sch:rule>
        <sch:rule id="requirement-checks" context="o:implemented-requirement">
            <sch:let name="okay-implementation-status-values" value="$FedRAMP-value-sets[@name='control-implementation-status']/f:allowed-values/f:enum/@value"/>
            <sch:report test="$diagnostic"><xsl:value-of select="exists($FedRAMP-value-sets[@name='control-implementation-status']/f:allowed-values)"/></sch:report>
            <prop name="implementation-status">implemented</prop>
            <sch:let name="given-status" value="o:prop[o:with-oscal-ns(.)][@name='implementation-status']"/>
            <sch:assert test="exists($given-status)">[R001]: <sch:name/> does not give an implementation status (prop[@name='implementation-status'])</sch:assert>
            <sch:assert test="($given-status = $okay-implementation-status-values) or empty($given-status)">[R002]: <sch:name/> implementation status is unknown: we recognize only 
                <sch:value-of select="$okay-implementation-status-values => o:or-sequence()"/></sch:assert>
            <sch:report test="count($given-status) gt 1">[R003]: More than one implementation status is given</sch:report>
            <sch:report role="info" test="count($given-status) eq 1">[S001:<sch:value-of select="upper-case($given-status)"/>:<sch:value-of select="@control-id"/>] control '<sch:value-of select="@control-id"/>' has status '<sch:value-of select="$given-status"/>'  (<sch:value-of select="@uuid"/>)</sch:report>
        </sch:rule>
        
    </sch:pattern>
    
    <!-- Returns true if @ns is given as/for OSCAL, or not given  -->
    <xsl:function name="o:with-oscal-ns" as="xs:boolean">
        <xsl:param name="who" as="node()"/>
        <xsl:sequence select="empty($who/@ns) or $who/@ns='http://csrc.nist.gov/ns/oscal'"/>
    </xsl:function>
    
    <xsl:function name="o:or-sequence" as="xs:string">
        <xsl:param name="items" as="item()*"/>
        <xsl:for-each select="$items ! ('''' || string(.) || '''')">
            <xsl:if test="position() gt 1 and not(position() eq last())">, </xsl:if>
            <xsl:if test="position() gt 1 and position() eq last()"> or </xsl:if>
            <xsl:sequence select="."/>
        </xsl:for-each>
    </xsl:function>
    
</sch:schema>