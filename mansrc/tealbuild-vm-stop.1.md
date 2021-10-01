% TEALBUILD-VM-STOP(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild vm-stop - Stops the TealBuild virtual machine


# SYNOPSIS

**tealbuild vm-stop**


# DESCRIPTION

Stops the TealBuild virtual machine. When the VM is running in snapshot mode,
as it does for building packages, the stop process should be instant. However,
if a desktop environment is loaded in persistent mode, it may be necessary to
shut down the VM manually from within the QEMU window.

In snapshot mode, the QEMU "quit" monitor command is used to cause a hard
shutdown equivalent to pulling out the power plug on a physical system. This
approach is fine in snapshot mode, since any modifications to the disk are
thrown away anyway, leaving nothing to corrupt. However, in persistent mode,
an ACPI shutdown request has to be sent instead. If the VM is left in runlevel
3 with no desktop environment started, this request should be enough to cause
an orderly shutdown. However, some desktop environments intercept the ACPI
request and present a menu instead.


# SEE ALSO

tealbuild(1), tealbuild-build(1), tealbuild-vm-restart(1), tealbuild-vm-start(1), tealbuild-vm-start-persistent(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
