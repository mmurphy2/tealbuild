# TealBuild
## A package build and repository helper for Slackware Linux

TealBuild is designed to be highly configurable and easily extensible, all
without having to build a completely customized version of the software.


## BASIC CUSTOMIZATION

Basic customization of TealBuild is accomplished by editing the
tealbuild.conf file. A well-commented version of that file may be obtained
by running:

    ```
    $ tealbuild new-config
    ```

which will generate a new tealbuild.conf in the current TEALBUILD\_ROOT.
To specify the output directory (i.e. create a new TEALBUILD\_ROOT), run:

    ```
    $ tealbuild new-config /path/to/output/directory
    ```

In the tealbuild.conf file, locations of directories can be changed,
parameters of the VM can be customized, and even custom templates can be
specified for creating new ports. Each set of customizations, by default,
will apply only to the build tree in which the customizations are made.


## SITE AND USER CONFIGURATION

If a user needs to maintain multiple build trees, all of which have some
common settings, the common settings may be placed in a tealbuild.conf
file located in "${HOME}/.config/tealbuild". Only the settings that are
specific to a given build tree should then be placed into the tealbuild.conf
file located at the root of the build tree.

Similarly, site-level customizations can be put into a file located at
/etc/tealbuild/tealbuild.conf, which will be loaded before the user-level
configuration. This way, the order of configuration precedence is that the
build tree configuration overrides the user configuration, which itself
overrides the site configuration.


## CUSTOM TEMPLATES

Custom templates for the doinst.sh.in, build helper, .info, slack-desc,
SlackBuild, and tealbuild.include files can be specified in the
configuration. It is advisable to use the templates included with
TealBuild (in the share/tealbuild/templates directory) as a starting
point. Customized templates can be placed in the following locations,
in decreasing order of precedence. That is, if a custom template named
"slack-desc" is found in the templates directory of the build tree, it will
be used instead of any templates beneath it.

* $TEALBUILD\_ROOT/templates
* $HOME/.config/tealbuild/templates
* /etc/tealbuild/templates
* TealBuild's included templates (share/tealbuild/templates)

For a list of the templates available at the various paths, run:

    ```
    $ tealbuild list-templates
    ```


### Template Language

In the templates, there are placeholders that begin with two curly braces,
followed by a space, followed by a name, followed by a space, and then ended
with two more curly braces. For example:

    ```
    {{ TEALBUILD_ROOT }}
    ```

These placeholders are used for template substitution and will be replaced by
the environment variable of the same name. Thus, the above example in a
template would be replaced by whatever the TEALBUILD\_ROOT variable has as its
value when the template is processed into a file.

Users of Django or Jinja2 will find this template language familiar. However,
there are two important differences inside the TealBuild implementation:

1. No filters or other control structures are supported, so variable values
   can only be printed without any transformations; and
2. A single space on either side of the variable name is mandatory.

If highly unlikely conditions demand using Jinja2 or Django templates inside
TealBuild templates, the TealBuild tags can be escaped like this:

    ```
    \{{ no_substitution_here }}
    ```


## EXTENDING TEALBUILD

If stock TealBuild does not have a capability that is required, or if its
functionality needs to be changed, scripts ending with the .bash extension
may be placed in any of the following locations. These are sourced in order,
from top to bottom:

* /etc/tealbuild/extensions/
* $HOME/.config/tealbuild/extensions/
* $TEALBUILD\_ROOT/extensions

TealBuild is structured using Bash functions. An individual function can be
replaced by defining a function with the same name in an extension script.
New functionality, including new commands, may also be added.

To see a list of the currently loaded functions, run:

    ```
    $ tealbuild list-functions
    ```

To facilitate adding functions or commands to TealBuild, two templates are
provided among the packed templates described above. The first, named
library.bash, is a template for adding new library functionality to
TealBuild. Library functions in TealBuild perform small tasks or combine
smaller tasks into larger ones.

In contrast, command functions (the template for which is command.bash)
provide the user interface of TealBuild. These functions begin with cmd_ and
add commands that TealBuild can run. Both the command and library template
files have some documentation explaining the structure of the functions.

Note that successful creation of TealBuild extensions does require knowledge
of Bash scripting, and TealBuild uses (and abuses) many features of the Bash
language. For documentation and help with Bash scripting, the following
websites are useful:

* https://tldp.org/LDP/abs/html/
* https://wiki.bash-hackers.org/
* https://www.gnu.org/software/bash/manual/bash.html


## CONTRIBUTING TO TEALBUILD

The main TealBuild project welcomes contributions that add to or improve the
functionality of the system. Please note that contributions must be under the
same (MIT) license as the original TealBuild code, as listed in the LICENSE
file in the Git repository.

Bash code submitted for possible inclusion into TealBuild must be formatted
using 4-space indents, following the same naming convention as the rest of
the source. In particular, global or environment variables that are intended
to be configurable should have SHOUTING\_SNAKE\_CASE names, while variables
local to functions should be declared local (with the local keyword) and have
lower\_case\_with\_underscore names. A global variable that is not intended for
the user to configure (only if truly necessary), should be formatted as
\_SHOUTING\_SNAKE\_CASE, with a leading underscore.

Any new commands should be documented with a man page in Markdown format,
using the template found in the doc/customization directory. Markdown is
converted to groff using Pandoc (see the mansrc directory inside the
TealBuild distribution).
