# check_gpg_signature <gpg_key> <filename>
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

# Checks the specified filename, which should be a detached signature (.asc)
# file, against the GPG key given as the first argument. Returns 0 if the
# signature is good, nonzero otherwise.
#
# <gpg_key>     --  One of: (1) a local path to a GPG public key, (2) the URL
#                   of a GPG public key, or (3) literal public key data
# <filename>    --  path to the .asc file to check

function check_gpg_signature() {
    local base gpgtemp keydata lines status workdir

    keydata="$1"
    base=$(basename "$2")
    workdir=$(dirname "$2")
    gpgtemp=$(mktemp -d)
    chmod 700 "${gpgtemp}"

    if ! echo "${keydata}" | grep -q -- '-----BEGIN PGP PUBLIC KEY BLOCK-----'; then
        if [[ -f "${keydata}" ]]; then
            keydata=$(cat "${keydata}")
        else
            keydata=$(wget -O - "${keydata}")
        fi
    fi

    echo "${keydata}" | ${GPG} --homedir "${gpgtemp}" --import
    status=${PIPESTATUS[1]}

    if [[ ${status} -eq 0 ]]; then
        (cd "${workdir}" && ${GPG} --homedir "${gpgtemp}" --verify "${base}")
        status=$?

        if [[ ${status} -ne 0 ]]; then
            echo "GPG verification FAILED for $2" >&2
        fi
    else
        echo "Failed to import GPG public key" >&2
    fi

    [[ "${gpgtemp}" != "/" ]] && rm -rf "${gpgtemp}"

    return ${status}
}
