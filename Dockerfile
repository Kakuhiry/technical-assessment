FROM node:16-alpine AS base
WORKDIR /app
COPY package.json ./
RUN npm install
COPY ./ ./

ENV .env
ENV nginx.conf

CMD ["node", "app.js"]