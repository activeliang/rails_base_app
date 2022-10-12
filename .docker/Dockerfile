# syntax=docker/dockerfile:1
FROM ruby:3.1.2
RUN sed -i "s@http://deb.debian.org@http://mirrors.aliyun.com@g" /etc/apt/sources.list && rm -Rf /var/lib/apt/lists/* && apt-get update
RUN apt-get update -qq && apt-get install -y postgresql-client
RUN apt install sudo
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
RUN apt-get update && apt-get install -y nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN sudo apt update && sudo apt install yarn

# RUN npm install --global yarn
RUN gem install foreman

WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
# RUN gem sources --add https://mirrors.tuna.tsinghua.edu.cn/rubygems/ --remove https://rubygems.org/
# RUN bundle config mirror.https://rubygems.org https://mirrors.tuna.tsinghua.edu.cn/rubygems
RUN bundle install
# RUN if [ $RAILS_ENV == 'production' ] ; then bundle exec rake assets:precompile ; fi
RUN rails assets:precompile

# Add a script to be executed every time the container starts.
COPY ./.docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
# ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
# CMD ["rails", "server", "-b", "0.0.0.0"]
ENTRYPOINT ["entrypoint.sh"]