# FROM node:20-alpine
# FROM docker:dind

FROM alpine:latest

RUN apk fix && apk --no-cache --update add git git-lfs gpg less openssh patch nodejs npm sudo docker

RUN addgroup -S build-user && adduser -D -H -S build-user -G build-user
WORKDIR /my-app
COPY . /my-app
RUN chown -R build-user:build-user /my-app

RUN echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel
RUN adduser build-user wheel

RUN adduser build-user docker

USER build-user

CMD ["/bin/sh"]