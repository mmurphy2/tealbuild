# tealbuild
Bash and QEMU-based build system for Slackware Linux (abandoned)

Please note that this project has been ABANDONED. The code is provided here under an MIT license, and it is available for
anyone who would like to use it (or parts of it) in their own build systems.


## About this Code

In the summer of 2021, we did a feasibility study of potentially using Slackware Linux for some HPC, server, and lab
workstations at Coastal Carolina University. During this process, quite a few pieces of software were compiled from
source for testing purposes. In order to ensure that built packages did not contain unintentional dependencies on other
packages, we built each package inside a QEMU virtual machine with a clean Slackware -current installation.

This code automated the processes of:

1. Downloading and verifying source code
2. Starting, stopping, and resetting the QEMU VM for different builds
3. Running the Slackbuild scripts
4. Reviewing the built packages before including them into a repository
5. Creating and maintaining the resulting repositories

In addition, the build system contains extra functionality for updating upstream source trees (e.g. SlackBuilds.org
git repositories) and building -current ISO images from the corresponding Slackware tree.

Although shell scripts are a preferred way to develop programs within the Slackware community, it was readily apparent
that this project needed to be rewritten in another programming language with proper support for data structures and
string handling. Such a rewrite was planned pending the outcome of the feasibility study. In the end, however, it was
determined that the size of the software stack that needed to be built from source was too large for a small number of
people to maintain. As a consequence, another distribution was chosen, and this project was abandoned.


## Getting Started

This code "should" (as of October 1, 2021) still run. Begin by changing to the src/bin directory, then running:

```
eval $(./tealbuild complete)
```

Once this step is complete, read the tutorial:

```
man tealbuild-tutorial
```

Although this application was designed to build packages for Slackware Linux, it should run on any distribution with the
proper software installed. Dependencies can be checked by running:

```
tealbuild check-system
```

Note that TealBuild should NOT be run as root. Packages are built inside a QEMU virtual machine (as root inside the VM), but
the VM itself should be started by a regular user.
