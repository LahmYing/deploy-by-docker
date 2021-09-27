# 只需修改版本号，即新建对应版本的镜像和容器
# 暂不指定端口，方便在 portainer 处理版本和端口

# command result to var 'tag'
tag=$(date +%Y_%m_%d_%H_%M_%S)

# 构建镜像
docker build -t blog:${tag} .

# 启动容器
docker run \
    -itd \
    --name blog_${tag} \
    --restart always \
    blog:${tag}

# 进入容器
# docker exec -i -t blog /bin/bash
