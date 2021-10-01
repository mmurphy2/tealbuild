% TEALBUILD-TUTORIAL(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild tutorial - Step-by-step tutorial for using TealBuild


# DESCRIPTION

This document provides a step-by-step quickstart tutorial for using
TealBuild. To understand what each command does, refer to the man pages
for tealbuild(1) and its individual commands. Note that this tutorial is
written in a conversational style, as opposed to the formal style of the
typical manual page.

In this tutorial, commands that you type as your regular user directly onto
your computer are denoted with $. Commands that are run as the root user
inside the build VM are denoted with #.


0. If you have not already done so, put the TealBuild script on your PATH
   and configure Bash completion by running:

   ```
   $ eval $(/path/to/tealbuild complete)
   ```

   It is a good idea to check that your host computer has all the required
   programs needed to run TealBuild. Perform this check by running:

   ```
   $ tealbuild check-system
   ```


1. Begin by creating the basic TealBuild build tree and configuration file:

   ```
   $ tealbuild new-config
   ```


2. Change to the newly created build tree, and edit the tealbuild.conf file
   to put your name in PACKAGER\_NAME and your email in PACKAGER\_EMAIL. Also
   edit the TAG setting to append a unique package build tag for yourself.
   This might start with \_ for readability and must consist only of letters
   and underscores.

   ```
   $ cd ~/tealbuild
   $ vim tealbuild.conf    # or use your favorite editor
   ```


3. Create a new build virtual machine:

   ```
   $ tealbuild vm-install current
   ```

   This step will synchronize a copy of the Slackware(64) software tree to
   your computer, then it will build a Slackware -current installation ISO
   and boot the VM from it. Note that it would also be possible to use a
   released version of Slackware by specifying the version number instead
   of "current". In that case, the official DVD ISO would be downloaded
   from mirrors.slackware.com, instead of building it locally.

   Once the VM has booted, perform a Slackware installation in the usual way
   (which is beyond the scope of this tutorial). Do a full or terse install
   using all package sets, and be sure to leave the rc.sshd service checked
   to start at boot time.


4. Once the installation is complete, let the setup program reboot the VM.
   Log into the VM as root, uncomment a mirror in /etc/slackpkg/mirrors, and
   then update the VM by running these commands INSIDE the VM:

   ```
   # slackpkg update gpg
   # slackpkg update
   # slackpkg upgrade-all
   ```

   If you just synchronized the tree and built the installer ISO in the
   previous step, there should not be any updates. However, this step ensures
   that slackpkg is ready to update the VM whenever it needs to be done in
   the future.

   While we're here, let's greatly speed up the VM boot time by lowering the
   LILO timeout. Inside the VM, run:

   ```
   # vim /etc/lilo.conf
   ```

   Change the line that reads:

   ```
   timeout = 1200
   ```

   to

   ```
   timeout = 20
   ```

   This will reduce the LILO delay from 2 minutes to 2 seconds. Save the file
   and then run:

   ```
   # lilo
   ```


5. Once the LILO timeout has been reduced, configure SSH by running the
   following command on your host system (NOT inside the VM) and following
   the instructions given:

   ```
   $ tealbuild vm-configure-ssh
   ```

   Once this step is complete, log into the virtual machine and perform an
   orderly shutdown by running:

   ```
   # poweroff
   ```


6. You're now ready to build your first package. To do this, we first need to
   import the package into the ports collection within the build tree. Run:

   ```
   $ tealbuild import "http://slackbuilds.org/slackbuilds/14.2/system/firejail.tar.gz"
   ```


7. Now take a look at the imported SlackBuild file to be sure everything
   looks good.

   ```
   $ cd ~/tealbuild/ports/firejail
   $ vim firejail.SlackBuild
   ```

   You can also take a look at firejail.info and the slack-desc file.


8. Notice that we don't yet have the source code for firejail itself. We can
   have TealBuild grab it for us like this:

   ```
   $ tealbuild fetch-sources firejail
   ```

   Note that we still need to give the package name, even though we're
   inside the firejail directory. The source files are actually stored in a
   separate directory from the port files.


9. If the download was successful, we're ready to build the package. Be sure
   the build VM is not running, then give the command:

   ```
   $ tealbuild build firejail
   ```

   This command will start the build VM in snapshot mode, in which any
   changes made will be lost upon shutdown. Once the VM is running, TealBuild
   will upload the scripts from your port directory, as well as the sources
   from the SOURCES directory, into the VM. It will then run the SlackBuild
   for you automatically.

   To view the automatically generated log of the build process, use Bash
   completion with the "log" command, as shown below. The build log will have
   the same base name (the part before the .t?z) as the package.

   ```
   $ tealbuild log firejail<tab><tab>
   ```


11. If the build completed successfully, the resulting Slackware package will
    be in your staging directory. You can view this directory manually:

    ```
    $ cd ~/tealbuild/stage/x86\_64
    $ ls
    ```

    (If building for a different architecture, substitute that architecture
    in place of the x86\_64.)

    Alternatively, you can view the packages you have in staging using:

    ```
    $ tealbuild stage-list
    ```

    What is the staging directory? Well, when we first build a package, we
    might want to test it before accepting it into our local package
    repository. After building a package, it will be installed into the VM
    automatically. Log into the VM, and then check to see if the program
    is there and working:

    ```
    # firejail ps ax
    ```

    We know that firejail is working if the ps ax output only shows a few
    processes. The rest of the processes on the system have been hidden by
    the firejail sandbox.

    Remember that this automatic installation into the VM is only temporary,
    since the VM is in snapshot mode. As soon as the VM is shut down and
    restarted, it will be back to a "clean" Slackware installation with no
    extra packages.


12. While we could just install packages out of our staging area, it would be
    nice to put them into a proper repository. With a repository, we could
    use a third-party package management tool (like slackpkg+, slapt-get, or
    slpkg) to install and remove our packages. We could also share the
    repository with other people by uploading it to a server.

    To create a repository, we first need a GPG key to sign our packages.
    Create one by running:

    ```
    $ tealbuild create-gpg-key
    ```

    Enter your name and email when prompted. For the comment, you might want
    to label the key with some text indicating that it is used for building
    packages.

    Check that your GPG key was properly created by running:

    ```
    $ tealbuild list-gpg-keys
    ```


13. Now we need to accept our newly created package into our repository.
    Accepting the package signs it and creates the required metadata files
    for that package. We can accept all the packages in our staging area
    (we only have this one anyway) by running:

    ```
    $ tealbuild accept
    ```


14. Once we have accepted a package into the repository, we need to update
    the repository metadata. To do this, first check that your EDITOR
    variable is set to the name of the editor you prefer to use (if it isn't
    already vi). Run:

    ```
    $ tealbuild update-repo
    ```

    The repository-level metadata will be generated, and your editor will
    appear, showing the contents of the ChangeLog.txt that will be created
    for the newly accepted packages (any existing ChangeLog will be appended
    after your edit this one). You should just have one ChangeLog entry for
    the firejail package.


15. Once you have closed your editor, your repository update will be
    complete, and you'll have a local Slackware repository with a newly
    built package! However, we can take another step and simulate uploading
    the repository to another system.

    Edit the ~/tealbuild/tealbuild.conf file to make the following changes:

    ```
        REPO_REMOTE_PATH="${HOME}/myrepo"
    ```

    Then run:

    ```
    $ tealbuild upload-repo
    ```

    You should find a copy of your repository in ~/myrepo.

    We don't actually need this copy of the repository in ~/myrepo for
    anything else, so you can go ahead and delete it if you want.


16. Now we can test that our newly created repository works properly. Begin
    by restarting the VM, which clear the installed firejail package (since
    snapshot mode is in use):

    ```
    $ tealbuild vm-restart
    ```


17. While the VM is restarting, start TealBuild's repository test server by
    running:

    ```
    $ tealbuild repo-server start
    ```

    The repository test server is just the http.server module that ships
    with Python version 3. It is enough to test that the repository is
    working. However, it should not be used in production (i.e. to serve
    the repository over the Internet).


18. Once the VM has restarted, get a shell on the VM by running:

    ```
    $ tealbuild shell
    ```

    Verify that you have a clean VM by trying to run:

    ```
    # firejail ps ax
    ```

    This time, you should get an error that firejail cannot be found.


19. In this shell, let's download and install slackpkg+ to test our repo.
    Run these commands in the VM shell:

    ```
    # wget 'https://sourceforge.net/projects/slackpkgplus/files/slackpkg%2B-1.7.6-noarch-7mt.txz'
    # installpkg slackpkg+-1.7.6-noarch-7mt.txz
    ```

    Open an editor (vim is shown here) to edit /etc/slackpkg/slackpkgplus.conf

    ```
    # vim /etc/slackpkg/slackpkgplus.conf
    ```

    Change the REPOPLUS line to read:

    ```
    REPOPLUS=( slackpkgplus myrepo )
    ```

    Add a line below REPOPLUS that reads:

    ```
    MIRRORPLUS['myrepo']=http://10.0.2.2:8018/x86_64/
    ```

    If you're building for a different architecture, substitute that
    architecture in place of x86_64 in the above MIRRORPLUS line.

    Save the file and exit the editor.


20. Keep using the VM shell, and run:

    ```
    # slackpkg update gpg
    # slackpkg update
    # slackpkg install firejail
    ```

    If everything was successful, you should see slackpkg+ install the
    firejail package from your own repository. Verify once again that
    firejail is working by running:

    ```
    # firejail ps ax
    ```


21. When you're finished with the tutorial, exit the VM shell by running:

    ```
    # exit
    ```

    Stop the repository server by running:

    ```
    $ tealbuild repo-server stop
    ```

    Finally, to stop the build VM, run:

    ```
    $ tealbuild vm-stop
    ```

Congratulations on reaching the end of the tutorial! The next step is to read the man page for
tealbuild(1), which explains basic concepts. Individual commands are documented in their own
man pages.

Happy building!


# SEE ALSO

tealbuild(1), tealbuild-accept(1), tealbuild-build(1), tealbuild check-system(1), tealbuild-complete(1),
tealbuild-create-gpg-key(1), tealbuild-fetch-sources(1),
tealbuild-import(1), tealbuild-list-gpg-keys(1), tealbuild-log(1),
tealbuild-new-config(1), tealbuild-repo-server(1), tealbuild-shell(1), tealbuild-stage-list(1),
tealbuild-update-repo, tealbuild-upload-repo(1)
tealbuild-vm-configure-ssh(1), tealbuild-vm-install(1), tealbuild-vm-restart(1), tealbuild-vm-stop(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
