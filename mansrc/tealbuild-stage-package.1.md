% TEALBUILD-STAGE-PACKAGE(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild stage-package - Adds prebuilt packages to the staging area


# SYNOPSIS

**tealbuild stage-package** *package* [[*package*] ...]


# DESCRIPTION

Adds one or more binary packages directly to the staging area. This command
is used to enable TealBuild to perform repository management tasks for
packages that have been built outside TealBuild. Another possible use case
is to add third-party Slackware packages to a private repository. Note that
no GPG checks are performed on the packages being added: the user must
verify the authenticity of such packages before staging them.


# SEE ALSO

tealbuild(1), tealbuild-accept(1), tealbuild-stage-list(1), tealbuild-stage-review(1), tealbuild-stage-rm(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
