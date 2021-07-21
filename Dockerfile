FROM centos:centos7
#维护该镜像的用户信息
MAINTAINER lokott@123.com
#指令集
#更新及安装相关工具
RUN yum update -y
RUN yum install -y wget lsof telnet net-tools gcc gcc-c++ make pcre pcre-devel zlib zlib-devel
#从官网上下载nginx软件包源并解压
RUN wget http://nginx.org/download/nginx-1.16.1.tar.gz
RUN tar zxf nginx-1.16.1.tar.gz
#创建nginx用户
RUN useradd -M -s /sbin/nologin nginx
#指定后续RUN指令的工作目录
WORKDIR nginx-1.16.1
#配置参数以及编译nginx
RUN ./configure --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_stub_status_module
RUN make && make install
#ENV PATH /usr/local/nginx/sbin:$PATH
#端口设置
EXPOSE 80
EXPOSE 443
#以非daemon方式运行
RUN echo "daemon off;" >> /usr/local/nginx/conf/nginx.conf
#切换工作目录
WORKDIR /root/nginx
ADD nginx.sh /nginx.sh
RUN chmod 755 /nginx.sh
#启动容器执行指令


ADD jdk-8u91-linux-x64.tar.gz /usr/local
WORKDIR /usr/local
RUN mv jdk1.8.0_91 /usr/local/Java
ENV JAVA_HOME /usr/local/java
ENV JAVA_BIN /usr/local/java/bin
ENV JRE_HOME /usr/local/java/jre
ENV PATH $PATH:/usr/local/java/bin:/usr/local/java/jre/bin
ENV CLASSPATH /usr/local/java/jre/bin:/usr/local/java/lib:/usr/local/java/jre/lib/charsets.jar
ADD apache-tomcat-9.0.16.tar.gz /usr/local
WORKDIR /usr/local
RUN mv apache-tomcat-9.0.16 /usr/local/tomcat8
EXPOSE 8080
ENTRYPOINT ["/usr/local/tomcat8/bin/catalina.sh","run"]

RUN yum -y install \
ncurses \
ncurses-devel \
bison \
cmake \
make \
gcc \
gcc-c++
#创建mysql用户
RUN useradd -s /sbin/nologin mysql
#复制软件包到指定目录（将会自动解压）
ADD mysql-boost-5.7.20.tar.gz /usr/local/src
#指定工作目录
WORKDIR /usr/local/src/mysql-5.7.20/
#cmake配置及编译安装
RUN cmake \
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_UNIX_ADDR=/usr/local/mysql/mysql.sock \
-DSYSCONFDIR=/etc \
-DSYSTEMD_PID_DIR=/usr/local/mysql \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_PERFSCHEMA_STORAGE_ENGINE=1 \
-DMYSQL_DATADIR=/usr/local/mysql/data \
-DWITH_BOOST=boost \
-DWITH_SYSTEMD=1 && make && make install
#更改mysql目录属主属组
RUN chown -R mysql:mysql /usr/local/mysql/
#删除默认安装的my.cnf文件
RUN rm -rf /etc/my.cnf
#复制一份my.cnf到etc目录下
ADD my.cnf /etc
#更改该文件权限
RUN chown mysql:mysql /etc/my.cnf
#设置环境变量，命令目录及库文件目录
ENV PATH=/usr/local/mysql/bin:/usr/local/mysql/lib:$PATH
#指定工作目录
WORKDIR /usr/local/mysql/
#初始化设置
RUN bin/mysqld \
--initialize-insecure \
--user=mysql \
--basedir=/usr/local/mysql \
--datadir=/usr/local/mysql/data
#优化启动方式
RUN cp /usr/local/mysql/usr/lib/systemd/system/mysqld.service /usr/lib/systemd/system/
EXPOSE 3306
#直接设置运行启动脚本
RUN echo -e "#!/bin/sh \nsystemctl enable mysqld" > /run.sh
RUN chmod 755 /run.sh



