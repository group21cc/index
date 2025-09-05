FROM nginx:alpine

# Copy HTML file to nginx default directory
COPY index.html /usr/share/nginx/html/index.html

# Expose ports 80, 443, and 8080
EXPOSE 80 443 8080

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
