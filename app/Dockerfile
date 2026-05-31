# 1. 使用官方 Ctyun 镜像作为基础镜像
FROM su3817807/ctyun:latest

# 2. 切换到 root 用户以安装系统级依赖
USER root

# 3. 设置时区
ENV TZ=Asia/Shanghai
ENV RUNNING_IN_DOCKER=true
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 4. 安装 Python3、Chromium、中文字体、Cron
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    chromium \
    fonts-wqy-zenhei \
    cron \
    libgl1 \
    libglib2.0-0 \
    dos2unix \
    && rm -rf /var/lib/apt/lists/*

# 5. 安装 Python 依赖
RUN pip3 install --no-cache-dir DrissionPage==4.0.4.19 ddddocr --break-system-packages

# 6. 复制脚本到工作目录
COPY login_script.py /app/login_script.py
COPY pc_login.py /app/pc_login.py
COPY start.sh /app/start.sh

# 7. 修复换行符并赋予执行权限
RUN dos2unix /app/start.sh && chmod +x /app/start.sh

# 8. 配置 Cron 定时任务
RUN echo "0 3,20 * * * /usr/bin/python3 /app/login_script.py > /proc/1/fd/1 2>&1" > /var/spool/cron/crontabs/root && \
    echo "0 4,6 * * * /usr/bin/python3 /app/pc_login.py > /proc/1/fd/1 2>&1" >> /var/spool/cron/crontabs/root && \
    chmod 600 /var/spool/cron/crontabs/root

# 9. CMD 运行启动脚本
CMD ["/bin/bash", "/app/start.sh"]
