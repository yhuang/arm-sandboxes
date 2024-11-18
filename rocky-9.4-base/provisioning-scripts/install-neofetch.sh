#!/usr/bin/env bash

dnf config-manager --set-enabled crb
dnf install -q -y \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm \
    https://dl.fedoraproject.org/pub/epel/epel-next-release-latest-9.noarch.rpm

dnf install -q -y neofetch

MOTD_SH="/etc/profile.d/motd.sh"

cat << EOF | tee ${MOTD_SH}
#!/usr/bin/env bash
printf "\n"
neofetch
EOF

chmod a+x $MOTD_SH