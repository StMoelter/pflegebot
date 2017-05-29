FROM ruby:2.4.1-alpine
RUN gem update

WORKDIR /connector

COPY Gemfile ./
COPY Gemfile.lock ./

RUN bundle install

COPY . ./

CMD ["bundle", "exec", "ruby", "listener.rb"]