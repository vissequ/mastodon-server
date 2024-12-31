# Use the official Mastodon base image
FROM tootsuite/mastodon:v4.2.0

# Set environment variables
ENV RAILS_ENV=production \
    NODE_ENV=production \
    BIND=0.0.0.0 \
    RAILS_SERVE_STATIC_FILES=true \
    TZ=Etc/UTC

# Create and set working directory
WORKDIR /mastodon

# Copy application files
COPY . .

# Install dependencies
RUN bundle install --deployment --without development test
RUN yarn install --pure-lockfile
RUN yarn run build:production
RUN bundle exec rails assets:precompile

# Expose default Puma port
EXPOSE 3000

# Start Mastodon server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
