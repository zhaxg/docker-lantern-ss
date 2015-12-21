FROM centos:centos7
MAINTAINER zhaxg <zhaxg@qq.com>

RUN yum -y install openssh-server epel-release && \
    yum -y install pwgen && \
    rm -f /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config

ADD set_root_pw.sh /set_root_pw.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

ENV ROOT_PASS docker
ENV AUTHORIZED_KEYS **None**


#install shadowsocks ------------------------------------------------------
RUN yum install -y python-setuptools && easy_install pip
RUN pip install shadowsocks 

#install proxychains --------------------------------------------------- 
RUN yum install -y bind-utils
RUN rpm -ivh ftp://195.220.108.108/linux/sourceforge/m/ma/magicspecs/apt/3.0/x86_64/RPMS.p/proxychains-3.1-17mgc30.x86_64.rpm
RUN sed -i 'N;$!P;D' /etc/proxychains.conf
RUN sed -i '$a http 127.0.0.1 8787' /etc/proxychains.conf
 
#install lantern_linux_amd64 ----------------------------------------------
RUN yum install -y wget 
RUN wget https://github.com/kendou/lantern/raw/master/lantern_linux_amd64 -O /usr/bin/lantern_linux_amd64
RUN chmod +x /usr/bin/lantern_linux_amd64 

EXPOSE 22
EXPOSE 8388
EXPOSE 8787
CMD ["/run.sh"]
  

