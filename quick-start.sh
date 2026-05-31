#!/bin/bash
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

usage() {
    cat << EOF
${GREEN}天翼云电脑保活自动化 - 快速部署${NC}

用法:
    $0 <账号> <密码>

示例:
    $0 手机号 密码

功能:
    - 保活：24小时自动重连云电脑
    - 积分任务：AI对话 + 云电脑挂机
    - 自动兑换：可选自动兑换积分奖励
    - 定时任务：每日自动执行

常用命令:
    docker logs -f ctyun_账号      查看日志
    docker stop ctyun_账号         停止
    docker start ctyun_账号        启动
EOF
}

if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    usage
    exit 0
fi

if ! command -v docker > /dev/null 2>&1; then
    echo -e "${RED}[!] 错误: 未安装 Docker${NC}"
    exit 1
fi

# 检查是否在项目目录
if [ ! -f "app/entrypoint.sh" ] || [ ! -f "app/login_script.py" ] || [ ! -f "app/pc_login.py" ]; then
    echo -e "${RED}[!] 错误: 请在项目目录运行此脚本${NC}"
    echo -e "    git clone https://github.com/lovegongqi/ctyun-auto.git"
    echo -e "    cd ctyun-auto"
    exit 1
fi

APP_USER="$1"
APP_PASSWORD="$2"
DATA_DIR="${HOME}/data"
CONTAINER_NAME="ctyun_${APP_USER}"
IMAGE_NAME="ctyun-auto:v1"

if [ -z "$APP_PASSWORD" ]; then
    echo -e "${RED}[!] 密码不能为空${NC}"
    exit 1
fi

echo -e "${GREEN}=== 天翼云电脑保活自动化快速部署 ===${NC}\n"

# 1. 检查是否已验证过
if [ -f "${DATA_DIR}/.devicecode_${APP_USER}" ]; then
    echo -e "${GREEN}[*] 检测到已保存的设备码，跳过验证${NC}"
    VERIFIED=true
else
    echo -e "${YELLOW}[!] 首次运行，需要验证设备${NC}"
    VERIFIED=false
fi

# 2. 创建数据目录
mkdir -p "$DATA_DIR"

# 3. 如果未验证，先验证
if [ "$VERIFIED" = false ]; then
    echo -e "\n======================================================="
    echo -e "${YELLOW}[1/3] 设备验证阶段${NC}"
    echo -e "======================================================="
    echo -e "请在短信到达后输入验证码，按回车确认\n"
    
    docker run --rm -it \
        -e APP_USER="$APP_USER" \
        -e APP_PASSWORD="$APP_PASSWORD" \
        -e TZ=Asia/Shanghai \
        -v "$DATA_DIR":/app/data \
        --add-host "deskcdn.ctyun.cn:106.120.187.154" \
        --add-host "deskcdn.ctyun.cn.ctadns.cn:106.120.187.154" \
        su3817807/ctyun:latest dotnet CtYun.dll
    
    if [ -f "${DATA_DIR}/.devicecode_${APP_USER}" ]; then
        echo -e "\n${GREEN}[*] 设备验证成功!${NC}"
    else
        echo -e "\n${RED}[!] 验证未成功，请检查后重试${NC}"
        exit 1
    fi
fi

# 4. 构建自定义镜像（包含积分任务脚本）
echo -e "\n======================================================="
echo -e "${YELLOW}[2/3] 构建自定义镜像${NC}"
echo -e "======================================================="

docker build -q -t "$IMAGE_NAME" ./app

# 5. 启动后台守护容器
echo -e "\n======================================================="
echo -e "${YELLOW}[3/3] 启动后台守护容器${NC}"
echo -e "======================================================="

# 删除旧容器（如果存在）
docker rm -f "$CONTAINER_NAME" 2>/dev/null || true

# 启动后台容器
docker run -d \
    --name "$CONTAINER_NAME" \
    -e APP_USER="$APP_USER" \
    -e APP_PASSWORD="$APP_PASSWORD" \
    -e TZ=Asia/Shanghai \
    -v "$DATA_DIR":/app/data \
    --add-host "deskcdn.ctyun.cn:106.120.187.154" \
    --add-host "deskcdn.ctyun.cn.ctadns.cn:106.120.187.154" \
    --restart unless-stopped \
    "$IMAGE_NAME"

echo -e "\n${GREEN}[*] 部署成功!${NC}\n"
echo -e "容器名: ${CONTAINER_NAME}"
echo -e "数据目录: ${DATA_DIR}"
echo -e ""
echo -e "${YELLOW}常用命令:${NC}"
echo -e "  docker logs -f ${CONTAINER_NAME}   查看日志"
echo -e "  docker stop ${CONTAINER_NAME}      停止"
echo -e "  docker start ${CONTAINER_NAME}     启动"
echo -e ""
echo -e "${YELLOW}定时任务:${NC}"
echo -e "  03:00、20:00  AI对话积分任务"
echo -e "  04:00、06:00  云电脑挂机任务"
echo -e ""
echo -e "${YELLOW}配置自动兑换:${NC}"
echo -e "  docker exec -it ${CONTAINER_NAME} python3 /app/pc_login.py --config-redeem"
