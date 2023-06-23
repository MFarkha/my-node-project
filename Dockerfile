# FROM node:20-alpine
# FROM docker:dind
FROM alpine:latest

RUN apk fix && apk --no-cache --update add git git-lfs gpg less openssh patch nodejs npm sudo docker aws-cli docker-credential-ecr-login

RUN addgroup build-user && adduser -D build-user -G build-user

RUN mkdir -p /home/build-user/app
COPY . /home/build-user/app
RUN chown -R build-user:build-user /home/build-user/app

RUN echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel
RUN adduser build-user wheel

RUN adduser build-user docker

USER build-user
WORKDIR /home/build-user/app

RUN mkdir -p /home/build-user/.docker && echo '{    "credsStore": "ecr-login"   }' >> /home/build-user/.docker/config.json 

CMD ["/bin/sh"]