% TEALBUILD-VM-CONFIGURE-SSH(1) TealBuild
% Dr. Mike Murphy
% June 2021


# NAME

tealbuild vm-configure-ssh - Interactively configures SSH in the virtual machine


# SYNOPSIS

**tealbuild vm-configure-ssh**


# DESCRIPTION

Interactively configures the SSH connection that TealBuild uses to connect
to the build VM. The build VM must be started in persistent mode, and
/etc/ssh/sshd\_config inside the build VM must have the directive:

```
PermitRootLogin yes
```

After setting that directive, the SSH daemon must be restarted, and
/etc/rc.d/rc.sshd must be set executable so that sshd starts each time the
virtual machine boots.

This command is normally only needed once after creating a build VM.


# SEE ALSO

tealbuild(1), tealbuild-vm-install(1), tealbuild-vm-start-persistent(1)


# COPYRIGHT

Copyright 2021 Coastal Carolina University. License: MIT.
