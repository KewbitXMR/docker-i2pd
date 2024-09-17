FROM alpine:latest
LABEL maintainer="kewbitxmr@protonmail.com"

# Install i2pd and its dependencies
RUN apk update && \
    apk add --no-cache i2pd

# Create a non-root user and set permissions for i2pd
RUN addgroup -S i2pd && adduser -S -G i2pd i2pd && \
    mkdir -p /etc/i2pd /var/lib/i2pd && \
    chown -R i2pd:i2pd /etc/i2pd /var/lib/i2pd

# Copy the configuration files into the container
COPY i2pd.conf /etc/i2pd/i2pd.conf
COPY tunnels.conf /etc/i2pd/tunnels.conf
COPY subscriptions.txt /etc/i2pd/subscriptions.txt

# Change ownership of the configuration files
RUN chown i2pd:i2pd /etc/i2pd/i2pd.conf /etc/i2pd/tunnels.conf /etc/i2pd/subscriptions.txt

# Set permissions for i2pd directories
RUN chmod 750 /etc/i2pd && \
    chmod 640 /etc/i2pd/* && \
    chmod 750 /var/lib/i2pd

# Expose necessary ports
EXPOSE 4444 4447 7070 9439

# Switch to the non-root user
USER i2pd

# Define the entrypoint to start i2pd
ENTRYPOINT ["/usr/sbin/i2pd", "--conf", "/etc/i2pd/i2pd.conf"]