#!/usr/bin/env bash

export RAILS_ENV="production"

bundle exec pumactl -F config/puma.rb stop

# kill -9 $(cat tmp/pids/sidekiq.pid)

whenever -c spotify-playlist --set environment=$RAILS_ENV
