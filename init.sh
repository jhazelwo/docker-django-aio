#!/usr/local/bin/dumb-init /bin/bash
set -e
FQDN="this-app.example.org"

/etc/init.d/postgresql start

sed -i "s/djapp.example.tld/${FQDN}/g" /etc/nginx/nginx.conf
/etc/init.d/nginx start

uwsgi --home=/app/www/my-repo --socket=/tmp/uwsgi.socket \
  --uid=www-data --gid=www-data --chmod-socket=600 --enable-threads \
  --module djapp.wsgi \
  --chdir=/app/www/my-repo/djapp \
  --env DJANGO_SETTINGS_MODULE=djapp.settings 2>&1 | tee -a /var/log/uwsgi.log

