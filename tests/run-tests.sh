#!/bin/sh

cd `dirname $0`
FIGCONV="../bin/figconv"

cleanup() {
    echo "CLEANUP: Removing files generated in tests"
    rm --verbose example*.pdf
    rm --verbose example*.png
}
trap cleanup EXIT

echo "Generating PDFs from test files ... "
$FIGCONV

echo "Checking whether all PDFs have been generated as expected ... "
for I in $(seq 1 4)
do
    GENFILE="example${I}.pdf"
    [ -s $GENFILE ] || {
        echo "ERROR: File '$GENFILE' not generated" > /dev/stderr
        exit 1
    }
done

echo "Generating PNGs from test files"
$FIGCONV --png

echo "Checking whether all PNGs have been generated as expected ... "
for I in $(seq 1 4)
do
    GENFILE="example${I}.png"
    [ -s $GENFILE ] || {
        echo "ERROR: File '$GENFILE' not generated" > /dev/stderr
        exit 1
    }
done

echo "All tests passed."
