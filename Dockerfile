# Phase de construction
FROM node:18-alpine AS builder
WORKDIR /app
RUN apk add --no-cache git
RUN git clone https://github.com/thijs-hakkenberg/archimate-mcp.git .
RUN npm install && npm run build

# Image finale légère
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules
# Dossier où vous mettrez vos fichiers .archimate
RUN mkdir /models
VOLUME /models
ENTRYPOINT ["node", "dist/index.js"]
