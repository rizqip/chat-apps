# ==========================
# Stage 1: Build React App
# ==========================
FROM node:18-alpine AS build

WORKDIR /app
COPY package*.json ./
RUN npm install --legacy-peer-deps
COPY . .
RUN npm run build

# ==========================
# Stage 2: Serve via Nginx
# ==========================
FROM nginx:alpine

# Copy hasil build React ke direktori Nginx
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]