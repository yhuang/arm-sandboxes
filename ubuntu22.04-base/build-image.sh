#!/usr/bin/env bash -e

OS="ubuntu"
VERSION="22.04"

HOSTNAME="${OS}-base"
BOX_NAME="${OS}${VERSION}-base"
USERNAME="vagrant"
PASSWORD="vagrant"
ENCRYPTED_PASSWORD='$6$oO2AduquZSwbacIt$zR.tGl0ra0OX7bY61P1ncqJIleJcgPSuNArOVVOTraleioxUCD7\/Mwq9dj4UtTFfVYeryKD6TTeZB8DIWumDE0'

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

SOURCE_PATH="source-vmware-vmx/${OS}${VERSION}-arm64.vmx"
OUTPUT_DIRECTORY="boxes"

PACKER_LOG=1 packer build \
  -var "build_name=${HOSTNAME}" \
  -var "box_name=${BOX_NAME}" \
  -var "output_directory=${OUTPUT_DIRECTORY}" \
  -var "source_path=${SOURCE_PATH}" \
  -var "ssh_username=${USERNAME}" \
  -var "ssh_password=${PASSWORD}" \
  -var "user_home_dir=/home/${USERNAME}" \
  -force .

echo -e "\e[38;5;39m===============================#\e[0m"
echo -e "\e[38;5;39m   Box Building with Vagrant   #\e[0m"
echo -e "\e[38;5;39m===============================#\e[0m"

vagrant box add --force ${OUTPUT_DIRECTORY}/${BOX_NAME}.vmware.box --name ${BOX_NAME}

rm -fr ${OUTPUT_DIRECTORY}/*.lck

echo -e "\e[38;5;39m===================#\e[0m"
echo -e "\e[38;5;39m       Done!       #\e[0m"
echo -e "\e[38;5;39m===================#\e[0m"
