# qemu_start_vm [extra_options]
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

# Base function for starting the build VM using QEMU. This function should
# not be called directly (use one of the qemu_start_vm_* functions to start
# in a specified mode instead). Any arguments passed to the function will be
# passed to the qemu-system-* process.
#
# [extra_options]   --  optional extra options for the qemu-system-* command

function qemu_start_vm() {
    local sys="${ARCH,,}"

    [[ "${sys}" =~ i[0-9]86 ]] && sys="i386"

    "qemu-system-${sys}" \
        -machine type="${VM_SYSTEM}" \
        -accel "${VM_ACCEL}" \
        -cpu "${VM_CPU}" \
        -smp cores="${VM_CPU_CORES_PER_CPU}",threads="${VM_CPU_THREADS_PER_CORE}",sockets="${VM_CPU_COUNT}" \
        -m "${VM_RAM}" \
        -rtc base=utc \
        -drive file="${VM_IMAGE}",if="${VM_DISK_TYPE}",format="${VM_IMAGE_FORMAT}" \
        -nic user,id=NAT,model="${VM_NIC_MODEL}",mac="${VM_MAC}",hostfwd="tcp:127.0.0.1:"${VM_SSH_PORT}"-:22" \
        -vga "${VM_VGA}" \
        -display "${VM_DISPLAY}" \
        -boot order=cd,menu=on \
        -usb -device usb-tablet \
        -monitor "tcp:127.0.0.1:${VM_MONITOR_PORT},server=on,wait=off" \
        -daemonize \
        ${VM_EXTRA_SETTINGS} \
        "$@"
    return $?
}
