# build_group <name> [name ...]
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

# Builds a group of packages in order, after installing any prerequisite packages needed
# for the build. Stops and returns a non-zero value if any build fails. Returns 0 if all
# builds are successful.
#
# <name>   --  name of the port to build (must be in the PORTS directory)

function build_group() {
    local choice status=0

    # Install any prebuilt packages that are needed for this build
    install_prereqs "$@"
    status=$?

    if [[ ${status} -eq 0 ]]; then
        while [[ $# -gt 0 ]]; do
            build_package "$1"
            status=$?

            if [[ ${status} -eq 0 ]]; then
                banner "Successfully built $1" >&2

                if [[ "${TEALBUILD_INTERACTIVE}" == "yes" ]]; then
                    echo -n "Rebuild package? [y/N] "
                    read -e choice

                    if [[ "${choice}" != "y" ]]; then
                        shift
                    else
                        ssh_removepkg "$1"
                    fi
                else
                    shift
                fi
            else
                banner "Build failed for $1." >&2

                if [[ "${TEALBUILD_INTERACTIVE}" == "yes" ]]; then
                    echo "Build failed for $1. You may be able to fix the build and retry."
                    echo
                    echo -n "Retry build (fix first before answering)? [y/N] "
                    read -e choice

                    if [[ "${choice}" != "y" ]]; then
                        echo "Aborted build." >&2
                        break
                    fi

                    # If choice is y, do NOT shift, so that build is re-attempted
                else
                    echo "Aborted build." >&2
                    break
                fi
            fi
        done
    else
        banner "Missing prerequisite packages for build request." >&2
    fi

    return ${status}
}
