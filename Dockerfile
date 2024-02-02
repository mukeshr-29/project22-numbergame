# Stage 1: Build the application
FROM node:16-alpine AS build

WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

RUN npm install

# Copy the application source code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Create the production image
FROM node:16-alpine AS production

WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=build /app /app

# Expose the port
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]

