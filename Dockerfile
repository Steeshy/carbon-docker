FROM node:20-alpine

# Install build tools
# RUN apk add --no-cache git bash python3 make g++

# WORKDIR /app

# Copy entrypoint script
# COPY entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh

# Set entrypoint
# ENTRYPOINT ["/entrypoint.sh"]

# RUN npm install -g turbo

# ---- Stage 1: Build ----
FROM node:18 AS builder

# Set working directory
WORKDIR /app

# Copy everything
COPY . .

# Install dependencies
RUN npm install --legacy-peer-deps

# Build in production mode
ENV NODE_ENV=production
ENV NODE_OPTIONS=--max_old_space_size=6144
RUN npm run build

# ---- Stage 2: Runtime ----
FROM node:18

WORKDIR /app

# Copy only built files + production deps
COPY --from=builder /app .

# Set environment
ENV NODE_ENV=production
ENV NODE_OPTIONS=--max_old_space_size=6144

EXPOSE 3000

# Start production server
CMD ["npm", "run", "start"]
