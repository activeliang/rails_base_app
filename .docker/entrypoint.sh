#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"

turquoise="\033[36m"

echo -e "${turquoise}Starting the application in ${RAILS_ENV} mode...${reset}"

# Create Database
# echo -e "${turquoise}Creating Database...${reset}"
# rails db:create

# Apply database migrations
# echo -e "${turquoise}Applying database migrations...${reset}"
# rails db:migrate

# Apply database migrations
# echo -e "${turquoise}Creating seeds...${reset}"
# rails db:seed

# Start server
echo -e "${turquoise}Starting server...${reset}"

if [ $RAILS_ENV = "development" ]; then
  yarn install
  bundle install
  foreman start -f Procfile.dev
else
  bundle exec puma -e production -C config/puma.rb
  # bundle exec rails s
fi

