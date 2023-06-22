# FROM node:20-alpine
FROM docker:cli

# RUN apk fix && apk --no-cache --update add git git-lfs gpg less openssh patch
RUN apk fix && apk --no-cache --update add git git-lfs gpg less openssh patch npm

RUN addgroup -S build-user && adduser -S build-user -G build-user
WORKDIR /my-app
COPY . /my-app
RUN chown -R build-user:build-user /my-app
USER build-user

CMD ["/bin/sh"]
