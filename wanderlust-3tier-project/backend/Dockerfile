# syntax=docker/dockerfile:1.4

# =====================
# Stage 1: Dependencies
# =====================
FROM node:21-alpine AS deps
WORKDIR /app

# Copy package files for dependency installation
COPY package*.json ./

# Install dependencies with optimized flags
RUN npm ci --no-audit --prefer-offline --no-fund && \
    npm cache clean --force

# ===================
# Stage 2: Build stage
# ===================
FROM node:21-alpine AS build
WORKDIR /app

# Copy dependencies from previous stage
COPY --from=deps /app/node_modules ./node_modules
COPY package*.json ./

# Copy only necessary source files
COPY src/ ./src/
COPY config/ ./config/ 
COPY .env.sample ./

# Build/compile if needed (uncomment if you have a build step)
# RUN npm run build

# ==========================
# Stage 3: Production stage
# ==========================
FROM node:21-alpine AS production
WORKDIR /app

# Set NODE_ENV
ENV NODE_ENV=production

# Copy package files for production dependencies
COPY package*.json ./

# Install only production dependencies with optimized flags
RUN npm ci --only=production --no-audit --prefer-offline --no-fund && \
    npm cache clean --force

# Copy application code from build stage
COPY --from=build /app/src ./src
COPY --from=build /app/config ./config
COPY --from=build /app/package.json ./
COPY --from=build /app/.env.sample ./.env

# Create non-root user with minimal privileges using Alpine syntax
RUN addgroup -S appgroup && \
    adduser -S appuser -G appgroup && \
    chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose API port
EXPOSE 5000

# Set health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget -q --spider http://localhost:5000/health || exit 1

# Use exec form of CMD for proper signal handling
CMD ["node", "src/index.js"]
