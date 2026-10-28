# Imagen base Node.js Alpine
FROM node:22-alpine

# Directorio de trabajo
WORKDIR /usr/src

# Copiar manifiesto de dependencias e instalar
COPY package*.json ./
RUN npm install

# Copiar código de la API
COPY . .

# Puerto de la API
EXPOSE 3002

CMD [ "npm", "start" ]
