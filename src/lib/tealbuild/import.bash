# import <directory | tarball | url >
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

# Imports a specified directory into the PORTS tree for building. Typically,
# the directory to be imported comes from SBo or a similar upstream source.
# Alternatively, a tarball containing the directory to be imported may be
# specified, or even an http(s) or ftp URL from which the tarball may be
# downloaded. The downloaded or extracted tarball must contain a single
# directory matching the port name.
#
# <directory | tarball | url >  -- path or URL to import

function import() {
    local item line tarfile temp tln
    local name=$(basename "$1")
    local ruler_offset=$(printf ' %.0s' $(seq ${#name}))  # used if we have to create a slack-desc
    local target="${PORTS}/${name}"
    local year=$(date +%Y)

    if [[ ! -d "$1" ]]; then
        tarfile="$1"

        # This could be a URL to a tarfile: support HTTP(s) and FTP
        if echo "$1" | grep -qE '^(http|https|ftp)://'; then
            wget -O /tmp/tealbuild.import.tar "$1" || return 1
            tarfile="/tmp/tealbuild.import.tar"
        fi

        # Be sure we have the correct tarfile format
        for item in $(tar tf "${tarfile}" | sed 's~/.*~~'); do
            if [[ -z "${tln}" ]]; then
                # Set the top-level name, and be sure there is only one
                tln="${item}"
            elif [[ "${tln}" != "${item}" ]]; then
                echo "$1 does not have the correct structure for import" >&2
                return 1
            fi
        done

        if [[ -z "${tln}" ]]; then
            echo "No such directory or archive: $1" >&2
            return 2
        else
            # Reset the final name of the directory that will be extracted
            name="${tln}"
            target="${PORTS}/${name}"
        fi
    fi

    if [[ -d "${target}" ]]; then
        echo "A port named ${name} already exists in ${PORTS}" >&2
        return 3
    fi

    mkdir -pv "${PORTS}"
    if [[ -n "${tln}" ]]; then
        tar vf "${tarfile}" -C "${PORTS}" -x
        temp=$?
        rm -f /tmp/tealbuild.import.tar
        [[ ${temp} -ne 0 ]] && return 4
    else
        cp -r "$1" "${target}" || return 4
    fi

    if [[ -f "${target}/${name}.SlackBuild" ]]; then
        echo "Fixing default build settings..."
        sed -i "s/^TAG=.*/TAG=\${TAG:-${TAG}}/" "${target}/${name}.SlackBuild"
        sed -i 's~^TMP=.*~TMP=${TMP:-/tmp/tealbuild/build}~' "${target}/${name}.SlackBuild"
        sed -i 's~^PKG=.*~PKG=${TMP}/package-${PRGNAM}~' "${target}/${name}.SlackBuild"
        sed -i 's~^OUTPUT=.*~OUTPUT=${OUTPUT:-/tmp/tealbuild/output}~' "${target}/${name}.SlackBuild"
        sed -i 's/^BUILD=.*/BUILD=${BUILD:-1}/' "${target}/${name}.SlackBuild"
        sed -i 's/${PKGTYPE:-tgz}/${PKGTYPE:-txz}/' "${target}/${name}.SlackBuild"
        sed -i 's/^python /python3 /' "${target}/${name}.SlackBuild"

        echo "Adding copyright line..."
        line=$(cat "${target}/${name}.SlackBuild" | grep -n "# Copyright" | tail -n 1 | sed 's/:.*//')
        if [[ -n "${line}" ]]; then
            line=$(( line + 1 ))
            sed -i "${line}i# Copyright ${year} ${COPYRIGHT_OWNER}" "${target}/${name}.SlackBuild"
            [[ $? -ne 0 ]] && echo "Adding copyright line failed... manual edit required"
        else
            echo "Unable to find existing copyright line... manual edit required"
        fi
    else
        echo "Creating SlackBuild..."
        generate_from_template "default.SlackBuild" "${target}/${name}.SlackBuild"
    fi

    if [[ -f "${target}/${name}.info" ]]; then
        echo "Updating ${target}/${name}.info..."
        sed -i "s/^MAINTAINER=.*/MAINTAINER=\"${PACKAGER_NAME}\"/" "${target}/${name}.info"
        sed -i "s/^EMAIL=.*/EMAIL=\"${PACKAGER_EMAIL}\"/" "${target}/${name}.info"
    else
        echo "Creating ${name}.info..."
        generate_from_template "info" "${target}/${name}.info"
    fi

    if [[ ! -f "${target}/tealbuild.include" ]]; then
        echo "Creating tealbuild.include file..."
        generate_from_template "tealbuild.include" "${target}/tealbuild.include"
    fi

    if [[ ! -f "${target}/slack-desc" ]]; then
        echo "Creating slack-desc..."
        generate_from_template "slack-desc" "${target}/slack-desc"
    fi

    return 0
}
