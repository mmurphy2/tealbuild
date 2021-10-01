# sync_slackware <version>
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

# Synchronizes a section of the Slackware software tree from an rsync mirror
# site, placing the result into an architecture+version-dependent
# subdirectory of the local copy of the tree. This approach only synchronizes
# the part of the tree actually needed for custom ISO creation and patch
# extraction purposes. This function will automatically select between
# "slackware" and "slackware64", and it is designed to work with numbered
# releases as well as with "current".
#
# <version>   --  version of Slackware (numbered or "current")

function sync_slackware() {
    local oldts partname stamp status ts

    partname="slackware"
    [[ "${ARCH}" == "x86_64" ]] && partname+="64"
    partname+="-$1"

    # rsync the part of the tree we want
    echo "Synchronizing ${partname} from upstream tree..."
    mkdir -pv "${SLACKWARE}/${partname}" || return 1
    rsync -havP --delete --delete-after --no-o --no-g --safe-links --timeout=60 --contimeout=30 \
        "${SLACKWARE_UPSTREAM}/${partname}/" "${SLACKWARE}/${partname}/"
    status=$?

    # Check the GPG signature on CHECKSUMS.md5
    if [[ ${status} -eq 0 ]]; then
        echo "Checking GPG signature of CHECKSUMS.md5.asc"
        check_slackware_gpg "${SLACKWARE}/${partname}/CHECKSUMS.md5.asc"
        status=$?
    else
        echo "Failed to rsync ${SLACKWARE_UPSTREAM}/${partname}" >&2
    fi

    # Check the MD5 sums
    if [[ ${status} -eq 0 ]]; then
        echo "Verifying MD5 checksums..."
        (cd "${SLACKWARE}/${partname}" && tail +13 CHECKSUMS.md5 | md5sum -c -)
        status=$?

        if [[ ${status} -ne 0 ]]; then
            echo "MD5 check FAILED" >&2
        fi
    fi

    # Implement safeguard against a replay attack
    # See: https://www2.cs.arizona.edu/stork/packagemanagersecurity/attacks-on-package-managers.html
    if [[ ${status} -eq 0 ]]; then
        stamp=$(head -n 1 "${SLACKWARE}/${partname}/ChangeLog.txt")
        ts=$(date -d "${stamp}" +%s)

        if [[ -f "${SLACKWARE}/${partname}/tealbuild.stamp" ]]; then
            oldts=$(head -n 1 "${SLACKWARE}/${partname}/tealbuild.stamp")
            if [[ "${ts}" -lt "${oldts}" ]]; then
                echo "DANGER! Possible replay attack: ChangeLog.txt timestamp has run backward" >&2
                status=1
            fi
        fi

        echo "${ts}" > "${SLACKWARE}/${partname}/tealbuild.stamp" || status=1
    fi

    return ${status}
}
