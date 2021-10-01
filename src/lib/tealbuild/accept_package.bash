# accept_package [package_file ...]
#
# This function is part of TealBuild.
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

# Accepts packages from the staging area, adding GPG signatures, generating
# package metadata, and moving them into the repository (archiving any prior
# versions of the package that were already in the repository). Specific
# package files can be listed; otherwise, all files in the staging area are
# accepted. If a GPG signature needs to be selected, the user-id can be
# specified with the TEALBUILD_GPG_EMAIL environment variable.
#
# [package_file]   --  optional base names of package files to accept
#
function accept_package() {
    local files="$@"
    local epkg found fpath item name pkg selpkg
    local status=0

    # Check to see if there are actually any new packages in staging first
    if ! ls "${STAGE}/${ARCH}/"*.t?z >/dev/null 2>&1; then
        echo "There are no new packages in the staging area." >&2
        return 1
    fi

    mkdir -pv "${REPO}/${ARCH}" || return 1

    for fpath in $(ls "${STAGE}/${ARCH}/"*.t?z); do
        pkg=$(basename "${fpath}")

        # Check to see if only certain packages need to be accepted
        if [[ $# -ne 0 ]]; then
            found="no"
            for selpkg in "$@"; do
                if [[ "${selpkg}" == "${pkg}" ]]; then
                    found="yes"
                    break
                fi
            done

            if [[ "${found}" != "yes" ]]; then
                # The package wasn't listed, so continue to the next package
                continue
            fi
        fi

        if [[ ! -f "${fpath}.asc" ]]; then
            gpg_sign "${fpath}" || status=1
        fi

        if [[ ${status} -eq 0 ]]; then
           create_meta "${fpath}" || status=1
        fi

        if [[ ${status} -eq 0 ]]; then
            # Archive any previous versions of the same package first
            name="${pkg%-*-*-*.t?z}"
            for item in $(find "${REPO}/${ARCH}" -name "${name}-*-*-*.t?z" -printf '%f '); do
                if [[ "${name}" == "${item%-*-*-*.t?z}" ]]; then
                    archive "${item}"
                fi
            done

            if [[ ${status} -eq 0 ]]; then
                # Move the package and metadata from staging into the repository
                mv "${fpath}" "${REPO}/${ARCH}/${pkg}" || status=1
                mv "${fpath}.asc" "${REPO}/${ARCH}/${pkg}.asc" || status=1
                mv "${STAGE}/${ARCH}/${pkg%.t?z}."{meta,txt,manifest} "${REPO}/${ARCH}/" || status=1
                if [[ -f "${STAGE}/${ARCH}/${pkg%.t?z}.log" ]]; then
                    mv "${STAGE}/${ARCH}/${pkg%.t?z}.log" "${REPO}/${ARCH}/" || status=1
                fi
            fi
        fi

        if [[ ${status} -ne 0 ]]; then
            echo "Package acceptance failed for ${pkg}" >&2
            break
        fi
    done

    if [[ ${status} -eq 0 ]]; then
        banner "New packages have been accepted into the repository." "" " Remember to run tealbuild update-repo"
    else
        banner "FAILED to accept new packages."
    fi

    return ${status}
}
