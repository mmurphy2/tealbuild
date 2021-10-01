% TEALBUILD-GENERATE-REPO-CHECKSUMS(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild generate-repo-checksums - Generates and signs the CHECKSUMS.md5 file


# SYNOPSIS

**tealbuild generate-repo-checksums**


# DESCRIPTION

Generates and signs the CHECKSUMS.md5 file for the local repository,
replacing any previous version of the file. This file contains a list of the
MD5 checksums for every other public file in the repository, with the
exception of FILELIST.TXT. Third-party package managers rely on the
CHECKSUMS.md5 file to validate the contents of the repository, and they may
validate the GPG signature on CHECKSUMS.md5 using CHECKSUMS.md5.asc.

Note that it is not necessary to run this command directly. The

```
$ tealbuild update-repo
```

command will also perform this function as part of a repository update.

If running this command manually, it is important to run it second-to-last,
after generating the PKGLIST.TXT, MANIFEST.bz2, and ChangeLog.txt, but
before generating FILELIST.TXT. If this command is run out of order, the
repository is unlikely to work properly with third-party package
management tools.


# SEE ALSO

tealbuild(1), tealbuild-generate-changelog(1), tealbuild-generate-repo-filelist(1),
tealbuild-generate-repo-manifest(1), tealbuild-generate-repo-pkglist(1), tealbuild-update-repo(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
