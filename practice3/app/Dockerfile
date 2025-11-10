FROM alpine

# Install bash, MariaDB client (for MySQL commands) and ping
RUN apk add --no-cache bash mariadb-client iputils

# Copy the script
COPY app.sh /app.sh
RUN chmod +x /app.sh

CMD ["bash", "/app.sh"]

