% TEALBUILD-ARCHIVE(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild archive - Moves a package from the repository to the archive


# SYNOPSIS

**tealbuild archive** *package* [[*package*] ...]


# DESCRIPTION

Removes one or more packages from the repository, moving the removed
packages and metadata files to the archive. This command should be run
whenever a package is to be retired from the archive. Accepting a newer
version of a package that is already in the repository will automatically
archive the prior version.


# SEE ALSO

tealbuild(1), tealbuild-accept(1), tealbuild-update-repo(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
