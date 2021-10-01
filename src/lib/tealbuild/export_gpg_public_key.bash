# export_gpg_public_key <output_file> [email]
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

# Exports a public GPG key from GPG_HOME.
#
# <output_file>   --   path to the output file
# [email]         --   identity of the key to export
#
# If no email is given (and TEALBUILD_GPG_EMAIL is unset), the default key
# will be exported.

function export_gpg_public_key() {
    local email

    [[ -n "${TEALBUILD_GPG_EMAIL}" ]] && email="--local-user ${TEALBUILD_GPG_EMAIL}"
    [[ -n "$2" ]] && email="--local-user $2"

    ${GPG} --homedir "${GPG_HOME}" --output "$1" --armor --export ${email}
    return $?
}
