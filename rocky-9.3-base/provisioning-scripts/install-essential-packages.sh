#!/usr/bin/env bash

dnf groupinstall -q -y "Development Tools"

dnf install -q -y \
bind-utils \
cmake \
curl-devel \
dnf-utils \
iptraf \
jq \
libcurl-devel \
libxcrypt-compat \
lsof \
nano \
nmap \
nmap-ncat \
nfs-utils \
python3-pip \
ruby-devel \
selinux-policy-devel \
sysstat \
tcpdump \
traceroute \
vim \
whois \
zlib-devel \
zsh
