#!/usr/bin/env bash

SSHD_CONFIG="/etc/ssh/sshd_config"

echo '==> Configuring sshd_config options'

echo '==> Turning off sshd DNS lookup to prevent timeout delay'
echo "UseDNS no" >> ${SSHD_CONFIG}
echo '==> Disablng GSSAPI authentication to prevent timeout delay'
echo "GSSAPIAuthentication no" >> ${SSHD_CONFIG}