FROM node

ENV NODE_ENV=production
ENV NODE_VERSION 14.17.3
ENV YARN_VERSION 1.22.11

ENV WORK_DIR=/usr/app/blog

# 执行命令，创建文件夹
RUN mkdir -p ${WORK_DIR}
RUN chmod -R 777 ${WORK_DIR}
RUN mkdir -p ${WORK_DIR}/logs
RUN chmod -R 777 ${WORK_DIR}/logs

# Set working directory
WORKDIR ${WORK_DIR}

RUN node --version && npm --version && yarn --version

COPY ["package.json", "package-lock.json*", "./"]

# Install PM2 globally
RUN yarn global add pm2

# Install dependencies
RUN yarn

# 校正时间
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# Copy all files
COPY ./ ./

# Expose the listening port
EXPOSE 80

RUN ls -al -R

CMD ["pm2-runtime", "start", "--raw", "app.js", "--env", "production"]