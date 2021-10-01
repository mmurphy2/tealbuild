# My fancy command.
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
# Template for a new command named mycmd. To add a command to TealBuild, use
# this template as a base. Change all instances of "mycmd" to the name of the
# new command (which must use valid Bash identifiers, and _ will be changed
# to - in the user interface automatically).
#

function cmd_mycmd() {
    local status=0

    # check_args verifies that the correct number of arguments have been
    # supplied by the user. The format is:
    #
    # check_args "command-as-typed" $# <min> <max> "<synopsis> [as-displayed]" || return 2
    #
    # If number of arguments is unlimited, use + for <max>.
    #
    check_args "mycmd" $# 0 1 "[synopsis]" || return 2

    return ${status}
}

# _cmd_mycmd <count> <word>
#
# Bash completion function for the mycmd command. What does it do?
#
# <count>   --  total number of completion words
# <word>    --  current word being completed
#
function _cmd_mycmd() {
    # Bash completion function. To add Bash completion for mycmd, design this
    # function to echo (or otherwise output) a string with possible Bash
    # completions. This function will receive 2 arguments: the number of
    # words in the completion line (word[0] will be tealbuild, and word[1]
    # will get completed to mycmd automatically, so we're really looking for
    # 2 and up here), and the current word being completed (which could be a
    # partial word or an empty string if the user typed a space after the
    # previous word). If more detailed information is needed, the COMP_LINE
    # variable is also available.
}
