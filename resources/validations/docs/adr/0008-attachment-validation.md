# 8. Attachment Validation Approach

Date: 2021-06-08

## Status

Accepted

## Context

The 10x ASAP Development Team, in the course or work for [18F/fedramp-automaton#52](https://github.com/18F/fedramp-automation/issues/52), needs to define the minimally viable checks needed to determine attachment data in `oscal:back-matter/oscal:resources` is correctly attached to [an OSCAL SSP instance](https://pages.nist.gov/OSCAL/concepts/layer/implementation/ssp/). Per [ADR 2](./0002-xml-schematron-usage.md) and [ADR 4](./0004-xslt-function-library.md), the runtime design with exclusive use of XSLT presents architectural limitations.

1. XSLT 3.0, as a standard, has limited facility to parse non-XML files. If not a valid XML document, it must be text-only (to be parsed with [`fn:unparsed-text()`](https://www.w3.org/TR/xpath-functions-31/#func-unparsed-text)).
2. File path resolution becomes complex with relative paths in OSCAL ([`oscal:rlink`](https://pages.nist.gov/OSCAL/reference/latest/system-security-plan/xml-reference/#/system-security-plan/back-matter)) when _not_ using traditional file systems local to where validations execute and/or without a stateful backend service.
3. Fully remote paths defined in ([`oscal:rlink`](https://pages.nist.gov/OSCAL/reference/latest/system-security-plan/xml-reference/#/system-security-plan/back-matter))s presume, especially given the frequent reliance on HTTP and HTTPS URIs, will be problematic when developing browser-based software. We cannot presume [permissive CORS configurations](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS) and this prevents low-friction access of remote resources, many of which will be controlled by a third party.


Additionally, there are many different filetypes [supported by the OSCAL specification](https://pages.nist.gov/OSCAL/reference/latest/system-security-plan/json-reference/#/system-security-plan/back-matter/resources/rlinks/media-type), so long as a `@media-type` is in IANA Media Type Registry. This registry is significant, and makes validation onerous. Supporting all medita types has limited benefits for the long tail of registered but obscure formats that FedRAMP will not encounter and are still opaque. They are not XML and cannot be analyzed, only checked or their existence.

## Decision

The 10x ASAP Team will validate attached documents, but do so as minimally as possible for now.

- One or more of the following for a given [`oscal:resource`](https://pages.nist.gov/OSCAL/reference/latest/system-security-plan/json-reference/#/system-security-plan/back-matter/resources/):
  - One `oscal:base64` defined
  - One `oscal:rlink` defined
  - Both a `oscal:base64` and a `oscal:rlink` defined
  - For a `oscal:base64` its `text()`, validations will check only for [the existence of the base64-encoded content](https://datatracker.ietf.org/doc/html/rfc4648#page-5) via regular expression patterns, not the content itself
  - For a `oscal:rlink` validations will check only for the existence of a non-empty, well-formed `@href` reference, not for the existence of the data at that location itself

For attachments, the FedRAMP validations will only support the IANA media-types for an OSCAL `@media-type` defined below:

## Consequences
