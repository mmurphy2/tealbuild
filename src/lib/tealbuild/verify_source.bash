# verify_source <path> <md5> <gpgsig> <gpgkey>
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

# Verifies a downloaded source file. If GPG verification is available, GPG is
# used; otherwise, MD5 verification is used.

function verify_source() {
    local sum
    local status=0

    echo "Verifying $1..."

    if [[ -f "$3" ]]; then
        # Use GPG if available
        if check_gpg_signature "$4" "$3"; then
            echo "Verified $1 using GPG"
        else
            echo "GPG verification FAILED for $1" >&2
            status=1
        fi
    elif [[ "$2" == "SKIP" ]]; then
        echo "SKIPPING MD5 verification for $1"
    else
        sum=$(md5sum "$1" | awk '{print $1}')
        if [[ "${sum}" == "$2" ]]; then
            echo "Verified $1 using MD5"
        else
            echo "MD5 verification FAILED for $1" >&2
            status=1
        fi
    fi

    return ${status}
}
