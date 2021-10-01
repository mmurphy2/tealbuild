% TEALBUILD-FETCH-SOURCES(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild fetch-sources - Downloads and verifies source files for a port


# SYNOPSIS

**tealbuild fetch-sources** *port\_name* [[*port\_name*] ...]


# DESCRIPTION

Automatically downloads and verifies source files
listed in the .info files for the specified *port\_name* argument(s). Note
that the download process is fairly simplistic and depends on the
correctness of the .info file. If more than one *port\_name* is given, the
sources for the ports will be downloaded in order, but the process will
abort if any source download fails, and subsequent *port\_name*s will not
be attempted.

A *port\_name* must be in the ports directory (PORTS) before this command
will be able to retrieve its source files. To create a new port, or to
import an existing one, see the help for the "new" and "import" commands.

Verification will be performed using GPG if the .info file contains the
URLs of detached signature files in its GPG or GPG\_x86\_64 entries. The
GPG verification will be performed against the key listed in GPG\_KEY
(which may be the path or URL to the public key, or the public key
itself). If GPG information is not supplied by the .info file, MD5
verification will be used instead.


# SEE ALSO

tealbuild(1), tealbuild-import(1), tealbuild-new(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
