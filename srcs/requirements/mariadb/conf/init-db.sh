#!/bin/sh

# Ensure necessary environment variables are set
: "${DB_NAME:?Need to set DB_NAME}"
: "${DB_USER:?Need to set DB_USER}"
: "${DB_PWD:?Need to set DB_PWD}"
: "${DB_ROOT_PWD:?Need to set DB_ROOT_PWD}"

# Run only if the MySQL database is being initialized for the first time
if [ ! -d "/var/lib/mysql/$DB_NAME" ]; then

    # Initialize the MySQL data directory
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Start the MariaDB server without networking to perform the initial setup
    mysqld_safe --skip-networking &

    # Wait for the MariaDB server to start
    while ! mysqladmin ping --silent; do
        echo 'Waiting for MariaDB to start...'
        sleep 1
    done

    # Create the database if it doesn't exist
    mysql -uroot -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"
    # Create the user if it doesn't exist, with the specified password
    mysql -uroot -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PWD';"
    # Grant all privileges on the database to the user
    mysql -uroot -e "GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%' WITH GRANT OPTION;"
    # Change the root user's password
    mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PWD';"
    # Flush privileges to apply changes
    mysql -uroot -e "FLUSH PRIVILEGES;"

    # Shutdown the server to apply settings
    mysqladmin -uroot -p$DB_ROOT_PWD shutdown

fi

# Run the mysqld server in the foreground
exec mysqld_safe
