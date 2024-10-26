How to install the Nemea system using Vagrant
=============================================

This document describes how to install virtual machine with the Nemea system using Vagrant.
The goal is to simplify the installation setup and get started with using the Nemea system.

Requirements
------------

The guide assumes that Virtualbox and Vagrant are properly installed in your machine.
You can download these software here:

- Virtualbox: https://www.virtualbox.org/wiki/Downloads
- Vagrant: http://www.vagrantup.com/downloads.html
- Ansible
    - galaxy collection community: `ansible-galaxy collection install community.general`
    - galaxy collection posix: `ansible-galaxy collection install ansible.posix`

NEMEA Installation Steps
========================

This directory contains prepared configuration (Vagrantfile) for the following systems:

* [OracleLinux9](./OracleLinux9/)

After choosing the system change working directory into the chosen one and follow the
system dependent instructions in the README.md file.

Troubleshooting
===============

Note: For more information about network configuration, refer to
http://docs.vagrantup.com/v2/networking/public_network.html

