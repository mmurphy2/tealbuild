% TEALBUILD-EXPORT-GPG-PUBLIC-KEY(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild export-gpg-public-key - Exports a public GPG key from TealBuild


# SYNOPSIS

**tealbuild export-gpg-public-key** *outfile* [*email*]


# DESCRIPTION

Exports a GPG public key from the build tree's GPG store (GPG\_HOME) in
armored ascii format. If no *email* is specified, exports the default public key.


# SEE ALSO

tealbuild(1), tealbuild-create-gpg-key(1), tealbuild-export-gpg-private-key(1), tealbuild-import-gpg-key(1),
tealbuild-list-gpg-keys(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
