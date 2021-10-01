# Automatically downloads and checks the MD5 hash values of source files.
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

function cmd_fetch_sources() {
    local item
    local status=0

    check_args "fetch-sources" $# 1 + "<port_name> [[port_name] ...]" || return 2

    for item in "$@"; do
        fetch_sources "${item}"
        status=$?

        if [[ ${status} -eq 0 ]]; then
            banner "Successfully fetched sources for ${item}"
        else
            banner "FAILED to fetch sources for ${item}"
            break
        fi
    done

    return ${status}
}

# _cmd_fetch_sources <count> <word>
#
# Bash completion function for the fetch-sources command. Outputs a list of
# directory names in the PORTS directory.
#
# <count>   --  total number of completion words
# <word>    --  current word being completed
#
function _cmd_fetch_sources() {
    find "${PORTS}" -mindepth 1 -maxdepth 1 -type d -not -name '.*' -printf '%f\n' 2>/dev/null | sort
}
