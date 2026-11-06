#!/bin/bash

result=0

for number in 1 2 3 4; do
    input_dir="Testcase${number}"
    output_dir="Testcase${number}Diff"
    valid=1
    has_differences=0

    for first in "$input_dir"/*.1.txt; do
        [ -f "$first" ] || continue

        second="${first%.1.txt}.2.txt"
        filename="${first##*/}"
        output_file="$output_dir/${filename%.1.txt}Diff.txt"

        if [ ! -f "$second" ]; then
            valid=0
        elif cmp -s "$first" "$second"; then
            if [ -e "$output_file" ]; then
                valid=0
            fi
        else
            has_differences=1

            if [ ! -f "$output_file" ]; then
                valid=0
            elif ! cmp -s \
                <(diff -u "$first" "$second" | tail -n +3) \
                <(tail -n +3 "$output_file"); then
                valid=0
            fi
        fi
    done

    if [ "$has_differences" -eq 1 ]; then
        [ -d "$output_dir" ] || valid=0
    else
        [ ! -d "$output_dir" ] || valid=0
    fi

    if [ "$valid" -eq 1 ]; then
        echo "Testcase${number}: PASS"
    else
        echo "Testcase${number}: FAIL"
        result=1
    fi
done

exit "$result"
