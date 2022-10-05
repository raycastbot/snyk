#!/usr/bin/env bash

set -e -o noglob

if [ -z "$1" ]; then
    echo "Paths not provided"
    exit 1
else
    declare -a 'paths=('"$1"')'
fi

last_exit_code=0
exit_code=$last_exit_code

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
        echo "::error::Snyk found high vurnabilities in $extension_folder"
    fi
    if [ $exit_code -eq 0 ]; then
        exit_code=$last_exit_code
    fi

    cd $starting_dir
done

exit $exit_code
