% TEALBUILD-GENERATE-REPO-MANIFEST(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild generate-repo-manifest - Generates the repository MANIFEST.bz2 file


# SYNOPSIS

**tealbuild generate-repo-manifest**


# DESCRIPTION

Generates the MANIFEST.bz2 file for the local repository, replacing any
previous version of the file. This file contains a structured list of the
contents of each package within the repository, and it is used by add-on
package management tools to enable searching for packages based on a needed
file path.

Note that it is not necessary to run this command directly. The

```
$ tealbuild update-repo
```

command will also perform this function as part of a repository update.


# SEE ALSO

tealbuild(1), tealbuild-generate-changelog(1), tealbuild-generate-repo-checksums(1),
tealbuild-generate-repo-filelist(1), tealbuild-generate-repo-pkglist(1),
tealbuild-update-repo(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
