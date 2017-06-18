FROM ruby:2.4.1-alpine

WORKDIR /pflegebot

RUN apk --update add --virtual build-dependencies build-base ruby-dev postgresql-dev libxml2-dev libxslt-dev \
        nodejs tzdata bash

RUN gem install bundler
COPY Gemfile ./
COPY Gemfile.lock ./

RUN bundle install --jobs=4 --without development test

COPY . ./
RUN RAILS_ENV=production NO_BUNNY=1 bundle exec rake assets:precompile

VOLUME '/pflegebot/logs'
VOLUME '/pflegebot/public'
EXPOSE 3000

ENV RAILS_ENV production
CMD ["bundle","exec","puma", "-C", "config/puma_prod.rb"]