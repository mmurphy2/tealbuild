# install_prereqs <port> [[port] ...]
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

# Installs prerequisite packages, which have already been built, into the build VM. Prequisites for each listed build
# will be installed, first from the staging area, then from the repo. If the prereq isn't found, the process is aborted,
# an error message is displayed, and a nonzero status is returned.

function install_prereqs() {
    local item package preq oldtbrequires
    local ports_checked=()
    local status=0

    oldtbrequires="${TEALBUILD_REQUIRES}"
    TEALBUILD_REQUIRES="build"

    for item in "$@"; do
        for preq in $(depsolve "${item}"); do
            if [[ "${preq}" != "${item}" ]]; then
                if ! has_element "${preq}" "${ports_checked[@]}"; then
                    package=$(find_package "${preq}")
                    if [[ -n "${package}" ]]; then
                        ssh_upgradepkg "${package}" || status=1
                    else
                        echo "Dependency ${preq} not found for ${item}" >&2
                        status=1
                    fi
                fi
            fi
        done
        ports_checked+=( "${item}" )
    done

    TEALBUILD_REQUIRES="${oldtbrequires}"
    return ${status}
}
