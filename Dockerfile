# Use the official NGINX base image
FROM nginx:latest

# Copy website content to the NGINX html directory
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80 for the container
EXPOSE 80

# Default command (run NGINX)
CMD ["nginx", "-g", "daemon off;"]
