% TEALBUILD-VM-INSTALL(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild vm-install - Starts the build virtual machine for initial installation


# SYNOPSIS

**tealbuild vm-install** *iso | version*


# DESCRIPTION

Starts the TealBuild virtual machine in persistent mode for initial
installation. The VM will be booted from the Slackware ISO file given as an
argument to this command. From that point, the installation must be performed
manually from inside the VM.

If the Slackware ISO file has not yet been downloaded, a version number can be
specified instead. TealBuild will download the installer ISO for that version,
matching the architecture set in ARCH (the host system architecture, by
by default). A released version of Slackware will be downloaded from the
official mirrors.

To build a Slackware -current ISO, give the word "current" as the version number.
Building a -current ISO will first sync the Slackware software tree, then build
the ISO from that.


# SEE ALSO

tealbuild(1), tealbuild-make-iso(1), tealbuild-sync-slackware(1), tealbuild-vm-start-persistent(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
