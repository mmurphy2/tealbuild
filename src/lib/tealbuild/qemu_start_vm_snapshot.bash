# qemu_start_vm_snapshot
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

# Starts the build VM in snapshot mode, in which any changes made inside the
# VM are thrown away when the VM stops. This mode is used for building
# packages, since it prevents introducing unintended dependencies.

function qemu_start_vm_snapshot() {
    # IMPORTANT: put -snapshot before -name. This makes snapshot mode detection more reliable by allowing the command-line
    # to be grepped for ' -snapshot ', reducing the risk of false detection if someone puts the word "snapshot" in the name
    # of the VM image
    qemu_start_vm \
        -snapshot \
        -name "tealbuild VM - snapshot mode" \
        "$@"
    return $?
}
