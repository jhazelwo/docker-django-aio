#!/bin/sh
docker build --force-rm=true -t jhazelwo/django-aio .

[ "x$1" = "xclean" ] && {
    for this in `/usr/bin/docker images |grep '<none>'|awk '{print $3}'`; do
        /usr/bin/docker rmi $this
    done
}

