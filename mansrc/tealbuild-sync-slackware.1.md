% TEALBUILD-SYNC-SLACKWARE(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild sync-slackware - Downloads or updates the Slackware software tree


# SYNOPSIS

**tealbuild sync-slackware** *version*


# DESCRIPTION

Downloads or updates a Slackware or Slackware64 (depending on ARCH setting)
software tree inside the directory specified by the SLACKWARE setting. This
process uses rsync to synchronize the contents of the local Slackware tree
with the remote mirror server. This local tree can then be used for various
purposes, including creating custom installers, pushing patches to systems,
and so forth.

The specified *version* may be a Slackware release version or the word
"current" for the development version.


# SEE ALSO

tealbuild(1), tealbuild-make-iso(1), tealbuild-update(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
