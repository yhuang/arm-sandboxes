#!/usr/bin/env bash

apt-get install -q -y build-essential

apt-get install -q -y \
  apt-transport-https \
  autoconf \
  cmake \
  dnsutils \
  gettext \
  gnupg2 \
  iptraf \
  jq \
  libcurl4-openssl-dev \
  libssl-dev \
  linux-headers-$(uname -r) \
  lsof \
  net-tools \
  nfs-common \
  nfs-kernel-server \
  nmap \
  ncat \
  ntp \
  python3-pip \
  ruby-dev \
  selinux-policy-dev \
  sysstat \
  tasksel \
  tcpdump \
  traceroute \
  unzip \
  whois \
  zlib1g-dev \
  zsh
