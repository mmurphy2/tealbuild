# generate_repo_checksums
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

# Generates and signs the CHECKSUMS.md5 file inside the repository. This
# step should be run next-to-last, after everything but the FILELIST has
# been generated.

function generate_repo_checksums() {
    local status=0
    local temp

    cd "${REPO}/${ARCH}"

    echo "Generating CHECKSUMS.md5"

    rm -f CHECKSUMS.md5
    cat > CHECKSUMS.md5 << EOF
These are the MD5 message digests for the files in this directory.
If you want to test your files, use 'md5sum' and compare the values to
the ones listed here.

To test all these files, use this command:

tail +13 CHECKSUMS.md5 | md5sum -c --quiet - | less

'md5sum' can be found in the GNU coreutils package on ftp.gnu.org in
/pub/gnu, or at any GNU mirror site.

MD5 message digest                Filename
EOF
    find . -type f \! \( -name '*.log' -o -name '*.manifest' -o -name '*.meta' -o -name 'CHECKSUMS.md5*' \) -print0 | sort -z | \
        xargs -0 md5sum >> CHECKSUMS.md5
    status=$?

    if [[ ${status} -eq 0 ]]; then
        echo "Signing CHECKSUMS.md5"
        rm -f CHECKSUMS.md5.asc
        gpg_sign CHECKSUMS.md5
        status=$?
        [[ ${status} -ne 0 ]] && echo "Failed to sign CHECKSUMS.md5" >&2
    else
        echo "Failed to generate CHECKSUMS.md5" >&2
    fi

    cd - > /dev/null
    return ${status}
}
