% TEALBUILD-COPY(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild copy - Copies files/directories into the virtual machine


# SYNOPSIS

**tealbuild copy** *source* [[*source*] ...] *dest*


# DESCRIPTION

Copies one or more files and/or directories from the host system into the
TealBuild virtual machine, using scp as the root user inside the VM. Unlike
using scp directly, this command automatically copies directories
recursively, so there is no need for the -r switch.


# SEE ALSO

tealbuild(1), tealbuild-retrieve(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
