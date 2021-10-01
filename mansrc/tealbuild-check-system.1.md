% TEALBUILD-CHECK-SYSTEM(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild check-system - Checks TealBuild prerequisites


# SYNOPSIS

**tealbuild check-system**


# DESCRIPTION

Runs checks on the system to ensure that the needed commands for running
TealBuild are present. Since TealBuild is designed to run on any Linux
distribution, this command determines if the required software is present,
but it does not suggest the package names required for installing any
missing software.

The exit status of this command is 0 if all checks pass, or non-zero if
one or more pieces of software are missing. However, some programs are only
needed when running specific commands, so it may be possible to run
TealBuild with some missing prerequisites.


# SEE ALSO

tealbuild(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
