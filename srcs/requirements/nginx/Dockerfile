# Use the penultimate stable version of Debian
FROM debian:bullseye

# Install Tini, NGINX, and OpenSSL for TLS
RUN apt-get update && \
    apt-get install -y --no-install-recommends tini nginx openssl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Remove default server definition
RUN rm /etc/nginx/sites-enabled/default

# Create directories for SSL certificates and NGINX configuration
RUN mkdir -p /etc/nginx/ssl /etc/nginx/conf.d

# Generate SSL certificate and key
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=rjeong/CN=rjeong.42.fr/emailAddress=rjeong@student.42seoul.kr"

# Copy custom nginx configuration file
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Expose port 443 for HTTPS
EXPOSE 443

# Use Tini as the init system
ENTRYPOINT ["/usr/bin/tini", "--"]

# Command to run NGINX
CMD ["nginx", "-g", "daemon off;"]
