# 天翼云电脑保活并完成每日任务获取积分

本项目用于在 Docker 容器中保活云电脑使其长期开机，保活不会中断使用，并自动完成积分任务，每天可获取300积分。

## 快速部署（推荐）

一行命令搞定：

```bash
git clone https://github.com/lovegongqi/ctyun-auto.git
cd ctyun-auto/
bash quick-start.sh 手机号 密码
```

示例：
```bash
bash quick-start.sh 手机号 密码
```

**流程**：首次验证设备（输入短信验证码）→ 自动启动后台守护容器

---

## 部署方式对比

| 方式 | 命令 | 特点 |
|------|------|------|
| **快速部署** | `bash quick-start.sh 手机号 密码` | 无需构建镜像，一行搞定 |
| 交互式部署 | `bash deploy.sh` | 引导式，需要手动确认 |

---

## 常用命令

```bash
# 查看日志
docker logs -f ctyun_手机号

# 停止/启动容器
docker stop ctyun_手机号
docker start ctyun_手机号

# 重新部署
bash quick-start.sh 手机号 密码
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
