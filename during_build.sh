#!/bin/sh

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

