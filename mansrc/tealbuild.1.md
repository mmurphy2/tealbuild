% TEALBUILD(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild - A package build and repository helper for Slackware Linux


# SYNOPSIS

**tealbuild** [*options*] *command* [*arguments*]


# DESCRIPTION

TealBuild (**tealbuild**) is a multipurpose package and repository generation and management tool,
intended for developing add-on packages for Slackware Linux. The TealBuild system uses a QEMU
virtual machine to build each package (or set of related packages) in a clean environment,
preventing the introduction of unintentional dependencies in built packages.

TealBuild provides an interface to manage package ports to Slackware, execute and maintain the
virtual machine, manage the build environment, run the SlackBuild script to build binary packages,
retrieve the results, sign the resulting packages, create a Slackware repository, and optionally
push the repository to a remote system. It is also capable of maintaining a local mirror of the
Slackware software tree and creating installation ISO files.

Note that TealBuild does not resolve dependencies automatically. These must be resolved by the user,
either by building dependent packages in order using a single build command, or by first pushing
prebuilt packages from the local repository to the build VM.


## Conventions and Terminology

In the TealBuild documentation and man pages, commands that are run as the regular user on the host
system are prefixed with a $ sign, while commands that are run inside the
build virtual machine (VM) are prefixed with a # sign (since they're all
run as root inside the VM anyway).

Terms in SHOUTING\_SNAKE\_CASE refer to configuration variables, which are
usually set in the tealbuild.conf file.

Certain terminology is used throughout the TealBuild documentation:

**build tree**
: A structured directory to keep TealBuild-related files in
  one place. When using the default configuration, all
  files are kept in a single directory hierarchy, and there
  is one such hierarchy for each architecture of each
  repository that is being maintained.

**ports**
: The collection of build scripts and related files, located
  in subdirectories of the PORTS directory. A single port
  consists of the SlackBuild script, slack-desc file, and
  related files that are used to build a binary Slackware
  package. Ports generally follow the convention used by
  SlackBuilds.org, in that the base name of the package is
  the port name, and the files within it are named according
  to the port name (e.g. portname.SlackBuild). As is the
  convention at SBo, the actual source code for the software
  is stored separately from the port scripts.

**build VM**
: A virtual machine, executed with QEMU, in which all
  packages are built.

**host system**
: The physical computer on which QEMU runs, and on which the
  TealBuild command is invoked.

**snapshot mode**
: An operating mode of QEMU, in which any changes made to the
  build VM's virtual hard disk are written to a temporary file
  and discarded whenever the build VM is stopped.

**persistent mode**
: The opposite of snapshot mode: changes made inside the build
  VM are written back to the virtual hard disk and are thereby
  made permanent.

**staging area**
: A temporary holding location for packages that have been
  built in the VM and retrieved, but which have not yet been
  signed and put into the repository.

**repository**
: A Slackware-style package repository, which is stored
  locally. This repository contains GPG-signed packages and
  has the required metadata to be used by third-party
  package management tools (e.g. Slackpkg+, Slapt-get, etc.).

**acceptance**
: A build step that involves signing a package in the staging
  area, generating its package metadata, moving it into the
  repository, and updating the top-level repository metadata.
  If a previous version of the same package is already in the
  repository, that version is archived first.

**archive**
: A directory that is separate from the package repository,
  into which packages and associated metadata are moved
  whenever a newer a version of a package replaces the current
  one, or whenever a package is retired.


## Configuration

Configuration of TealBuild is done by creating a configuration file named
tealbuild.conf. At start time, TealBuild looks for this configuration file by
walking up the directory tree from the current working directory, unless the
TEALBUILD\_ROOT environment variable is set. The normal location for
tealbuild.conf is the root of the build tree (to which TEALBUILD\_ROOT
refers). This design permits multiple build trees to be supported, without
having to set TEALBUILD\_ROOT manually.

If TEALBUILD\_ROOT is unset, and no configuration file is found, then
TEALBUILD\_ROOT defaults to ~/tealbuild. In any case, a new configuration file
can be generated in the root of the build tree by running:

```
$ tealbuild new-config
```

