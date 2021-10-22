# 作用

用于部署静态项目，比如此处的 `./public`，是 https://github.com/LahmYing/blog 项目的构建产物

# 项目地址

http://lahmying.top/blog/archives

# 建站流程

<!-- http://lahmying.top/blog/2021/09/17/%E4%B8%AA%E4%BA%BA%E5%BB%BA%E7%AB%99%E7%9B%B8%E5%85%B3/ -->

# 部署

## 手动部署

cd 至该项目在主机上的目录，执行 build.sh，实现：

- 构建镜像
- 基于构建的镜像启动容器

<!-- **_留意该容器的端口设置，见 app.js 和 build.sh 和 Dockerfile_** -->

## 结合阿里云飞流一键部署

阿里云飞流 https://flow.teambition.com/
步骤如下：

- 代码源： 授权使用 github
- node.js 构建命令： `yarn`
- 构建镜像并推到阿里云镜像仓库
  需要新建一个[阿里云镜像仓库](https://cr.console.aliyun.com/cn-shenzhen/instances)（公开，有时要在 portainer.io 修改容器与主机端口并新建容器，portainer 只能 pull 公开的镜像）
- 启动容器

```sh
# $myimage 是变量，是上一步飞流构建的镜像
export myimage=$(echo $myimage | base64 -d)
tag=$(date +%Y_%m_%d_%H_%M_%S)
docker run \
    -itd \
    -p 80:80  \
    --name blog_$tag \
    --restart always \
    $myimage
```

# 优化静态文件

## 压缩

`$ yarn compress`
