FROM ruby:3.4.7-slim

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  libyaml-dev \
  libvips \
  git \
  curl \
  nodejs \
  npm \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy Gemfiles terlebih dahulu agar Docker cache efisien
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy seluruh project
COPY . .

# Jalankan perintah default
CMD ["bash", "-c", "bundle exec rails db:prepare && bundle exec rails s -b 0.0.0.0 -p 3000"]
