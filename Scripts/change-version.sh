#!/bin/bash

VERSION_FILE=Sources/l10nlint/Generated/Version.swift

echo "enum Version {
    static let current = \"$1\"
}" > "$VERSION_FILE"