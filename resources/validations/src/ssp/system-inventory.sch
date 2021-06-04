<?xml version="1.0" encoding="UTF-8"?>
<sch:schema
    queryBinding="xslt2"
    xmlns:frdoc="https://fedramp.gov/ns/documentation"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">

    <sch:ns
        prefix="oscal"
        uri="http://csrc.nist.gov/ns/oscal/1.0" />
    <sch:ns
        prefix="fedramp"
        uri="https://fedramp.gov/ns/oscal" />

    <sch:title>FedRAMP OSCAL SSP System Inventory</sch:title>

    <sch:pattern>

        <!-- OSCAL SSP schema no longer has <system-inventory> element -->

        <sch:let
            name="fedramp-values"
            value="doc('file:../../../../resources/xml/fedramp_values.xml')" />

        <sch:title>A FedRAMP OSCAL SSP must specify system inventory items</sch:title>

        <sch:rule
            context="/oscal:system-security-plan/oscal:system-implementation"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans pp52-60">

            <sch:p>A FedRAMP OSCAL SSP must populate the system inventory</sch:p>

            <!-- FIXME: determine if essential items are present -->
            <sch:assert
                id="has-inventory-items"
                role="error"
                test="oscal:inventory-item">A FedRAMP OSCAL SSP must incorporate inventory-item elements</sch:assert>

        </sch:rule>

        <sch:title>FedRAMP SSP value constraints</sch:title>

        <sch:rule
            context="oscal:prop[@name = 'asset-id']">
            <sch:p>asset-id must be unique</sch:p>
            <sch:assert
                id="inventory-item-has-unique-asset-id"
                role="error"
                test="count(//oscal:prop[@name = 'asset-id'][@value = current()/@value]) = 1">asset-id <sch:value-of
                    select="@value" /> is not unique</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:prop[@name = 'asset-type']">
            <sch:p>must have an allowed type</sch:p>
            <sch:let
                name="asset-types"
                value="$fedramp-values//fedramp:value-set[@name = 'asset-type']//fedramp:enum/@value" />
            <sch:assert
                id="has-allowed-asset-type"
                role="warning"
                test="@value = $asset-types"><sch:name /> should have a FedRAMP asset type <sch:value-of
                    select="string-join($asset-types, ' ∨ ')" /> (not "<sch:value-of
                    select="@value" />")</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:prop[@name = 'virtual']">
            <sch:p>must have an allowed type</sch:p>
            <sch:let
                name="virtuals"
                value="$fedramp-values//fedramp:value-set[@name = 'virtual']//fedramp:enum/@value" />
            <sch:assert
                id="has-allowed-virtual"
                role="error"
                test="@value = $virtuals"><sch:name /> must have an allowed value <sch:value-of
                    select="string-join($virtuals, ' ∨ ')" /> (not "<sch:value-of
                    select="@value" />")</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:prop[@name = 'public']">
            <sch:p>must have an allowed type</sch:p>
            <sch:let
                name="publics"
                value="$fedramp-values//fedramp:value-set[@name = 'public']//fedramp:enum/@value" />
            <sch:assert
                id="has-allowed-public"
                role="error"
                test="@value = $publics"><sch:name /> must have an allowed value <sch:value-of
                    select="string-join($publics, ' ∨ ')" /> (not "<sch:value-of
                    select="@value" />")</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:prop[@name = 'allows-authenticated-scan']">
            <sch:p>must have an allowed type</sch:p>
            <sch:let
                name="allows-authenticated-scans"
                value="$fedramp-values//fedramp:value-set[@name = 'allows-authenticated-scan']//fedramp:enum/@value" />
            <sch:assert
                id="has-allowed-allows-authenticated-scan"
                role="error"
                test="@value = $allows-authenticated-scans"><sch:name /> must have an allowed value <sch:value-of
                    select="string-join($allows-authenticated-scans, ' ∨ ')" /> (not "<sch:value-of
                    select="@value" />")</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:prop[@name = 'is-scanned']">
            <sch:p>must have an allowed type</sch:p>
            <sch:let
                name="is-scanneds"
                value="$fedramp-values//fedramp:value-set[@name = 'is-scanned']//fedramp:enum/@value" />
            <sch:assert
                id="has-allowed-is-scanned"
                role="error"
                test="@value = $is-scanneds"><sch:name /> must have an allowed value <sch:value-of
                    select="string-join($is-scanneds, ' ∨ ')" /> (not "<sch:value-of
                    select="@value" />")</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'scan-type']">
            <sch:let
                name="scan-types"
                value="$fedramp-values//fedramp:value-set[@name = 'scan-type']//fedramp:enum/@value" />
            <sch:assert
                id="inventory-item-has-allowed-scan-type"
                role="error"
                test="@value = $scan-types"><sch:name /> must have an allowed value <sch:value-of
                    select="string-join($scan-types, ' ∨ ')" /> (not "<sch:value-of
                    select="@value" />")</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:component">
            <sch:p>must have an allowed type</sch:p>
            <sch:let
                name="component-types"
                value="$fedramp-values//fedramp:value-set[@name = 'component-type']//fedramp:enum/@value" />
            <sch:assert
                id="component-has-allowed-type"
                role="error"
                test="@type = $component-types"><sch:name /> uuid <sch:value-of
                    select="@uuid" /> must have an allowed component type <sch:value-of
                    select="string-join($component-types, ' ∨ ')" /> (not "<sch:value-of
                    select="@type" />")</sch:assert>
        </sch:rule>

        <sch:title>FedRAMP OSCAL SSP inventory items</sch:title>

        <sch:rule
            context="oscal:inventory-item"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans pp52-60">

            <sch:p>All FedRAMP OSCAL SSP inventory-item elements</sch:p>

            <sch:p>must have a uuid</sch:p>
            <sch:assert
                id="inventory-item-has-uuid"
                role="error"
                test="@uuid"><sch:name /> uuid <sch:value-of
                    select="@uuid" /> must have a uuid attribute</sch:assert>

            <sch:p>must have an asset-id</sch:p>
            <sch:assert
                id="inventory-item-has-asset-id"
                role="error"
                test="oscal:prop[@name = 'asset-id']"><sch:name /> uuid <sch:value-of
                    select="@uuid" /> must have an asset-id property</sch:assert>

            <sch:p>must have an asset-type</sch:p>
            <sch:assert
                id="inventory-item-has-asset-type"
                role="error"
                test="
                    oscal:prop[@name = 'asset-type']
                    or
                    oscal:component[@uuid = current()/oscal:implemented-component/@component-uuid]/oscal:prop[@name = 'asset-type']
                    "><sch:name /> uuid <sch:value-of
                    select="@uuid" /> must have an asset-type property directly or indirectly</sch:assert>
            <sch:report
                role="information"
                test="true()"><sch:name /> uuid <sch:value-of
                    select="@uuid" /> has <sch:name
                    path="oscal:implemented-component" />
            </sch:report>

            <sch:p>must have virtual</sch:p>
            <sch:assert
                id="inventory-item-has-virtual"
                role="error"
                test="
                    oscal:prop[@name = 'virtual']
                    or
                    oscal:component[@uuid = current()/oscal:implemented-component/@component-uuid]/oscal:prop[@name = 'virtual']
                    "><sch:name /> uuid <sch:value-of
                    select="@uuid" /> must have virtual property directly or indirectly</sch:assert>

            <sch:p>must have public</sch:p>
            <sch:assert
                id="inventory-item-has-public"
                role="error"
                test="
                    oscal:prop[@name = 'asset-type']/@value = ('os', 'infrastructure', 'software', 'database')
                    and
                    oscal:prop[@name = 'public']
                    "><sch:name /> uuid <sch:value-of
                    select="@uuid" /> must have public property</sch:assert>


            <sch:p>must have scan-type</sch:p>
            <sch:assert
                id="inventory-item-has-scan-type"
                role="error"
                test="oscal:prop[@name = 'scan-type']"><sch:name /> uuid <sch:value-of
                    select="@uuid" /> must have scan-type property</sch:assert>

        </sch:rule>

        <sch:rule
            context="
                oscal:inventory-item[
                oscal:prop[@name = 'asset-type']/@value = ('os', 'infrastructure')
                or
                oscal:component[@uuid = current()/oscal:implemented-component/@component-uuid]/oscal:prop[@name = 'asset-type']/@value = ('os', 'infrastructure')
                ]">

            <sch:p>must have allows-authenticated-scan</sch:p>
            <sch:assert
                id="inventory-item-has-allows-authenticated-scan"
                role="error"
                test="
                    (
                    oscal:prop[@name = 'allows-authenticated-scan']
                    )
                    or
                    (
                    oscal:component[@uuid = current()/oscal:implemented-component/@component-uuid]/oscal:prop[@name = 'allows-authenticated-scan']
                    )
                    "><sch:name /> uuid <sch:value-of
                    select="@uuid" /> must have allows-authenticated-scan property directly or indirectly</sch:assert>

            <sch:p>must have baseline-configuration-name</sch:p>
            <sch:p>value is unconstrained</sch:p>
            <sch:assert
                id="inventory-item-has-baseline-configuration-name"
                role="error"
                test="
                    (
                    oscal:prop[@name = 'baseline-configuration-name']
                    )
                    or
                    (
                    oscal:component[@uuid = current()/oscal:implemented-component/@component-uuid]/oscal:prop[@name = 'baseline-configuration-name']
                    )
                    "><sch:name /> uuid <sch:value-of
                    select="@uuid" /> must have baseline-configuration-name property</sch:assert>

            <sch:p>must have a vendor-name property</sch:p>
            <sch:p>value is unconstrained</sch:p>
            <!-- FIXME: Documentation says vendor name is in FedRAMP @ns -->
            <sch:assert
                id="inventory-item-has-vendor-name"
                role="error"
                test="oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'vendor-name']"><sch:name /> uuid <sch:value-of
                    select="@uuid" /> must have a vendor-name property</sch:assert>

            <sch:p>must have a hardware-model property</sch:p>
            <sch:p>value is unconstrained</sch:p>
            <!-- FIXME: perversely, hardware-model is not in FedRAMP @ns -->
            <sch:assert
                id="inventory-item-has-hardware-model"
                role="error"
                test="oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'hardware-model']"><sch:name /> uuid <sch:value-of
                    select="@uuid" /> must have a hardware-model property</sch:assert>

            <sch:p>must have is-scanned</sch:p>
            <sch:assert
                id="inventory-item-has-is-scanned"
                role="error"
                test="oscal:prop[@name = 'is-scanned']"><sch:name /> uuid <sch:value-of
                    select="@uuid" /> must have is-scanned property</sch:assert>

            <sch:p>must have a scan-type property</sch:p>
            <!-- FIXME: DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 53 has typo -->

        </sch:rule>

        <sch:rule
            context="oscal:inventory-item[oscal:prop[@name = 'asset-type']/@value = ('software', 'database')]">
            <!-- FIXME: Software/Database Vendor -->

            <sch:p>must have software-name</sch:p>
            <!-- FIXME: vague asset categories -->
            <sch:assert
                id="inventory-item-has-software-name"
                role="error"
                test="oscal:prop[@name = 'software-name']"><sch:name /> uuid <sch:value-of
                    select="@uuid" /> must have software-name property</sch:assert>

            <sch:p>must have software-version</sch:p>
            <!-- FIXME: vague asset categories -->
            <sch:assert
                id="inventory-item-has-software-version"
                role="error"
                test="
                    oscal:prop[@name = 'software-version']
                    "><sch:name /> uuid <sch:value-of
                    select="@uuid" /> must have software-version property</sch:assert>

            <sch:p>must have function</sch:p>
            <!-- FIXME: vague asset categories -->
            <sch:assert
                id="inventory-item-has-function"
                role="error"
                test="
                    oscal:prop[@name = 'function']
                    "><sch:name /> uuid <sch:value-of
                    select="@uuid" /> "<sch:value-of
                    select="oscal:prop[@name = 'asset-type']/@value" />" must have function property</sch:assert>

        </sch:rule>

        <sch:title>FedRAMP OSCAL SSP components</sch:title>

        <sch:rule
            context="/oscal:system-security-plan/oscal:system-implementation/oscal:component[(: a component referenced by any inventory-item :)@uuid = //oscal:inventory-item/oscal:implemented-component/@component-uuid]"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 54">

            <sch:p>A FedRAMP OSCAL SSP component</sch:p>

            <sch:p>must have an asset type</sch:p>

            <sch:assert
                id="component-has-asset-type"
                role="error"
                test="oscal:prop[@name = 'asset-type']"><sch:name /> uuid <sch:value-of
                    select="@uuid" /> must have an asset-type property</sch:assert>

        </sch:rule>

    </sch:pattern>

</sch:schema>
