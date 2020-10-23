Schematron Validations for OSCAL
===

project structure
---

`/src` for the sch files
`/test` for any xpec or other testing artifacts
`/test/demo` xml files for validating xspec against

To Run Tests
---

```sh
export  SAXON_CP=yourpath/saxon-xx.jar
xspec/bin/xspec.sh -s -j test/test.xspec ```