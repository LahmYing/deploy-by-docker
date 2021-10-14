# # 使用基础版本的 Alpine 镜像
# FROM alpine:3.14 as CHUNK_ONE
# RUN sed -i 's/https/http/' /etc/apk/repositories
# RUN apk add curl
# # 安装 nodejs 和 yarn
# # alpine 版本可用的 node.js 和 yarn： https://pkgs.alpinelinux.org/packages?name=yarn&branch=v3.14
# RUN apk add --no-cache --update nodejs=14.17.4-r0 yarn=1.22.10-r0

FROM node:slim as CHUNK_ONE

# 工作区文件夹，非该项目所在文件夹
ENV WORK_DIR=/usr/app/blog

# 执行命令，创建文件夹
RUN mkdir -p ${WORK_DIR}
RUN chmod -R 777 ${WORK_DIR}
RUN mkdir -p ${WORK_DIR}/logs
RUN chmod -R 777 ${WORK_DIR}/logs

# Set working directory
WORKDIR ${WORK_DIR}

RUN node --version && npm --version && yarn --version

COPY package.json yarn.lock ./
# COPY ./ ./
RUN yarn

FROM CHUNK_ONE
COPY --from=CHUNK_ONE ${WORK_DIR}/node_modules ./node_modules

# PM2: 服务持久运行工具
RUN yarn global add pm2

# RUN npm config set registry https://registry.npm.taobao.org && npm i pm2 -g
# RUN npm install && npm run compress

# 校正时间
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# Copy all files
COPY . .
RUN yarn compress

# Expose the listening port
EXPOSE 80

# 列出所有文件和文件夹，包括隐藏目录
# cntofu.com/book/139/index.html
# https://zhuanlan.zhihu.com/p/57390458
# 等同 RUN ls -a -l -R -I "node_modules*"
RUN ls -alR -I "node_modules*"

CMD ["pm2-runtime", "start", "--raw", "app.js", "--env", "production"]
