% TEALBUILD-SHELL(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild shell - Obtains a root shell on the TealBuild virtual machine


# SYNOPSIS

**tealbuild shell** [*command*] [*args* ...]


# DESCRIPTION

Initiates an SSH connection to the TealBuild virtual machine, logging in as
the root user. If an optional command string is given, it will be run.
Otherwise, an interactive shell will be obtained on the VM. This shell is more
comfortable for working directly on the VM, since copy and paste will work
with the host system.


# SEE ALSO

tealbuild(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
