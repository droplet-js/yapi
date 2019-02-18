# --- clone ---

FROM alpine:3.8 as clone

ENV YAPI_VERSION 1.4.4

RUN wget https://github.com/YMFE/yapi/archive/v${YAPI_VERSION}.tar.gz
RUN tar xzf v${YAPI_VERSION}.tar.gz

# --- build ---

FROM node:7.6-alpine as build

ENV YAPI_VERSION 1.4.4

COPY --from=clone /yapi-${YAPI_VERSION} /yapi

RUN apk add --no-cache git python make openssl tar gcc

RUN cd /yapi; \
    npm install --production --registry https://registry.npm.taobao.org

# --- prod ---

FROM node:7.6-alpine as prod

MAINTAINER v7lin <v7lin@qq.com>

COPY --from=build /yapi /yapi/vendors
COPY config.json /yapi/

WORKDIR /yapi/vendors

EXPOSE 3000

ENTRYPOINT ["node"]
CMD ["server/app.js"]
