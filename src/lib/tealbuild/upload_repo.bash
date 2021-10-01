# upload_repo
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

# Uploads a copy of the local repository to a remote system.

function upload_repo() {
    local name remote status
    local rsync_opts=()

    if [[ ! -d "${REPO}/${ARCH}" ]]; then
        echo "There is no local repository to upload." >&2
        return 1
    fi

    remote="${REPO_REMOTE_PATH}"
    if [[ -z "${remote}" ]]; then
        echo "Remote repository has not been configured in tealbuild.conf" >&2
        return 1
    fi

    if [[ -n "${REPO_SSH_USER}" && -n "${REPO_SSH_HOST}" ]]; then
        rsync_opts=( "-e" "ssh -p ${REPO_SSH_PORT:-22}" )
        remote="${REPO_SSH_USER}@${REPO_SSH_HOST}:${remote}"
    fi

    # Check that we aren't about to push a broken repository
    check_repo || status=1
    for name in CHECKSUMS.md5 CHECKSUMS.md5.asc ChangeLog.txt MANIFEST.bz2; do
        if [[ ! -f "${REPO}/${ARCH}/${name}" ]]; then
            echo "Local repository is missing ${name}" >&2
            status=1
        fi
    done

    if [[ ${status} -eq 0 ]]; then
        # Be sure that the remote repository hasn't changed
        if [[ "${TEALBUILD_FORCE_PUSH_REPO}" != "YES" ]]; then
            check_remote
            status=$?
        fi

        if [[ ${status} -eq 0 ]]; then
            # Push the ChangeLog.txt first to reduce collision risk
            rsync "${rsync_opts[@]}" -P -ritvz "${REPO}/${ARCH}/ChangeLog.txt" "${remote}/${ARCH}/ChangeLog.txt"
            rsync "${rsync_opts[@]}" -P -ritvz --cvs-exclude --exclude '*.meta' --exclude '*.manifest' \
                    --exclude '*.log' --delete --delete-after "${REPO}/${ARCH}/" "${remote}/${ARCH}/"
            status=$?

            mkdir -p "${ARCHIVE}/changelogs"
            cat "${REPO}/${ARCH}/ChangeLog.txt" > "${ARCHIVE}/changelogs/ChangeLog.txt-$(date +%Y%m%d-%H%M%S)"
        fi
    else
        echo "Local repository is broken and cannot be uploaded in this state." >&2
        echo "It must be fixed manually." >&2
    fi

    return ${status}
}
