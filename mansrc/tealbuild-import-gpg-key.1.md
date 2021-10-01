% TEALBUILD-IMPORT-GPG-KEY(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild import-gpg-key - Imports a GPG key into TealBuild


# SYNOPSIS

**tealbuild import-gpg-key** *keyfile*


# DESCRIPTION

Imports an existing GPG key into the GPG\_HOME directory for the build tree.
To obtain the GPG key in a format suitable for import, run:

```
$ gpg --output mykeyfile --armor --export-secret-key [email]
```

If the GPG key is in an unusual location, use the --homedir option to
gpg(1) when performing the export.


# SEE ALSO

gpg(1), tealbuild(1), tealbuild-create-gpg-key(1), tealbuild-export-gpg-private-key(1),
tealbuild-export-gpg-public-key(1), tealbuild-list-gpg-keys(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
