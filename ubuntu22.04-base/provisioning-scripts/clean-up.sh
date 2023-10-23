#!/usr/bin/env bash

echo "==> Disk usage before cleanup"
df -h

echo "==> Clear out machine id"
rm -f /etc/machine-id
touch /etc/machine-id

apt clean
e4defrag /

echo "==> Clear core files"
rm -f /core*

echo "==> Removing temporary files used to build box"
rm -rf /tmp/*

echo '==> Zeroing out empty area to save space in the final image'
# Zero out the free space to save space in the final image.  Contiguous
# zeroed space compresses down to nothing.
dd if=/dev/zero of=/EMPTY bs=1M || echo "dd exit code $? is suppressed."
rm -f /EMPTY

# Block until the empty file has been removed, otherwise, Packer
# will try to kill the box while the disk is still full and that's bad
sync

echo "==> Disk usage after cleanup"
df -h
