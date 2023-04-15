#!/usr/bin/env bash -e

OS="ubuntu"
VERSION="22.04"

HOSTNAME="${OS}-daily"
USERNAME="vagrant"
PASSWORD="vagrant"
ENCRYPTED_PASSWORD='$6$oO2AduquZSwbacIt$zR.tGl0ra0OX7bY61P1ncqJIleJcgPSuNArOVVOTraleioxUCD7\/Mwq9dj4UtTFfVYeryKD6TTeZB8DIWumDE0'

ISO_TARGET_PATH="${HOME}/iso"
ISO_FILE_PATH="file:${HOME}/iso/jammy-live-server-arm64.iso"
OUTPUT_DIRECTORY="vmx"

ISO_CHECKSUM=$(curl https://cdimage.ubuntu.com/releases/22.04/release/SHA256SUMS | grep live-server-arm64.iso | awk '{print $1}')

USER_DATA="http/user-data"

if [ `uname -s` == "Darwin" ]; then
  sed -i "" "s|    hostname: .*|    hostname: ${HOSTNAME}|g" ${USER_DATA}
  sed -i "" "s|    username: .*|    username: ${USERNAME}|g" ${USER_DATA}
  sed -i "" "s|    password: .*|    password: ${ENCRYPTED_PASSWORD}|g" ${USER_DATA}
else
  sed -i "s|    hostname: .*|    hostname: ${HOSTNAME}|g" ${USER_DATA}
  sed -i "s|    username: .*|    username: ${USERNAME}|g" ${USER_DATA}
  sed -i "s|    password: .*|    password: ${ENCRYPTED_PASSWORD}|g" ${USER_DATA}
fi

echo -e "\e[38;5;39m================================#\e[0m"
echo -e "\e[38;5;39m   Image Building with Packer   #\e[0m"
echo -e "\e[38;5;39m================================#\e[0m"

PACKER_LOG=1 packer build \
  -var "box_name=${HOSTNAME}" \
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

vagrant box add --force boxes/${HOSTNAME}.vmware.box --name ${HOSTNAME}

rm -f ${ISO_TARGET_PATH}/*.lock
rm -fr ${OUTPUT_DIRECTORY}/${HOSTNAME}.vmx.lck

echo -e "\e[38;5;39m===================#\e[0m"
echo -e "\e[38;5;39m       Done!       #\e[0m"
echo -e "\e[38;5;39m===================#\e[0m"