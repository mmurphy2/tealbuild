% TEALBUILD-SIGN(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild sign - Creates detached GPG signatures


# SYNOPSIS

**tealbuild sign** *file* [*email*]


# DESCRIPTION

Generates a new detached signature for a given file, which is normally a
package file (but can actually be any file). Note that this command isn't
normally needed, since running:

```
$ tealbuild accept
```

will handle signing packages in the staging area automatically. However,
this command is provided for convenience in the event that a custom
signature is required for something. If no *email* is specified, the default key in GPG\_HOME is used
for signing.


# SEE ALSO

tealbuild(1), tealbuild-accept(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
