# generate_repo_pkglist
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

# Generates the PACKAGES.TXT and packages.diff files in the repository.

function generate_repo_pkglist() {
    local status=0

    check_repo || return 1
    cd "${REPO}/${ARCH}"

    echo "Generating PACKAGES.TXT"

    if [[ -f "PACKAGES.TXT" ]]; then
        cat PACKAGES.TXT | grep 'PACKAGE NAME:' | awk '{print $3}' | sort > pkglist.old
    fi

    cat > PACKAGES.TXT << EOF
PACKAGES.TXT;  $(date -u "+%a %b %e %H:%M:%S %Z %Y")

This file provides details on the packages found in the ./ directory.


EOF
    cat *.meta >> PACKAGES.TXT

    cat PACKAGES.TXT | grep 'PACKAGE NAME:' | awk '{print $3}' | sort > pkglist.new
    diff -Nd pkglist.old pkglist.new | grep '^[<>]' | sort -k 2 > packages.diff
    status=$?

    rm -f pkglist.old pkglist.new
    cd - > /dev/null

    return ${status}
}
