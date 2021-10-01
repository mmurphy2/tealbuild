# show_log <package_base>
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

# Displays the build log for the package with the specified <package_base>,
# which is the filename of the package with the final .t?z removed.

function show_log() {
    local target
    local status=0

    # Look for the log in STAGE first, then check the REPO, then finally TRASH
    if [[ -f "${STAGE}/${ARCH}/$1.log" ]]; then
        target="${STAGE}/${ARCH}/$1.log"
    elif [[ -f "${REPO}/${ARCH}/$1.log" ]]; then
        target="${REPO}/${ARCH}/$1.log"
    else
        target="${TRASH}/$1.log"
    fi

    if [[ -f "${target}" ]]; then
        if [[ -n "${TEALBUILD_PAGER}" ]]; then
            cat "${target}" | ${TEALBUILD_PAGER}
            status=$?
        else
            cat "${target}"
            status=$?
        fi
    else
        echo "No such log: ${target}" >&2
        status=1
    fi

    return ${status}
}
