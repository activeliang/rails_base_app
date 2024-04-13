update_nginx_conf() {
    # Define directories and files
    echo "start update nginx func"
    SOCK_DIR=/tmp/sockets/my_app
    NGINX_CONF=/etc/nginx/conf.d/my_app.conf

    # Find all active sockets in SOCK_DIR
    sleep 1
    SOCK_FILES=$(find $SOCK_DIR -type s -printf '%f\n' | grep -v '\.old$' | sort)

    # Check each socket for connectivity and remove inactive ones
    ACTIVE_SOCK_FILES=()
    for sock_file in $SOCK_FILES; do
        echo "check file:  $SOCK_DIR/$sock_file"
        if socat -u OPEN:/dev/null UNIX-CONNECT:"$SOCK_DIR/$sock_file"; then
            echo "valid sock file: $sock_file"
            ACTIVE_SOCK_FILES+=("$SOCK_DIR/$sock_file")
        else
            echo "Socket $SOCK_DIR/$sock_file is not active. Removing it."
            rm -f "$SOCK_DIR/$sock_file"
        fi
    done

    echo "ACTIVE_SOCK_FILES: $ACTIVE_SOCK_FILES"

    # Exit if no active sockets are found
    if [ ${#ACTIVE_SOCK_FILES[@]} -eq 0 ]; then
        echo "No active sockets found."
        exit 0
    fi

    # Generate the proxy_pass configuration line
    echo "upstream my_app_upstream {" > /tmp/my_app_upstream.conf
    for sock_file in ${ACTIVE_SOCK_FILES[@]}; do
        echo "    server unix:$sock_file;" >> /tmp/my_app_upstream.conf
    done
    echo "}" >> /tmp/my_app_upstream.conf

    # Append the nginx configuration file
    cat /home/deploy/my_app/.docker/nginx.conf >> /tmp/my_app_upstream.conf

    # Replace the existing NGINX configuration file with the new one
    mv /tmp/my_app_upstream.conf $NGINX_CONF

    # Check if Nginx is active and reload or start it accordingly
    nginx_status=$(systemctl is-active nginx)
    if [ "${nginx_status}" == "active" ]; then
        systemctl reload nginx
    else
        systemctl start nginx
    fi
}
