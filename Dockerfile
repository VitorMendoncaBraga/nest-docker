# Busca uma imagem base para começar a trabalhar no ambiente
FROM node:25.2.1-alpine3.23 as build

# Diretório que quero rodar a aplicação no linux
WORKDIR /usr/src/app

# Copiar o arquivo package.json para dentro do container para funcionar a aplicação
COPY package.json package-lock.json ./

# Instalar as dependências de prod
RUN npm install

# Copiar todos os arquivos para o container
COPY . .

# Build do servidor
RUN npm run build

# Stage 2: run time

FROM node:25.2.1-alpine3.23

WORKDIR /usr/src/app

COPY package.json package-lock.json ./
RUN npm ci --omit=dev

COPY --from=build /usr/src/app/dist ./dist

EXPOSE 3000

CMD [ "npm", "run", "start:prod" ]