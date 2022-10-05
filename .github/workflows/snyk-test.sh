#!/usr/bin/env bash

set -e -o noglob

if [ -z "$1" ]; then
    echo "Paths not provided"
    exit 1
else
    declare -a 'paths=('"$1"')'
fi

starting_dir=$PWD
for dir in "${paths[@]}" ; do
    extension_folder=`basename $dir`
    printf "\nEntering $dir\n"
    cd "$dir"
    snyk test --severity-threshold=high
    cd $starting_dir
done
