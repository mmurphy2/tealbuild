% TEALBUILD-CHECK-REMOTE-REPO(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild check-remote-repo - Checks the remote repository for changes


# SYNOPSIS

**tealbuild check-remote-repo**


# DESCRIPTION

**tealbuild check-remote-repo** checks the remote repository (as defined in tealbuild.conf) for any changes. This
command is useful if multiple people or systems can push packages to the same repository.


# EXIT STATUS

**0**
: The remote repository matches the local repository.

**1**
: The remote repository has been changed and does not match the local repository.


# SEE ALSO

tealbuild(1), tealbuild-download-repo(1), tealbuild-upload-repo(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
