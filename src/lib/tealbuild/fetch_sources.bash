# fetch_sources <name>
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

# Downloads and verifies the source archives found in a .info file inside a
# port directory (in PORTS). The source archives themselves are stored in
# a subdirectory with the same name in SOURCES.
#
# <name>    --   name of the port for which sources are to be downloaded

function fetch_sources() {
    local dl gpgkey index item line md5 name path sig status sum temp
    local download_list=()
    local filename_list=()
    local md5_list=()
    local gpg_list=()
    local sig_list=()
    local gpg_key_list=()

    if [[ ! -f "${PORTS}/$1/$1.info" ]]; then
        echo "File not found: ${PORTS}/$1/$1.info" >&2
        return 1
    fi

    # First, get the downloads from the info file. Use a subshell to avoid namespace pollution.
    temp=$(. "${PORTS}/$1/$1.info" && echo "${DOWNLOAD_x86_64}")
    if [[ "${ARCH}" == "x86_64" && -z "${temp}" ]]; then
        temp=$(. "${PORTS}/$1/$1.info" && echo "${DOWNLOAD}")
    fi

    for item in ${temp}; do
        # Allow renaming downloads (borrowed syntax from Arch Linux)
        if echo "${item}" | grep -q '::'; then
            filename_list+=("${item%%::*}")
            download_list+=("${item#*::}")
        else
            download_list+=("${item}")
            filename_list+=($(basename "${item}"))
        fi
    done

    # Extract the MD5 sums from the same info file
    temp=$(. "${PORTS}/$1/$1.info" && echo "${MD5SUM_x86_64}")
    if [[ "${ARCH}" == "x86_64" && -z "${temp}" ]]; then
        temp=$(. "${PORTS}/$1/$1.info" && echo "${MD5SUM}")
    fi

    for item in ${temp}; do
        md5_list+=("${item}")
    done

    # Extract GPG signature files
    temp=$(unset GPG; . "${PORTS}/$1/$1.info" && echo "${GPG}")
    if [[ "${ARCH}" == "x86_64" && -z "${temp}" ]]; then
        temp=$(. "${PORTS}/$1/$1.info" && echo "${GPG_x86_64}")
    fi

    for item in ${temp}; do
        gpg_list+=("${item}")
        sig_list+=($(basename "${item}"))
    done

    # Extract GPG keys
    gpgkey="no"
    temp=""
    while IFS= read -r line; do
        if echo "${line}" | grep -q -- '-----BEGIN PGP PUBLIC KEY BLOCK-----'; then
            gpgkey="yes"
            temp+="${line}\n"
        elif [[ "${gpgkey}" == "yes" ]]; then
            temp+="${line}\n"
            if echo "${line}" | grep -q -- '-----END PGP PUBLIC KEY BLOCK-----'; then
                gpgkey="no"
                temp=$(echo -e "${temp}")
                gpg_key_list+=("${temp}")
                temp=""
            fi
        elif [[ -n "${line}" ]]; then
            gpg_key_list+="${line}"
        fi
    done <<< $(. "${PORTS}/$1/$1.info" && echo "${GPG_KEY}")

    # The actual download and verification step
    index=0
    mkdir -pv "${SOURCES}/$1"
    for item in "${download_list[@]}"; do
        path="${SOURCES}/$1/${filename_list[${index}]}"
        gpgkey="${gpg_key_list[${index}]}"
        sig="${sig_list[${index}]}"
        [[ -n "${sig}" ]] && sig="${SOURCES}/$1/${sig}"
        md5="${md5_list[${index}]}"

        # Allow one GPG key to be used for all sources
        if [[ -z "${gpgkey}" && -n "${sig}" && "${index}" -gt 0 ]]; then
            gpgkey="${gpg_key_list[0]}"
        fi

        if [[ -f "${path}" ]]; then
            if verify_source "${path}" "${md5}" "${sig}" "${gpgkey}"; then
                index=$(( index + 1 ))
                continue
            else
                echo "Removing and re-downloading the source file"
                rm -f "${path}"
                rm -f "${sig}"
            fi
        fi

        echo "Downloading ${item}..."
        wget -O "${path}" "${item}"
        status=$?

        if [[ ${status} -eq 0 ]]; then
            if [[ -n "${sig}" ]]; then
                echo "Downloading ${sig}..."
                temp=$(basename "${sig}")
                wget -O "${SOURCES}/$1/${temp}" "${gpg_list[${index}]}"
                status=$?
            fi
        fi

        if [[ ${status} -eq 0 ]]; then
            if ! verify_source "${path}" "${md5}" "${sig}" "${gpgkey}"; then
                echo "Verification failed for ${item}" >&2
                status=1
                break
            fi
        else
            echo "Download failed: ${item}" >&2
            break
        fi
        index=$(( index + 1 ))
    done

    return ${status}
}
