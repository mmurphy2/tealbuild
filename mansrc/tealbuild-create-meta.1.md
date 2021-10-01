% TEALBUILD-CREATE-META(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild create-meta - Creates metadata for packages in staging


# SYNOPSIS

**tealbuild create-meta** *staged\_package* [[*staged\_package*] ...]


# DESCRIPTION

Creates package metadata files (.manifest, .meta, and .txt) for one or more
listed packages in the staging area (STAGE). The .manifest file contains a list
of all files contained within the package (and is later used to create the
MANIFEST.bz2 file for the repository), while the .meta file contains
information about the package (which is later used to create the
PACKAGES.TXT file at the repository level). The .txt file is the
description of the package as extracted from the slack-desc file.

Note that running this command manually is generally not needed, unless
TealBuild is being used for some custom application. Instead, the
recommended workflow is to accept packages from the staging area into the
repository, which will trigger generation of both the metadata and the
package signature.


# SEE ALSO

tealbuild(1), tealbuild-accept(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
