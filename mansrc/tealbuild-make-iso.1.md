% TEALBUILD-MAKE-ISO(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild make-iso - Generates Slackware(64) DVD ISO images


# SYNOPSIS

**tealbuild make-iso** *root* *appid* *volid* *outfile*


# DESCRIPTION

Creates a bootable Slackware(64) ISO from the specified source tree. This
command may be used to generate a -current installer ISO. The *root*
parameter specifies the full path to the Slackware tree to use. Application and
volume IDs for the ISO file itself are then given, followed by the output ISO file path.

For a standard installer ISO, the application ID is normally set to
"Slackware Install", and the volume ID is normally set to "SlackDVD".


# SEE ALSO

tealbuild(1), tealbuild-sync-slackware(1), tealbuild-vm-install(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
