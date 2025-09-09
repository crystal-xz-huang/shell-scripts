#!/usr/bin/env bash

#===================================================================================
# FILE: backup.sh
#
# USAGE: backup.sh <filename>
#
# DESCRIPTION: Create a backup copy of a file by adding a numbered suffix.
#
# If the file is named example.txt the backup is called .example.txt.n
# where n is the smallest integer such that .example.txt.n does not already exist.
#
# NOTES: Does not back up hidden files (starting with a dot). or directories.
# ===================================================================================

FILENAME="$1"
if [ -z "$FILENAME" ] || [ ! -f "$FILENAME" ]; then
    echo "usage: $0 filename"
    exit 1
fi

if [ -f "$FILENAME" ]; then
    i=0
    while [ -f ".$FILENAME.$i" ]; do
        i=$((i + 1))
    done
    cp "$FILENAME" ".$FILENAME.$i"
    echo "Backup of '$FILENAME' saved as '.$FILENAME.$i'"
fi

exit 0