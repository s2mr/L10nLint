#!/bin/bash

source ./Scripts/variable.sh

echo "enum Version {
    static let current = \"$1\"
}" > "$VERSION_FILE"