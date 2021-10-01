# qemu_monitor_command <command> [args]
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

# Sends a command to the qemu monitor for the build VM. This function permits
# the build VM to be controlled by the host system (e.g. to terminate it).
#
# <command>   --  QEMU monitor command to send
# [args]      --  any arguments to the command
#
# The monitor commands are documented at:
# https://qemu-project.gitlab.io/qemu/system/monitor.html

function qemu_monitor_command() {
    local status=2
    local result=""

    if ss -lntp | awk '{print $4}' | grep ':' | awk -F ':' '{print $2}' | grep -q "${VM_MONITOR_PORT}"; then
        result=$(echo "$@" | ncat ${NCAT_OPTIONS} 127.0.0.1 "${VM_MONITOR_PORT}")
        status=${PIPESTATUS[1]}
        result=$(echo "${result}" | grep -v '^(qemu)' | grep -v '^QEMU')
        # It looks like the monitor might use /r/n line endings!
        result=$(echo "${result}" | sed 's/\r$//')
    fi

    echo "${result}"
    return ${status}
}
