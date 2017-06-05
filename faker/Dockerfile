FROM ruby:2.4.1-alpine
RUN gem update

WORKDIR /faker

COPY Gemfile ./
COPY Gemfile.lock ./

RUN bundle install --without development test

COPY . ./

CMD ["bundle", "exec", "ruby", "faker.rb"]