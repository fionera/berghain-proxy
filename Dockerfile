FROM alpine/git:latest AS berghain-checkout
WORKDIR /
RUN git clone https://github.com/DropMorePackets/berghain.git

FROM node:alpine AS berghain-build-frontend
WORKDIR /
COPY --from=berghain-checkout berghain /berghain
RUN cd /berghain/web && npm install && npm run build


FROM golang:alpine AS berghain-build-backend
WORKDIR /
COPY --from=berghain-checkout berghain /berghain
RUN cd /berghain && CGO_ENABLED=0 go build ./cmd/spop

FROM haproxy:2.9-alpine
USER root

RUN apk add --update supervisor && rm  -rf /tmp/* /var/cache/apk/*

RUN mkdir -p /var/log/supervisor

RUN mkdir /berghain
COPY --from=berghain-build-frontend /berghain/web/dist/index.html /berghain/index.html
COPY --from=berghain-build-backend /berghain/spop /berghain/app

COPY haproxy/haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
COPY haproxy/berghain.conf /usr/local/etc/haproxy/berghain.conf
COPY berghain.yaml /berghain/config.yaml
COPY supervisord.conf /etc/supervisord.conf

USER haproxy
EXPOSE 8080
ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]

