Schematron Validations for OSCAL
===

![OSCAL Validations: Unit Tests](https://github.com/18F/fedramp-automation/workflows/OSCAL%20Validations:%20Unit%20Tests/badge.svg)

project structure
---

`/src` for the sch files
`/lib` for toolchain dependencies (e.g. Schematron)
`/report/test` for XSpec outputs
`/report/schematron` for final validations in Schematron SVRL reporting format
`/target` for intermediary and compiled artifacts (e.g. XSLT stylesheets)
`/test` for any XSpec or other testing artifacts
`/test/demo` xml files for validating XSpec against

To validate xml files using schematron
---

*Prerequesite
if you haven't done it previously: to add the needed dependencies (declared by .gitmodules), run the following:*

example

`./bin/validate_with_schematron.sh test/demo/FedRAMP-SSP-OSCAL-Template.xml`

you must pass in a file name you want validated as argument `$1`. by default it will compile and validate the input with all `src/*.sch` files.

if you wish to override the default version (currently 10.2) of `SAXON HE`, you may pass it as the argument `$2`

To Run Tests
---

*Prerequesite
if you haven't done it previously: to add the needed dependencies (declared by .gitmodules), run the following:*

`git submodule update --init --recursive`

```sh
cd /path/to/fedramp-automation/resources/validations
#if you have a preferred version of a saxon jar downloaded export SAXON_CP as so
export SAXON_CP=yourpath/Saxon-HE-X.Y.Z.jar
#set the test directory relative to project path, you may change if you prefer somehere else
export TEST_DIR=$(pwd)/report/test
#execute xpec with the test harness that runs all tests
lib/xspec/bin/xspec.sh -s -j test/test_all.xspec
```

Adding tests to the harness
---

To add new tests, add an import to the `test-all.xpec`
ex: `<x:import href="new_test.xspec" />`
