#!/usr/bin/env bash

HASHICORP_PROFILE="/etc/profile.d/hashicorp.sh"

cat << 'EOF' | tee ${HASHICORP_PROFILE}
pathmunge () {
        if ! echo $PATH | /bin/egrep -q "(^|:)$1($|:)" ; then
           if [ "$2" = "after" ] ; then
              PATH=$PATH:$1
           else
              PATH=$1:$PATH
           fi
        fi
}
EOF

HASHICORP_DIR="/usr/local/bin/hashicorp"
mkdir -p ${HASHICORP_DIR}
echo "pathmunge $HASHICORP_DIR" >> ${HASHICORP_PROFILE}

chmod 644 ${HASHICORP_PROFILE}
