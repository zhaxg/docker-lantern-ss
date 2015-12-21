#FROM index.tenxcloud.com/tenxcloud/centos:latest
FROM centos
MAINTAINER zhaxg <zhaxg@qq.com>

ENV SS_PASS docker 
ENV ROOT_PASS docker

EXPOSE 8388
EXPOSE 8787

RUN echo "root:$ROOT_PASS" | chpasswd

#install shadowsocks ------------------------------------------------------
RUN yum install -y python-setuptools && easy_install pip
RUN pip install shadowsocks 

#install proxychains-ng --------------------------------------------------- 
RUN yum install -y bind-utils
RUN rpm -ivh ftp://195.220.108.108/linux/sourceforge/m/ma/magicspecs/apt/3.0/x86_64/RPMS.p/proxychains-3.1-17mgc30.x86_64.rpm
RUN sed -i 'N;$!P;D' /etc/proxychains.conf
RUN sed -i '$a http 127.0.0.1 8787' /etc/proxychains.conf
 
#install lantern_linux_amd64 ----------------------------------------------
RUN yum install -y wget 
RUN wget https://github.com/kendou/lantern/raw/master/lantern_linux_amd64 -O /usr/bin/lantern_linux_amd64
RUN chmod +x /usr/bin/lantern_linux_amd64 

RUN sed -i '$a exec proxychains ssserver -p 8388 -k $SS_PASS -d start' /run.sh
RUN sed -i '$a exec lantern_linux_amd64 --addr 0.0.0.0:8787' /run.sh

#ENTRYPOINT /run.sh
CMD lantern_linux_amd64 --addr 0.0.0.0:8787 && proxychains ssserver -p 8388 -k $SS_PASS -d start