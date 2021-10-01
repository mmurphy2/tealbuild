# banner <first_line> [[extra_lines] ...]
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

# Displays a banner consisting of 78 stars, followed by lines with starred
# borders, followed by a 78-star bottom line. It is the caller's
# responsibility to ensure that each line is no more than 74 characters long.
# The displayed banner will be preceded and followed by a blank line.
#
# <first_line>  --  first line of the banner
# [extra_lines] --  optional additional lines
#
# Returns 0 if no lines overflowed. A return value of 1 indicates that a line
# was too long.

function banner() {
    local line len n rpad
    local status=0

    echo
    echo "******************************************************************************"

    for line in "$@"; do
        echo -n "* ${line}"
        len=${#line}
        rpad=$(( 74 - len ))
        if [[ ${rpad} -ge 0 ]]; then
            for n in $(seq ${rpad}); do
                echo -n " "
            done
            echo " *"
        else
            # Overflow: just clear the buffer
            echo
            status=1
        fi
    done

    echo "******************************************************************************"
    echo

    return ${status}
}
