# Use the official Node.js image.
FROM node:16

# Set the working directory.
WORKDIR /app

# Copy package files and set network config.
COPY package*.json ./
RUN npm config set strict-ssl false && npm config set loglevel verbose && npm cache clean --force

# Install dependencies.
RUN npm install

# Copy the rest of the application code.
COPY . .

# Build the application.
RUN npm run build

# Expose the port that the app runs on.
EXPOSE 9000

# Start the Medusa server.
CMD ["npm", "run", "start"]
