% TEALBUILD-DEPENDS(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild depends - Recursively determines what ports depend on a given port


# SYNOPSIS

**tealbuild depends** [[*port\_name*] ...]


# DESCRIPTION

Recursively computes the set of packages that depend on the specified *port\_name*s. If no *port\_name* is given,
then a recursive computation is performed for all ports in the tree (which is slow!). The **tealbuild depends**
command will determine what ports depend directly on the specified port(s), as well as what ports depend
indirectly on the specified port(s) by depending on other ports that depend on the specified port(s).

The purpose of this command is to gauge the impact a port has on other ports in the collection when performing
upgrades. Due to the recursive way dependencies are calculated, this command is slow to execute.


# SEE ALSO

tealbuild(1), tealbuild-requires(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
