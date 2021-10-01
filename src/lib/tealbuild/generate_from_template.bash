# generate_from_template <template_name> <output_file>
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

# Generates an output file from a template, where the template is located
# first from TEALBUILD_ROOT/templates, followed by _USERCONFDIR/templates,
# followed by _SYSCONFDIR/templates, then finally _SHARE/templates.
#
# <template_name>   --  base name of the template file
# <output_file>     --  output path of the rendered template
#
# The template will be generated as <output_file>.new if <output_file>
# already exists.

function generate_from_template() {
    local status tplfile
    local dotnew=""
    local outdir=$(dirname "$2")

    # Find the template file
    if [[ -f "${TEALBUILD_ROOT}/templates/$1" ]]; then
        tplfile="${TEALBUILD_ROOT}/templates/$1"
        status=0
    else
        if [[ -f "${_USERCONFDIR}/templates/$1" ]]; then
            tplfile="${_USERCONFDIR}/templates/$1"
            status=0
        else
            if [[ -f "${_SYSCONFDIR}/templates/$1" ]]; then
                tplfile="${_SYSCONFDIR}/templates/$1"
                status=0
            else
                if [[ -f "${_SHARE}/templates/$1" ]]; then
                    tplfile="${_SHARE}/templates/$1"
                    status=0
                else
                    echo "Template file not found: $1" >&2
                    status=1
                fi
            fi
        fi
    fi

    if [[ ${status} -eq 0 ]]; then
        if [[ -d "${outdir}" ]]; then
            if [[ -e "$2" ]]; then
                dotnew=".new"
            fi

            echo "Using template file ${tplfile}" >&2
            cat "${tplfile}" | render_template "${ext_temp}" > "$2${dotnew}"
            status=$?

            if [[ ${status} -ne 0 ]]; then
                echo "Failed to create $2" >&2
            fi
        else
            echo "Output directory ${outdir} does not exist." >&2
            status=1
        fi
    fi

    return ${status}
}
