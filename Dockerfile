FROM library/node:8.4-alpine
MAINTAINER Devashish "devashish@shippable.com"

ADD . /srv

RUN cd /srv && npm install

EXPOSE 3000

STOPSIGNAL SIGTERM

ENTRYPOINT ["/srv/run.sh"]
