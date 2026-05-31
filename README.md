# 天翼云电脑保活并完成每日任务获取积分

本项目用于在 Docker 容器中保活云电脑使其长期开机，保活不会中断使用，并自动完成积分任务，每天可获取300积分。

## 快速部署（推荐）

```bash
git clone https://github.com/lovegongqi/ctyun-auto.git
cd ctyun-auto/
bash quick-start.sh 手机号 密码
```

示例：
```bash
bash quick-start.sh 18170890791 Gq360304437.
```

**流程**：首次验证设备 → 自动构建镜像 → 启动后台守护容器

---

## 功能列表

| 功能 | 说明 |
|------|------|
| **保活** | 24小时自动重连云电脑，防止掉线 |
| **AI对话** | 每日3:00、20:00自动执行AI对话积分任务 |
| **挂机任务** | 每日4:00、6:00自动执行云电脑挂机任务 |
| **自动兑换** | 可选自动兑换积分奖励 |

---

## 常用命令

```bash
# 查看日志
docker logs -f ctyun_手机号

# 停止/启动容器
docker stop ctyun_手机号
docker start ctyun_手机号

# 查看定时任务
docker exec ctyun_手机号 crontab -l

# 配置自动兑换
docker exec -it ctyun_手机号 python3 /app/pc_login.py --config-redeem

# 手动执行积分任务
docker exec ctyun_手机号 python3 /app/login_script.py      # AI对话
docker exec ctyun_手机号 python3 /app/pc_login.py          # 挂机任务
```

---

## 来源说明

本项目中使用的保活程序来自 `CtYun` 项目：https://github.com/leleji/CtYun

当前仓库通过基础镜像 `su3817807/ctyun:latest` 使用该程序（容器内运行 `dotnet CtYun.dll`），本仓库主要补充了定时执行积分任务的能力和增加了24小时重启保活程序。

## 项目结构

```text
.
├─ quick-start.sh         # 快速部署脚本（推荐）
├─ deploy.sh              # 交互式部署脚本
├─ deploy_cron.sh         # 带 cron 参数的部署脚本
└─ app/
   ├─ Dockerfile          # 运行环境构建与 cron 任务配置
   ├─ entrypoint.sh       # 容器入口：启动 cron + 保活循环运行 CtYun.dll
   ├─ login_script.py      # AI对话积分任务脚本
   └─ pc_login.py          # 云电脑挂机任务 + 自动兑换脚本
```

验证码识别方案来自 https://github.com/sml2h3/ddddocr
