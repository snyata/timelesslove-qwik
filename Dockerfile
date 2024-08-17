FROM node:20.11.0 AS build

WORKDIR /app

COPY package*.json ./

RUN npm ci --only=production

COPY . .

RUN npm run build

FROM node:20.11.0-slim

WORKDIR /app

COPY --from=build /app/dist ./dist
COPY --from=build /app/package*.json ./

RUN npm install --only=production && npm cache clean --force

USER node

CMD ["node", "dist/index.js"]