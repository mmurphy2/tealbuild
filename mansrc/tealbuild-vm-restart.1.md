% TEALBUILD-VM-RESTART(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild vm-restart - Restarts the TealBuild virtual machine


# SYNOPSIS

**tealbuild vm-restart**


# DESCRIPTION

Restarts the TealBuild virtual machine. This command can be only used
whenever the VM is running in snapshot mode. Otherwise, the restart would
fail, since a shutdown from peristent mode takes too long.


# SEE ALSO

tealbuild(1), tealbuild-vm-start(1), tealbuild-vm-start-persistent(1), tealbuild-vm-stop(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
