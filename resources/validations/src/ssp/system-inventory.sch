<?xml version="1.0" encoding="UTF-8"?>
<sch:schema
    queryBinding="xslt2"
    xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">

    <sch:ns
        prefix="oscal"
        uri="http://csrc.nist.gov/ns/oscal/1.0" />
    <sch:ns
        prefix="fedramp"
        uri="https://fedramp.gov/ns/oscal" />

    <sch:title>FedRAMP OSCAL SSP System Inventory</sch:title>

    <doc:xspec
        href="system-inventory.xspec" />

    <sch:pattern>

        <!-- OSCAL SSP schema no longer has <system-inventory> element -->

        <sch:let
            name="fedramp-values"
            value="doc('file:../../../xml/fedramp_values.xml')" />

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
            context="oscal:prop[@name = 'allows-authenticated-scan'][@value = 'no']">
            <sch:assert
                diagnostics="has-allowed-allows-authenticated-scan-remarks-diagnostic"
                id="has-allowed-allows-authenticated-scan-remarks"
                role="error"
                test="remarks">allows-authenticated-scan property with a value of "no" has a remarks element.</sch:assert>
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
            context="oscal:prop[@name = 'is-scanned'][@value = 'no']">
            <sch:p>is-scanned property has an allowed value</sch:p>
            <sch:let
                name="is-scanneds"
                value="remarks" />
            <sch:assert
                diagnostics="has-allowed-is-scanned-remarks-diagnostic"
                id="has-allowed-is-scanned-remarks"
                role="error"
                test="@value = $is-scanneds">is-scanned property with a value of "no" has a remarks element.</sch:assert>

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
                test="not(oscal:prop[@name = 'asset-id'][2])">inventory-item has only one asset-id.</sch:assert>

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
                test="not(oscal:prop[@name = 'asset-type'][2])">inventory-item has only one asset-type.</sch:assert>

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
                test="not(oscal:prop[@name = 'virtual'][2])">inventory-item has only one virtual property.</sch:assert>

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
                test="not(oscal:prop[@name = 'public'][2])">inventory-item has only one public property.</sch:assert>

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
                test="not(oscal:prop[@name = 'scan-type'][2])">inventory-item has only one scan-type property.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:inventory-item[oscal:prop[@name = 'asset-type']/@value = ('os', 'infrastructure')]">

            <sch:p>"infrastructure" inventory-item has allows-authenticated-scan</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-allows-authenticated-scan-diagnostic"
                id="inventory-item-has-allows-authenticated-scan"
                role="error"
                test="(oscal:prop[@name = 'allows-authenticated-scan'])">"infrastructure" inventory-item has allows-authenticated-scan.</sch:assert>


            <sch:p>inventory-item has only one allows-authenticated-scan property</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-one-allows-authenticated-scan-diagnostic"
                id="inventory-item-has-one-allows-authenticated-scan"
                role="error"
                test="not(oscal:prop[@name = 'allows-authenticated-scan'][2])">inventory-item has only one one-allows-authenticated-scan
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
                test="oscal:prop[@name = 'baseline-configuration-name']">"infrastructure" inventory-item has only one
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

            <sch:p>"software or database" inventory-item has an asset type</sch:p>
            <sch:assert
                diagnostics="component-has-asset-type-diagnostic"
                id="component-has-asset-type"
                role="error"
                test="oscal:prop[@name = 'asset-type']">"software or database" inventory-item has an asset type.</sch:assert>

            <sch:p>"software or database" inventory-item has an asset type</sch:p>
            <sch:assert
                diagnostics="component-has-one-asset-type-diagnostic"
                id="component-has-one-asset-type"
                role="error"
                test="oscal:prop[@name = 'asset-type']">"software or database" inventory-item has one asset type.</sch:assert>

        </sch:rule>
    </sch:pattern>

    <sch:diagnostics>

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
            doc:assertion="has-allowed-allows-authenticated-scan-remarks"
            id="has-allowed-allows-authenticated-scan-remarks-diagnostic">
            <sch:value-of
                select="name()" /> with a value of "no" lacks a remarks element.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="has-allowed-is-scanned"
            id="has-allowed-is-scanned-diagnostic">
            <sch:value-of
                select="name()" /> must have an allowed value <sch:value-of
                select="string-join($is-scanneds, ' ∨ ')" /> (not "<sch:value-of
                select="@value" />").</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="has-allowed-is-scanned-remarks"
            id="has-allowed-is-scanned-remarks-diagnostic">
            <sch:value-of
                select="name()" /> with a value of "no" lacks a remarks element.</sch:diagnostic>

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

    </sch:diagnostics>
</sch:schema>
