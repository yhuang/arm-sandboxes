#!/usr/bin/env bash

MPAPIS_KEY="409B6B1796C275462A1703113804BB82D39DC0E3"
PKUCZYNSKI_KEY="7D2BAF1CF37B13E2069D6956105BD0E739499BDB"

gpg2 \
--keyserver keyserver.ubuntu.com \
--recv-keys ${MPAPIS_KEY} ${PKUCZYNSKI_KEY}

curl -sSL https://get.rvm.io | bash -s stable

# latest confirmed working version on Ubuntu 22.04 LTS is 3.3.0
RUBY_VERSION="3.3.0"
RVM_SCRIPT="${HOME}/.rvm/scripts/rvm"

. ${RVM_SCRIPT}

echo "gem: --no-document" > ${HOME}/.gemrc

rvm install ${RUBY_VERSION}
rvm use ${RUBY_VERSION} --default

rvm gemset create user
rvm use ${RUBY_VERSION}@user --default

gem install --no-document \
aws-sdk \
bundler \
rake \
specific_install \
inspec \
test-kitchen