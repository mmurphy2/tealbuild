# Generates a new TealBuild configuration file in the TEALBUILD_ROOT directory.
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

function cmd_new_config() {
    local path
    local status=0

    check_args "new-config" $# 0 1 "[new_root]" || return 2

    if [[ -n "$1" ]]; then
        path="$1"
        if [[ "${path:0:1}" != "/" ]]; then
            path="$(pwd)/$1"
        fi
        TEALBUILD_ROOT=$(realpath -s -m "${path}")
    fi

    mkdir -pv "${TEALBUILD_ROOT}"
    status=$?

    if [[ ${status} -eq 0 ]]; then
        generate_from_template "tealbuild.conf" "${TEALBUILD_ROOT}/tealbuild.conf"
        status=$?
    fi

    return ${status}
}