If an existing configuration file was already present, the newly generated
file will be named tealbuild.conf.new, so as to avoid overwriting the
original file. Otherwise, the file will be named tealbuild.conf, which is
the required name for the configuration to be loaded.

To create a new build tree, either set TEALBUILD\_ROOT first, or give the path
of the new tree to the new-config command:

```
$ tealbuild new-config /path/to/new/tree
```

It is possible to put settings that are common to all build trees into a
common location. Before loading a build tree configuration, TealBuild will
first load a system-wide configuration (/etc/tealbuild/tealbuild.conf),
followed by a user-level configuration
("${HOME}/.config/tealbuild/tealbuild.conf"). Each descending level of
configuration file can override the settings made in the level above it, with
the build tree configuration having the most precedence.


## Virtual Machine Management

The first step in preparing to build packages with TealBuild is to set up the
build VM. If a Slackware(64) ISO file is available, the build VM can be
created, and the installation started, by running:

```
$ tealbuild vm-install /path/to/slackware/iso
```

If a Slackware(64) ISO has not been downloaded, TealBuild can download one
automatically if a version is specified instead of an ISO file path. The 32-
or 64-bit version of Slackware is selected based on the ARCH setting in
tealbuild.conf (which is initially based on the uname -m output on the
host system).

```
$ tealbuild vm-install 14.2
```

It is also possible to build an installation ISO for the -current version of
Slackware(64) using:

```
$ tealbuild vm-install current
```

This step will create the QEMU disk image and start the VM, booting into the
Slackware installer. It is necessary to install Slackware manually at this
point, performing a full installation with all disk sets. Be sure to leave
the rc.sshd service configured to start at boot time.

Once the setup program finishes, reboot the VM, update it using slackpkg,
lower the LILO timeout, and reboot again if the kernel is upgraded. Once
updates are done, run:

```
$ tealbuild vm-configure-ssh
```

and follow the instructions to create and configure an SSH key to use for
TealBuild to communicate with the VM. This command will prompt to accept the
SSH host key for the VM, followed by prompting for the root password to the VM
installation. Once this step is complete, run (inside the VM):

```
# poweroff
```

to perform an orderly shutdown. The VM is now ready to build packages.

All package building is done with the VM running in QEMU snapshot mode, which
discards any changes to the virtual hard disk upon VM termination. The
advantage of this approach is that each build is done in a clean environment,
without the potential for introducing hidden dependencies in the resulting
packages. To start the VM in snapshot mode manually, run:

```
$ tealbuild vm-start
```

Note that manually starting (and, if configured accordingly, stopping) the VM
in snapshot mode is not necessary. TealBuild can automate VM management as
part of the build process. The vm-stop and vm-restart commands provided in
the next paragraphs explain the manual control option.

Once the VM has booted to the login prompt, it will be possible to build
packages in it. For each VM session started, the only packages that should be
build in that session are ones that are dependent on each other. Once the
builds are complete, stop the VM using:

```
$ tealbuild vm-stop
```

It is important to stop and start the VM between builds of non-dependent
packages, to avoid potentially creating unintentional dependencies. For
convenience during long package building sessions, use:

```
$ tealbuild vm-restart
```

Finally, from time to time, it will be necessary to run package updates on
the VM to get the latest Slackware patches. For this activity, run:

```
$ tealbuild vm-start-persistent
```

and update using slackpkg. Be careful in persistent mode, as changes made
inside the VM will be written back to the virtual hard disk.


## Virtual Machine Operations

Most of the commands that are run in the VM are automated by the build
process. However, for finer control (and occasionally for updates), there are
some extra VM commands available.

To copy files or directories into the VM, run:

```
$ tealbuild copy source [more sources ...] destination
```

Multiple sources may be listed, and directories will be copied recursively
if listed as a source. The destination is the path inside the VM to which
the sources will be copied; it must be a directory if more than one sources
is given.

To copy a file or directory (which must be done one at a time) from the VM
back to the host system, run:

```
$ tealbuild retrieve /path/inside/vm /path/to/save/on/host
```

To access a root shell on the VM, run:

```
$ tealbuild shell [command]
```

