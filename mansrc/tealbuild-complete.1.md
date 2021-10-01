% TEALBUILD-COMPLETE(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild complete - Bash completion for TealBuild


# SYNOPSIS

**tealbuild complete** [*arguments*]


# DESCRIPTION

Implements Bash completion for TealBuild when invoked with arguments. When
invoked without arguments, produces the necessary output for use with eval
to add the tealbuild command to the PATH, add TealBuild manual pages to the MANPATH,
and enable Bash completion.


# EXAMPLES

**eval $(tealbuild complete)**
: Configures Bash completion and adds tealbuild to the PATH when running TealBuild without first installing it.


# SEE ALSO

tealbuild(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
