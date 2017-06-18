FROM ruby:2.4.1-alpine

WORKDIR /pflegebot

RUN apk add  --no-cache --virtual .build-dependencies build-base ruby-dev postgresql-dev libxml2-dev libxslt-dev
RUN apk add --no-cache nodejs tzdata bash

RUN gem install bundler
COPY Gemfile ./
COPY Gemfile.lock ./

RUN bundle install --jobs=6 --without development test

COPY . ./

# RUN apk del .build-dependencies

RUN RAILS_ENV=production NO_BUNNY=1 bundle exec rake assets:precompile

VOLUME '/pflegebot/logs'
VOLUME '/pflegebot/public'
EXPOSE 3000

ENV RAILS_ENV production
ENV REDIS_URL redis://redis:6379/0

CMD ["bundle","exec","puma", "-C", "config/puma_prod.rb"]