# 继承基础的centos镜像
FROM centos
# 指定作者信息
MAINTAINER myName<myName@163.com>
# 定义环境变量
ENV mypath /tmp
# 设置当前的工作目录，通过环境变量指定
WORKDIR $mypath

# 运行 yum 命令，安装 vim 和 net-tools 工具
RUN yum -y install vim
RUN yum -y install net-tools

# 暴露 80 端口，运行容器时就可以使用“-p 宿主机端口:容器中端口”指定端口映射
EXPOSE 80
  
# 容器启动时运行的指令
# 启动容器时，只运行最后一条CMD指令

