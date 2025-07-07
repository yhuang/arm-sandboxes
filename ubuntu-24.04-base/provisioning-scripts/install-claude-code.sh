#!/usr/bin/env bash

# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# in lieu of restarting the shell
\. "$HOME/.nvm/nvm.sh"

# Download and install Node.js:
nvm install 24

# Verify the Node.js version:
node -v # Should print "v24.3.0".
nvm current # Should print "v24.3.0".

# Verify npm version:
npm -v # Should print "11.4.2".

npm install -g @anthropic-ai/claude-code