% TEALBUILD-UPDATE-REPO(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild update-repo - Updates the local repository metadata


# SYNOPSIS

**tealbuild update-repo**


# DESCRIPTION

Updates the local repository, generating the repository-level metadata,
including the package list, manifest, ChangeLog, checksums, and file list.
Newly accepted packages are added to the repository metadata, and an
update to the ChangeLog.txt file is automatically generated. If the public
GPG key is not yet included in the repository, this command also takes
care of exporting it.

During the ChangeLog generation process, the user's EDITOR (defaults to vi)
is invoked to enable manual adjustments to the ChangeLog. It is important
to follow the established format of the ChangeLog.txt, as third-party
package management tools may extract information from this file. Review the
format of ChangeLog.txt on any Slackware mirror for the basic layout.

Separators between ChangeLog.txt updates are added automatically.


# SEE ALSO

tealbuild(1), tealbuild-export-gpg-public-key(1), tealbuild-generate-changelog(1),
tealbuild-generate-repo-checksums(1), tealbuild-generate-repo-filelist(1),
tealbuild-generate-repo-manifest(1), tealbuild-generate-repo-pkglist(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
