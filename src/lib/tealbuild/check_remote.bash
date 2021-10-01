# check_remote
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

# Checks to see if the remote repository has changed since it was last pushed from this TealBuild instance.

function check_remote() {
    local oldlog remote status temp
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

    echo "Checking remote ChangeLog.txt..."
    temp=$(mktemp -d)
    rsync "${rsync_opts[@]}" -itz --size-only "${remote}/${ARCH}/ChangeLog.txt" "${temp}/" >/dev/null 2>&1
    status=$?

    if [[ ${status} -eq 23 ]]; then
        # No remote ChangeLog.txt on host, so this check is good
        status=0
    else
        oldlog=$(find "${ARCHIVE}/changelogs/" -mindepth 1 -maxdepth 1 -printf '%f\n' 2>/dev/null | sort | tail -n 1)
        if [[ -n "${oldlog}" ]]; then
            # If we have an old ChangeLog, check to see if the one we just downloaded differs
            if ! diff -q "${ARCHIVE}/changelogs/${oldlog}" "${temp}/ChangeLog.txt"; then
                status=1
            fi
        else
            # No old ChangeLog, so the remote repo must be different
            status=1
        fi
    fi

    [[ "${temp}" != "/" ]] && rm -rf "${temp}"

    # Display a difference message if required
    if [[ ${status} -ne 0 ]]; then
        echo "Remote repository has been changed." >&2
        echo "Run tealbuild download-repo first, and resolve differences." >&2
    fi

    return ${status}
}
