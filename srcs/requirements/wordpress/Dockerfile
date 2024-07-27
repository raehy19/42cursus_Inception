# Use the penultimate stable version of Debian
FROM debian:bullseye

# Install PHP, PHP extensions, and other dependencies
RUN apt-get update && \
    apt-get install -y php7.4 php7.4-fpm php7.4-mysql curl wget less vim

# Create the /var/www/html directory
RUN mkdir -p /var/www/html

# Download and extract WordPress
RUN curl -O https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    rm latest.tar.gz && \
    mv wordpress/* /var/www/html && \
    rm -rf wordpress

# Copy custom wp-config.php file
COPY conf/wp-config.php /var/www/html/wp-config.php

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Command to run PHP-FPM
CMD ["php-fpm7.4", "-F"]
