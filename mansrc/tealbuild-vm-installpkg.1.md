% TEALBUILD-VM-INSTALLPKG(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild vm-installpkg - Installs a Slackware package into the build VM


# SYNOPSIS

**tealbuild vm-installpkg** *package* [[*package*] ...]


# DESCRIPTION

Installs one or more package files into the TealBuild virtual machine using
/sbin/installpkg inside the VM. Note that the persistence of the
installation will depend on the persistence of the VM. If the VM is running
in snapshot mode, the installation will be lost once the VM is terminated.
However, in persistent mode, the package will remain installed on the VM
permanently. Caution must be exercised to avoid the potential of creating
unintended dependencies when building packages after another package has
been installed.

The *package* arguments are paths to Slackware packages on the host file system. These packages will be uploaded
to the VM automatically.


# SEE ALSO

tealbuild(1), tealbuild-vm-removepkg(1), tealbuild-vm-start(1), tealbuild-vm-start-persistent(1), tealbuild-vm-upgradepkg(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
