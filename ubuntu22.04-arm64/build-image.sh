#!/usr/bin/env bash -e

# https://ubuntu.com/download/server/arm
OS="ubuntu"
VERSION="22.04"

HOSTNAME="${OS}-arm64"
BOX_NAME="${OS}${VERSION}-arm64"
USERNAME="vagrant"
PASSWORD="vagrant"

ISO_TARGET_PATH="${HOME}/iso"
ISO_FILE_PATH="file:${HOME}/iso/ubuntu22.04.3-live-server-arm64.iso"
OUTPUT_DIRECTORY="vmx"

ISO_CHECKSUM=$(curl https://cdimage.ubuntu.com/releases/22.04/release/SHA256SUMS | grep live-server-arm64.iso | awk '{print $1}')

USER_DATA="http/user-data"

echo -e "\e[38;5;39m================================#\e[0m"
echo -e "\e[38;5;39m   Image Building with Packer   #\e[0m"
echo -e "\e[38;5;39m================================#\e[0m"

PACKER_LOG=1 packer build \
  -var "build_name=${HOSTNAME}" \
  -var "box_name=${BOX_NAME}" \
  -var "iso_checksum=sha256:${ISO_CHECKSUM}" \
  -var "iso_file_path=${ISO_FILE_PATH}" \
  -var "iso_target_path=${ISO_TARGET_PATH}" \
  -var "output_directory=${OUTPUT_DIRECTORY}" \
  -var "ssh_username=${USERNAME}" \
  -var "ssh_password=${PASSWORD}" \
  -var "user_home_dir=/home/${USERNAME}" \
  -force .

echo -e "\e[38;5;39m===============================#\e[0m"
echo -e "\e[38;5;39m   Box Building with Vagrant   #\e[0m"
echo -e "\e[38;5;39m===============================#\e[0m"

vagrant box add --force boxes/${BOX_NAME}.vmware.box --name ${BOX_NAME}

rm -f ${ISO_TARGET_PATH}/*.lock
rm -fr ${OUTPUT_DIRECTORY}/*.lck

echo -e "\e[38;5;39m===================#\e[0m"
echo -e "\e[38;5;39m       Done!       #\e[0m"
echo -e "\e[38;5;39m===================#\e[0m"