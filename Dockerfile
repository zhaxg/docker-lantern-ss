FROM centos:7
MAINTAINER zhaxg <zhaxg@qq.com>

ENV SS_PASS docker
ENV ROOT_PASS docker

EXPOSE 22
EXPOSE 8388
EXPOSE 8787

#aliyun source---------------------------------------------------
RUN yum install -y wget && yum clean all
RUN wget -O /etc/yum.repos.d/CentOS-Base-aliyun.repo http://mirrors.aliyun.com/repo/Centos-7.repo

#yum install Package
RUN yum -y install openssh-server
RUN yum -y install python-setuptools && easy_install pip

#set sshd----------------------------------------------------------
RUN mkdir /var/run/sshd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN echo 'root:$ROOT_PASS' |chpasswd
 
#install shadowsocks ------------------------------------------------------ 
RUN pip install shadowsocks 

#install supervisor------------------------------
RUN easy_install supervisor
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisord.conf

#install proxychains --------------------------------------------------- 
RUN yum install -y bind-utils
RUN rpm -ivh http://tqmes.coding.io/upload/proxychains-3.1-17mgc30.x86_64.rpm
#RUN rpm -ivh ftp://195.220.108.108/linux/sourceforge/m/ma/magicspecs/apt/3.0/x86_64/RPMS.p/proxychains-3.1-17mgc30.x86_64.rpm
RUN sed -i 'N;$!P;D' /etc/proxychains.conf
RUN sed -i '$a http 127.0.0.1 8787' /etc/proxychains.conf
 
#install lantern_linux_amd64 ----------------------------------------------
RUN wget http://tqmes.coding.io/upload/lantern_linux_amd64 -O /usr/bin/lantern_linux_amd64
#RUN wget https://github.com/kendou/lantern/raw/master/lantern_linux_amd64 -O /usr/bin/lantern_linux_amd64
RUN chmod +x /usr/bin/lantern_linux_amd64 

#run supervisor
CMD ["/usr/bin/supervisord -c /etc/supervisord.conf"]
  

