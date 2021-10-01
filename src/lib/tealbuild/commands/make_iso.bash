# Creates a bootable Slackware(64) ISO from the specified source tree.
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

function cmd_make_iso() {
    local status=0

    check_args "make-iso" $# 4 4 "<tree_root> <appid> <volid> <output_file>" || return 2
    make_iso "$@"
    status=$?

    if [[ ${status} -eq 0 ]]; then
        banner "New ISO file created at: $4"
    else
        banner "Failed to generate ISO file." >&2
    fi

    return ${status}
}

# _cmd_make_iso <count> <word>
#
# Bash completion function for the make-iso command. For the first argument
# to the command, yields a list of directories inside the SLACKWARE
# directory. For the second and third arguments, yields the standard values
# of these arguments as would be used when building a -current ISO. For the
# final argument, falls back to readline defaults.
#
# <count>   --  total number of completion words
# <word>    --  current word being completed
#
function _cmd_make_iso() {
    if [[ "$1" -eq 2 || ( "$1" -le 3 && -n "$2" ) ]]; then
        find "${SLACKWARE}" -mindepth 1 -maxdepth 1 -type d 2>/dev/null
    elif [[ "$1" -eq 3 && -z "$2" ]]; then
        echo "'Slackware-Install'"
    elif [[ "$1" -eq 4 && -z "$2" ]]; then
        echo "SlackDVD"
    fi
}
