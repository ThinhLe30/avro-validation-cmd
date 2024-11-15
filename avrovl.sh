#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <path_to_yaml_file>"
    exit 1
fi

yaml_file="$1"

avro_file="test.avsc"

cleanup() {
    if [ -f "$avro_file" ]; then
        rm "$avro_file"
        echo "Temporary file $avro_file deleted."
    fi
}

trap cleanup EXIT INT TERM

yq eval -o=json "$yaml_file" >"$avro_file"

if [ $? -ne 0 ]; then
    echo "Error: Failed to convert YAML to JSON."
    exit 1
fi

avrosv "$avro_file"

if [ $? -ne 0 ]; then
    echo "Error: Schema is invalid"
else
    echo "Avro schema is valid"
    pbcopy <"$avro_file"
    echo "Avro schema copied to clipboard."
fi
