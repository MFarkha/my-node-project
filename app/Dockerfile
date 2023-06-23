FROM node:18-alpine

RUN mkdir -p /home/my-node-app
COPY . /home/my-node-app

WORKDIR /home/my-node-app
EXPOSE 3000

RUN npm install
CMD ["node", "server.js"]