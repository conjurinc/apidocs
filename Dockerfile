FROM node:0.12.7

RUN mkdir -p /app

WORKDIR /app

RUN npm install -g dredd@1.0.1
