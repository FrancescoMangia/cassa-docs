# Use multi-stage build
# Stage 1: Build documentation
FROM ghcr.io/foundry-rs/foundry:latest AS builder

# Switch to root to fix permissions
USER root

WORKDIR /app

# Copy project files
COPY . .

# Fix ownership for foundry user
RUN chown -R foundry:foundry /app

# Switch back to foundry user
USER foundry

# Generate documentation
RUN forge doc --build

# Stage 2: Serve with nginx
FROM nginx:alpine

# Copy the generated docs from builder (forge doc outputs to docs/book/)
COPY --from=builder /app/docs/book /usr/share/nginx/html

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port (Railway will automatically assign PORT env var)
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
