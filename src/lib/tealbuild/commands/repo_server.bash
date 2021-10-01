# Starts a simple HTTP server using the repository tree (REPO) as the root.
#
# This command is part of TealBuild.
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
#

function cmd_repo_server() {
    local cmdline
    local pid
    local status=0

    check_args "repo-server" $# 0 1 "<start | stop | status>" || return 2

    cmdline="python3 -m http.server --bind ${REPO_SERVER_ADDRESS} --directory ${REPO} ${REPO_SERVER_PORT}"

    case "$1" in
        start)
            if [[ -d "${REPO}" ]]; then
                ${cmdline} >/dev/null &
                status=$?
                pid=$!

                if [[ ${status} -eq 0 ]]; then
                    disown ${pid}
                    echo "Repository server started on port ${REPO_SERVER_PORT}"
                else
                    echo "Failed to start repository server. Is the port in use?" >&2
                fi
            else
                echo "The repository has not yet been created." >&2
                echo >&2
                echo "Run tealbuild update-repo to create it." >&2
                status=1
            fi
            ;;
        stop)
            pid=$(ps ax | grep "${cmdline}" | grep -v grep | awk '{print $1}')
            if [[ -n "${pid}" ]]; then
                kill ${pid}
                status=$?
            fi
            ;;
        status)
            ps ax | grep -v grep | grep -q "${cmdline}"
            status=$?
            if [[ "${status}" -eq 0 ]]; then
                echo "Server is running on port ${REPO_SERVER_PORT}"
            else
                echo "Server is not running"
            fi
            ;;
        *)
            echo "Usage: tealbuild repo-server <start | stop | status>" >&2
            status=1
            ;;
    esac

    return ${status}
}

# _cmd_repo_server
#
# Bash completion function for the repo-server command. Supports a single
# argument of stop, start, or status.
#
function _cmd_repo_server() {
    if [[ "$1" -le 3 ]]; then
        echo "start stop status"
    fi
}
