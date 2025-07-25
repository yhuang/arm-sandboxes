#!/usr/bin/env bash

MPAPIS_KEY="409B6B1796C275462A1703113804BB82D39DC0E3"
PKUCZYNSKI_KEY="7D2BAF1CF37B13E2069D6956105BD0E739499BDB"

gpg2 \
--keyserver keyserver.ubuntu.com \
--recv-keys ${MPAPIS_KEY} ${PKUCZYNSKI_KEY}

curl -sSL https://get.rvm.io | bash -s stable

RUBY_VERSION="3.4.4"
RVM_SCRIPT="${HOME}/.rvm/scripts/rvm"

. ${RVM_SCRIPT}

echo "gem: --no-document" > ${HOME}/.gemrc

rvm install ${RUBY_VERSION}
rvm use ${RUBY_VERSION} --default

rvm gemset create user
rvm use ${RUBY_VERSION}@user --default

# Install bundler in the gemset
gem install --no-document bundler

# Create Gemfile
cat > /tmp/Gemfile << 'EOF'
source 'https://rubygems.org'
gem 'aws-sdk'
gem 'rake'
gem 'specific_install'
gem 'inspec'
gem 'test-kitchen'
EOF

# Install gems via bundler (will use current gemset)
bundle install --gemfile=/tmp/Gemfile

rm -f /tmp/Gemfile