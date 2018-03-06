#!/usr/bin/env bash

export RAILS_ENV="production"

echo "Assets precompile"
bundle exec rails assets:precompile

echo "Restart server"
bundle exec pumactl -F config/puma.rb stop
bundle exec pumactl -F config/puma.rb start

whenever -i spotify-playlist --set environment=$RAILS_ENV
