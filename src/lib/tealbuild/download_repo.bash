# download_repo
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

# Downloads a copy of the remote repository to the local system.

function download_repo() {
    local remote status
    local rsync_opts=()

    mkdir -pv "${REPO}/${ARCH}" || return 1

    remote="${REPO_REMOTE_PATH}"
    if [[ -z "${remote}" ]]; then
        echo "Remote repository has not been configured in tealbuild.conf" >&2
        return 1
    fi

    if [[ -n "${REPO_SSH_USER}" && -n "${REPO_SSH_HOST}" ]]; then
        remote="${REPO_SSH_USER}@${REPO_SSH_HOST}:${remote}"
        rsync_opts=( "-e" "ssh -p ${REPO_SSH_PORT:-22}" )
    fi

    rsync "${rsync_opts[@]}" -P -ritvz --cvs-exclude --exclude '*.meta' --exclude '*.manifest' \
                --exclude '*.log' "${remote}/${ARCH}/" "${REPO}/${ARCH}/"
    status=$?

    mkdir -pv "${ARCHIVE}/changelogs"
    cat "${REPO}/${ARCH}/ChangeLog.txt" > "${ARCHIVE}/changelogs/ChangeLog.txt-$(date +%Y%m%d-%H%M%S)"

    if ! check_repo; then
        echo "Duplicates must be resolved manually." >&2
    fi

    return ${status}
}
