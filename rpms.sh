#!/bin/bash
#
# Copyright (C) 2015 CESNET
#
# LICENSE TERMS
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in
#    the documentation and/or other materials provided with the
#    distribution.
# 3. Neither the name of the Company nor the names of its contributors
#    may be used to endorse or promote products derived from this
#    software without specific prior written permission.
#
# ALTERNATIVELY, provided that this notice is retained in full, this
# product may be distributed under the terms of the GNU General Public
# License (GPL) version 2 or later, in which case the provisions
# of the GPL apply INSTEAD OF those given above.
#
# This software is provided ``as is'', and any express or implied
# warranties, including, but not limited to, the implied warranties of
# merchantability and fitness for a particular purpose are disclaimed.
# In no event shall the company or contributors be liable for any
# direct, indirect, incidental, special, exemplary, or consequential
# damages (including, but not limited to, procurement of substitute
# goods or services; loss of use, data, or profits; or business
# interruption) however caused and on any theory of liability, whether
# in contract, strict liability, or tort (including negligence or
# otherwise) arising in any way out of the use of this software, even
# if advised of the possibility of such damage.

#set -x

if [ "$#" -eq 1 ]; then
   chuser="$1"
else
   echo "For non-interactive mode run with username as argument, e.g.:"
   echo "  $0 builder"
   echo "where builder is a non-root user for building RPMs."
fi

if [ -x "`which dnf`" ]; then
   export pkginst=dnf
elif [ -x "`which yum`" ]; then
   export pkginst=yum
else
   echo "Unsupported package manager (dnf/yum)" >&2
   exit 1
fi

if [ -z "$chuser" ]; then
   echo "Warning: You must have 'rpmbuild' in order to generate RPM package."
   echo "If you want to abort this script, press CTRL+C (i.e. send SIGINT signal)"
   sleep 5

   if [ "x`whoami`" != xroot ]; then
      echo "Run this script as root, since it must install RPM packages continuously"
      exit 1
   fi

   read -p "Enter the name of user who will compile packages: " chuser

   read -p "Are You sure You want to continue? [yn]" -n1 ans

   if [ "x$ans" != xy ]; then
      exit 0
   fi
fi

./bootstrap.sh
./configure -q

echo "Remove previously installed packages"
$pkginst remove -q -y libtrap\* unirec\* nemea\*
$pkginst install -q -y libnf-devel libpcap-devel libidn-devel bison flex

export topdir=$PWD
export chuser

(
   cd nemea-framework
   (
      cd libtrap
      su $chuser -p -c "$topdir/generate-rpm.sh"
      $pkginst install -y -q $(find \( -name '*noarch.rpm' -o -name '*64.rpm' \))
   )
   (
      cd common
      su $chuser -p -c "$topdir/generate-rpm.sh"
      $pkginst install -y -q $(find \( -name '*noarch.rpm' -o -name '*64.rpm' \))
   )
   (
      cd unirec
      su $chuser -p -c "$topdir/generate-rpm.sh"
      $pkginst install -y -q $(find \( -name '*noarch.rpm' -o -name '*64.rpm' \))
   )
   su $chuser -p -c "./bootstrap.sh >/dev/null 2>/dev/null&& ./configure -q"
   (
      cd pytrap
      su $chuser -p -c "make rpm"
      $pkginst install -y -q $(find \( -name '*noarch.rpm' -o -name '*64.rpm' \))
      su $chuser -p -c "python3.6 setup.py bdist_wheel"
      su $chuser -p -c "python3.8 setup.py bdist_wheel"
      su $chuser -p -c "python3.9 setup.py bdist_wheel"
   )
   (
      cd pycommon
      su $chuser -p -c "make rpm"
      su $chuser -p -c "python3.6 setup.py bdist_wheel"
      $pkginst install -y -q $(find \( -name '*noarch.rpm' -o -name '*64.rpm' \))
   )
   su $chuser -p -c "make rpm"
   $pkginst install -y -q $(find -name 'nemea-framework-*noarch.rpm')
)
(
   cd modules
   su $chuser -p -c "$topdir/generate-rpm.sh"
   $pkginst install -y -q $(find \( -name '*noarch.rpm' -o -name '*64.rpm' \))
)
(
   cd detectors
   su $chuser -p -c "$topdir/generate-rpm.sh"
   $pkginst install -y -q $(find \( -name '*noarch.rpm' -o -name '*64.rpm' \))
)
(
   cd modules-ng
   su $chuser -p -c "cmake . && make rpm"
   $pkginst install -y -q $(find \( -name '*noarch.rpm' -o -name '*64.rpm' \))
)
(
   cd nemea-supervisor
   su $chuser -p -c "$topdir/generate-rpm.sh"
   $pkginst install -y -q $(find \( -name '*noarch.rpm' -o -name '*64.rpm' \))
)

su $chuser -p -c "$topdir/bootstrap.sh >/dev/null 2>/dev/null&& $topdir/configure -q"
mkdir -p "`pwd`/RPMBUILD"
rpmbuild  -ba nemea.spec --define "_topdir `pwd`/RPMBUILD"
mkdir -p "`pwd`/rpms"
find -name '*.rpm' -not -path "./rpms/*" -exec mv {} rpms/ \;
chown -R $chuser rpms/

mkdir -p "`pwd`/wheels"
find -name '*.whl' -not -path "./wheels/*" -exec mv {} wheels/ \;


