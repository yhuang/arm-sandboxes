#!/usr/bin/env bash

# Download and run the official installation script
curl https://sdk.cloud.google.com | bash -s -- --disable-prompts --install-dir=/opt

# Create symlinks for system-wide access
ln -sf /opt/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud
ln -sf /opt/google-cloud-sdk/bin/gsutil /usr/local/bin/gsutil
ln -sf /opt/google-cloud-sdk/bin/bq /usr/local/bin/bq