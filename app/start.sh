#!/bin/bash

# 启动 cron 服务
service cron start
echo "[*] Cron 定时服务已启动"

# 运行官方的 CtYun.dll
exec dotnet CtYun.dll
