#!/bin/bash

TEST_DIR=./test-files
TMP_FILE=./test-files/.tmp

TEST_PREFIX=test_
RESULT_PREFIX=result_

SUCCESSFUL_TESTS=""
FAILED_TESTS=""
UNCHECKED_TESTS=""

for F in `find $TEST_DIR -type f -name test_'*' | sort`
do
    echo "-----------------------------------------------------------"
    echo "Running test: $F"

    ./buddy -i $F > $TMP_FILE

    # cat $TMP_FILE # Uncomment this line to output run results

    RESULT_FILE=`echo $F | sed "s/$TEST_PREFIX/$RESULT_PREFIX/g"`

    echo $RESULT_FILE

    if [ -e "$RESULT_FILE" ]; then
	echo "Checking diff"
	DIFF_OUT=`diff $TMP_FILE $RESULT_FILE`

	if [ "$DIFF_OUT" != "" ]; then
	    echo "$DIFF_OUT"
	    echo "Output from test $F differs"
	    FAILED_TESTS+=" $F"
	else
	    echo "Test passed"
	    SUCCESSFUL_TESTS+=" $F"
	fi
    else
	echo "No result file for test: $F... Skipping diff"
	UNCHECKED_TESTS+=" $F"
    fi

    echo ""
done

rm $TMP_FILE

echo "=======================  SUMMARY  ========================="
echo "SUCCESSFUL TESTS"
for F in $SUCCESSFUL_TESTS
do
    echo $F
done

echo ""
echo "FAILED TESTS"
for F in $FAILED_TESTS
do
    echo $F
done

echo ""
echo "UNCHECKED TESTS"
for F in $UNCHECKED_TESTS
do
    echo $F
done

echo ""
