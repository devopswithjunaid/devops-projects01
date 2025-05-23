# -------- Stage 1: Build Stage --------
FROM node:21 AS builder

# Set working directory
WORKDIR /app

# Copy dependency files
COPY package*.json ./

# Install all dependencies
RUN npm install

# Copy all source files
COPY . .

# Build your app (only if applicable, e.g., for production builds)
# RUN npm run build


# -------- Stage 2: Runtime Stage --------
FROM node:21-slim

# Set working directory
WORKDIR /app

# Copy only what’s needed from builder
COPY --from=builder /app /app

WORKDIR /app  # Add this line to be explicit before the COPY

# Copy environment config (you may already have this in /app, but keep it explicit)
COPY .env.sample .env.local

# Add non-root user
RUN adduser --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

# Expose the app port
EXPOSE 5173

# Run the app
CMD ["npm", "run", "dev", "--", "--host"]
