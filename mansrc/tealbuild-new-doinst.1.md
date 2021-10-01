% TEALBUILD-NEW-DOINST(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild new-doinst - Generates a new doinst.sh.in file


# SYNOPSIS

**tealbuild new-doinst** *port\_name* [*output\_file*]


# DESCRIPTION

Generates a new doinst.sh.in file for a port with the specified name. If an
output\_file is not given, the port must already exist within the ports
directory (PORTS). If an existing doinst.sh.in file is found in the ports
directory, the newly generated file will have the .new extension.

Note that the generated file is always named doinst.sh.in, so that it does
not get included by accident in a generated package. Before adding this
file to a build, the file needs to be edited carefully to ensure that it is
correct. Remember that doinsh.sh is run as root on all the systems making
use of the resulting package!

The output file is generated from a template named "doinst.sh", which ships with TealBuild.


# SEE ALSO

tealbuild(1), tealbuild-new(1), tealbuild-new-info(1), tealbuild-new-slack-desc(1),
tealbuild-new-slackbuild(1), tealbuild-new-tealbuild-include(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
