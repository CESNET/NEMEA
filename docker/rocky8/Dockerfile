FROM rockylinux:8-minimal
RUN microdnf install dnf
RUN dnf -y install epel-release
RUN curl -s 'https://copr.fedorainfracloud.org/coprs/g/CESNET/NEMEA/repo/epel-8/group_CESNET-NEMEA-epel-8.repo' > /etc/yum.repos.d/group_CESNET-NEMEA-epel-8.repo
#RUN dnf -y update
RUN dnf -y --enablerepo=devel --enablerepo=powertools install epel-rpm-macros \
   python3-rpm-macros python-rpm-macros python-srpm-macros rpm-build git which \
   doxygen bison flex libcurl-devel lua-devel bzip2-devel libpcap-devel \
   ncurses-devel fuse3-devel openssl-devel libxml2-devel libidn-devel make automake \
   autoconf pkgconfig gcc gcc-c++ libtool cmake \
   python3-devel python3-setuptools python3-pip python3-wheel \
   python38 python38-devel python38-pip python38-wheel python38-setuptools \
   python39 python39-devel python39-pip python39-wheel python39-setuptools \
   python3-jinja2 python3-ply python3-pynspect python3-yaml \
   python3-sphinx

	# python3-nemea-pytrap
RUN dnf clean all

CMD ["/bin/bash"]

