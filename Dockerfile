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

WORKDIR /app

COPY . .

# Move into the ERP app folder
WORKDIR /app/apps/erp

RUN npm install --legacy-peer-deps

# Build in production mode
ENV NODE_ENV=production
ENV NODE_OPTIONS=--max_old_space_size=6144
RUN npm run build

# ---- Stage 2: Runtime ----
FROM node:18

WORKDIR /app/apps/erp

COPY --from=builder /app/apps/erp .

ENV NODE_ENV=production
ENV NODE_OPTIONS=--max_old_space_size=6144

EXPOSE 3000

CMD ["npm", "run", "start"]