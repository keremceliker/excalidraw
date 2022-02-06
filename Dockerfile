FROM node:14-alpine AS build

WORKDIR /opt/node_app

COPY package.json yarn.lock ./
RUN yarn --ignore-optional

ARG NODE_ENV=production

COPY . .
RUN yarn build:app:docker

FROM nginxinc/nginx-unprivileged

COPY --from=build /opt/node_app/build /usr/share/nginx/html
EXPOSE 8080

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
