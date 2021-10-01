# archive <package> [[package] ...]
#
# This function is part of TealBuild.
#
# Copyright 2021 Coastal Carolina University
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.

# Moves a package and its associated metadata files from the repository
# (REPO) to the package archive (ARCHIVE). This function is used whenever
# a package is either upgraded to a newer version in the repo or retired
# from the repo altogether.
#

function archive() {
    local item pkg stem
    local status=0

    mkdir -p "${ARCHIVE}/${ARCH}"

    for pkg in "$@"; do
        echo "Archiving ${pkg}..."
        stem="${pkg%.t?z}"

        for item in "${pkg}" "${pkg}.asc" "${stem}.txt" "${stem}.meta" "${stem}.manifest" "${stem}.log"; do
            mv -v "${REPO}/${ARCH}/${item}" "${ARCHIVE}/${ARCH}/${item}" || status=1
        done
    done

    return ${status}
}
