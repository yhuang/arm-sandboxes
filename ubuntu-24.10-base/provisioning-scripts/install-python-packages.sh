#!/usr/bin/env bash

# https://stackoverflow.com/questions/38869231/python-cant-find-the-file-pip-conf
cat << 'EOF' >> /etc/pip.conf
[global]
break-system-packages = true
EOF

python3 -m pip install --upgrade six
python3 -m pip install --upgrade google-api-python-client
python3 -m pip install --upgrade oauth2client
python3 -m pip install requests
# https://github.com/pypa/pip/issues/3165
python3 -m pip install --ignore-installed google-cloud-storage
python3 -m pip install google-auth
python3 -m pip install lxml