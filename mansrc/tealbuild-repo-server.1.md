% TEALBUILD-REPO-SERVER(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild repo-server - Manages a simple TealBuild repository test server


# SYNOPSIS

**tealbuild repo-server** *start | stop | status*


# DESCRIPTION

Manages a simple HTTP server (the http.server module from Python 3), using
the repository tree (REPO) as the root. The port and listen address of the
server are configurable in the REPO\_SERVER\_ADDRESS and REPO\_SERVER\_PORT
settings in tealbuild.conf. This server exists for the purpose of testing
the repository with third-party package management tools. It is not for
use in production (using Apache or NGINX for that).

To start the server, give the "start" argument. The "stop" argument will terminate the server, while "status"
will indicate whether or not the server is running.


# SEE ALSO

tealbuild(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
