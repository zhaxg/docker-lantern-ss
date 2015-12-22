FROM centos:centos7
MAINTAINER zhaxg <zhaxg@qq.com>

ENV SS_PASS docker
ENV ROOT_PASS docker 

ADD install /tmp

#yum install Package
RUN yum -y install openssh-server
RUN yum -y install python-setuptools && easy_install pip

#set sshd----------------------------------------------------------
RUN mkdir /var/run/sshd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN echo 'root:docker' |chpasswd
 
#install shadowsocks ------------------------------------------------------ 
RUN pip install shadowsocks 

#install proxychains --------------------------------------------------- 
RUN yum install -y bind-utils 
RUN rpm -ivh /tmp/proxychains-3.1-17mgc30.x86_64.rpm
RUN sed -i 'N;$!P;D' /etc/proxychains.conf
RUN sed -i '$a http 127.0.0.1 8787' /etc/proxychains.conf
 
#install lantern_linux_amd64 ---------------------------------------------- 
RUN cp -f /tmp/lantern_linux_amd64 /usr/bin/lantern 
RUN chmod +x /usr/bin/lantern

#-----------------------------------------------------------
RUN easy_install supervisor  
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisord.conf

EXPOSE 22
EXPOSE 8388
EXPOSE 8787
CMD ["/usr/bin/supervisord -c /etc/supervisord.conf"]  

