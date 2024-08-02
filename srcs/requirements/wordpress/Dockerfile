# Use the penultimate stable version of Debian
FROM debian:bullseye

# Install Tini, PHP, PHP extensions, and other dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends tini php7.4 php7.4-fpm php7.4-mysql curl wget less vim ca-certificates mariadb-client && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create necessary directories
RUN mkdir -p /var/www/html /run/php

# Install WordPress CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x ./wp-cli.phar && \
    mv wp-cli.phar /usr/bin/wp && \
    wp cli update

# Copy the initialization script
COPY conf/init-wp.sh /usr/local/bin/init-wp.sh

# Make the initialization script executable
RUN chmod +x /usr/local/bin/init-wp.sh

# Modify php-fpm configuration to listen on port 9000
RUN sed -i 's/\/run\/php\/php7.4-fpm.sock/0.0.0.0:9000/g' /etc/php/7.4/fpm/pool.d/www.conf

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Use Tini as the init system
ENTRYPOINT ["/usr/bin/tini", "--"]

# Command to run the initialization script
CMD ["/usr/local/bin/init-wp.sh"]
