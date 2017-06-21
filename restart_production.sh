#!/usr/bin/env bash

export RAILS_ENV="production"

echo "Assets precompile"
bundle exec rails assets:precompile

echo "Restart server"
bundle exec pumactl -F config/puma.rb stop
bundle exec pumactl -F config/puma.rb start

# kill -9 $(cat tmp/pids/sidekiq.pid)
# bundle exec sidekiq -e $RAILS_ENV -C config/sidekiq.yml

whenever -i spotify-playlist --set environment=$RAILS_ENV
