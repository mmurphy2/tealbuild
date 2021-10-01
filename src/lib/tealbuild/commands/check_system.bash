# Runs checks on the system to ensure it is ready to run TealBuild.
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

function cmd_check_system() {
    local check qarch
    local status=0

    check_args "check-system" $# 0 0 || return 2

    # Check for QEMU
    echo "Checking for QEMU..."
    qarch="${ARCH,,}"
    [[ "${qarch}" =~ i[0-9]86 ]] && qarch="i386"
    check=$(qemu-system-${qarch} -version 2>/dev/null | head -n 1 | awk '{print $4}')
    if [[ -z "${check}" ]]; then
        echo "Missing qemu-system-${arch}: TealBuild will not be able to build packages"
        status=1
    else
        if [[ "${check%.*.*}" -lt 6 ]]; then
            echo "Installed QEMU version ${check} < 6.0.0."
            echo "TealBuild might still work but has not been tested with this version."
            status=1
        else
            echo "QEMU >= 6.0.0 is installed"
        fi
    fi

    # Check for the commands TealBuild needs to run
    echo "Checking for commands used by TealBuild..."
    which which || status=1
    which awk || status=1
    which bzcat || status=1
    which bzip2 || status=1
    which date || status=1
    which diff || status=1
    which du || status=1
    which find || status=1
    which git || status=1
    which ${GPG} || status=1
    which grep || status=1
    which kill || status=1
    which less || status=1
    which lzcat || status=1
    which md5sum || status=1
    which ncat || status=1
    which ps || status=1
    which python3 || status=1
    which qemu-img || status=1
    which realpath || status=1
    which rsync || status=1
    which scp || status=1
    which sed || status=1
    which sort || status=1
    which ssh || status=1
    which ssh-keygen || status=1
    which tar || status=1
    which uniq || status=1
    which wget || status=1
    which xargs || status=1
    which xorriso || status=1
    which xzcat || status=1
    which zcat || status=1

    # Check that EDITOR is set to a valid value
    if [[ -n "${EDITOR}" ]]; then
        which "${EDITOR}" || status=1
    else
        echo "Warning: EDITOR is unset: falling back to vi"
        which vi || status=1
    fi

    if [[ ${status} -eq 0 ]]; then
        banner "System check complete. There is a good chance TealBuild will run."
    else
        banner "Issues have been found. TealBuild may encounter errors."
    fi

    return ${status}
}
