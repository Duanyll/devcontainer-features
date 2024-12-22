#!/bin/sh
set -e

echo "Activating feature 'mkdir'"

DIRS=${DIRECTORIES}
USERID=${USERID:-1000}
GROUPID=${GROUPID:-1000}
MODE=${MODE:-755}

# If directories are empty, show warning and exit
if [ -z "$DIRS" ]; then
    echo "No directories specified to create!"
    exit 1
fi

# Split the comma-separated list into an array
OLD_IFS=$IFS
IFS=','
set -- $DIRS
IFS=$OLD_IFS

for dir in "$@"; do
    echo "Creating directory: $dir"
    mkdir -p $dir
    chown -R $USERID:$GROUPID $dir
    chmod -R $MODE $dir
done