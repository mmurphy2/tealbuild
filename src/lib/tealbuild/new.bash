# new <name> [slackbuild_template]
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

# Creates a new port with SlackBuild, slack-desc, info, doinst, and
# tealbuild.include templates in "${PORTS}/<name>". If the optional
# [slackbuild_template] argument is given, it specifies the name of the
# SlackBuild template to use ([slackbuild_template].SlackBuild).
#
# <name>    --  name of the new package for which to create a port
# [slackbuild_template]  --  name of SlackBuild template to use

function new() {
    local name="$1"  # the "name" variable is used inside the templates
    local sbtemplate="$2"
    local ruler_offset=$(printf ' %.0s' $(seq ${#name}))  # used in the slack-desc template
    local year=$(date +%Y)  # used in the SlackBuild template
    local status=0

    [[ -z "${sbtemplate}" ]] && sbtemplate="default"

    if [[ -e "${PORTS}/${name}" ]]; then
        echo "Port '${name}' already exists"
        status=1
    else
        mkdir -pv "${PORTS}/${name}" || status=1
        generate_from_template "${sbtemplate}.SlackBuild" "${PORTS}/${name}/${name}.SlackBuild" || status=1
        generate_from_template "info" "${PORTS}/${name}/${name}.info" || status=1
        generate_from_template "slack-desc" "${PORTS}/${name}/slack-desc" || status=1
        generate_from_template "doinst.sh" "${PORTS}/${name}/doinst.sh.in" || status=1
        generate_from_template "tealbuild.include" "${PORTS}/${name}/tealbuild.include" || status=1
    fi

    if [[ ${status} -eq 0 ]]; then
        banner "Created new port '${name}'" "" "${PORTS}/${name}"
    else
        banner "FAILED to create new port '${name}'" >&2
    fi

    return ${status}
}
