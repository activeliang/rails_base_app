cat >/etc/nginx/conf.d/wxdev.conf<<EOF
server {
    listen 80;
    server_name wxdev.hongliang.fun;
    location / {
       proxy_set_header  Host               \$host;
       proxy_set_header  X-Forwarded-Host   \$host;
       proxy_set_header  X-Forwarded-Server \$host;
       proxy_set_header  X-Real-IP          \$remote_addr;
       proxy_set_header  X-Forwarded-For    \$proxy_add_x_forwarded_for;
       proxy_buffering                      on;
       proxy_pass                           http://localhost:8180;
   }
}
EOF
service nginx force-reload

ssh root@wxdev.hongliang.fun "kill -9 \$(lsof -i tcp:8180 -t)"; ssh root@wxdev.hongliang.fun -N -R 8180:0.0.0.0:3000