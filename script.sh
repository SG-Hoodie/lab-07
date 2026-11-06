#!/bin/bash

for number in 1 2 3 4; do
    input_dir="Testcase${number}"
    output_dir="Testcase${number}Diff"

    rm -rf "$output_dir"

    for first in "$input_dir"/*.1.txt; do
        [ -f "$first" ] || continue

        second="${first%.1.txt}.2.txt"
        filename="${first##*/}"
        output_file="$output_dir/${filename%.1.txt}Diff.txt"

        if ! cmp -s "$first" "$second"; then
            mkdir -p "$output_dir"
            diff -u "$first" "$second" > "$output_file"
        fi
    done
done
