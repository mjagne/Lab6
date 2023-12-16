#Step 1 (Build):
# Use the Node base image for building React app
FROM node:13.12.0-alpine as build

# Set the working directory
WORKDIR /app

# Add node_modules to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# Install React app dependencies
COPY package.json ./
COPY package-lock.json ./
RUN npm ci --silent
RUN npm install react-scripts@3.4.1 --silent

# Copy application files
COPY . ./

# Build the React application
RUN npm run build

# Step 2 (Run):
# Use Nginx image for runtime
FROM nginx:stable-alpine

# Copy the React build folder from the build stage to nginx server folder
COPY --from=build /app/build /usr/share/nginx/html

# Expose server at port 80
EXPOSE 80

# Start nginx and keep it in the foreground
CMD ["nginx", "-g", "daemon off;"]
