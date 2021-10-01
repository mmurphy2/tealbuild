% TEALBUILD-LIST-TEMPLATES(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild list-templates - Lists available TealBuild templates


# SYNOPSIS

**tealbuild list-templates**


# DESCRIPTION

Lists available templates for the creation of new SlackBuilds, slack-desc, tealbuild.include, and various other
TealBuild-related files. This command automatically searches and filters the various levels of the search path, so
that only one template with a given base name is listed (specifically, the one with the highest precedence in the
search path).


# FILES

$TEALBUILD\_ROOT/templates/
: Highest precedence location: build tree level templates.

$HOME/.config/tealbuild/templates/
: User-level templates.

/etc/tealbuild/templates/
: System-level templates.

PREFIX/share/tealbuild/templates/
: Lowest precedence location: templates that ship with TealBuild.


# SEE ALSO

tealbuild(1), tealbuild-new(1), tealbuild-new-config(1), tealbuild-new-doinst(1),
tealbuild-new-info(1), tealbuild-new-slack-desc(1), tealbuild-new-slackbuild(1),
tealbuild-new-tealbuild-include(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
