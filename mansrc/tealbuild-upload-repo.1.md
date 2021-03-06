% TEALBUILD-UPLOAD-REPO(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild upload-repo - Uploads the local repository to a remote system


# SYNOPSIS

**tealbuild upload-repo**


# DESCRIPTION

Uploads the local repository (in the REPO directory) to a remote system. The method used for uploading is configured
in tealbuild.conf, the template for which contains explanatory comments for configuring repository uploads. Basic
checks are performed to ensure that a broken repository is not uploaded.

In addition, the remote repository is checked for changes that have occurred since the previous upload. These checks
are not completely devoid of race conditions if multiple people or systems are updating the remote repository;
however, the checks are done in such a way that a remote update collision should be an unlikely event. In some
instances, such as when changing GPG keys, it will be necessary to skip these checks on upload. Setting the
variable TEALBUILD\_FORCE\_PUSH\_REPO=YES (note: YES must be in all caps) will skip the checks.


# SEE ALSO

tealbuild(1), tealbuild-check-remote-repo(1), tealbuild-download-repo(1), tealbuild-update-repo(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
