# ssh_installpkg <path> [[path] ...]
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

# Installs one or more packages into the build VM using installpkg.
#
# <path>   --  complete path to the package file to install

function ssh_installpkg() {
    local pkg pkgbase
    local status=0

    for pkg in "$@"; do
        if [[ -r "${pkg}" ]]; then
            vm_scp "${pkg}" /tmp
            status=$?

            if [[ ${status} -eq 0 ]]; then
                pkgbase=$(basename "${pkg}")
                vm_ssh /sbin/installpkg "/tmp/${pkgbase}"
                status=$?
            fi

            if [[ ${status} -ne 0 ]]; then
                echo "Failed: ${pkg}" >&2
                break
            fi
        else
            echo "File not found: ${pkg}" >&2
            status=1
            break
        fi
    done

    return ${status}
}
