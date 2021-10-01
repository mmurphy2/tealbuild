# profile_cpu
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

# Determines how many CPU cores are available on the local host and echoes
# half that number (minimum 1). The purpose of this function is to establish
# a sensible default value for the number of cores to give the tealbuild
# virtual machine.

function profile_cpu() {
    local cores

    cores=$(cat /proc/cpuinfo | grep processor | tail -n 1 | awk '{print $3}')
    cores=$(( cores + 1 ))
    cores=$(( cores / 2 ))
    [[ ${cores} -lt 1 ]] && cores=1

    echo ${cores}

    if [[ ${cores} -lt 2 ]]; then
        echo "Warning: Build performance on this computer may be unsatisfactory" >&2
    fi
}
