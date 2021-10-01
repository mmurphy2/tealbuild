# update_repo
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

# Generates repository-level metadata from the package-level metadata, which
# must already be present (e.g. from running accept).

function update_repo() {
    local status

    echo "Updating repository metadata in ${REPO}/${ARCH}"

    generate_repo_pkglist
    status=$?

    if [[ ${status} -eq 0 ]]; then
        generate_repo_manifest
        status=$?
    fi

    if [[ ${status} -eq 0 ]]; then
        generate_changelog
        status=$?
    fi

    if [[ ${status} -eq 0 ]]; then
        if [[ ! -f "${REPO}/${ARCH}/GPG-KEY" ]]; then
            export_gpg_public_key "${REPO}/${ARCH}/GPG-KEY"
            status=$?

            if [[ ${status} -ne 0 ]]; then
                echo "Failed to export public GPG key" >&2
            fi
        fi
    fi

    if [[ ${status} -eq 0 ]]; then
        generate_repo_checksums
        status=$?
    fi

    if [[ ${status} -eq 0 ]]; then
        generate_repo_filelist
        status=$?
    fi

    return ${status}
}
