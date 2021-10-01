% TEALBUILD-NEW-INFO(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild new-info - Generates a new .info file for a port


# SYNOPSIS

**tealbuild new-info** *port\_name* [*output\_file*]


# DESCRIPTION

Generates a new .info file for a port with the specified name. If an
output\_file is not given, the port must already exist within the ports
directory (PORTS). If an existing .info file is found in the ports
directory, the newly generated file will have the .new extension.

The output file is generated from the "info" template that ships with TealBuild.


# SEE ALSO

tealbuild(1), tealbuild-new(1), tealbuild-new-doinst(1), tealbuild-new-slack-desc(1),
tealbuild-new-slackbuild(1), tealbuild-new-tealbuild-include(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
