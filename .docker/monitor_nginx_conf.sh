#!/bin/bash

# Define monitored directory and script to execute
MONITOR_DIR="/tmp/sockets/myapp"
EXECUTE_SCRIPT="/home/deploy/myapp/.docker/simple_upstream_to_nginx.sh"

# Create required directories if not exists
mkdir -p "$MONITOR_DIR"

# Make the script executable
chmod +x "$EXECUTE_SCRIPT"

# Monitor the directory using inotifywait and execute the script when a new file is created
while inotifywait -q -e create --format '%w%f' "$MONITOR_DIR"; do
    # Execute the script when a new file is detected
    source "$EXECUTE_SCRIPT"
    update_nginx_conf
done

