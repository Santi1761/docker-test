# -------- Stage 1: build (Create React App) --------
FROM node:18-alpine AS builder
WORKDIR /app

# Instala dependencias
COPY package*.json ./
RUN npm install --no-audit --no-fund

# Copia el resto y construye
COPY . .
RUN npm run build

# -------- Stage 2: servir con Nginx --------
FROM nginx:alpine

# Config SPA (rutas) y estáticos
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copia el build de CRA
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
