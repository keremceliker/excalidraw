FROM node:14-alpine AS build

WORKDIR /usr/src/app

COPY package.json package-lock.json ./
RUN npm install

COPY . .
ENV NODE_ENV=production
RUN npm run build:app

FROM nginxinc/nginx-unprivileged

COPY --from=build /usr/src/app/build /usr/share/nginx/html
EXPOSE 8080

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
