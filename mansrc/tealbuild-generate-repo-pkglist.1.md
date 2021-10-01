% TEALBUILD-GENERATE-REPO-PKGLIST(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild generate-repo-pkglist - Generates the repository PACKAGES.TXT


# SYNOPSIS

**tealbuild generate-repo-pkglist**


# DESCRIPTION

Generates the PACKAGES.TXT file for the local repository, replacing any
previous version of the file. This file contains a list of each package in
the repository, along with the package sizes and descriptions.

Note that it is not necessary to run this command directly. The

```
$ tealbuild update-repo
```

command will also perform this function as part of a repository update.


# SEE ALSO

tealbuild(1), tealbuild-generate-changelog(1), tealbuild-generate-repo-checksums(1),
tealbuild-generate-repo-filelist(1), tealbuild-generate-repo-manifest(1),
tealbuild-update-repo(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
