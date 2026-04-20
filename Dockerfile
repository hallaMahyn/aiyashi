# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.3.5
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"


# ── Build stage ──────────────────────────────────────────────────────────────
FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential git libvips pkg-config \
      libpq-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

COPY . .

RUN bundle exec bootsnap precompile app/ lib/

RUN mkdir -p app/assets/builds && \
    SECRET_KEY_BASE_DUMMY=1 ./bin/rails tailwindcss:build && \
    ls app/assets/builds/ && \
    SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile && \
    ls public/assets/ | grep tailwind


# ── Final stage ───────────────────────────────────────────────────────────────
FROM base

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl libvips libpq5 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
