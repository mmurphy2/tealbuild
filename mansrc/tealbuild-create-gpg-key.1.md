% TEALBUILD-CREATE-GPG-KEY(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild create-gpg-key - Generates a new package signing key


# SYNOPSIS

**tealbuild create-gpg-key**


# DESCRIPTION

Generates a new GPG key for signing packages, storing the resulting keypair
in GPG\_HOME. When running this command, it is recommended that a comment be
added to the effect that this key is a repository signing key. It is
recommended that a dedicated key be used for each package repository (and
therefore, each build tree). However, a key may be shared between build
trees (and repositories) by setting common GPG\_HOME locations in each
build tree configuration.


# SEE ALSO

tealbuild(1), tealbuild-export-gpg-private-key(1), tealbuild-import-gpg-key(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
