FROM ruby:2.6

RUN gem install bundler

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

ENV DATABASE_URL="postgres://localhost:5432/devops_test"

# Migrate the database.
# RUN ruby db/migrate.rb

# Run unit tests:
#RUN bundle exec rspec

# Run the web server:
CMD ["bundle", "exec", "puma"]