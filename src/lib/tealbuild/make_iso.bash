# make_iso <tree_root> <appid> <volid> <output_file>
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

# Generates a bootable installer ISO (intended for Slackware) from a software
# tree at the specified root. In the general case, the root directory will be
# the top-level slackware(64)-version directory.
#
# <tree_root>     --  root of the software tree
# <appid>         --  application ID for the generated ISO file
# <volid>         --  volume ID for the generated ISO file
# <output_file>   --  destination ISO file

function make_iso() {
    local cwd outfile syslinux tempdir
    local status=0

    cwd=$(pwd)
    outfile="$4"
    tempdir=$(mktemp -d)

    if [[ "${outfile:0:1}" != "/" ]]; then
        outfile="${cwd}/$4"
    fi

    # We need one file from syslinux to make the bootable ISO. However, we don't want to require syslinux be installed
    # on the host system, so extract it from Slackware's version. Use any patched version first, then fall back to the
    # original in a/.
    syslinux=$(ls "$1/patches/packages/"syslinux-*-*-*.t?z 2>/dev/null)
    [[ -z "${syslinux}" ]] && syslinux=$(ls "$1"/slackware*/a/syslinux-*-*-*.t?z)

    if [[ -n "${syslinux}" ]]; then
        tar xOf "${syslinux}" usr/share/syslinux/isohdpfx.bin > "${tempdir}/isohdpfx.bin"
        status=$?
    else
        echo "Unable to find syslinux package in tree" >&2
        status=1
    fi

    if [[ ${status} -eq 0 ]]; then
        cd "$1"
        xorriso -as mkisofs \
            -iso-level 3 \
            -full-iso9660-filenames \
            -rock \
            -joliet \
            -appid "$2" \
            -hide-rr-moved \
            -verbose \
            -omit-period \
            -omit-version-number \
            -eltorito-boot isolinux/isolinux.bin \
            -eltorito-catalog isolinux/boot.cat \
            -no-emul-boot \
            -boot-load-size 4 \
            -boot-info-table \
            -isohybrid-mbr "${tempdir}/isohdpfx.bin" \
            -eltorito-alt-boot \
            -e isolinux/efiboot.img \
            -isohybrid-gpt-basdat \
            -exclude 'source' \
            -volid "$3" \
            -output "${outfile}" \
            .
        status=$?
        cd - > /dev/null
    fi

    [[ "${tempdir}" != "/" ]] && rm -rf "${tempdir}"

    return ${status}
}
