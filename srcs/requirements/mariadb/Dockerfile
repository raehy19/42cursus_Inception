# Use the penultimate stable version of Debian
FROM debian:bullseye

# Install MariaDB
RUN apt-get update && \
    apt-get install -y mariadb-server

# Copy custom configuration file
COPY conf/my.cnf /etc/mysql/my.cnf

# Expose the default MariaDB port
EXPOSE 3306

# Command to run MariaDB
CMD ["mysqld"]
