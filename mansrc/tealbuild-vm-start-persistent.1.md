% TEALBUILD-VM-START-PERSISTENT(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild vm-start-persistent - Starts the build VM in persistent mode for maintenance


# SYNOPSIS

**tealbuild vm-start-persistent**


# DESCRIPTION

Starts the TealBuild virtual machine in persistent mode, in which any changes
are written back to the virtual hard disk. This mode should not be used for
building packages. Instead, it is intended for updating the virtual machine
installation with the latest version of official packages.


# SEE ALSO

tealbuild(1), tealbuild-vm-start-persistent(1), tealbuild-vm-stop(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
