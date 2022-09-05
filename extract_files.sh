#!/bin/bash

# List of files to be extracted
declare -a files=(
"data.ext4.win001"
"data.ext4.win002"
"data.ext4.win003"
)

for f in ${files[*]}
do
    tar -xvf $f
done

