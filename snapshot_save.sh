#!/usr/bin/env dash

#===================================================================================
# FILE: snapshot_save.sh
#
# USAGE: snapshot_save.sh
#
# DESCRIPTION: Save a snapshot of the current directory
#
# Save copies of all files in the current directory in a new snapshot directory
# named .snapshot.n
# - Ignores hidden files starting with a dot (.)
# - Ignores snapshot-save.sh and snapshot-load.sh
#
# NOTES:
# - Does not save subdirectories
# - Restore a snapshot with snapshot-load.sh <n>
#===================================================================================

if [ $# != 0 ]; then
    echo "Usage: $0" 1>&2
    exit 1
fi

suffix=0
while [ -e ".snapshot.$suffix" ]; do
    suffix=$((suffix + 1))
done

snapshot_directory=".snapshot.$suffix"
mkdir $snapshot_directory || exit 1

echo "Creating snapshot $suffix"

for file in *; do
    if echo "$file" | grep -vqE 'snapshot'; then
        cp "$file" ".snapshot.$suffix"
    fi
done