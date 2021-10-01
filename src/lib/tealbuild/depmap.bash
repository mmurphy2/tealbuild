# depmap <port>
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

# Finds all ports that depend on the specified port. This function uses the recursive depsolve function and is therefore
# extremely slow, especially if a lot of ports are in the ports tree. However, it does measure the impact of each port in
# the tree on each other port.

function depmap() {
    local dep port
    local status=0

    if [[ -d "${PORTS}/$1" ]]; then
        echo -n "$1: "
        for port in $(find "${PORTS}" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null | sort); do
            if [[ "${port}" != "$1" ]]; then
                for dep in $(depsolve "${port}"); do
                    if [[ "${dep}" == "$1" ]]; then
                        echo -n "${port} "
                        break
                    fi
                done
            fi
        done
        echo
    else
        echo "No such port: $1" >&2
        status=1
    fi

    return ${status}
}
