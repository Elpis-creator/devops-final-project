FROM node:lts-alpine

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev

COPY index.js ./
COPY public ./public

ENV NODE_ENV=production

EXPOSE 3000

CMD ["node", "index.js"]