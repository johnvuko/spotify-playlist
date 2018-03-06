#!/usr/bin/env bash

export RAILS_ENV="production"

bundle exec pumactl -F config/puma.rb stop

whenever -c spotify-playlist --set environment=$RAILS_ENV
