% TEALBUILD-VM-START(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild vm-start - Starts the TealBuild VM in snapshot mode


# SYNOPSIS

**tealbuild vm-start**


# DESCRIPTION

Starts the TealBuild virtual machine using QEMU snapshot mode, which prevents
changes from being written back to the disk image. This mode is used for
building packages with TealBuild.


# SEE ALSO

tealbuild(1), tealbuild-build(1), tealbuild-vm-restart(1), tealbuild-vm-start-persistent(1), tealbuild-vm-stop(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
