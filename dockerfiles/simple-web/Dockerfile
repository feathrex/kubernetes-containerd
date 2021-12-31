# Specify Base Image
FROM node:alpine

# Change working directory
WORKDIR /opt/app

# COPY package.json /opt/app.
COPY ./package.json ./

# Install some dependencies
RUN npm install

COPY ./ ./

# Default command
CMD ["npm", "start"]
