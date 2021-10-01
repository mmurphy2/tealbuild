% TEALBUILD-GENERATE-CHANGELOG(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild generate-changelog - Generates the repository ChangeLog.txt


# SYNOPSIS

**tealbuild generate-changelog**


# DESCRIPTION

Generates the ChangeLog.txt file for the local repository, updating any
existing ChangeLog with recently accepted packages. At the end of the
process, the user's EDITOR (defaults to vi) will be started to review any
make any needed manual adjustments to the updated portion of the ChangeLog.

Note that it is not necessary to run this command directly. The

```
$ tealbuild update-repo
```

command will also perform this function as part of a repository update.

Separators between entires are added automatically after the manual edits
are completed.


# SEE ALSO

tealbuild(1), tealbuild-update-repo(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
