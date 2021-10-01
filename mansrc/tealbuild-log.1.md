% TEALBUILD-LOG(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild log - Displays the build log for a package


# SYNOPSIS

**tealbuild log** *name*


# DESCRIPTION

Displays the build log output for a given package in the staging area or repository. The log name is the base
name of the package, which is the package file name less the .t?z extension at the end. A previous build must
have succeeded for the log to exist for the package.

If the TEALBUILD\_PAGER environment variable is set, the log output will be run through the pager.


# SEE ALSO

tealbuild(1), tealbuild-build(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
