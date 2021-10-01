% TEALBUILD-VM-UPGRADEPKG(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild vm-upgradepkg - Upgrades a package inside the TealBuild VM


# SYNOPSIS

**tealbuild vm-upgradepkg** *package* [[*package*] ...]


# DESCRIPTION

Upgrades one or more package files into the TealBuild virtual machine using
/sbin/upgradepkg --install-new inside the VM. Note that the persistence of
the installation will depend on the persistence of the VM. If the VM is
running in snapshot mode, the installation will be lost once the VM is
terminated. However, in persistent mode, the package will remain installed
on the VM permanently. Caution must be exercised to avoid the potential of
creating unintended dependencies when building packages after another
package has been installed.

Paths to *package* targets are given on the host machine. The package files will be uploaded to the virtual
machine automatically.


# SEE ALSO

tealbuild(1), tealbuild-vm-installpkg(1), tealbuild-vm-removepkg(1), tealbuild-vm-start(1), tealbuild-vm-start-persistent(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
