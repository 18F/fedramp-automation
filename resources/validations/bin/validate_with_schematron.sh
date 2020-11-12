#!/usr/bin/env bash
set -o pipefail

usage() {
    if test -n "$1"; then
        echo "$1"
        echo
    fi
    echo "Usage: validate_with_schematron.sh [-s directoryName|-o reportDirectory|-v saxonVersionNumber|-h] -f file"
    echo
    echo "  -f    fileName               the input file to be tested."
    echo "  -s    directoryName          schematron directory containing .sch files used to validate"
    echo "  -o    rootDirectory          is an the root of the report output."
    echo "  -v    saxonVersionNumber     if you wish to override the default version to be downloaded"
    echo "  -h                           display this help message"
}

# output root defaults to report folder relative to this script
OUTPUT_ROOT="report/schematron"
# schematron directory validate the file with each .sch found defaults to src/*.sch relative to this script
SCHEMA_LOCATION_DIR="src"
##
## options ###################################################################
##
while echo "$1" | grep -- ^- > /dev/null 2>&1; do
    case "$1" in
        # input file to validate
        -f)
            shift
            DOC_TO_VALIDATE="$1"
            ;;
        # saxon version
        -v)
            if test -n "$SAXON_CP"; then
                echo "SAXON_CP is set to ${SAXON_CP} as an environment variable setting version using -v is invalid"
                exit 1
            else
                shift
                SAXON_VERSION="$1"
            fi
            ;;
        # schema directory location
        -s)
            shift
            SCHEMA_LOCATION_DIR="$1"
            ;;
        # output directory root
        -o)
            shift
            OUTPUT_ROOT="$1"
            ;;
        # Help!
        -h)
            usage
            exit 0
            ;;
        # Unknown option!
        -*)
            usage "Error: Unknown option: $1"
            exit 1
            ;;
    esac
    shift
done

echo output dir "${OUTPUT_ROOT}"
echo to val "$DOC_TO_VALIDATE";
if test ! -e  "$DOC_TO_VALIDATE" ; then
    echo "no file input for report, exiting"
    exit 1
else 
    echo "doc requested to be validated: ${DOC_TO_VALIDATE}"
fi

# Delete pre-existing XSLT report
rm -rf target/*.xsl;

#if version not specified default
SAXON_VERSION=${SAXON_VERSION:-10.2}
SAXON_OPTS="${SAXON_OPTS:-allow-foreign=true}"

echo "using saxon version ${SAXON_VERSION}"

saxonLocation=saxon/Saxon-HE/"${SAXON_VERSION}"/Saxon-HE-"${SAXON_VERSION}".jar
if test -n "$SAXON_CP" ; then
    echo SAXON_CP env variable used is "${SAXON_CP}"
elif command -v mvn &> /dev/null ;then
    mvn -q org.apache.maven.plugins:maven-dependency-plugin:2.1:get \
        -DrepoUrl=https://mvnrepository.com/ \
        -DartifactId=Saxon-HE \
        -DgroupId=net.sf.saxon \
        -Dversion="${SAXON_VERSION}"
    SAXON_CP=~/.m2/repository/net/sf/${saxonLocation}
elif command -v curl &> /dev/null; then
    SAXON_CP=lib/Saxon-HE-"${SAXON_VERSION}".jar
    curl -H "Accept: application/zip" -o "${SAXON_CP}" https://repo1.maven.org/maven2/net/sf/"${saxonLocation}"
else
    echo "SAXON_CP environment variable is not set. mvn or curl is required to download dependencies, neither found, please install one and retry"
    exit 1
fi

# Delete pre-existing SVRL report
rm -rf "${OUTPUT_ROOT}/report/schematron/*.results.xml"
rm -rf "${OUTPUT_ROOT}/report/schematron/*.results.html"

#in the future replace the for loop with an optional passed in directory or single schema file -f 
for qualifiedSchematronName in "${SCHEMA_LOCATION_DIR}"/*.sch; do
    [ -e "${qualifiedSchematronName}" ] || continue
        
    # compute name without .sch
    schematronName=${qualifiedSchematronName##*/}
    schematronRoot=${schematronName%.*}
    
    # Use Saxon XSL transform to convert our Schematron to pure XSL 2.0 stylesheet
    # shellcheck disable=2086
    java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -o:target/"${schematronRoot}".xsl \
        -s:"${qualifiedSchematronName}" \
        lib/schematron/trunk/schematron/code/iso_svrl_for_xslt2.xsl \
        $SAXON_OPTS

    echo "compiling: ${qualifiedSchematronName} to: target/${schematronRoot}.xsl"
   
    # Use Saxon XSL transform to use XSL-ified Schematron rules to analyze full FedRAMP-SSP-OSCAL template
    # and dump the result into reports.
    reportName="${OUTPUT_ROOT}/${DOC_TO_VALIDATE}__${schematronRoot}.results.xml"
    htmlReportName="${OUTPUT_ROOT}/${DOC_TO_VALIDATE}__${schematronRoot}.results.html"

    rm -rf "${reportName}" "${htmlReportName}"

    echo "validating doc: ${DOC_TO_VALIDATE} with ${qualifiedSchematronName} output found in ${reportName}"

    # shellcheck disable=2086
    java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -o:"${reportName}" \
        -s:"${DOC_TO_VALIDATE}" \
        target/"${schematronRoot}".xsl \
        $SAXON_OPTS

    # shellcheck disable=2086
    java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -o:"${htmlReportName}" \
        -s:"${reportName}"  \
        lib/svrl2html.xsl \
        $SAXON_OPTS

done
