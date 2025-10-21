# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.3.9
FROM ruby:${RUBY_VERSION}-slim AS base

# Minimal production runtime environment
ENV RAILS_ENV=production \
    BUNDLE_WITHOUT="development test" \
    BUNDLE_DEPLOYMENT=1 \
    RAILS_LOG_TO_STDOUT=1 \
    RAILS_SERVE_STATIC_FILES=1

WORKDIR /rails

# Runtime OS dependencies only (keep image small)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl libjemalloc2 libvips tzdata ca-certificates libpq5 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# ================================
# Build stage
# ================================
FROM base AS build

# Build-time deps for native gems and PostgreSQL
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential git libyaml-dev pkg-config libpq-dev python3 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install Node (for asset builds if needed) and enable Corepack (Yarn)
RUN curl -fsSL https://nodejs.org/dist/v20.17.0/node-v20.17.0-linux-x64.tar.xz \
  | tar -xJ -C /usr/local --strip-components=1 --no-same-owner && corepack enable

# Ruby gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle /usr/local/bundle/ruby/*/cache /usr/local/bundle/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Application code
COPY . .

# Bootsnap cache for app code
RUN bundle exec bootsnap precompile app/ lib/

# Precompile assets without requiring real master key
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# ================================
# Final image
# ================================
FROM base

# Bring in gems and app from the build stage
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Rails entrypoint handles db:prepare safely
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Railway provides $PORT (commonly 8080)
ENV PORT=8080
EXPOSE 8080

# Start the app with Puma
CMD ["bash","-lc","rm -f tmp/pids/server.pid && bundle exec rails db:prepare && bundle exec puma -C config/puma.rb -b tcp://0.0.0.0:${PORT:-8080}"]
