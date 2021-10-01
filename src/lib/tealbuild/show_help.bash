# show_help
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

# Displays a help message to the user.

function show_help() {
    local basename fn

    basename=$(basename "$0")
    echo "TealBuild - A package build and repository helper for Slackware Linux"
    echo
    echo "Usage: ${basename} <command> [[argument] ...]"
    echo
    echo "Available commands are:"
    echo
    for fn in $(compgen -A function | grep '^cmd_' | sed 's/^cmd_//' | sed 's/_/-/g' | sort); do
        echo "    * ${fn}"
    done
    echo
    echo "For more help, see the man page for tealbuild(1). If TealBuild is not"
    echo "installed centrally, run:"
    echo
    echo "    eval \$(${basename} complete)"
    echo
    echo "to place TealBuild on the PATH and set up man pages."
}
