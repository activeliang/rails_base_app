#! /bin/bash

cat >/etc/systemd/system/myapp_sock_monitor.service<<EOF
[Unit]
Description=execution of monitor script for rails app sock file

[Service]
Type=simple
User=root
ExecStart=/home/deploy/myapp/.docker/monitor_nginx_conf.sh

Restart=always

[Install]
WantedBy=multi-user.target
EOF

chmod 644 /etc/systemd/system/myapp_sock_monitor.service
systemctl daemon-reload
systemctl reenable /etc/systemd/system/myapp_sock_monitor.service
systemctl restart myapp_sock_monitor.service