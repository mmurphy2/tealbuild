# build <name> [name ...]
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

# Top-level build manager for building packages. This code automatically
# starts and stops the build VM based on the AUTOSTART_VM and AUTOSTOP_VM
# settings. Once the VM is known to be running in snapshot mode, the actual
# build work is handled by build_group and build_package.
#
# <name>   --  name of a port in the PORTS directory to build

function build() {
    local item
    local status=0
    local stopped=1
    local countdown=${AUTOSTART_VM_TIMEOUT}

    # Be sure we have all required sources first
    for item in "$@"; do
        if ! fetch_sources "${item}"; then
            banner "Missing sources for ${item}: cannot build."
            return 1
        fi
    done

    if is_vm_running; then
        # We can only build if the VM is in snapshot mode.
        if is_vm_snapshot; then
            build_group "$@"
            status=$?
        else
            banner "The TealBuild VM is running in persistent mode!" \
                   "This mode cannot be used for building, since unintentional dependencies" \
                   "might be introduced into the resulting packages." \
                   "" \
                   "Stop the VM (in an orderly way) and start it in snapshot mode first." >&2
            status=1
        fi
    else
        if [[ "${AUTOSTART_VM}" == "yes" ]]; then
            qemu_start_vm_snapshot
            status=$?

            if [[ ${status} -eq 0 ]]; then
                # Wait for the VM to become ready
                while [[ ${countdown} -gt 0 ]]; do
                    echo -ne "Waiting ${countdown} seconds for the VM to start...\r"
                    vm_ssh -o ConnectTimeout=1 /bin/true >/dev/null 2>&1
                    if [[ $? -eq 0 ]]; then
                        echo
                        break
                    fi
                    countdown=$(( countdown - 1 ))
                done

                is_vm_running
                status=$?
                if [[ ${status} -eq 0 && ${countdown} -eq 0 ]]; then
                    banner "Failed to connect to VM. Is SSH configured correctly?" >&2
                    status=1
                elif [[ ${status} -ne 0 ]]; then
                    banner "The VM did not remain in operation after starting." \
                           "Check that QEMU is working properly, and that you didn't close the VM window." >&2
                fi

                if [[ ${status} -eq 0 ]]; then
                    build_group "$@"
                    status=$?

                    case "${AUTOSTOP_VM}" in
                        always)
                            terminate_vm
                            stopped=$?
                            [[ ${status} -eq 0 ]] && status=${stopped}
                            ;;
                        on_success)
                            if [[ ${status} -eq 0 ]]; then
                                terminate_vm
                                stopped=$?
                                status=${stopped}
                            fi
                            ;;
                        on_error)
                            if [[ ${status} -ne 0 ]]; then
                                terminate_vm
                                stopped=$?
                            fi
                            ;;
                        *)
                            # Includes the "never" case: do nothing here (stopped=1 from above)
                            ;;
                    esac

                    if [[ ${stopped} -ne 0 ]]; then
                        banner "Warning: the TealBuild VM is still running in snapshot mode." \
                               "Be sure to stop it before building unrelated packages." >&2
                    fi
                fi
            else
                banner "The TealBuild VM could not be started. Check the configuration." >&2
            fi
        else
            banner "The TealBuild virtual machine is not running. Start it in snapshot mode first." >&2
            status=1
        fi
    fi

    return ${status}
}
