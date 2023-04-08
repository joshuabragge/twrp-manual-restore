#!/bin/sh

files=$(ls data.*.win* | grep "win[0-9]\{3\}$")

for f in ${files[*]}
do
    tar -xvf $f
done
