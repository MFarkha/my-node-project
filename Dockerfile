# FROM node:20-alpine
FROM docker:cli

# RUN apk fix && apk --no-cache --update add git git-lfs gpg less openssh patch
RUN apk fix && apk --no-cache --update add git git-lfs gpg less openssh patch npm

RUN groupadd -r build-user && useradd -r -s /bin/false -g build-user build-user
WORKDIR /app
COPY . /app
RUN chown -R build-user:build-user /app
USER build-user

CMD ["/bin/sh"]
