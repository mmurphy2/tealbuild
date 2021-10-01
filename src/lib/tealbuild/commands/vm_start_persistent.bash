# Starts the TealBuild virtual machine in persistent mode.
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

function cmd_vm_start_persistent() {
    local status=0
    check_args "vm-start-persistent" $# 0 0 || return 2

    if ! is_vm_running; then
        qemu_start_vm_persistent
        status=$?
    else
        if ! is_vm_snapshot; then
            echo "The VM is already running in persistent mode." >&2
            status=1
        else
            echo "The VM is currently running in snapshot mode and must be stopped first." >&2
            status=1
        fi
    fi

    return ${status}
}
