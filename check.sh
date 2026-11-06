#!/bin/bash

# Keep track of whether any Testcase fails
result=0

# Loop through Testcase1 to Testcase4
for ((i = 1; i < 5; i++)); do

    # Set input and output directory names
    input="Testcase${i}"
    output="Testcase${i}Diff"

    # Assume the Testcase passes initially
    valid=1
    has_differences=0

    # Loop through all .1.txt files
    for file in "$input"/*.1.txt; do

        # Skip if the file does not exist
        [ -f "$file" ] || continue

        # Find the matching .2.txt file
        second="${file%.1.txt}.2.txt"

        # Get the filename without the directory
        name="${file##*/}"

        # Create the expected output filename
        expected="$output/${name%.1.txt}Diff.txt"

        # Check if the second file exists
        if [ ! -f "$second" ]; then
            valid=0

        # Check if the two files are identical
        elif diff -u "$file" "$second" > /dev/null; then

            # Identical pairs should not have output files
            if [ -e "$expected" ]; then
                valid=0
            fi

        else
            # The files differ
            has_differences=1

            # Check if the expected output file exists
            if [ ! -f "$expected" ]; then
                valid=0

            # Compare diff output, ignoring the first two lines
            elif ! cmp -s \
                <(diff -u "$file" "$second" | tail -n +3) \
                <(tail -n +3 "$expected"); then
                valid=0
            fi
        fi
    done

    # Check if the output directory should exist
    if [ "$has_differences" -eq 1 ]; then
        [ -d "$output" ] || valid=0
    else
        [ ! -d "$output" ] || valid=0
    fi

    # Print PASS or FAIL for each Testcase
    if [ "$valid" -eq 1 ]; then
        echo "Testcase${i}: PASS"
    else
        echo "Testcase${i}: FAIL"
        result=1
    fi
done

# Return 0 if all Testcases passed, otherwise 1
exit "$result"
