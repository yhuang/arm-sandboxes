#!/usr/bin/env bash

APPLICATION="go"
VERSION="1.22.2"
ARCHIVE="${APPLICATION}${VERSION}.linux-arm64.tar.gz"

wget https://go.dev/dl/${ARCHIVE}

tar xzf ${ARCHIVE} -C /opt

rm -f ${ARCHIVE}

GOENV_SH="/etc/profile.d/goenv.sh"

cat << EOF | tee ${GOENV_SH}
export GOROOT=/opt/go
export GOPATH=/etc/opt/go
export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin
EOF

chmod 644 ${GOENV_SH}

. ${GOENV_SH}

OLD_PATH=$(grep 'Defaults\s*secure_path\s*=\s*\(.*\)' /etc/sudoers |
awk -F'=' '{print $2}' |
sed -e 's/^[ \t]*//')
OLD_SECURE_PATH="Defaults    secure_path = ${OLD_PATH}"
NEW_SECURE_PATH="Defaults    secure_path = ${OLD_PATH}:${GOROOT}/bin:${GOPATH}/bin"

sed -i "s|${OLD_SECURE_PATH}|${NEW_SECURE_PATH}|" /etc/sudoers

echo 'Defaults    env_keep += "GOPATH"' >> /etc/sudoers.d/go

mkdir -p ${GOPATH}/{src,bin,pkg}

go install golang.org/x/tools/cmd/...@latest
go install golang.org/x/lint/golint@latest

chown -R root:wheel ${GOPATH}
chmod -R 775 ${GOPATH}
