FROM node:19-alpine

RUN mkdir -p /home/app
COPY app/* /home/app

WORKDIR /home/app
EXPOSE 3000

RUN npm install
CMD ["node", "server.js"]