If no command is specified, the shell will be an interactive SSH session.

Packages can be installed, upgraded, or removed inside the VM using:

```
$ tealbuild vm-installpkg /path/to/package/file/on/host [...]
$ tealbuild vm-upgradepkg /path/to/package/file/on/host [...]
$ tealbuild vm-removepkg package_name [...]
```

Be careful when changing the package set with the VM running in persistent
mode, as any changes will be permanent and may affect future builds.


## Building Packages

Once the build VM is installed and updated, it will be possible to build
packages. To use TealBuild, follow the SlackBuilds.org convention when naming
the port directory and build script. For example, if the package to be
built is named "foo", the port directory must be named "foo" and have these
files in it:

```
foo/
foo/foo.SlackBuild
foo/foo.info
foo/slack-desc
```

When configuring a SlackBuild file for TealBuild, note that TealBuild
expects the TMP directory to be set to /tmp/tealbuild/build, with the
OUTPUT directory set to /tmp/tealbuild/output. The build process will set
these values as environment variables at build time, but not all SlackBuild
scripts are designed to read the variables from the environment.

If creating a new port from scratch, running:

```
$ tealbuild new name
```

will create a new directory in the ports collection (PORTS) with
templates for the SlackBuild, .info, slack-desc, tealbuild.include, and
doinst.sh (named doinst.sh.in to prevent accidental inclusion in the final
package) files. These templates can serve as a helpful starting point for a
new package. It is also possible to generate these templates one-by-one
(refer to the man pages for details).

To assist in importing third-party SlackBuilds (e.g. from SlackBuilds.org),
TealBuild can make some modifications to the SlackBuild file automatically:

```
$ tealbuild import name
```

where name is the name of the directory (also the name of the port)
containing the SlackBuild and slack-desc files, the path to a tar archive with
the directory inside it (such as may be downloaded from SlackBuilds.org), or
a URL from which to download the tar archive. The edited files will be placed
into the TealBuild PORTS directory in a subdirectory of the same name.

Once any manual edits to the build script and files have been made, it will
be necessary to download and verify the sources of the actual software
application. If the sources include a .info file, TealBuild can attempt
to download and verify the sources using:

```
$ tealbuild fetch-sources name
```

Note that sources are put into a *separate* directory from the port (a
subdirectory of SOURCES instead of PORTS). This behavior follows the same
convention as is used on SlackBuilds.org, and its primary purpose is to
allow the ports collection to be maintained as a git repository. This way,
revision control is available on the port scripts, and the ports are
easily shared with others.

Some packages from SlackBuilds.org (and other sources) have optional
variables that can be set at build time. Other packages need preliminary work
completed, such as adding a new user account. For convenience, these actions
may be placed into a file named tealbuild.include in the port directory,
which will be included into the build environment before running the
SlackBuild.

Once the port is ready, build the package with:

```
$ tealbuild build name
```

where name is the name of the port. If all goes well, the package will be
built and then copied into the staging area. If the build fails, it will be
necessary to troubleshoot and edit the SlackBuild file. Troubleshooting may
be a bit easier on the VM itself (under /tmp/tealbuild/build), using either
the QEMU window or a TealBuild shell. A log of the build process may be
viewed by running:

```
$ tealbuild log name-version-arch-build
```

The log files in the above command have the same base name as the package
that was generated by the build. These files are stored alongside the
package in the staging area and are moved into the local repository upon
package acceptance. However, they are not uploaded with the repository,
if the upload-repo command is run.

At the end of the build process for a package, the newly built package will
be installed inside the VM automatically (but remember, the VM is a
snapshot, and it will revert to its original state when stopped). As long as
the packages are listed in dependency order (e.g. name3 depends on name2,
which depends on name1), all can be built. The same thing can be done with:

```
$ tealbuild build name1
$ tealbuild build name2
$ tealbuild build name3
```

as long as the VM is not stopped between TealBuild invocations.

If the VM is stopped between builds of dependent packages, or if a new
package needs to be built later with a dependency on a package that has
already been built, it is possible to install packages into the build VM
using:

