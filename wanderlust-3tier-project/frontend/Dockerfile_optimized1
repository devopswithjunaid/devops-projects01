# Use BuildKit features
# syntax=docker/dockerfile:1.4

# -------- Stage 1: Dependencies --------
FROM node:21-alpine AS deps
WORKDIR /app

# Copy only package files to leverage layer caching
COPY package*.json ./

# Install all dependencies with optimized flags
RUN npm ci --no-audit --prefer-offline --no-fund && \
    npm cache clean --force

# -------- Stage 2: Build Stage --------
FROM node:21-alpine AS builder
WORKDIR /app

# Copy dependencies from previous stage
COPY --from=deps /app/node_modules ./node_modules
COPY package*.json ./

# Copy only the source files needed
COPY src/ ./src/
COPY public/ ./public/
COPY *.js *.json *.html ./
COPY .env.sample ./

# Build the app (uncomment if using a build process)
# RUN npm run build

# -------- Stage 3: Runtime Stage --------
FROM node:21-alpine AS runtime
WORKDIR /app

# Set environment to production
ENV NODE_ENV=production

# Install only production dependencies
COPY package*.json ./
RUN npm ci --only=production --no-audit --prefer-offline --no-fund && \
    npm cache clean --force

# Copy necessary files from builder stage
COPY --from=builder /app/src ./src
COPY --from=builder /app/public ./public
COPY --from=builder /app/*.js ./
COPY --from=builder /app/*.json ./
COPY --from=builder /app/*.html ./
COPY --from=builder /app/.env.sample ./.env.local

# Create non-root user with minimal permissions
RUN addgroup -S appgroup && \
    adduser -S appuser -G appgroup && \
    chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 5173

# Use exec form of CMD for proper signal handling
CMD ["npm", "run", "dev", "--", "--host"]
