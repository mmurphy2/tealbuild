#!/bin/bash

which pandoc >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "Pandoc is required for generating the man pages" >&2
    exit 1
fi

whatami=$(readlink -e "$0")
whereami=$(dirname "${whatami}")
top_level=$(dirname "${whereami}")

mkdir -p "${top_level}/tealbuild/man/man1"

cd "${whereami}"
for page in *.1.md; do
    pandoc "${page}" -s -t man -o "${top_level}/tealbuild/man/man1/${page%.md}"
done
