# Use multi-stage build
# Stage 1: Build documentation
FROM rust:latest AS builder

WORKDIR /app

# Install Foundry
RUN curl -L https://foundry.paradigm.xyz | bash && \
    bash -c "source ~/.bashrc && foundryup"
ENV PATH="/root/.foundry/bin:${PATH}"

# Install mdbook
RUN cargo install mdbook

# Copy project files
COPY . .

# Replace root README with interfaces README for forge doc homepage
RUN rm -f README.md && cp src/interfaces/README.md README.md

# Build API docs with forge
RUN forge doc --build

# Build custom docs with mdbook  
RUN cd mdbook-src && mdbook build

# Stage 2: Serve with nginx
FROM nginx:alpine

# Copy both doc sets
COPY --from=builder /app/docs/book /usr/share/nginx/html/api
COPY --from=builder /app/mdbook-src/book /usr/share/nginx/html

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port (Railway will automatically assign PORT env var)
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
