# generate_repo_filelist
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

# Generates the FILELIST.TXT in the repository directory. This is the last
# step in preparing the repository for use.

function generate_repo_filelist() {
    local uid="$(id -u)"
    local gid="$(id -g)"
    local status=0

    cd "${REPO}/${ARCH}" || return 1

    echo "Generating FILELIST.TXT"
    date -u "+%a %b %e %H:%M:%S %Z %Y" > FILELIST.TXT
    cat >> FILELIST.TXT << EOF

Here is the file list for this directory.  If you are using a
mirror site and find missing or extra files in the disk
subdirectories, please have the archive administrator refresh
the mirror.

EOF

    find . \! \( -name '*.log' -o -name '*.manifest' -o -name '*.meta' \) -print0 | sort -z | \
        xargs -0 ls -ldn --time-style=long-iso | sed "s/${uid}/root/" | sed "s/${gid}/root/" >> FILELIST.TXT
    status=$?

    cd - > /dev/null
    [[ ${status} -ne 0 ]] && echo "Failed to generate FILELIST.TXT" >&2
    return ${status}
}
