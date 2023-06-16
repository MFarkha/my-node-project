FROM node:19-alpine

RUN mkdir -p /home/my-node-app
COPY . /home/app

WORKDIR /home/my-node-app/app
EXPOSE 3000

RUN npm install
CMD ["node", "server.js"]