```
$ tealbuild vm-installpkg /path/to/package /path/to/another/package ...
```


## Dependencies

TealBuild does not resolve dependencies automatically. However, it does
contain a few commands to assist the user in resolving dependencies
manually. These are:

```
$ tealbuild requires name
$ tealbuild depends name
```

The first command determines what ports must be built in order to build the
named port, using information from the .info file to compute dependencies
recursively. The second command recursively determines which ports depend
upon the named port. If either command is run without arguments, information
is calculated for the entire ports collection. Note that the **tealbuild depends**
command is quite slow, as it does a recursive search for ports that depend
both directly and indirectly on the named port.


## Logs

All build steps, including execution of tealbuild.include, are logged to a
file with the same name as the generated package, only with a .log extension.
An easy way to review the log for a build is:

```
$ tealbuild log name<tab><tab>
```

where name is the name of the package that was built. Pressing the tab key
twice will activate Bash completion to show the available logs. By default,
the "less" command will be used as a pager. However, the pager can be changed
by setting the TEALBUILD\_PAGER environment variable.


## Signatures

Before pushing packages to repositories, it is necessary to sign them using
GPG. To facilitate signing, TealBuild maintains GPG keys in the directory
set by the GPG\_HOME configuration variable (by default, TEALBUILD\_ROOT/gpg).
To create a new GPG key, run:

```
$ tealbuild create-gpg-key
```

To use an existing GPG key, first export the key from its current location:

```
$ gpg --output mykeyfile --armor --export-secret-key [email]
```

Then import it into TealBuild using:

```
$ tealbuild import-gpg-key mykeyfile
```

To list GPG keys that TealBuild has available, run:

```
$ tealbuild list-gpg-keys
```

To export a public or private GPG key, use the respective:

```
$ tealbuild export-gpg-public-key output_file [email]
$ tealbuild export-gpg-private-key output_file [email]
```

If no email address (or other user-id accepted by gpg) is specified, the
default key will be selected.

To sign a package file manually, run:

```
$ tealbuild sign /path/to/package/file [email]
```

Note that package signatures are added automatically as part of the
acceptance process, which is documented in the next section.


## Package Acceptance

A Slackware repository contains various metadata files that assist package
managers in finding and downloading packages. By default, TealBuild places
built packages into the staging (STAGE) directory. It can move these files
into the repository (REPO) directory by adding GPG signatures and generating
metadata for each package in staging:

```
$ tealbuild accept [package ...]
```

It is possible to accept only certain packages by listing the base filename of
each package to accept. Otherwise, all packages in staging will be
accepted.

To see the packages in staging first, run:

```
$ tealbuild stage-list
```

To remove a file (delete it!) from staging, run:

```
$ tealbuild stage-rm <package_filename> [package_filename ...]
```

For the sake of completeness, it is also possible to generate package
metadata manually, using:

```
$ tealbuild create-meta <package_filename> [package_filename ...]
```

Metadata support for packages with slapt-get dependency information is
automatic. To suppress this type of metadata, ensure that packages are not
build with it included. (These are the install/slack-required,
install/slack-conflicts, and install/slack-suggests files.)

Note that accepting a different version of a package from a version that is
already in the repository will result in archiving the previous version of
the package into the archive directory. Since a Slackware package
repository can only have one version of each package, automatically
archiving prior versions at acceptance time reduces the risk of pushing
a broken repository. If the accept command isn't used as part of a custom
workflow, then archiving prior package versions must be done manually. The
following command will archive packages manually:

```
$ tealbuild archive <package_filename> [package_filename ...]
```


## Repository Management

Accepted packages are placed into a local repository. To use this repository
with third-party package tools, it is necessary to generate some top-level
repository metadata from the package metadata. TealBuild can perform this
task using:

```
$ tealbuild update-repo
```

This command needs to be re-run each time new packages are accepted into
the repository.

For more control over the repository update process, it is possible to run
the individual steps separately. However, it is important to note that the
generate-repo-pkglist step must be run before generate-changelog, or an
error will occur. It is also necessary to run generate-repo-checksum next to
last, or the package repository won't work properly with the third-party
package management tools. The FILELIST.TXT file is generated last.

