% TEALBUILD-GENERATE-REPO-FILELIST(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild generate-repo-filelist - Generates FILELIST.TXT in the repository


# SYNOPSIS

**tealbuild generate-repo-filelist**


# DESCRIPTION

Generates the FILELIST.TXT file for the local repository, replacing any
previous version of the file. This file contains a list of the other files
in the repository and can be used to check the currency of mirrors whenever
a repository is mirrored among different servers. This file should be
generated last when updating the repository.

Note that this command does not need to be run separately. Using:

```
tealbuild update-repo
```

will generate the FILELIST.TXT automatically.


# SEE ALSO

tealbuild(1), tealbuild-generate-changelog(1), tealbuild-generate-repo-checksums(1),
tealbuild-generate-repo-manifest(1), tealbuild-generate-repo-pkglist(1),
tealbuild-update-repo(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
