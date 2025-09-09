#!/usr/bin/env dash

#===================================================================================
# FILE: snapshot_load.sh
#
# USAGE: snapshot_load.sh <n>
# OPTIONS: n - snapshot number to restore
#
# DESCRIPTION: Restore backups from .snapshot.n in the current directory,
# and save the current versions of all files in a new snapshot.
#
# NOTES: Requires snapshot-save.sh to be in the same directory and executable
#===================================================================================

if [ $# != 1 ]; then
    echo "Usage: $0 <snapshot-number>" 1>&2
    exit 1
fi

suffix=$1

snapshot_directory=".snapshot.$suffix"

if [ ! -d "$snapshot_directory" ]; then
    echo "Unknown snapshot $suffix" 1>&2
    exit 1
fi

# Ensure snapshot-save.sh exists and is executable
if [ ! -x "./snapshot_save.sh" ]; then
    echo "Error: snapshot_save.sh not found or not executable" 1>&2
    exit 1
fi

# Save current state first
snapshot-save.sh

echo "Restoring snapshot $suffix"

# Copy files from the snapshot directory to the current directory
cp -p "$snapshot_directory"/* .
