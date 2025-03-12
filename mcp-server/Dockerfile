FROM node:18-alpine

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy server code
COPY . .

# Expose port 9090
EXPOSE 9090

# Run the server
CMD ["node", "server.js"]