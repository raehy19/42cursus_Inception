# Use the penultimate stable version of Debian
FROM debian:bullseye

# Install Tini and MariaDB
RUN apt-get update && apt-get install -y --no-install-recommends \
    tini mariadb-server && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy custom configuration file
COPY conf/my.cnf /etc/mysql/my.cnf

# Copy the initialization script
COPY conf/init-db.sh /usr/local/bin/init-db.sh
RUN chmod +x /usr/local/bin/init-db.sh

# Expose the default MariaDB port
EXPOSE 3306

# Use Tini as the init system
ENTRYPOINT ["/usr/bin/tini", "--"]

# Command to run the initialization script
CMD ["/usr/local/bin/init-db.sh"]