```
$ tealbuild generate-repo-pkglist
$ tealbuild generate-repo-manifest
$ tealbuild generate-changelog
$ tealbuild generate-repo-checksums
$ tealbuild generate-repo-filelist
```

It is a good idea to review and edit the ChangeLog.txt file manually, since
additional comments or other information might needed to be added. It is also
important to check that TealBuild's upgrade/downgrade detection has worked
properly for the specific packages in question. For this reason, the user's
EDITOR will be started on the ChangeLog.txt file after the ChangeLog has been
generated. If EDITOR is unset, vi will be used.

Once the repository is updated, it can be copied to another directory or
uploaded to a remote server. Both rsync (locally and via SSH) and (s)cp are
supported by default, and a custom upload script can be used for situations
in which the built-in functionality is insufficient. Remote uploading must be
enabled in the tealbuild.conf file, where explanatory comments may be found.

If uploading is enabled, it can be performed using:

```
$ tealbuild upload-repo
```


## Multiple Repositories

If packages are to be built for multiple repositories, a separate build tree
will be created for each one. Support for multiple build trees is automatic
as long as TealBuild is invoked from the correct build tree. For
finer-grained control, TEALBUILD\_ROOT may be set explicitly before starting
TealBuild.

It may be desirable to share the ports collection and GPG keys among
different build trees. There are two ways to accomplish this task. First,
symbolic links are followed, so the PORTS and GPG\_HOME directories in each
build tree may simply link to a single, shared location. Alternatively, the
PORTS and GPG\_HOME variables may be set to common values in the
tealbuild.conf for each build tree, or at the system or user level.

When building for multiple architectures, a separate build tree should be
used for each architecture. These separate trees may all share a repository
(both local and remote), since packages are placed into the subdirectories
based upon architecture automatically.


## Slackware Tree

TealBuild is capable of maintaining a local copy of the software tree for
specific Slackware(64) versions. Having a local copy of the tree makes it
possible to generate installer ISO files, such as one that might be used to
install -current. To download or update a tree, run:

```
$ tealbuild sync-slackware current
```

Substitute a release number for "current" to download a numbered version
instead. Slackware or Slackware64 will be selected automatically, based upon
the value of ARCH. The location of the downloaded tree is set by the
SLACKWARE setting in the configuration file, and the rsync mirror is
specified using the SLACKWARE\_UPSTREAM variable.


## Generating an Installer ISO

Once a Slackware tree is available locally, the installer can be generated
using a command similar to:

```
$ tealbuild make-iso /path/to/slackware/tree "Slackware Install" "SlackDVD" \
    /path/to/the/output/file
```


## Extending Tealbuild

If stock TealBuild does not have a capability that is required, or if its
functionality needs to be changed, TealBuild is designed to be easy to
extend. See the documentation in the doc/customization directory that
accompanies the TealBuild distribution.


## Typical Workflow

In a production environment, the typical workflow for TealBuild is:

1. **Software Identification**: Identify software that is needed for the system, and determine whether or
   not that software is already included with Slackware. If so, this is the
   only step. If not, continue.

2. **Port Creation**: Obtain or create a port for the desired software. SlackBuilds.org and
   other upstream sources may be of use here. If an upstream port exists,
   import it into the ports tree. Otherwise, create a new port, and develop
   the SlackBuild and related files accordingly.

3. **Source Fetching**: Once the port has been imported or created, fetch the source code for the
   software. For open source applications, TealBuild can automate this step.
   However, if a package is needed for a proprietary application, the sources
   (or prebuilt binaries) may need to be downloaded manually.

4. **Package Build**: Build the package. TealBuild automates this part of the process and builds
   in a clean environment within a VM.

5. **Testing**: Test the package while it is still in the staging area. This step can be
   performed in the build VM immediately after the build, in a fresh snapshot
   of the build VM, or even on the host or another physical system.

6. **Acceptance**: Once quality control for the package is complete, accept the package into
   the local repository.

7. **Repository Update**: When a batch of packages has been accepted, update the local repository
   and complete the ChangeLog.

