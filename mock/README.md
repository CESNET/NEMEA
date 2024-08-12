# Explanation

This directory contains `mock` configuration files, which include @CESNET/NEMEA
copr repo with dependencies.

Example how to rebuild a package for, e.g., libtrap for RockyLinux8 is as follows:

```
mock -r rocky+epel+nemea-8-x86_64.cfg path/to/srpms/libtrap-1.18.1-1.src.rpm
```

See the output of the command to find the results and logs.
