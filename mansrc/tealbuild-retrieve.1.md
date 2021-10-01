% TEALBUILD-RETRIEVE(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild retrieve - Copies a file or directory from the TealBuild virtual machine


# SYNOPSIS

**tealbuild retrieve** *item\_in\_vm* *dest\_on\_host*


# DESCRIPTION

Copies a file or directory from the build VM back to the host system.
Recursive copying is detected automatically, so there is no need for the
-r switch.


# EXAMPLES

**tealbuild retrieve /etc/fstab /tmp/vm-fstab**
: Copies /etc/fstab from the virtual machine to /tmp/vm-fstab on the host.


# SEE ALSO

tealbuild(1), tealbuild-copy(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
