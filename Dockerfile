# --- clone ---

FROM docker:git as clone

ENV YAPI_VERSION 1.5.2

RUN git clone -b v${YAPI_VERSION} https://github.com/YMFE/yapi.git

# --- build ---

FROM node:11.9.0-alpine as build

COPY --from=clone /yapi $PWD/yapi
RUN cd yapi; \
    ls
RUN npm install -g yapi-cli --registry https://registry.npm.taobao.org

RUN echo $PWD

# --- prod ---

FROM node:11.9.0-alpine as prod

MAINTAINER v7lin <v7lin@qq.com>

#RUN docker-php-ext-install mysqli; \
#    docker-php-ext-install pdo_mysql
#
#COPY --from=clone /discuz/upload $PWD
#
#RUN chmod a+w -R config data uc_server/data uc_client/data
