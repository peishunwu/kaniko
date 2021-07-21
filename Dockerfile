FROM  centos:7
RUN     yum nginx -y && /usr/sbin/nginx
WORKDIR /usr/share/nginx/html
RUN  rm -f ./index.html
COPY index.html ./
COPY init.sh /init.sh
EXPOSE 80/tcp
