#!/bin/bash
echo "Setting up Calypso project..."
gem install bundler
bundle install

if [ ! -f .env ]; then
  echo "SERVER_IP=0.0.0.0" > .env
  echo "SERVER_PORT=3630" >> .env
  echo "Created .env file."
else
  echo ".env file already exists."
fi

if [ ! -f control_token.txt ]; then
  echo "authorized=true" > control_token.txt
  echo "Control token created."
fi

echo "Setup complete!"
