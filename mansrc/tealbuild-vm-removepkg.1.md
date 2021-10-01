% TEALBUILD-VM-REMOVEPKG(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild vm-removepkg - Uninstalls packages from the build VM


# SYNOPSIS

**tealbuild vm-removepkg** *name* [[*name*] ...]


# DESCRIPTION

Removes one or more installed packages from the TealBuild virtual machine
using /sbin/removepkg inside the VM. Note that the persistence of the
removal will depend on the persistence of the VM. If the VM is running
in snapshot mode, the removal will be undone once the VM is terminated.
However, in persistent mode, the package will remain removed from the VM
permanently. Caution must be exercised to avoid breaking the VM.


# SEE ALSO

tealbuild(1), tealbuild-vm-installpkg(1), tealbuild-vm-start(1), tealbuild-vm-start-persistent(1), tealbuild-vm-upgradepkg(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
