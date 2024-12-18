#!/usr/bin/bash

# redmine agile plugin
tar xzf /config/redmine-agile-*light.tgz -C /opt/bitnami/redmine/plugins/

if [ -f /opt/bitnami/redmine/plugins/redmine_agile/Gemfile ]; then
  cd /opt/bitnami/redmine/plugins
  chown -R redmine redmine_agile
  cd ..
  bundle config set frozen false
  bundle install --without development test RAILS_ENV=production
  bundle exec rake redmine:plugins NAME=redmine_agile RAILS_ENV=production
fi
