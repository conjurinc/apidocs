FROM node:0.12.7

RUN mkdir -p /app

WORKDIR /app

RUN npm install -g dredd@1.0.1 hercule@1.2.1 async@1.5.0 conjur-api@4.5.2

RUN apt-get update && apt-get install -y ruby-full

ADD transactions-4.6.txt /
ADD dredd /
