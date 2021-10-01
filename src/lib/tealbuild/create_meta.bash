# create_meta <package_file> [[package_file] ...]
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

# Creates a metadata (.meta), description (.txt), and contents (.manifest) file
# for each of a set of package files.
#
# <package_file>  --  path to the Slackware package file

function create_meta() {
    local base name path pkg pkgsize stem uncsize
    local conflicts required suggests
    local status=0

    for pkg in "$@"; do
        echo "Generating metadata for ${pkg}..."
        if [[ -f "${pkg}" ]]; then
            base=$(basename "${pkg}")
            stem=${base%.t?z}
            name="${base%-*-*-*}"
            path=$(dirname "${pkg}")
            pkgsize=$(du -k "${pkg}" | awk '{print $1}')
            uncsize=$(calculate_size "${pkg}")
            uncsize=$(( uncsize / 1024 ))

            # Extract the slack-desc to make the description file
            tar -f "${pkg}" -x install/slack-desc -O | grep "^${name}:" > "${path}/${stem}.txt"
            status=$?

            # Bail out if the slack-desc is missing
            if [[ ${status} -ne 0 ]]; then
                echo "Package ${pkg} is missing install/slack-desc!" >&2
                return 1
            fi

            # Create the metadata file
            echo "PACKAGE NAME:  ${base}" > "${path}/${stem}.meta"
            echo "PACKAGE LOCATION:  ." >> "${path}/${stem}.meta"
            echo "PACKAGE SIZE (compressed):  ${pkgsize} K" >> "${path}/${stem}.meta"
            echo "PACKAGE SIZE (uncompressed): ${uncsize} K" >> "${path}/${stem}.meta"

            # If the package was built with slapt-get dependency files, assume the user wants them included
            conflicts=$(tar -f "${pkg}" -x install/slack-conflicts -O 2>/dev/null | tr '\n' ',' | sed 's/,$//')
            requires=$(tar -f "${pkg}" -x install/slack-required -O 2>/dev/null | tr '\n' ',' | sed 's/,$//')
            suggests=$(tar -f "${pkg}" -x install/slack-suggests -O 2>/dev/null | tr '\n' ',' | sed 's/,$//')
            [[ -n "${conflicts}" ]] && echo "PACKAGE_CONFLICTS:  ${conflicts}" >> "${path}/${stem}.meta"
            [[ -n "${requires}" ]] && echo "PACKAGE_REQUIRED:  ${requires}" >> "${path}/${stem}.meta"
            [[ -n "${suggests}" ]] && echo "PACKAGE_SUGGESTS:  ${suggests}" >> "${path}/${stem}.meta"

            # Add the slack-desc
            echo "PACKAGE DESCRIPTION:" >> "${path}/${stem}.meta"
            cat "${path}/${stem}.txt" >> "${path}/${stem}.meta"
            echo >> "${path}/${stem}.meta"   # put the blank line here for concatenation purposes later

            # Create the .manifest file with a list of all the files in the package
            echo "++========================================" > "${path}/${stem}.manifest"
            echo "||" >> "${path}/${stem}.manifest"
            echo "||   Package:  ./${base}" >> "${path}/${stem}.manifest"
            echo "||" >> "${path}/${stem}.manifest"
            echo "++========================================" >> "${path}/${stem}.manifest"
            tar tvvf "${pkg}" >> "${path}/${stem}.manifest"
            echo -e "\n" >> "${path}/${stem}.manifest"  # Append 2 blank lines for later
        else
            echo "File not found: ${pkg}" >&2
            status=1
        fi

        if [[ ${status} -ne 0 ]]; then
            break
        fi
    done

    return ${status}
}
