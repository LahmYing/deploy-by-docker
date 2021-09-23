# 只需修改版本号，即新建对应版本的镜像和容器
# 暂不指定端口，方便在 portainer 处理版本和端口

# 构建镜像
docker build -t blog:1.0.1 .

# 启动容器
docker run \
    -itd \
    --name blogV1.0.1 \
    --restart always \
    blog:1.0.1

# 进入容器
# docker exec -i -t blog /bin/bash
