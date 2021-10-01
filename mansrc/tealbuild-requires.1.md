% TEALBUILD-REQUIRES(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild requires - Calculates dependencies of a requested port


# SYNOPSIS

**tealbuild requires** [[*port\_name*] ...]


# DESCRIPTION

**tealbuild requires** calculates dependencies of a given *port\_name* and displays a build list with the original
*port\_name* listed last. This build list can then be used with the build command (tealbuild-build(1)) to build a
package with all its dependent packages in one step. The output of **tealbuild requires** can be used as the
argument list to **tealbuild build**.

In the event that the original port name is not the last element in the output, a circular dependency situation
exists in the build tree. Either the packages require iterative compilation (a true circular dependency), or the
.info files are wrong for one or more ports.

If executed without a *port\_name*, computes dependencies of all ports in the tree. More than one port may be
specified on the command line to compute dependencies for a smaller set of ports. When used in this way, the
output cannot be used as the argument list to **tealbuild build**.

By default, **tealbuild requires** operates on the REQUIRES line of each .info file in the requested
*port\_name*s. However, the BUILD\_REQUIRES line may also be added, as documented below.


# EXIT STATUS

**0**
: Each port in the dependency list had a .info file, which allowed dependencies to be resolved.

**1**
: One or more ports lacked a .info file, so the dependency resolution may be incomplete.


# ENVIRONMENT

**TEALBUILD_REQUIRES**
: If the TEALBUILD\_REQUIRES environment variable is set to "build", then the BUILD\_REQUIRES entries in .info files
  will be processed in addition to, and after, the REQUIRES entries in the .info files.


# SEE ALSO

tealbuild(1), tealbuild-build(1), tealbuild-depends(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
