#!/bin/bash
#
# Build helper for TealBuild. This script is run on the build virtual machine
# using an SSH connection. If creating a custom version of this script, be
# sure to pay attention to the exit status. If anything goes wrong the build,
# this script needs to return a non-zero status. Otherwise, TealBuild will
# consider the build successful even if it wasn't.
#

status=0

# The ports directory is uploaded to the VM at /tmp/tealbuild/src/<name>
cd "/tmp/tealbuild/src/{{ name }}"

# If there is a tealbuild.include file, source it, loading its contents into
# the current Bash shell. This way, any environment variables set inside the
# tealbuild.include are loaded.
if [[ -f tealbuild.include ]]; then
    . tealbuild.include
    status=$?
fi

TAG="{{ TAG }}"
TMP=/tmp/tealbuild/build
OUTPUT=/tmp/tealbuild/output
PKGTYPE="{{ PKGTYPE }}"

if [[ ${status} -eq 0 ]]; then
    # The trick here is to source (instead of execute) the SlackBuild file. If
    # we just executed the SlackBuild, all the environment variables set in
    # this script or in tealbuild.include would have to be exported first;
    # otherwise, the SlackBuild wouldn't see them. We bypass this problem by
    # running the SlackBuild in this same Bash environment where the variables
    # are already set.
    . "{{ name }}.SlackBuild"
    status=$?
fi

exit ${status}
