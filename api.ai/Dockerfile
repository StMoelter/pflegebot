FROM ruby:2.4.1-alpine
RUN apk add --no-cache --virtual .build-dependencies build-base ruby-dev bash

RUN gem update

WORKDIR /api_ai

COPY Gemfile ./
COPY Gemfile.lock ./

RUN bundle install --without development test

RUN apk del .build-dependencies

COPY . ./

CMD ["bundle", "exec", "ruby", "api_ai.rb"]