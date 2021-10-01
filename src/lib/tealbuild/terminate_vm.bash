# terminate_vm
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

# Terminates the build VM. If the VM is running in snapshot mode, the
# termination is abrupt (using the monitor's quit command), since there is no
# persistent disk image to corrupt. However, in persistent mode, this
# function can only send an ACPI shutdown request. As long as the VM is in
# runlevel 3 with X stopped, the shutdown should proceed normally. However,
# some desktop environments intercept the shutdown request and prompt the
# user for confirmation first.

function terminate_vm() {
    local status=1
    local run=1

    is_vm_running
    run=$?

    if [[ ${run} -eq 2 ]]; then
        # VM is paused: resume it first
        qemu_monitor_command cont
        sleep 2
        run=0
    fi

    if [[ ${run} -eq 0 ]]; then
        # Are we in snapshot mode? If so, we can just quit.
        if is_vm_snapshot; then
            qemu_monitor_command quit > /dev/null
            status=$?
        else
            # We need to do a graceful shutdown, since the VM is persistent
            qemu_monitor_command system_powerdown > /dev/null
            status=$?

            echo "Requested VM shutdown (in persistent mode). This may take a few minutes."
        fi
    fi

    return ${status}
}
