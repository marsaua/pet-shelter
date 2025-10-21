# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.3.9
FROM ruby:${RUBY_VERSION}-slim AS base

# Базові прод-налаштування
ENV RAILS_ENV=production \
    RACK_ENV=production \
    BUNDLE_WITHOUT="development test" \
    BUNDLE_DEPLOYMENT=1 \
    RAILS_LOG_TO_STDOUT=1 \
    RAILS_SERVE_STATIC_FILES=1 \
    PORT=8080

WORKDIR /rails

# Runtime залежності (без dev-tools)
# libpq5 — для pg gem; libvips — ActiveStorage variants; tzdata — час. пояси; ca-certificates — HTTPS
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl libjemalloc2 libvips tzdata ca-certificates libpq5 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# ================================
# Build stage
# ================================
FROM base AS build

# Інструменти для збірки нативних гемів та JS (pg, sass, etc.)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential git libyaml-dev pkg-config libpq-dev python3 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# (Опційно) Node 20 + Corepack (щоб працював yarn/pnpm, якщо вони є)
ARG NODE_VERSION=20.17.0
RUN curl -fsSL https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz \
  | tar -xJ -C /usr/local --strip-components=1 --no-same-owner && corepack enable

# Спочатку встановимо гемі — це дає кращий кеш
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle /usr/local/bundle/ruby/*/cache /usr/local/bundle/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# JS залежності (працює і з yarn.lock, і з package-lock.json, і без них)
COPY package.json ./
COPY yarn.loc[k] ./
COPY package-lock.jso[n] ./
RUN if [ -f yarn.lock ]; then yarn install --immutable; \
    elif [ -f package-lock.json ]; then npm ci; \
    else echo "No JS lockfile found; skipping strict install"; fi

# Код застосунку
COPY . .

# Прекомпіляція bootsnap для коду
RUN bundle exec bootsnap precompile app/ lib/

# Прекомпіляція assets у production (без master.key)
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Після білду нам node_modules не потрібні у прод-образі
RUN rm -rf node_modules

# ================================
# Final image
# ================================
FROM base

# Копіюємо гемі та додаток з білд-стадії
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Нерутовий користувач
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Rails entrypoint (в Rails 7/8 створюється при `rails new`) робить db:prepare тощо
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Railway надає $PORT (типово 8080)
EXPOSE 8080

# Стартуємо Puma, слухаємо 0.0.0.0:$PORT
CMD ["bash","-lc","rm -f tmp/pids/server.pid && bundle exec rails db:prepare && bundle exec puma -C config/puma.rb -b tcp://0.0.0.0:${PORT:-8080}"]
