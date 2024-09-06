# syntax = docker/dockerfile:1

# Use a specific version of Node.js
ARG NODE_VERSION=18.18.0
FROM node:${NODE_VERSION}-slim as base

LABEL fly_launch_runtime="Node.js"

# Set the working directory
WORKDIR /app

# Set production environment
ENV NODE_ENV="production"
ARG YARN_VERSION=1.22.19
RUN npm install -g yarn@$YARN_VERSION --force

# Stage to install dependencies and build the application
FROM base as build

# Install dependencies needed to build node modules
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential node-gyp pkg-config python-is-python3

# Copy application files
COPY --link .yarnrc.yml package.json yarn.lock ./
RUN yarn install --frozen-lockfile --production=false

# Copy the remaining application code
COPY --link . .

# Build the application
RUN yarn run build

# Remove development dependencies
RUN yarn install --production=true

# Final stage to build the application image
FROM base

# Copy the built application
COPY --from=build /app /app

# Expose the port and define the command to run the application
EXPOSE 9000
CMD [ "yarn", "start" ]
