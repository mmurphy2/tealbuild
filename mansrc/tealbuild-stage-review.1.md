% TEALBUILD-STAGE-REVIEW(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild stage-review - Reviews the contents of packages in the staging area


# SYNOPSIS

**tealbuild stage-review** [*prefix-pattern*]


# DESCRIPTION

Displays the contents of the built packages in the staging area (STAGE). An optional
*prefix-pattern* may be employed to narrow the package list if the staging
area has become well-populated. This pattern will be prefixed to \*.t?z when
searching for packages. Note that the actual directory searched is the
architecture-specific (set by ARCH) subdirectory of the staging directory.

Bash completion (enabled via "tealbuild complete") is helpful here.


# SEE ALSO

tealbuild(1), tealbuild-accept(1), tealbuild-stage-list(1), tealbuild-stage-package(1), tealbuild-stage-rm(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
