#!/bin/bash

# script to copy a binary with its library dependencies to a target folder
# Michael Brade <brade@kde.org>

if [ $# != 2 ] ; then
    echo "usage: $0 <path to the binary> <target folder>"
    exit 1
fi

PATH_TO_BINARY="$1"
TARGET_FOLDER="$2"

# if we cannot find the the binary we have to abort
if [ ! -f "$PATH_TO_BINARY" ] ; then
    echo "The file '$PATH_TO_BINARY' was not found. Aborting!"
    exit 1
fi

mkdir -p "$TARGET_FOLDER"

if [ ! -d "$TARGET_FOLDER" ] ; then
    echo "The directory '$TARGET_FOLDER' was not found and could not be created. Aborting!"
    exit 1
fi


# copy the binary to the target folder and create required directories
#echo "#### copy binary"
#cp -v "$PATH_TO_BINARY" "$TARGET_FOLDER"

# copy the shared libs to the target folder and create required directories
echo "#### copy libraries for $PATH_TO_BINARY"
for lib in `ldd "$PATH_TO_BINARY" | grep "=> /" | awk '{print $3}'` ; do
    if [ -f "$lib" ] ; then
        cp -v --parents "$lib" "$TARGET_FOLDER"
    else
        echo "ERROR: $lib not copied, it is not a regular file!"
        exit 1
    fi
done

