# Generates a new SlackBuild file for a port with the specified name.
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

function cmd_new_slackbuild() {
    local name="$1"  # used inside the template
    local tplname="$2"
    local outfile="$3"
    local year=$(date +%Y)  # used inside the template

    check_args "new-slackbuild" $# 1 3 "<port_name> [template [output_file]]" || return 2

    [[ -z "${tplname}" ]] && tplname="default"
    [[ -z "${outfile}" ]] && outfile="${PORTS}/${name}/${name}.SlackBuild"

    generate_from_template "${tplname}.SlackBuild" "${outfile}"
    return $?
}

# _cmd_new_slackbuild <count> <word>
#
# Bash completion function that suggests existing port names for the first
# argument, followed by SlackBuild template names for the second argument,
# then falls back to the readline default (file/path completion) for the
# third argument.
#
# <count>   --  total number of completion words
# <word>    --  current word being completed
#
function _cmd_new_slackbuild() {
    if [[ "$1" -lt 3 || ( "$1" -eq 3 && -n "$2" ) ]]; then
        find "${PORTS}" -mindepth 1 -maxdepth 1 -type d -not -name '.*' -printf '%f\n' 2>/dev/null
    elif [[ "$1" -eq 3 || ( "$1" -eq 4 && -n "$2" ) ]]; then
        list_templates | grep '\.SlackBuild$' | sed 's/\.SlackBuild$//'
    fi
}
