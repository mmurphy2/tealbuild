#!/bin/bash

which pandoc >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "Pandoc is required for generating the man pages" >&2
    exit 1
fi

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <input_md_file>" >&2
    exit 2
fi

pandoc "$1" -s -t man | man -l -
