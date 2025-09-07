#!/usr/bin/env dash
#
# Change the names of the specified files to lower case. (simple version of the perl utility rename)
#
# Usage ./toLower.sh: <files>
#
# Crystal Huang <crystalhuang@y7mail.com>
#
#==============================================================================
if test $# = 0
then
    echo "Usage $0: <files>" 1>&2
    exit 1
fi

for filename in "$@"
do
    new_filename=$(
        echo "$filename"|
        tr '[:upper:]' '[:lower:]'
        )

    test "$filename" = "$new_filename" &&
        continue

    if test -r "$new_filename"
    then
        echo "$0: $new_filename exists" 1>&2
    elif test -e "$filename"
    then
        mv -- "$filename" "$new_filename"
    else
        echo "$0: $filename not found" 1>&2
    fi

done
