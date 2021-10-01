# Creates package metadata files for one or more packages.
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

function cmd_create_meta() {
    check_args "create-meta" $# 1 + "<staging_package_file> [[staging-package-file] ...]" || return 2

    create_meta "$@"
    return $?
}

# _cmd_create_meta <count> <word>
#
# Bash completion function for the create-meta command. Outputs a list of
# the packages in the staging area.
#
# <count>   --  total number of completion words
# <word>    --  current word being completed
#
function _cmd_create_meta() {
    (cd "${STAGE}/${ARCH}" && ls *.t?z 2>/dev/null)
}
