# Step 1: Build Stage
FROM node:18-alpine AS builder

# Set working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all files to the working directory
COPY . .

# Build the application for production (Vite will generate files in the `dist` folder)
RUN npm run build

# Step 2: Serve Stage
FROM nginx:alpine

# Copy the built files from the builder stage to Nginx's default web root
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy custom NGINX configuration
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 for the Nginx server
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]

