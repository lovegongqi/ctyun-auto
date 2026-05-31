# 天翼云电脑保活自动化

本项目用于在 Docker 容器中保活云电脑、自动完成每日积分任务（每天约300积分）。

## 一键部署

```bash
git clone https://github.com/lovegongqi/ctyun-auto.git
cd ctyun-auto/
bash quick-start.sh 手机号 密码
```

示例：
```bash
bash quick-start.sh 18170890791 Gq360304437.
```

---

## 功能列表

| 功能 | 说明 | 时间 |
|------|------|------|
| **保活** | 24小时自动重连云电脑 | 全天候 |
| **AI对话** | 自动完成AI对话积分任务 | 03:00、20:00 |
| **挂机任务** | 云电脑挂机获取积分 | 04:00、06:00 |

---

## 常用命令

```bash
# 查看运行日志
docker logs -f ctyun_手机号

# 停止/启动容器
docker stop ctyun_手机号
docker start ctyun_手机号

# 手动执行积分任务
docker exec ctyun_手机号 python3 /app/login_script.py
docker exec ctyun_手机号 python3 /app/pc_login.py

# 查看定时任务日志
docker exec ctyun_手机号 cat /app/data/cron.log
```

---

## 来源说明

- 保活程序来自 [CtYun](https://github.com/leleji/CtYun) 项目
- 验证码识别方案来自 [ddddocr](https://github.com/sml2h3/ddddocr)
- 使用基础镜像 `su3817807/ctyun:latest`
