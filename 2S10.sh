#!/bin/bash

# 介绍信息
{
    echo -e "\e[92m" 
    echo "通往电脑的路不止一条，所有的信息都应该是免费的，打破电脑特权，在电脑上创造艺术和美，计算机将使生活更美好。"
    echo "    ______                   _____               _____         "
    echo "    ___  /_ _____  ____________  /______ ___________(_)______ _"
    echo "    __  __ \\__  / / /__  ___/_  __/_  _ \\__  ___/__  / _  __ \`/"
    echo "    _  / / /_  /_/ / _(__  ) / /_  /  __/_  /    _  /  / /_/ / "
    echo "    /_/ /_/ _\\__, /  /____/  \\__/  \\___/ /_/     /_/   \\__,_/  "
    echo "            /____/                                              "
    echo "缝合怪：天诚 原作者们：cmliu RealNeoMan、k0baya、eooce"
    echo -e "\e[0m"  
}

# 变量定义
SERVER_PORT=32710
PASSWORD="8866bae1-1167-4be9-a2b8-72e572a006ae"
HYSTERIA_DIR="/usr/home/hysteria"

# 创建必要的目录
mkdir -p $HYSTERIA_DIR

# 下载 Hysteria2 二进制文件
ARCH=$(uname -m)
if [[ "$ARCH" == "arm" || "$ARCH" == "arm64" || "$ARCH" == "aarch64" ]]; then
    FILE_INFO=("https://download.hysteria.network/app/latest/hysteria-freebsd-arm64 web" "https://github.com/eooce/test/releases/download/ARM/swith npm")
  elif [[ "$ARCH" == "amd64" || "$ARCH" == "x86_64" || "$ARCH" == "x86" ]]; then
    FILE_INFO=("https://download.hysteria.network/app/latest/hysteria-freebsd-amd64 web" "https://github.com/eooce/test/releases/download/freebsd/swith npm")
else
    echo "不支持的系统架构: $ARCH"
    exit 1
fi

curl -L -o $HYSTERIA_DIR/hysteria $DOWNLOAD_URL
chmod +x $HYSTERIA_DIR/hysteria

# 生成 TLS 证书和密钥
openssl req -x509 -nodes -newkey ec:<(openssl ecparam -name prime256v1) \
    -keyout $HYSTERIA_DIR/server.key -out $HYSTERIA_DIR/server.crt \
    -subj "/CN=example.com" -days 3650

# 创建 Hysteria2 配置文件
cat << EOF > $HYSTERIA_DIR/config.yaml
listen: :$SERVER_PORT

tls:
  cert: $HYSTERIA_DIR/server.crt
  key: $HYSTERIA_DIR/server.key

auth:
  type: password
  password: "$PASSWORD"

fastOpen: true

masquerade:
  type: proxy
  proxy:
    url: https://www.bing.com
    rewriteHost: true

transport:
  udp:
    hopInterval: 30s
EOF

# 启动 Hysteria2 服务
nohup $HYSTERIA_DIR/hysteria server -c $HYSTERIA_DIR/config.yaml >/dev/null 2>&1 &

echo "Hysteria2 安装完成并已启动"
echo "配置文件路径: $HYSTERIA_DIR/config.yaml"
