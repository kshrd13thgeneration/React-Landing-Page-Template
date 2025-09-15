# Dockerfile for React App
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

RUN npm run build

# Serve build with simple http server
RUN npm install -g serve
CMD ["serve", "-s", "build", "-l", "3000"]
