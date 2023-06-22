FROM node:20-alpine

RUN apk fix && apk --no-cache --update add git git-lfs gpg less openssh patch
