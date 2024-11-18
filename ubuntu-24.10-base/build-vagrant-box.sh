#!/usr/bin/env bash -e

BENTO_DIR="${HOME}/workspace/bento"

OS="ubuntu"
MAJOR_NUMBER="24"
MINOR_NUMBER="10"
VERSION="${MAJOR_NUMBER}.${MINOR_NUMBER}"
ARCH=aarch64

HOSTNAME="${OS}${MAJOR_NUMBER}-${MINOR_NUMBER}-base"
SOURCE_DIR="../${OS}-${VERSION}-${ARCH}/boxes"
BOX_NAME="${OS}-${VERSION}-base"

USERNAME="vagrant"
PASSWORD="vagrant"

echo -e "\e[38;5;39m================================#\e[0m"
echo -e "\e[38;5;39m   Image Building with Packer   #\e[0m"
echo -e "\e[38;5;39m================================#\e[0m"

SOURCE_PATH="${SOURCE_DIR}/${OS}-${VERSION}-${ARCH}.vmware.box"
OUTPUT_DIR="boxes"
TARGET_PATH="${OUTPUT_DIR}/${BOX_NAME}.vmware.box"

packer build \
  -var "build_name=${HOSTNAME}" \
  -var "box_name=${BOX_NAME}" \
  -var "output_dir=${OUTPUT_DIR}" \
  -var "source_path=${SOURCE_PATH}" \
  -var "ssh_username=${USERNAME}" \
  -var "ssh_password=${PASSWORD}" \
  -var "user_home_dir=/home/${USERNAME}" \
  -force .

echo -e "\e[38;5;39m===============================#\e[0m"
echo -e "\e[38;5;39m   Box Building with Vagrant   #\e[0m"
echo -e "\e[38;5;39m===============================#\e[0m"

vagrant box remove ${SOURCE_PATH}

mv ${OUTPUT_DIR}/package.box ${TARGET_PATH}
rm -f ${OUTPUT_DIR}/Vagrantfile
vagrant box add --force ${TARGET_PATH} --name ${BOX_NAME}

echo -e "\e[38;5;39m===================#\e[0m"
echo -e "\e[38;5;39m       Done!       #\e[0m"
echo -e "\e[38;5;39m===================#\e[0m"
