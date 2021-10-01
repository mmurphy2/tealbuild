% TEALBUILD-NEW-SLACKBUILD(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild new-slackbuild - Generates a new SlackBuild for a port


# SYNOPSIS

**tealbuild new-slackbuild** *port\_name* [*template* [*output\_file*]]


# DESCRIPTION

Generates a new SlackBuild file for a port with the specified name. If an
output\_file is not given, the port must already exist within the ports
directory (PORTS). If an existing SlackBuild file is found in the ports
directory, the newly generated file will have the .new extension.

The optional [*template*] argument selects the SlackBuild template to use and
defaults to "default". Run 

```
$ tealbuild list-templates
```

and look at the templates ending in .SlackBuild to see available options. Note that only the name of the
template without the .SlackBuild extension is used for selecting the template.


# EXAMPLES

**tealbuild new-slackbuild foo module**
: Creates a new SlackBuild file for a port named "foo", using the "module" template.


# SEE ALSO

tealbuild(1), tealbuild-new(1), tealbuild-new-doinst(1), tealbuild-new-info(1), tealbuild-new-slack-desc(1),
tealbuild-new-tealbuild-include(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
