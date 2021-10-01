# stage_rm <filename> [[filename] ...]
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

# Removes a specified package file (or files) from the staging area,
# moving them into the TRASH.
#
# <filename>  -- base name of the file to remove from staging

function stage_rm() {
    local pkg status stem

    mkdir -pv "${TRASH}"
    status=$?

    for pkg in "$@"; do
        mv -v "${STAGE}/${ARCH}/${pkg}" "${TRASH}/${pkg}" || status=1

        # Also remove any metadata and log file
        [[ -f "${STAGE}/${ARCH}/${pkg}.asc" ]] && mv -v "${STAGE}/${ARCH}/${pkg}.asc" "${TRASH}/${pkg}.asc"
        stem="${pkg%.t?z}"
        [[ -f "${STAGE}/${ARCH}/${stem}.txt" ]] && mv -v "${STAGE}/${ARCH}/${stem}.txt" "${TRASH}/${stem}.txt"
        [[ -f "${STAGE}/${ARCH}/${stem}.log" ]] && mv -v "${STAGE}/${ARCH}/${stem}.log" "${TRASH}/${stem}.log"
        [[ -f "${STAGE}/${ARCH}/${stem}.meta" ]] && mv -v "${STAGE}/${ARCH}/${stem}.meta" "${TRASH}/${stem}.meta"
        [[ -f "${STAGE}/${ARCH}/${stem}.manifest" ]] && mv -v "${STAGE}/${ARCH}/${stem}.manifest" "${TRASH}/${stem}.manifest"
    done

    return ${status}
}
