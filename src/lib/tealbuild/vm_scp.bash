# vm_scp <source_path> [source_path ...] <dest>
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

# Uses SCP to transfer a file or directory to the build VM (as the root user).
# The transferred file or directory will be saved in <dest> inside the build
# VM. Detection of recursive transfers is automatic.

function vm_scp() {
    local recursive=""
    local sources=()
    local status

    while [[ $# -gt 1 ]]; do
        [[ -d "$1" ]] && recursive="-r"
        sources+=( "$1" )
        shift
    done

    scp -i "${SSH_ROOT_KEY}" -P ${VM_SSH_PORT} ${recursive} "${sources[@]}" root@localhost:"$1"
    return $?
}
