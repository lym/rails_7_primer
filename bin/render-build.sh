#!/usr/bin/env bash
# exit on error
# Render calls this script each time the app is deployed.
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rake db:migrate
