# FROM node

# 使用基础版本的 Alpine 镜像，自己安装Nodejs
# FROM alpine:latest
# RUN apk add --no-cache --update nodejs nodejs-npm

# FROM node:alpine
FROM node:slim

# ENV NODE_ENV=production
# ENV NODE_VERSION 14.17.3

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

# COPY ["package.json", "package-lock.json*", "yarn.lock", "./"]
COPY ./ ./

# Install PM2 globally
# RUN npm i yarn && yarn global add pm2
RUN npm config set registry https://registry.npm.taobao.org && npm i pm2 -g

# Install dependencies
# RUN yarn && yarn compress
RUN npm install && npm run compress

# 校正时间
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# Copy all files
COPY ./ ./

# Expose the listening port
EXPOSE 80

# 列出所有文件和文件夹，包括隐藏目录
# cntofu.com/book/139/index.html
# https://zhuanlan.zhihu.com/p/57390458
# 等同 RUN ls -a -l -R -I "node_modules*"
RUN ls -alR -I "node_modules*"

CMD ["pm2-runtime", "start", "--raw", "app.js", "--env", "production"]
