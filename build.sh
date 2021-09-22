# 构建镜像
docker build -t blog:1.0.0 .

# 启动容器
docker run \
    -itd \
    -p 80:80  \
    --name blog \
    --restart always \
    blog:1.0.0

# 进入容器
# docker exec -i -t blog /bin/bash