FROM ruby:2.4.1-alpine

RUN apk --update add --no-cache --virtual .build-dependencies build-base ruby-dev bash

WORKDIR /connector

COPY Gemfile ./
COPY Gemfile.lock ./

RUN gem update
RUN bundle install

RUN apk del .build-dependencies build-base ruby-dev

COPY . ./


EXPOSE 3000

CMD ["bundle", "exec", "puma", "config.ru", "-p", "3000"]