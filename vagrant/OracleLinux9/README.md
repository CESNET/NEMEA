Installation of NEMEA using Vagrant on OracleLinux9
===================================================

If you do not have a vagrant box for OracleLinux9 box yet, use:

```
vagrant box add generic/oracle9 --provider=virtualbox
```

Installation - Final Step
=========================

Start the VM Installation using (this will take few minutes):
```
vagrant up
```

Once the installation is complete, SSH into the VM:
```
vagrant ssh
```

Content of VM
=============

* ipfixprobe
* ipfixcol2 with ipfixcol2-unirec-output
* all NEMEA packages installed from COPR repository

