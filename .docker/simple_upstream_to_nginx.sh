update_nginx_conf() {
    # Define directories and files
    SOCK_DIR=/tmp/sockets/myapp
    NGINX_CONF=/etc/nginx/conf.d/myapp.conf

    # Find all active sockets in SOCK_DIR
    sleep 1
    SOCK_FILES=$(find $SOCK_DIR -type s -printf '%f\n' | grep -v '\.old$' | sort)

    # Check each socket for connectivity and remove inactive ones
    ACTIVE_SOCK_FILES=()
    for sock_file in $SOCK_FILES; do
        if nc -zU $SOCK_DIR/$sock_file; then
            ACTIVE_SOCK_FILES+=("$SOCK_DIR/$sock_file")
        else
            echo "Socket $SOCK_DIR/$sock_file is not active. Removing it."
            rm -f $SOCK_DIR/$sock_file
        fi
    done

    # Exit if no active sockets are found
    if [ ${#ACTIVE_SOCK_FILES[@]} -eq 0 ]; then
        echo "No active sockets found."
        exit 0
    fi

    # Generate the proxy_pass configuration line
    echo "upstream myapp_upstream {" > /tmp/myapp_upstream.conf
    for sock_file in ${ACTIVE_SOCK_FILES[@]}; do
        echo "    server unix:$sock_file;" >> /tmp/myapp_upstream.conf
    done
    echo "}" >> /tmp/myapp_upstream.conf

    # Append the nginx configuration file
    cat /home/deploy/myapp/.docker/nginx.conf >> /tmp/myapp_upstream.conf

    # Replace the existing NGINX configuration file with the new one
    mv /tmp/myapp_upstream.conf $NGINX_CONF

    # Check if Nginx is active and reload or start it accordingly
    nginx_status=$(systemctl is-active nginx)
    if [ "${nginx_status}" == "active" ]; then
        systemctl reload nginx
    else
        systemctl start nginx
    fi
}
