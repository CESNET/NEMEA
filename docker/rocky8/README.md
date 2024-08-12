# Explanation

This directory contains `Dockerfile` to build an image based on RockyLinux8 with
all required dependencies installed.

The image can be used to create a container and build all NEMEA RPM packages
and Python wheels.

To do this, just run `build.sh`, and the results should be in `rpms/` an `wheels/`.

# Requirements

* podman or docker