8. **Repository Upload**: Upload the local repository to the remote production repository, making
   the software available to the managed systems.


## Alternate Workflows

There are situations in which the workflow may need to be modified. TealBuild
is easily adapted to these situations. For example, if packages are only
being built for the local system, they can be installed directly from the
staging area, bypassing the remainder of the standard workflow.

Another alternate workflow may be useful if a private, local repository is
maintained for a set of systems. It might be desirable to include binary
Slackware packages, which the user **has manually verified**, into the
private repository. Such packages would bypass the build process and go
directly to staging using:

```
$ tealbuild stage-package package_name
```

From this point, the rest of the workflow (acceptance through upload) would be used.


# OPTIONS

**\--help**
: Displays a help message that includes a list of all available commands.

**\--variable** value
: Sets the value of an environment variable within the TealBuild system to the specified value. The
  variable will be converted to uppercase, and its name must be a valid Bash variable name (i.e.
  starting with a letter or underscore, and consisting entirely of letters, underscores, and
  numbers.) Environment variables specified as command-line options are set last, after all
  configuration files have been read.


# EXAMPLES

**tealbuild \--help**
: Displays a list of available commands.

**tealbuild version**
: Displays version information.

**tealbuild check-system**
: Checks that the host system has all the necessary software to run TealBuild.

**tealbuild new-config**
: Creates a new tealbuild.conf configuration file at the root of the build tree, which is set by
  the environment variable TEALBUILD\_ROOT.

**tealbuild vm-install current**
: Fetches the Slackware or Slackware64 software tree for the -current (development) version from
  a mirror server, builds an installation DVD ISO image, and then creates and starts a QEMU virtual
  machine to use for building packages. The user must install Slackware(64) into the virtual
  machine by hand.

**tealbuild vm-cofigure-ssh**
: Configures an installed Slackware(64) virtual machine to use public key authentication for the
  root user account.

**tealbuild import firejail.tar.gz**
: Imports a SlackBuild, .info file, and related files from a tar archive such as may be downloaded
  from SlackBuilds.org. In this example, the archive for firejail is presented.

**tealbuild build firejail**
: Builds the port named firejail inside the virtual machine, retrieving the resulting binary
  package into the TealBuild staging area.

**tealbuild accept**
: Accepts packages from the staging area into the repository.

**tealbuild update-repo**
: Updates the metadata in the local package repository.

**tealbuild upload-repo**
: Uploads a copy of the local package repository to a remote location.


# EXIT VALUES

**0**
: The TealBuild command has completed normally.

**nonzero**
: The TealBuild command has completed abnormally.


# ENVIRONMENT

The TEALBUILD\_ROOT variable sets the location of the build tree. It defaults to $HOME/tealbuild if unset.

A pager for build logs can be selected with the TEALBUILD\_PAGER variable, which defaults to less(1).


# FILES

/etc/tealbuild/tealbuild.conf
: System-level configuration file.

/etc/tealbuild/extensions/
: System-level extensions to TealBuild. All extension files must have a .bash extension.

/etc/tealbuild/templates/
: System-level templates to use when generating SlackBuilds and other files.

$HOME/.config/tealbuild/tealbuild.conf
: User-level configuration file.

$HOME/.config/tealbuild/extensions/
: User-level extensions to TealBuild. All extension files must have a .bash extension.

$HOME/.config/tealbuild/templates/
: User-level templates to use when generating SlackBuilds and other files.

$TEALBUILD\_ROOT/tealbuild.conf
: Build tree configuration file.

$TEALBUILD\_ROOT/extensions/
: Build tree TealBuild extensions. All extension files must have a .bash extension.

$TEALBUILD\_ROOT/templates/
: Build tree templates to use when generating SlackBuilds and other files.


# SEE ALSO

tealbuild-check-system(1), tealbuild-tutorial(1), tealbuild-version(1)

Individual manual pages for TealBuild commands can be found in section 1 of the manual, using the form **tealbuild-command**,
where **command** is replaced with the name of the command. A list of commands may be found by running **tealbuild \--help**


# BUGS

Darell and Bill will fix all the bugs. I'll be out by the pool.


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
