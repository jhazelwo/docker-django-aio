#!/usr/local/bin/dumb-init /bin/bash
set -e
FQDN="this-app.example.org"


/etc/init.d/postgresql start
su - postgres -c 'psql -U postgres -c create\ database\ django'

cd /app/www
git clone --depth=1 git@github.com:username/my-repo.git
virtualenv my-repo
cd /app/www/my-repo
. bin/activate
pip install -r requirements.txt
djapp/manage.py makemigrations
djapp/manage.py migrate
djapp/manage.py createsuperuser --noinput --username admin --email admin@localhost
djapp/manage.py dbshell <<< "update auth_user set password='pbkdf2_sha256\$24000\$rL................eS\$0fyhCJ/+pqQT54TxO07vDLVw=' where username='admin';"

sed -i "s/djapp.example.tld/${FQDN}/g" /etc/nginx/nginx.conf
/etc/init.d/nginx start

uwsgi --home=/app/www/my-repo --socket=/tmp/uwsgi.socket \
  --uid=www-data --gid=www-data --chmod-socket=600 --enable-threads \
  --module djapp.wsgi \
  --chdir=/app/www/my-repo/djapp \
  --env DJANGO_SETTINGS_MODULE=djapp.settings 2>&1 | tee -a /var/log/uwsgi.log

