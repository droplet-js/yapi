# --- clone ---

FROM alpine:3.8 as clone

ENV YAPI_VERSION 1.5.2

RUN wget https://github.com/YMFE/yapi/archive/v${YAPI_VERSION}.tar.gz
RUN tar xzf v${YAPI_VERSION}.tar.gz

# 魔改
COPY server/yapiEnv.js /yapi-${YAPI_VERSION}/server
RUN sed -i "s|yapi.commons.generatePassword('ymfe.org', passsalt)|yapi.commons.generatePassword(yapi.WEBCONFIG.adminPassword, passsalt)|g" /yapi-${YAPI_VERSION}/server/install.js
RUN sed -i "s|const config = require('../../config.json');|const yapiEnv = require('./yapiEnv.js');\r\nconst config = yapiEnv.parseConfig();|g" /yapi-${YAPI_VERSION}/server/yapi.js
RUN sed -i "s|yapi.path.join(yapi.WEBROOT_RUNTIME, 'init.lock')|yapi.path.join(yapi.WEBROOT_RUNTIME, 'init', 'init.lock')|g" /yapi-${YAPI_VERSION}/server/install.js

RUN cat /yapi-${YAPI_VERSION}/server/install.js
RUN cat /yapi-${YAPI_VERSION}/server/yapi.js

# --- prod ---

FROM node:7.6-alpine as prod

MAINTAINER v7lin <v7lin@qq.com>

ENV YAPI_VERSION 1.5.2

COPY --from=clone /yapi-${YAPI_VERSION} /yapi/vendors

RUN apk add --no-cache git python make

RUN cd /yapi/vendors; \
    npm install -g ykit; \
    npm install --production --registry https://registry.npm.taobao.org

COPY config.json /yapi/

WORKDIR /yapi/vendors

EXPOSE 3000

CMD ["/bin/sh", "-c", "if [ ! -e \"/yapi/init/init.lock\" ]; then npm run install-server; fi; ykit pack -m; node server/app.js"]
