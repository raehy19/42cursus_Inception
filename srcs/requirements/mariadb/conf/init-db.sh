#!/bin/sh

echo "Starting the initialization script..."

# Ensure necessary environment variables are set
: "${DB_NAME:?Need to set DB_NAME}"
: "${DB_USER:?Need to set DB_USER}"
: "${DB_PWD:?Need to set DB_PWD}"
: "${DB_ROOT_PWD:?Need to set DB_ROOT_PWD}"

echo "Environment variables are set."

# Run only if the MySQL database is being initialized for the first time
if [ ! -d "/var/lib/mysql/$DB_NAME" ]; then
    echo "Database not found, initializing the MySQL data directory..."

    # Initialize the MySQL data directory
    mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql

    echo "Data directory initialized."

    # Start the MariaDB server without networking to perform the initial setup
    mysqld_safe --skip-networking &

    echo "Starting MariaDB server without networking..."

    # Wait for the MariaDB server to start
    while ! mysqladmin ping --silent; do
        echo 'Waiting for MariaDB to start...'
        sleep 1
    done

    echo "MariaDB started. Setting up the database..."

    # Create the database if it doesn't exist
    mysql -uroot -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"
    echo "Database $DB_NAME created."

    # Create the user if it doesn't exist, with the specified password
    mysql -uroot -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PWD';"
    echo "User $DB_USER created."

    # Grant all privileges on the database to the user
    mysql -uroot -e "GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%' WITH GRANT OPTION;"
    echo "Privileges granted to $DB_USER."

    # Change the root user's password
    mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PWD';"
    echo "Root password set."

    # Flush privileges to apply changes
    mysql -uroot -p$DB_ROOT_PWD -e "FLUSH PRIVILEGES;"
    echo "Privileges flushed."

    # Shutdown the server to apply settings
    mysqladmin -uroot -p$DB_ROOT_PWD shutdown
    echo "MariaDB server shut down to apply settings."

else
    echo "Database already exists. Skipping initialization."
fi

# Run the mysqld server in the foreground
echo "Starting MariaDB server in the foreground..."
exec mysqld_safe
