#!/usr/bin/env bash

apt-get install -q -y build-essential

apt-get install -q -y \
  apt-transport-https \
  autoconf \
  bison \
  cmake \
  dnsutils \
  gettext \
  gnupg2 \
  iptraf \
  jq \
  libcurl4-openssl-dev \
  libffi-dev \
  libgdbm-dev \
  libncurses5-dev \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  libtool \
  libyaml-dev \
  linux-headers-$(uname -r) \
  lsof \
  net-tools \
  nfs-common \
  nfs-kernel-server \
  nmap \
  ncat \
  ntp \
  open-vm-tools \
  pkg-config \
  python3-pip \
  ruby-dev \
  selinux-policy-dev \
  sqlite3 \
  sysstat \
  tasksel \
  tcpdump \
  traceroute \
  unzip \
  whois \
  zlib1g-dev \
  zsh
