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

    set +e
    snyk test --severity-threshold=high
    last_exit_code=${?}
    set -e

    if [ $last_exit_code -ne 0 ]; then
        echo "::error::Snyk found vurnabilities in $extension_folder"
        npm ci
        exit 1
    fi

    cd $starting_dir
done
