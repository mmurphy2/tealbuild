# Interactively configures the SSH connection between the host and build VM.
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

function cmd_vm_configure_ssh() {
    local throwaway
    local status=0

    check_args "vm-configure-ssh" $# 0 0 || return 2

    if [[ ! -f "${SSH_ROOT_KEY}" ]]; then
        banner "Generating SSH key. Do NOT set a password on this key!"
        ssh-keygen -t rsa -f "${SSH_ROOT_KEY}"
        status=$?
    fi

    if is_vm_running; then
        if is_vm_snapshot; then
            echo "The build VM needs to be running in persistent mode first." >&2
            status=1
        fi
    else
        echo "The build VM needs to be running (in persistent mode) first." >&2
        status=1
    fi

    if [[ ${status} -eq 0 ]]; then
        banner "Inside the build VM, which should be in installation or persistent mode," \
               "edit /etc/ssh/sshd_config and set:" \
               "" \
               "PermitRootLogin yes" \
               "" \
               "Then run /etc/rc.d/rc.sshd restart" \
               "" \
               "Press enter when this step is complete."
        read throwaway

        banner "You will now be prompted to accept the SSH host key, followed by" \
               "a prompt for the root password to the build VM:"

        ssh -p ${VM_SSH_PORT} -l root localhost mkdir -p /root/.ssh/
        status=$?

        if [[ ${status} -eq 0 ]]; then
            banner "You will be prompted again for the build VM root password."
            scp -P ${VM_SSH_PORT} "${SSH_ROOT_KEY}.pub" root@localhost:/root/.ssh/authorized_keys
            status=$?

            if [[ ${status} -eq 0 ]]; then
                echo "Now you should not be prompted for the root password again:"
                vm_ssh /bin/true
                status=$?
                banner "If you were not prompted, SSH is configured properly."
            else
                banner "Failed to copy the SSH key to the VM." >&2
            fi
        else
            banner "Failed to create /root/.ssh on the VM." >&2
        fi
    else
        banner "Failed to generate an SSH key." >&2
    fi

    return ${status}
}
