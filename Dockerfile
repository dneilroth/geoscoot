FROM ruby:2.5.3

RUN apt-get update
RUN apt-get install -y libsodium-dev nodejs build-essential libssl-dev git make g++ libxml2 libxml2-dev libxslt-dev libffi-dev bash

ARG RAILS_ENV=production

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN gem update bundler

ADD Gemfile* $APP_HOME/
RUN bundle install

COPY . .

RUN echo 'alias console="cd /app && bundle exec rails console"' >> ~/.bashrc
