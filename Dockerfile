# ----------------------------------------------------
# Single Stage: Production/Runtime Stage
# ----------------------------------------------------
# Use a lightweight Nginx image to serve the static content
FROM nginx:alpine

# The Nginx Configuration file references this location.
# Copy the custom Nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# *** CRITICAL FIX: Ensure index.html is copied from the build context ***
# Copy the static HTML file from the repository root into the Nginx public directory
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80 (standard HTTP port)
EXPOSE 80

# The default Nginx CMD runs the server
CMD ["nginx", "-g", "daemon off;"]
