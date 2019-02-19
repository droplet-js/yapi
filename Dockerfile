# --- clone ---

FROM alpine:3.8 as clone

ENV YAPI_VERSION 1.5.2

RUN wget https://github.com/YMFE/yapi/archive/v${YAPI_VERSION}.tar.gz
RUN tar xzf v${YAPI_VERSION}.tar.gz

# --- prod ---

FROM node:7.6-alpine as prod

MAINTAINER v7lin <v7lin@qq.com>

ENV YAPI_VERSION 1.5.2

COPY --from=clone /yapi-${YAPI_VERSION} /yapi/vendors

RUN apk add --no-cache git python make

RUN cd /yapi/vendors; \
    npm install -g ykit \
    npm install --registry https://registry.npm.taobao.org

COPY config.json /yapi/

WORKDIR /yapi/vendors

EXPOSE 3000

CMD ["/bin/sh", "-c", "if [ ! -e \"/yapi/init/init.lock\" ]; then npm run install-server; cp /yapi/init.lock /yapi/init/; fi; ykit pack -m; node server/app.js"]
