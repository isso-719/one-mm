FROM ruby:3.0.0

WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ./
#ENV BUNDLE_FROZEN=true
RUN gem install bundler && bundle config set --local without 'test'

COPY . ./
RUN bundle install

ENV RACK_ENV=production

CMD ["bundle", "exec", "ruby", "app.rb"]