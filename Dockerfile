# --- clone ---

FROM docker:git as clone

ENV YAPI_VERSION 1.5.2

RUN git clone -b v${YAPI_VERSION} https://github.com/YMFE/yapi.git

# --- build ---

FROM node:11.9.0-alpine as build

COPY --from=clone /yapi $PWD/yapi
RUN cd yapi; \
    npm install --production --registry https://registry.npm.taobao.org

# --- prod ---

FROM node:11.9.0-alpine as prod

MAINTAINER v7lin <v7lin@qq.com>

COPY --from=build /yapi /yapi/vendors

ENV ADMIN_ACCOUNT admin@admin.com
ENV MONGODB_SERVER_NAME mongo
ENV MONGODB_SERVER_PORT 27017
ENV MONGODB_SERVER_DATABASE yapi

RUN echo "{\"port\":\"3000\",\"adminAccount\":\"${ADMIN_ACCOUNT}\", \"db\":{\"servername\":\"${MONGODB_SERVER_NAME}\",\"port\":${MONGODB_SERVER_PORT},\"DATABASE\":\"${MONGODB_SERVER_DATABASE}\"}}" > /yapi/config.json

EXPOSE 3000

WORKDIR /yapi/vendors

ENTRYPOINT ["node", "server/app.js"]
