% TEALBUILD-NEW-CONFIG(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild new-config - Generates a new TealBuild configuration file


# SYNOPSIS

**tealbuild new-config** [*new\_root*]


# DESCRIPTION

Generates a new TealBuild configuration file in the TEALBUILD\_ROOT directory.
If the optional [new\_root] argument is supplied, the TEALBUILD\_ROOT will be
set to the new directory first. The TEALBUILD\_ROOT directory will be created
if it does not already exist.

If a file named tealbuild.conf is already present in TEALBUILD\_ROOT, the newly created configuration
file will be named tealbuild.conf.new. The configuration will be generated using the template file
named "tealbuild.conf" and shipped with TealBuild.


# SEE ALSO

tealbuild(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
