% TEALBUILD-IMPORT(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild import - Imports a port into the TealBuild build tree


# SYNOPSIS

**tealbuild import** *item* [[*item*] ...]


# DESCRIPTION

Imports a port from the specified directory, tarfile, or URL. The form of
an importable directory is one that is named according to the package name
and contains the SlackBuild and other files. An importable tarfile
contains the same files as a directory, all of which are organized under a
single directory within the tarfile. If a URL is specified, it must point
to a tarfile that will be downloaded and then extracted.

The tarfile download function has been tested with SlackBuilds.org. Note
that no GPG check of the tarfile is performed, since it is assumed that the
user will be manually reviewing the contents of the port for an accurate
download and to check for malicious code.

If multiple combinations of directories, tarfiles, and/or URLs are
provided, they will be imported in order. If an error occurs, the process
will abort at the point of the error, and any further ports will not be
imported into the build tree.


# SEE ALSO

tealbuild(1), tealbuild-new(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
