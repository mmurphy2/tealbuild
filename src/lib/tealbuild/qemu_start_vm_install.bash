# qemu_start_vm_install <iso_path | version>
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

# Function to start the VM the first time, when it is created, and Slackware
# is (manually) installed on it. If a path to an ISO file is given, then that
# ISO file is used for the installation. Otherwise, if either a version number
# (in the form x.x) or the word "current" is given, the ISO file is downloaded
# into the TEALBUILD_VM directory first. Note that the "current" ISO is
# generated from the Slackware(64) software tree directly, so that tree will
# be mirrored locally first if "current" is used.
#
# <iso_path | version>  --  path to the Slackware ISO file or a desired
#                           Slackware version (including current)

function qemu_start_vm_install() {
    local baseiso iso
    local suffix=""
    local status=0

    if [[ ! -f "$1" ]]; then
        [[ "${ARCH}" == "x86_64" ]] && suffix="64"

        # Are we requesting current?
        if [[ "$1" == "current" ]]; then
            baseiso="slackware${suffix}-current-install-dvd.iso"
            iso="${TEALBUILD_VM}/${baseiso}"

            if [[ ! -f "${iso}" ]]; then
                mkdir -pv "${TEALBUILD_VM}"
                status=$?

                if [[ ${status} -eq 0 ]]; then
                    sync_slackware current
                    status=$?

                    if [[ ${status} -eq 0 ]]; then
                        make_iso "${SLACKWARE}/slackware${suffix}-current" "Slackware Install" "SlackDVD" "${iso}"
                        status=$?
                    fi
                fi
            else
                echo "Found ${iso}; skipping download and build"
            fi
        else
            # Do we have a version number?
            echo "$1" | grep -qE '[0-9]+\.[0-9]'
            if [[ $? -eq 0 ]]; then
                baseiso="slackware${suffix}-$1-install-dvd.iso"
                iso="${TEALBUILD_VM}/${baseiso}"
                url="https://mirrors.slackware.com/slackware/slackware-iso/slackware${suffix}-$1-iso/${baseiso}"

                if [[ ! -f "${iso}" ]]; then
                    mkdir -pv "${TEALBUILD_VM}"
                    status=$?

                    if [[ ${status} -eq 0 ]]; then
                        wget -O "${iso}" "${url}"
                        status=$?
                    else
                        echo "Failed to create directory: ${TEALBUILD_VM}" >&2
                    fi

                    if [[ ${status} -eq 0 ]]; then
                        wget -O "${iso}.asc" "${url}.asc"
                        status=$?

                        if [[ ${status} -eq 0 ]]; then
                            check_slackware_gpg "${iso}.asc"
                            status=$?

                            if [[ ${status} -ne 0 ]]; then
                                echo "GPG verification FAILED: $iso" >&2
                            fi
                        else
                            echo "Failed to download ${iso}.asc" >&2
                        fi
                    else
                        echo "Failed to download ${iso}" >&2
                    fi
                else
                    echo "Found ${iso}; skipping download"
                fi
            else
                echo "ISO file not found: $1" >&2
                status=1
            fi
        fi
    else
        iso="$1"
    fi

    if [[ ${status} -eq 0 ]]; then
        qemu_start_vm -name "tealbuild VM - initial installation" -cdrom "${iso}"
        status=$?
    fi

    return ${status}
}
