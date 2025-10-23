# ----------------------------------------------------
# Stage 1: Build Stage (Not strictly needed for static HTML,
# but good practice for multi-stage builds)
# ----------------------------------------------------
# We use a scratch image since we are just copying files in the final stage
FROM scratch as build

# Copy the static HTML file into the build context
COPY index.html /usr/src/app/index.html
COPY nginx.conf /usr/src/app/nginx.conf


# ----------------------------------------------------
# Stage 2: Production/Runtime Stage
# ----------------------------------------------------
# Use a lightweight Nginx image to serve the static content
FROM nginx:alpine

# Copy the custom Nginx configuration file
# This is crucial for telling Nginx how to serve the files
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the static assets from the build stage to the Nginx public directory
# The Nginx configuration file references this location.
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80 (standard HTTP port)
EXPOSE 80

# The default Nginx CMD runs the server
CMD ["nginx", "-g", "daemon off;"]
