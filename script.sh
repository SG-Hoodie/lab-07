#!/bin/bash #tells script should be executed using bash
#runs 4 times
for ((i = 1; i < 5; i++)); do
    input="Testcase${i}"
    output="Testcase${i}Diff"

    rm -rf "$output" #remove old output

    for file in "$input"/*.1.txt; do #finds all filenames ending in .1.txt inside the input directory
        [ -f "$file" ] || continue # Check if the file exists

        second="${file%.1.txt}.2.txt"
        name="${file##*/}" #removes the directory path, leaving just the filename
        result="$output/${name%.1.txt}Diff.txt"

        if ! diff -u "$file" "$second" > /dev/null; then
            mkdir -p "$output"
            diff -u "$file" "$second" > "$result"
        fi
    done
done

