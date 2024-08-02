#!/bin/bash

echo "Starting WordPress setup script..."

# Wait for the MariaDB service to be available
echo "Checking MariaDB connection..."
until mysql -hmariadb -u${WORDPRESS_DB_USER} -p${WORDPRESS_DB_PASSWORD} -e "show databases;" > /dev/null 2>&1; do
    echo "Waiting for MariaDB to be ready..."
    sleep 2
done

echo "MariaDB is ready!"

# Run WP-CLI to set up WordPress
cd /var/www/html

# Download WordPress if not present
if [ ! -f /var/www/html/wp-load.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root
else
    echo "WordPress already downloaded."
fi

# Create wp-config.php if not present
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Creating wp-config.php..."
    wp config create --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD --dbhost=$WORDPRESS_DB_HOST --allow-root

else
    echo "wp-config.php already exists."
fi

# Check if WordPress is already installed
if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    wp core install --url="https://$DOMAIN_NAME" --title="rjeong's WordPress" --admin_user="$WORDPRESS_ADMIN_USER" --admin_password="$WORDPRESS_ADMIN_PASSWORD" --admin_email="$WORDPRESS_ADMIN_EMAIL" --skip-email --allow-root

    # Update general settings
    wp option update blogdescription "rjeong's Inception" --allow-root

    wp option update timezone_string "Asia/Seoul" --allow-root

    # Create a sample post
    wp post create --post_title="Hi, I'm rjeong" --post_content='This is a sample post. when this wordpress' --post_status=publish --allow-root

    # Allow comments on the sample post
    wp post meta add 1 _comments_open 1 --allow-root
else
    echo "WordPress is already installed."
fi

echo "WordPress setup completed!"

# Start PHP-FPM in the foreground
exec php-fpm7.4 -F
