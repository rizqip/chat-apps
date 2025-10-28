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
# Stage 2: Serve via Nginx (fixed)
# ==========================
FROM nginx:alpine

# Hapus konfigurasi default nginx
RUN rm -rf /etc/nginx/conf.d/default.conf

# Copy hasil build React ke direktori Nginx
COPY --from=build /app/build /usr/share/nginx/html

# Copy file konfigurasi nginx custom
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Jalankan nginx
CMD ["nginx", "-g", "daemon off;"]