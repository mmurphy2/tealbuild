# depsolve port_name [recurse]
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

# Recursive dependency solver: given a port name, checks the .info file for its dependencies. Recursively checks any
# dependencies, then adds the original port name to the end of the build list, which is deduplicated. Emits the build list.
# The second recurse argument is only used internally. Returns 0 if all ports in the chain had .info files, 1 if an .info file
# is missing.

function depsolve() {
    local status=0
    local dep info_file

    if [[ "$2" != "recurse" ]]; then
        # vim syntax highlighting doesn't like the ) here, but it is legal
        local build_list=()
    fi

    # The basic algorithm here is to do a postorder traversal of the dependency tree (depth-first search), adding the current
    # port name to the build list only after visiting all its dependent ports.
    info_file="${PORTS}/$1/$1.info"
    if [[ -f "${info_file}" ]]; then
        # Base case occurs whenever there are no dependencies: this loop does not run in that case
        for dep in $(. "${info_file}" && echo "${REQUIRES}"); do
            depsolve "${dep}" recurse
        done

        # Support BUILD_REQUIRES in .info files, after the REQUIRES
        if [[ "${TEALBUILD_REQUIRES}" == "build" ]]; then
            for dep in $(. "${info_file}" && echo "${BUILD_REQUIRES}"); do
                depsolve "${dep}" recurse
            done
        fi
    else
        status=1
    fi

    # Add the original requested port last, but deduplicate the build list in the process
    if ! has_element "$1" "${build_list[@]}"; then
        build_list+=("$1")
    fi

    # If this was the original request, emit the completed build list
    if [[ "$2" != "recurse" ]]; then
        echo "${build_list[@]}"
    fi

    return ${status}
}
