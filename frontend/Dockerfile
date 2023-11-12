# Étape de construction
# Utilisez une image Node.js officielle comme image de base
FROM node:latest as build-stage

# Définissez le répertoire de travail à l'intérieur du conteneur
WORKDIR /app

# Copiez package.json et package-lock.json en premier pour optimiser la mise en cache Docker
COPY package*.json ./

# Installez les dépendances
RUN npm install

# Copiez le reste des fichiers de l'application dans le conteneur
COPY . .

# Construisez l'application pour la production
RUN npm run build

# Étape de déploiement avec NGINX
# Utilisez l'image NGINX officielle
FROM nginx:stable-alpine as production-stage

# Copiez les fichiers de production du stage de construction
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Copiez votre fichier de configuration NGINX personnalisé (si nécessaire)
COPY nginx.conf /etc/nginx/nginx.conf

# Exposez le port 80 pour NGINX
EXPOSE 80

# Lorsque le conteneur démarre, NGINX démarre également
CMD ["nginx", "-g", "daemon off;"]
