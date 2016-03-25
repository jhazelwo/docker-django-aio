FROM ubuntu:14.04
MAINTAINER "John Hazelwood" <jhazelwo@users.noreply.github.com>
RUN apt-get update && \
  apt-get -y upgrade && \
  apt-get -y install bzip2 wget git curl zip git

RUN echo "#NGINX" >> /etc/apt/sources.list
RUN echo "deb http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list
RUN echo "deb-src http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list
RUN apt-get -y install nginx

RUN echo "#PGSQL" >> /etc/apt/sources.list
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list
RUN wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
RUN apt-get -y install libpq-dev postgresql postgresql-contrib
RUN echo "local all all trust" > /etc/postgresql/9.3/main/pg_hba.conf

RUN apt-get -y install python3-pip 
RUN pip3 install virtualenv dumb-init

RUN install -d -o 0 -g 0 -m 0700 /root/.ssh
COPY id_rsa /root/.ssh/id_rsa
RUN install -o 0 -g 0 -m 0600 /dev/null /root/.ssh/config
RUN echo "Host *" >> /root/.ssh/config
RUN echo " UserKnownHostsFile /dev/null" >> /root/.ssh/config
RUN echo " StrictHostKeyChecking no" >> /root/.ssh/config

RUN mkdir -p /app /app/bin /app/etc /app/git /app/www /app/log
RUN chown -vR 33:33 /app/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY init.sh /root/init.sh

EXPOSE 80
ENTRYPOINT /root/init.sh
