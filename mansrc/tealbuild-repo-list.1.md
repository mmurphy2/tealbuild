% TEALBUILD-REPO-LIST(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild repo-list - Lists packages in the repository


# SYNOPSIS

**tealbuild repo-list** [*prefix-pattern*]


# DESCRIPTION

Lists the built packages in the repository (REPO). An optional
*prefix-pattern* may be employed to narrow the package list if the repository
has become well-populated. This pattern will be prefixed to \*.t?z when
searching for packages. Note that the actual directory searched is the
architecture-specific (set by ARCH) subdirectory of the repository.

Bash completion (enabled via "tealbuild complete") is helpful here.


# SEE ALSO

tealbuild(1), tealbuild-accept(1), tealbuild-archive(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
