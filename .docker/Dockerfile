# syntax=docker/dockerfile:1

FROM ruby:3.1.2-alpine as build_host
# RUN sed -i "s@http://deb.debian.org@http://mirrors.aliyun.com@g" /etc/apt/sources.list && rm -Rf /var/lib/apt/lists/* && apt-get update
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
# RUN apt-get install -y git
RUN apk update && apk add --update --no-cache git
RUN apk add build-base
RUN apk add linux-headers
RUN apk add libpq-dev
RUN apk add git
RUN apk add --no-cache g++ musl-dev make libressl-dev openssl-dev libstdc++
RUN mkdir -p /myapp
WORKDIR /myapp
COPY Gemfile* ./
RUN gem install qiniu
RUN bundle config set --local path '/bundle'
# RUN bundle config set --local without 'development test'
ENV ARCHFLAGS "-arch x86_64"
RUN ARCHFLAGS="-arch x86_64" bundle install

FROM node:16.18-alpine3.15 AS node_host

FROM ruby:3.1.2-alpine AS cache_modules_host
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN set -eux & apk add --no-cache yarn
RUN apk add libpng-dev
RUN mkdir -p /myapp
WORKDIR /myapp
COPY package* ./
COPY yarn.loc* ./
RUN yarn config set registry https://registry.npmmirror.com
RUN yarn install

FROM ruby:3.1.2-alpine AS vite_host
# RUN sed -i "s@http://deb.debian.org@http://mirrors.aliyun.com@g" /etc/apt/sources.list && rm -Rf /var/lib/apt/lists/* && apt-get update
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
# RUN apt-get update -qq && apt-get install -y postgresql-client

COPY --from=node_host /usr/local/bin/node /usr/local/bin/node

RUN set -eux & apk add --no-cache yarn

COPY ./app/frontend /myapp/app/frontend
RUN mkdir -p /myapp/config
COPY ./config/vite.json /myapp/config/vite.json 
COPY ./vite.config.ts /myapp/vite.config.ts
WORKDIR /myapp
COPY --from=cache_modules_host /myapp/node_modules /myapp/node_modules
COPY package* ./
COPY postcss* ./
COPY tailwind* ./
COPY package* ./
RUN yarn build

FROM ruby:3.1.2-alpine
# RUN sed -i "s@http://deb.debian.org@http://mirrors.aliyun.com@g" /etc/apt/sources.list && rm -Rf /var/lib/apt/lists/* && apt-get update
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
# RUN apt-get update -qq && apt-get install -y postgresql-client
RUN apk update && apk add --update --no-cache postgresql-client tzdata curl nano gcompat
RUN apk add --no-cache libstdc++

# install nodejs 
# RUN apt install sudo
# RUN curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
# RUN apt-get update && apt-get install -y nodejs

COPY --from=node_host /usr/local/bin/node /usr/local/bin/node

# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
# RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
# RUN sudo apt update && sudo apt install yarn

RUN set -eux & apk add --no-cache yarn
RUN yarn config set registry https://registry.npmmirror.com

# RUN npm install --global yarn
RUN gem install foreman

COPY . /myapp
WORKDIR /myapp
COPY Gemfile* ./

COPY --from=build_host /bundle /bundle
COPY --from=build_host /usr/local/bundle /usr/local/bundle

COPY --from=vite_host /myapp/public/vite /myapp/public/vite

# RUN gem sources --add https://mirrors.tuna.tsinghua.edu.cn/rubygems/ --remove https://rubygems.org/
# RUN bundle config mirror.https://rubygems.org https://mirrors.tuna.tsinghua.edu.cn/rubygems

# RUN bundle check || bundle install
# RUN if [ "$RAILS_ENV" = "production" ] ; then  bundle check || bundle install ; fi
# RUN if [ "$RAILS_ENV" = "production" ] ; then RAILS_ENV=production bundle exec rails assets:precompile ; fi
# RUN RAILS_ENV=production bundle exec rails assets:precompile
# RUN rails assets:precompile

# Add a script to be executed every time the container starts.
COPY ./.docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
RUN bundle exec whenever --update-crontab
RUN chmod +x /myapp/.docker/backup.rb
# ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

RUN rm -fr /var/cache/apk/*

RUN echo -e "#! /bin/sh\ncd /myapp && bundle exec rails \$*" >> /usr/local/bin/rails && chmod +x /usr/local/bin/rails

# Configure the main process to run when running the image
# CMD ["rails", "server", "-b", "0.0.0.0"]
ENTRYPOINT ["/usr/bin/entrypoint.sh"]