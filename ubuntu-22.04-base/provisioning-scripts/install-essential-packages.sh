#!/usr/bin/env bash

apt-get install -q -y \
  apt-transport-https \
  autoconf \
  build-essential \
  gettext \
  gnupg2 \
  jq \
  libcurl4-openssl-dev \
  libssl-dev \
  linux-headers-$(uname -r) \
  net-tools \
  nfs-common \
  nfs-kernel-server \
  ntp \
  python3-pip \
  selinux-policy-dev \
  tasksel \
  unzip \
  whois \
  zsh
