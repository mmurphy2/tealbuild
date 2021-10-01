% TEALBUILD-NEW-TEALBUILD-INCLUDE(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild new-tealbuild-include - Generates a new tealbuild.include file


# SYNOPSIS

**tealbuild new-tealbuild-include** *port\_name* [*output\_file*]


# DESCRIPTION

Generates a new tealbuild.include file for a port with the specified name.
If an output\_file is not given, the port must already exist within the
ports directory (PORTS). If an existing tealbuild.include file is found in
the ports directory, the newly generated file will have the .new extension.

The output file is generated using the "tealbuild.include" template that ships with TealBuild.


# SEE ALSO

tealbuild(1), tealbuild-new(1), tealbuild-new-doinst(1), tealbuild-new-info(1), tealbuild-new-slack-desc(1),
tealbuild-new-slackbuild(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
