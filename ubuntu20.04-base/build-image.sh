#!/usr/bin/env bash -e

OS="ubuntu"
VERSION="20.04"

# https://app.vagrantup.com/bento/boxes/ubuntu-20.04-arm64/versions/202306.30.0
HOSTNAME="${OS}-base"
BOX_NAME="${OS}${VERSION}-base"
USERNAME="vagrant"
PASSWORD="vagrant"
ENCRYPTED_PASSWORD='$6$oO2AduquZSwbacIt$zR.tGl0ra0OX7bY61P1ncqJIleJcgPSuNArOVVOTraleioxUCD7\/Mwq9dj4UtTFfVYeryKD6TTeZB8DIWumDE0'

echo -e "\e[38;5;39m================================#\e[0m"
echo -e "\e[38;5;39m   Image Building with Packer   #\e[0m"
echo -e "\e[38;5;39m================================#\e[0m"

SOURCE_BOX_NAME="${OS}${VERSION}-arm64"
SOURCE_BOX_PATH="source-boxes/${SOURCE_BOX_NAME}.box"
TARGET_BOXES_DIRECTORY="boxes"

PACKER_LOG=1 packer build \
  -var "build_name=${HOSTNAME}" \
  -var "source_box_path=${SOURCE_BOX_PATH}" \
  -var "source_box_name=${SOURCE_BOX_NAME}" \
  -var "target_boxes_directory=${TARGET_BOXES_DIRECTORY}" \
  -var "ssh_username=${USERNAME}" \
  -var "ssh_password=${PASSWORD}" \
  -var "user_home_dir=/home/${USERNAME}" \
  -force .

echo -e "\e[38;5;39m===============================#\e[0m"
echo -e "\e[38;5;39m   Box Building with Vagrant   #\e[0m"
echo -e "\e[38;5;39m===============================#\e[0m"

rm -fr ${TARGET_BOXES_DIRECTORY}/.vagrant
rm -f ${TARGET_BOXES_DIRECTORY}/Vagrantfile
mv ${TARGET_BOXES_DIRECTORY}/package.box ${TARGET_BOXES_DIRECTORY}/${BOX_NAME}.vmware.box

vagrant box remove ${SOURCE_BOX_PATH}
vagrant box add --force ${TARGET_BOXES_DIRECTORY}/${BOX_NAME}.vmware.box --name ${BOX_NAME}

echo -e "\e[38;5;39m===================#\e[0m"
echo -e "\e[38;5;39m       Done!       #\e[0m"
echo -e "\e[38;5;39m===================#\e[0m"
