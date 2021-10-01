# bash_complete
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

# Bash completion engine for TealBuild. Performs Bash completion whenever
# COMP_LINE is set; otherwise, displays the output needed to set up Bash
# completion (and add tealbuild to the PATH).
#
# Extensible Bash completion works inside TealBuild by having an optional
# completion function along with each command function. For example, if a
# command is implemented with cmd_foo, the completion function would be
# _cmd_foo. If the completion function is not defined for a command, or if
# the completion function does not produce any output, the top-level
# "complete -o default" option will fall back to readline's default path
# completion, which will work nicely for any command that takes an arbitrary
# filename on the system.
#
# Completion functions are invoked with two arguments. The first is the number
# of words in the current completion line, which will generally be least 2 by
# the time a completion function is reached (the tealbuild executable name
# and command are the first two). The current word being completed (which may
# be empty) is the second argument. For the full text line, completion
# functions have access to the COMP_LINE variable as documented in the Bash
# reference for programmable command completion.

function bash_complete() {
    local basecommands cmd complete_fn data length whereami word
    local -a words

    if [[ -z "${COMP_LINE}" ]]; then
        if ! which tealbuild >/dev/null 2>&1; then
            echo "PATH=\"${_BINDIR}:\${PATH}\"; export PATH;"
            echo "MANPATH=\"${_MANDIR}:\${MANPATH}\"; export MANPATH;"
        fi

        echo "complete -o default -C 'tealbuild complete' tealbuild;"
        echo "# To enable Bash completion, run:"
        echo "#"
        echo "# eval \$($0 complete)"
    else
        data=""
        read -ra words <<< "${COMP_LINE}"
        length=${#words[@]}
        basecommands=$(compgen -A function | grep '^cmd_' | sed 's/^cmd_//' | sed 's/_/-/g')

        # To use compgen -W for word prefix matching, we need to tell it the prefix. However, when starting a new
        # completion before anything has been typed, the last element of the array is the previously completed word.
        # Check the last character of the COMP_LINE: if it's a space, then we're starting a new completion.
        word="${words[-1]}"
        [[ "${COMP_LINE: -1}" == " " ]] && word=""

        if [[ ${length} -eq 1 || (${length} -le 2 && -n "${word}") ]]; then
            # Start with the base commands if we don't have the first word complete
            compgen -W "${basecommands}" "${words[1]}"
        else
            # Obtain the name of the completion function for the base command, which will be named _cmd_function
            cmd="${words[1]}"
            complete_fn="_cmd_${cmd//-/_}"
            if [[ "$(LC_ALL=C type -t ${complete_fn})" == "function" ]]; then
                data=$("${complete_fn}" ${length} "${word}")
            fi

            # If we've received any completion words from the completion function, let compgen handle the prefix matching.
            if [[ -n "${data}" ]]; then
                compgen -W "${data}" "${word}"
            fi
        fi
    fi
}
