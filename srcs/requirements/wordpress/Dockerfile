# Use the penultimate stable version of Debian
FROM debian:bullseye

# Install Tini, PHP, PHP extensions, and other dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends tini php7.4 php7.4-fpm php7.4-mysql curl wget less vim ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create necessary directories
RUN mkdir -p /var/www/html /run/php

# Download and extract WordPress directly into the target directory
RUN curl -o latest.tar.gz https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz -C /var/www/html --strip-components=1 && \
    rm latest.tar.gz

# Copy custom wp-config.php file
COPY conf/wp-config.php /var/www/html/wp-config.php

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Modify php-fpm configuration to listen on port 9000
RUN sed -i 's/\/run\/php\/php7.4-fpm.sock/0.0.0.0:9000/g' /etc/php/7.4/fpm/pool.d/www.conf

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Use Tini as the init system
ENTRYPOINT ["/usr/bin/tini", "--"]

# Command to run PHP-FPM
CMD ["php-fpm7.4", "-F"]
