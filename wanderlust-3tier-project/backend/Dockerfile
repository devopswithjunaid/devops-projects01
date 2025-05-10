# syntax=docker/dockerfile:1.4

# -------- Stage 1: Dependencies --------
FROM node:21-alpine AS deps
WORKDIR /app

# Copy npmrc first for better caching
COPY .npmrc ./

# Set npm cache config
ENV NPM_CONFIG_CACHE=/npm-cache

# Copy package files for dependency installation
COPY package*.json ./

# Install dependencies with optimized settings
RUN --mount=type=cache,target=/npm-cache \
    npm ci --prefer-offline --no-audit || npm install --prefer-offline --no-audit

# -------- Stage 2: Runtime --------
FROM node:21-alpine AS runtime
WORKDIR /app

# Set production environment
ENV NODE_ENV=production

# Copy npmrc for runtime
COPY .npmrc ./

# Copy package files for production dependencies
COPY package*.json ./

# Copy node_modules from deps stage
COPY --from=deps /app/node_modules ./node_modules

# Copy application files
COPY . .

# Copy environment config
COPY .env.sample .env

# Create non-root user
RUN addgroup -S appgroup && \
    adduser -S appuser -G appgroup && \
    chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget -q --spider http://localhost:5000/ || exit 1

# Expose API port
EXPOSE 5000

# Run the app
CMD ["npm", "start"]
