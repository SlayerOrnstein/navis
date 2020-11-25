#!/bin/bash

CURRENT_VERSION="$(pub global run cider version | cut -d'+' -f1)"

if [ "$CURRENT_VERSION" != "$1" ]
then
    let VERSION_CODE="$(pub global run cider version | cut -d'+' -f2)" 
    let VERSION_CODE=++VERSION_CODE

    cider version "$1+$VERSION_CODE"
fi