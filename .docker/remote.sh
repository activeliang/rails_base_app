#!/bin/bash

target_host=89.185.31.111

proxy_command=(-o ProxyCommand="nc -X 5 -x 127.0.0.1:7890 %h %p")

function_a() {
    echo "执行函数 A"
    # 在这里添加函数 A 的具体实现
    ssh "${proxy_command[@]}" -tt root@$target_host "container_index=\$(docker ps -a --format '{{.Names}}' | awk '/my_app-web-/{print}' | sort -V | tail -n 1 | grep -oE '[0-9]+$'); docker-compose -f /home/deploy/my_app/docker-compose.yml exec --index=\$container_index web rails c"
}

function_b() {
    echo "执行函数 B，参数: $1"
    # 在这里添加函数 B 的具体实现
    ssh "${proxy_command[@]}" root@$target_host tail -n $1 /var/log/my_app/production.log
}

function_c() {
    echo "执行函数 C"
    # 在这里添加函数 C 的具体实现
    ssh "${proxy_command[@]}" root@$target_host tail -f /var/log/my_app/production.log
}

function_d() {
    echo "执行函数 D"
    ssh "${proxy_command[@]}" -tt root@$target_host "container_index=\$(docker ps -a --format '{{.Names}}' | awk '/-web-/{print}' | sort -V | tail -n 1 | grep -oE '[0-9]+$'); docker-compose -f /home/deploy/my_app/docker-compose.yml exec --index=\$container_index web sh"
}

function_e() {
    echo "执行函数 E"
    ssh "${proxy_command[@]}" -tt root@$target_host "cd /home/deploy/my_app && exec bash"
}

if [ "$#" -eq 0 ]; then
    echo "用法: $0 <console | tail [-n <number>]>"
    exit 1
fi

case $1 in
    console)
        function_a
        ;;
    tail)
        if [ "$2" == "-n" ] && [[ "$3" =~ ^[0-9]+$ ]]; then
            function_b "$3"
        else
            function_c
        fi
        ;;
    sh)
        function_d
        ;;
    bash)
        function_e
        ;;
    *)
        echo "错误: 未知参数 '$1'"
        echo "用法: $0 <console | tail [-n <number>]>"
        exit 1
        ;;
esac
