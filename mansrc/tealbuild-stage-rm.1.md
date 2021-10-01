% TEALBUILD-STAGE-RM(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild stage-rm - Discards packages from the staging area


# SYNOPSIS

**tealbuild stage-rm** *package* [[*package*] ...]


# DESCRIPTION

Removes a package file from the staging area (STAGE) and puts it in the trash (TRASH). This
command is used to reject a package that will not be accepted into the
repository (e.g. due to a bad build or other issue). Enabling TealBuild's
Bash completion is quite useful for this command.

The packages that are available in the staging area, which could be
removed or accepted, may be displayed using:

```
$ tealbuild stage-list
```

# SEE ALSO

tealbuild(1), tealbuild-accept(1), tealbuild-stage-list(1), tealbuild-stage-package(1), tealbuild-stage-review(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
