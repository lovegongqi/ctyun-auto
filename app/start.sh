#!/bin/bash

# 设置环境变量供 cron 任务使用
export APP_USER="${APP_USER:-}"
export APP_PASSWORD="${APP_PASSWORD:-}"
export RUNNING_IN_DOCKER="true"
export TZ="Asia/Shanghai"

# 启动 cron 服务
crond start
echo "[*] Cron 定时服务已启动"
echo "[*] 定时任务: 03:00、20:00 AI对话 | 04:00、06:00 挂机"

# 运行官方的 CtYun.dll
exec dotnet CtYun.dll
