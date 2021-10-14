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
COPY ["package.json", "package-lock.json*", "yarn.lock"]
RUN yarn install --frozen-lockfile
# RUN npm config set registry https://registry.npm.taobao.org && npm i pm2 -g && npm install
COPY . .
RUN yarn compress

FROM node:slim
ENV WORK_DIR=/usr/app/blog
COPY --from=CHUNK_ONE ${WORK_DIR}/node_modules ./node_modules
RUN yarn global add pm2
# 校正时间
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# Expose the listening port
EXPOSE 80
# 列出所有文件和文件夹，包括隐藏目录
# cntofu.com/book/139/index.html
# https://zhuanlan.zhihu.com/p/57390458
# 等同 RUN ls -a -l -R -I "node_modules*"
RUN ls -alR -I "node_modules*"
CMD ["pm2-runtime", "start", "--raw", "app.js", "--env", "production"]
