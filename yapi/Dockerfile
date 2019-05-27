# --- download ---

FROM alpine:3.9.3 as download

ENV YAPI_VERSION 1.7.0

RUN wget https://github.com/YMFE/yapi/archive/v${YAPI_VERSION}.tar.gz
RUN tar xzf v${YAPI_VERSION}.tar.gz
RUN mv /yapi-${YAPI_VERSION} /yapi
RUN ls /yapi

# 删除无用内容
RUN rm -rf /yapi/docs; \
    rm /yapi/README.md; \
    rm /yapi/yapi-base-flow.jpg

# 魔改
COPY yapiEnv.js /yapi/server
RUN sed -i "s|yapi.commons.generatePassword('ymfe.org', passsalt)|yapi.commons.generatePassword(yapi.WEBCONFIG.adminPassword, passsalt)|g" /yapi/server/install.js
RUN sed -i "s|\`初始化管理员账号成功,账号名：\"\${yapi.WEBCONFIG.adminAccount}\"，密码：\"ymfe.org\"\`|\`初始化管理员账号成功,账号名：\"\${yapi.WEBCONFIG.adminAccount}\"，密码：\"\${yapi.WEBCONFIG.adminPassword}\"\`|g" /yapi/server/install.js
RUN sed -i "s|const config = require('../../config.json');|const yapiEnv = require('./yapiEnv.js');\r\nconst config = yapiEnv.parseConfig();|g" /yapi/server/yapi.js
RUN sed -i "s|yapi.path.join(yapi.WEBROOT_RUNTIME, 'init.lock')|yapi.path.join(yapi.WEBROOT_RUNTIME, 'init', 'init.lock')|g" /yapi/server/install.js

# --- build ---

FROM node:7.6-alpine as build

COPY --from=download /yapi /yapi/vendors

RUN apk add --no-cache python make

RUN cd /yapi/vendors; \
    npm install --production --registry https://registry.npm.taobao.org

# --- wait ---

FROM docker:git as wait

RUN git clone -b master https://github.com/vishnubob/wait-for-it.git wait-for-it

# --- prod ---

FROM node:7.6-alpine as prod

MAINTAINER v7lin <v7lin@qq.com>

RUN apk add --no-cache bash

COPY --from=build /yapi/vendors /yapi/vendors
COPY --from=wait /wait-for-it/wait-for-it.sh /yapi/vendors
COPY entrypoint.sh /yapi/vendors

WORKDIR /yapi/vendors

EXPOSE 3000

ENTRYPOINT ["./entrypoint.sh"]
