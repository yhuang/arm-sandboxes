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
libffi-devel \
libxcrypt-compat \
lsof \
nano \
nmap \
nmap-ncat \
nfs-utils \
open-vm-tools \
openssl-devel \
python3-pip \
readline-devel \
ruby \
selinux-policy-devel \
sqlite-devel \
sysstat \
tcpdump \
traceroute \
vim \
whois \
zlib-devel \
zsh
