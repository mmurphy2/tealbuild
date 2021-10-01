% TEALBUILD-NEW(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild new - Creates a new port using TealBuild


# SYNOPSIS

**tealbuild new** *port\_name* [*template*]


# DESCRIPTION

Creates a new port within the ports tree (PORTS), named using the given
(port\_name). A new SlackBuild, .info file, slack-desc, doinst.sh.in, and
tealbuild.include file will be generated for the new port.

The optional [template] specifier allows a different SlackBuild template to
be selected for the SlackBuild generation step. To see a list of available
templates, run "tealbuild list-templates", and look for the names ending in
.SlackBuild. The default value for [template] is "default", and note that the
.SlackBuild is left off the template name when passing it as the optional argument.


# EXAMPLES

**tealbuild new foo module**
: Creates a new port named "foo", using the "module" SlackBuild template.


# SEE ALSO

tealbuild(1), tealbuild-new-doinst(1), tealbuild-new-info(1), tealbuild-new-slack-desc(1),
tealbuild-new-slackbuild(1), tealbuild-new-tealbuild-include(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
