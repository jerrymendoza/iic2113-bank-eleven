FROM ruby:2.7

RUN apt-get update && apt-get install -y \
  curl \
  build-essential \
  libpq-dev &&\
  curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y nodejs yarn

RUN mkdir /bank-eleven
WORKDIR /bank-eleven
COPY Gemfile /bank-eleven/Gemfile
COPY Gemfile.lock /bank-eleven/Gemfile.lock

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
RUN gem update bundler
RUN bundle install --jobs 5

COPY . .
RUN yarn upgrade

# Start the main process.
CMD rails server -b 0.0.0.0 -p  $PORT
