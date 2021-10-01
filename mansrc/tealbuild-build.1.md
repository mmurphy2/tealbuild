% TEALBUILD-BUILD(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild build - Builds Slackware packages from ports


# SYNOPSIS

**tealbuild build** *portname* [[*portname*] ...]


# DESCRIPTION

Builds one or more packages from a port directory in the build tree, in
order from left to right, stopping if any build fails. As part of the build
process, the package build scripts and sources will be copied from the port
directory on the host machine into the TealBuild virtual machine (which must
be running in snapshot mode). If the build VM is not yet running, and
AUTOSTART\_VM is set to "yes" in the configuration, the VM will be started in
snapshot mode before starting the first build.

The specified names are the names of the individual port directories inside
the PORTS path. As each resulting package is built, it is installed into the
VM using upgradepkg --install-new, which permits upgrading from a prior
build. Since the VM is running in snapshot mode, the installations are only
temporary, and the VM will revert to its clean state upon shutdown.

To build two or more packages where one is dependent on another, specify the
dependent package(s) last. For example, if package B depends on package A,
and package C depends on both A and B, run the command like this:

```
$ tealbuild build A B C
```

If a package to be built depends on another package that was built in a
prior TealBuild session, and the binary package is available in either the
staging area or the repository, it will be installed into the build VM
at the start of the build process. Otherwise, an error message will be
displayed to indicate that a prerequisite package is missing.

Once a package has been built successfully, the resulting binary package is
copied into the architecture-specific (based on the ARCH setting)
subdirectory of the staging area (STAGE).

If the VM was started automatically as part of the build process, it can
also be stopped, depending on the value of AUTOSTOP\_VM. If that variable is
set to "always", the VM is always stopped, regardless of build process exit
status. A setting of "never" never stops the VM. If AUTOSTOP\_VM is set to
"on\_success", the VM will be stopped if the build succeeds. Note that the
VM will NOT be stopped if it was not started by the build command.

Sources are checked (and fetched, if necessary) prior to starting the build
process. If the environment variable TEALBUILD\_INTERACTIVE is set to the
lower-case word "yes", then each listed package will be built, and the user
will be prompted to review the package contents and rebuild if necessary. If
a build fails while running interactively, the user will have an opportunity
to fix the port and retry the build.


# SEE ALSO

tealbuild(1), tealbuild-requires(1), tealbuild-vm-start(1), tealbuild-vm-stop(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
