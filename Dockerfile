FROM node:8

RUN apt-get update && apt-get install -y ruby-full

RUN mkdir -p /app

WORKDIR /app

RUN npm -g config set user root && npm install -g \
      dredd@4.6.0 hercule@4.1.0 async@2.5.0 conjur-api@4.5.2

COPY dredd /
