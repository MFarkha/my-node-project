# FROM node:20-alpine
FROM docker:latest

# RUN apk fix && apk --no-cache --update add git git-lfs gpg less openssh patch
RUN apk fix && apk --no-cache --update add git git-lfs gpg less openssh patch nodejs npm
