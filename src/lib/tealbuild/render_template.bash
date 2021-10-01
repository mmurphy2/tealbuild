# render_template [display_name]
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

# Extremely simple template renderer that implements a tiny subset of the
# Django/Jinja2 templating language. Specifically, this subset is simple
# substitution of variable values without supporting any filters. Each
# variable in the template must be written like so:
#
# {{ variable_name }}
#
# A single space around variable_name is strictly required by this engine
# (and is the recommended convention for Django/Jinja2). A missing leading
# space will not trigger a variable substitution, while a missing trailing
# space will result in a variable name error.
#
# The variables themselves are taken from the current environment, which can
# be modified in the usual way (e.g. foo=bar render_template example). If a
# variable is not defined in the environment, the placeholder will be deleted
# from the template.
#
# If the template is itself Django/Jinja2 code, then it is necessary to
# escape the leading { to prevent substitution, like so:
#
# \{{ not_a_variable_here }}
#
# The backslash will be stripped from the template output.
#
# If supplied [display_name] will be used as the template file identifier in
# any error messages, which will be sent to the standard error stream. The
# template itself is supplied as standard input to this function, while the
# resulting output file is produced as standard output. For example:
#
# echo "{{ PATH }}" | render_template
#
# Should return the current PATH.
#
# Variable names prefixed with rt_X_ are reserved for the templating engine.

function render_template() {
    local rt_X_cursor rt_X_delta rt_X_epos rt_X_line rt_X_loc rt_X_pos rt_X_prev rt_X_prevchar rt_X_varname
    local rt_X_line_no=1
    local rt_X_disp="$1"
    local rt_X_status=0

    while IFS= read -r rt_X_line; do
        rt_X_pos=0
        rt_X_cursor=0

        for rt_X_loc in $(echo "${rt_X_line}" | grep -bo '{{ '); do
            rt_X_pos="${rt_X_loc%%:*}"
            rt_X_prev=$(( rt_X_pos - 1 ))
            rt_X_delta=$(( rt_X_prev - rt_X_cursor ))
            rt_X_prevchar=""

            # Output everything in the line up to the character before the first match. If the first match is at
            # the start of the line, then rt_X_delta < 0, in which case there is nothing to output.
            if [[ ${rt_X_delta} -gt 0 ]]; then
                echo -n "${rt_X_line:rt_X_cursor:rt_X_delta}"
                rt_X_cursor=${rt_X_prev}
            fi

            if [[ ${rt_X_prev} -gt 0 ]]; then
                rt_X_prevchar="${rt_X_line:rt_X_prev:1}"
            fi

            if [[ "${rt_X_prevchar}" != '\' ]]; then
                # We're in a match with '{{ ' (since we're inside the for loop), the previous character wasn't '\'
                # Therefore, we need to do a variable substitution here. Start by outputting the previous character.
                echo -n "${rt_X_prevchar}"
                rt_X_cursor=$(( rt_X_cursor + 1 ))

                # Find the ending ' }}' in the rest of the line string
                rt_X_epos=$(echo "${rt_X_line:rt_X_pos+3}" | grep -bo ' }}' | head -n 1 | sed 's/:.*//')
                if [[ "${rt_X_epos}" -gt 0 ]]; then
                    rt_X_varname="${rt_X_line:rt_X_pos+3:rt_X_epos}"

                    if echo "${rt_X_varname}" | grep -q '^[A-Za-z_][A-Za-z0-9_]*$'; then
                        echo -n "${!rt_X_varname}"
                    else
                        echo "${rt_X_disp}:${rt_X_line_no}: Invalid variable name: '${rt_X_varname}'" >&2
                        rt_X_status=1
                        break  # abort and let the rest of the line be dumped as-is below
                    fi

                    rt_X_cursor=$(( rt_X_pos + 3 + rt_X_epos + 3 ))
                else
                    echo "${rt_X_disp}:${rt_X_line_no}: Syntax error: no matching ' }}'" >&2
                    rt_X_status=1
                    break # abort and let the rest of the line be dumped as-is below
                fi
            else
                # This '{{ ' is escaped as '\{{ '. Print everything after the \ on the next pass.
                rt_X_cursor=$(( rt_X_cursor + 1 ))
            fi
        done

        # Output the rest of the line plus a newline
        echo "${rt_X_line:rt_X_cursor}"
        rt_X_line_no=$(( rt_X_line_no + 1 ))
    done

    return ${rt_X_status}
}
