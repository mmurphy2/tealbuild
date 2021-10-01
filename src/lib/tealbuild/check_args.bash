# check_args <command_name> <num_args> <min_args> <max_args> <usage_info>
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

# Checks that the correct number of arguments have been supplied to a given
# function. Intended for use with command functions. Displays usage
# information on standard error if the argument number is incorrect.
#
# <cmd_name>     --  name of the command
# <num_args>     --  number of arguments given ($#)
# <min_args>     --  minimum number of arguments
# <max_args>     --  maximum number of arguments (use a single + sign if the
#                    function takes an unlimited number of arguments)
# <usage>        --  message to print if the number of arguments is wrong
#
# Returns 0 if the argument count is OK, 2 otherwise.

function check_args() {
    local status=0

    [[ $2 -lt $3 ]] && status=2
    [[ "$4" != "+" && $2 -gt $4 ]] && status=2

    if [[ ${status} -ne 0 ]]; then
        echo "Usage: ${_SELF_EXE} $0 $5" >&2
    fi

    return ${status}
}
