# ==========================
# Stage 1: Build React App
# ==========================
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json dan package-lock.json (atau yarn.lock jika pakai yarn)
COPY package*.json ./

# Install dependencies
RUN npm install --legacy-peer-deps

# Copy seluruh source code ke container
COPY . .

# Build React app untuk production (output: /app/build)
RUN npm run build

# ==========================
# Stage 2: Serve via Nginx
# ==========================
FROM nginx:alpine

# Hapus konfigurasi default nginx
RUN rm -rf /etc/nginx/conf.d/default.conf

# Copy hasil build React ke direktori Nginx
COPY --from=build /app/build /usr/share/nginx/html

# Copy file konfigurasi nginx custom (kamu bisa buat sendiri)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 (port default Nginx)
EXPOSE 80

# Jalankan nginx
CMD ["nginx", "-g", "daemon off;"]
