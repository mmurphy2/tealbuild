% TEALBUILD-INIT-REPO(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild init-repo - Initializes or clones a Git repo for the PORTS directory


# SYNOPSIS

**tealbuild init_repo** [*git\_url*]


# DESCRIPTION

REV (6/17/21 by WDM): Initializes or clones a Git repo for the ports directory.

Initializes the ports directory (PORTS) as a Git repository. If a *git\_url* is provided, that URL will be cloned
to create the repository. Otherwise, a new Git repository will be initialized locally.


# SEE ALSO

tealbuild(1), tealbuild-import(1), tealbuild-new(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
