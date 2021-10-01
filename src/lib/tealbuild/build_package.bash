# build_package <name>
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

# Builds the specified package inside the build VM, retrieving it after a
# successful build. Note that the source directory must be fully populated
# (with sources checked) before attempting the build. In addition, the build
# VM must already be running (handled previously by the build function).
#
# <name>  --  name of the port (in PORTS) to build

function build_package() {
    local choice log pkg status stem temp
    local name="$1"

    if ! verify_port "$1"; then
        echo "Required files missing in ${PORTS}/${name}" >&2
        return 2
    fi

    echo "Uploading port for $1 to build VM..."
    vm_ssh mkdir -pv /tmp/tealbuild/src
    vm_scp "${PORTS}/${name}" /tmp/tealbuild/src
    status=$?

    if [[ ${status} -ne 0 ]]; then
        echo "Abort: failed to upload port for ${name}" >&2
        return ${status}
    fi

    if [[ -d "${SOURCES}/${name}" ]]; then
        echo "Uploading sources for $1 to build VM..."
        vm_scp "${SOURCES}/${name}"/* "/tmp/tealbuild/src/${name}/"
        status=$?
    fi

    if [[ ${status} -ne 0 ]]; then
        echo "Abort: failed to upload sources for ${name}" >&2
        return ${status}
    fi

    echo "Creating and uploading tealbuild helper..."
    temp=$(mktemp -d)
    generate_from_template "helper.bash" "${temp}/helper.bash"
    vm_scp "${temp}/helper.bash" /tmp/tealbuild/helper.bash
    status=$?

    if [[ ${status} -ne 0 ]]; then
        echo "Failed to prepare and upload helper script for ${name}" >&2
    else
        echo "Cleaning output directory on the VM"
        vm_ssh rm -f "/tmp/tealbuild/output/*.t?z"
        status=$?
    fi

    if [[ ${status} -ne 0 ]]; then
        echo "Failed to clean VM output directory" >&2
    else
        log="${temp}/build.log"
        echo -n "Starting build: " > "${log}"
        date >> "${log}"
    fi

    if [[ ${status} -eq 0 ]]; then
        echo "Running $1 SlackBuild script"
        vm_ssh bash /tmp/tealbuild/helper.bash 2>&1 | tee -a "${log}"
        status=${PIPESTATUS[0]}

        if [[ ${status} -eq 0 ]]; then
            # Install the package inside the VM, which will both test doinst.sh and provide a dependency for
            # anything that follows it in the build DAG.
            vm_ssh /sbin/upgradepkg --install-new "/tmp/tealbuild/output/$1*.t?z"
            status=$?

            if [[ ${status} -eq 0 ]]; then
                # Retrieve package from VM, but only if it can install successfully
                vm_reverse_scp "/tmp/tealbuild/output/*.t?z" "${temp}/"
                status=$?

                if [[ ${status} -eq 0 ]]; then
                    mkdir -p "${STAGE}/${ARCH}"
                    cd "${temp}"
                    for pkg in *.t?z; do
                        if [[ -f "${pkg}" ]]; then
                            stem="${pkg%.t?z}"
                            cp "${pkg}" "${STAGE}/${ARCH}/${pkg}"
                            cat build.log > "${STAGE}/${ARCH}/${stem}.log"

                            if [[ "${TEALBUILD_INTERACTIVE}" == "yes" ]]; then
                                echo "Press enter to review the contents of ${pkg}"
                                read -e choice
                                tar tvf "${pkg}" | ${TEALBUILD_PAGER}
                            fi
                        fi
                    done
                    cd - > /dev/null
                else
                    echo "Failed to retrieve package from build VM." >&2
                fi
            fi
        else
            echo "Build failed." >&2
            mkdir -pv "${TRASH}"
            cat "${temp}/build.log" > "${TRASH}/${name}.failed-build.log"
        fi
    fi

    if [[ "${TEALBUILD_INTERACTIVE}" == "yes" ]]; then
        echo -n "Would you like to review the build log? [y/N] "
        read -e choice

        if [[ "${choice}" == "y" ]]; then
            cat "${temp}/build.log" | ${TEALBUILD_PAGER}
        fi
    fi

    [[ "${temp}" != "/" ]] && rm -rf "${temp}"

    return ${status}
}
