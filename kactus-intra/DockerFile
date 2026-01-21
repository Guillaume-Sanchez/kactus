# Étape 1 : Build de l'app React
FROM node:22-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Étape 2 : Serveur Web léger (Nginx)
FROM nginx:alpine
# Copie le dossier 'dist' ou 'build' (selon ta version de Vite/Create-React-App)
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]