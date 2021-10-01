# Displays the dependency list (as a build list) for the specified port.
#
# This command is part of TealBuild.
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
#
# Recursively computes dependencies of a given port.
#

function cmd_requires() {
    local port
    local status=0

    check_args "requires" $# 0 + "[[port_name] ...]" || return 2

    if [[ $# -gt 0 ]]; then
        for port in "$@"; do
            depsolve "${port}"
            [[ ${status} -eq 0 ]] && status=$?
        done
    else
        for port in $(find "${PORTS}" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null | sort); do
            depsolve "${port}"
            [[ ${status} -eq 0 ]] && status=$?
        done
    fi

    return ${status}
}

# _cmd_requries <count> <word>
#
# Bash completion function for the requires command. Emits a list of port names.
#
# <count>   --  total number of completion words
# <word>    --  current word being completed
#
function _cmd_requires() {
    find "${PORTS}" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null
}
