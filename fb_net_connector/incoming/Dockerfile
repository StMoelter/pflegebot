FROM ruby:2.4.1-alpine

RUN apk add --no-cache --virtual .build-dependencies build-base ruby-dev bash

WORKDIR /connector

COPY Gemfile ./
COPY Gemfile.lock ./

RUN gem update
RUN bundle install --without development test

RUN apk del .build-dependencies

COPY . ./


EXPOSE 3000

CMD ["bundle", "exec", "rackup", "config.ru", "-p", "3000"]