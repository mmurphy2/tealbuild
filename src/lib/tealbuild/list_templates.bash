# list_templates
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

# Produces a list of all the templates visible on the various template paths,
# along with the path of each template.

function list_templates() {
    local base found full item itembase path pathlist
    local templates=()

    pathlist=( "${TEALBUILD_ROOT}/templates" "${_USERCONFDIR}/templates" "${_SYSCONFDIR}/templates" "${_SHARE}/templates" )
    for path in "${pathlist[@]}"; do
        if [[ -d "${path}" ]]; then
            while read -r full; do
                base=$(basename "${full}")
                found="no"
                for item in "${templates[@]}"; do
                    itembase=$(basename "${item}")
                    if [[ "${itembase}" == "${base}" ]]; then
                        found="yes"
                        break
                    fi
                done

                if [[ "${found}" == "no" ]]; then
                    templates+=("${full}")
                fi
            done <<< $(find "${path}" -mindepth 1 -type f 2>/dev/null | sort)
        fi
    done

    for item in "${templates[@]}"; do
        echo "${item}"
    done
}
