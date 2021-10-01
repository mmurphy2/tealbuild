% TEALBUILD-ACCEPT(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild accept - Accepts packages from staging into the repository


# SYNOPSIS

**tealbuild accept** [[*package*] ...]


# DESCRIPTION

Accepts one or more package files from the staging area (STAGE) into the
repository (REPO). If no package files are listed, then all package files
in the staging area are accepted.

Package acceptance involves signing the package(s), creating package
metadata for each package, and moving the package(s) and metadata from the
staging area into the repository.

The general workflow is that packages are built (using the "build"
command) and then tested while still in the staging area. Those packages
that are working are then accepted into the repository, while ones that
prove problematic are removed from staging (the "stage-rm" command) and
rebuilt after modifying the corresponding port.

If a specific GPG signature (other than the default in GPG\_HOME) needs to
be selected for signing purposes, set TEALBUILD\_GPG\_EMAIL to the email
address (or user-id) of the signing key. Remember that the signing keys
are stored in GPG\_HOME and are, by default, separate from the main GPG
user directory (typically in ~/.gnupg).

Accepting a package that has a different version or build number than a package of the
same name that is already in the repository will archive the original package from the
repository. This automation ensures that only one version of a package with a given
name is in the repository at any time.


# SEE ALSO

tealbuild(1), tealbuild-archive(1), tealbuild-create-meta(1), tealbuild-sign(1), tealbuild-stage-review(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
