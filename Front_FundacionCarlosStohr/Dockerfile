# Imagen base Node.js Alpine
FROM node:22-alpine

# Directorio de trabajo
WORKDIR /app

# Copiar manifiesto de dependencias e instalar
COPY package*.json ./
RUN npm install

# Copiar código del cliente
COPY . .

# Puerto del servidor estático
EXPOSE 3001

CMD ["npm", "start"]
