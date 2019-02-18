# --- clone ---

FROM docker:git as clone

ENV YAPI_VERSION 1.5.2

RUN git clone -b v${YAPI_VERSION} https://github.com/YMFE/yapi.git

# --- build ---

FROM node:11.9.0-alpine as build

RUN apk add --no-cache python make

COPY --from=clone /yapi $PWD/yapi

RUN cd yapi; \
    npm install --production --registry https://registry.npm.taobao.org

# --- prod ---

FROM node:11.9.0-alpine as prod

MAINTAINER v7lin <v7lin@qq.com>

COPY --from=build /yapi /yapi/vendors

EXPOSE 3000

WORKDIR /yapi/vendors

ENTRYPOINT ["node"]
CMD ["server/app.js"]
