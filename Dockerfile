FROM centos:centos7
MAINTAINER zhaxg <zhaxg@qq.com>

ENV SS_PASS docker
ENV ROOT_PASS docker

EXPOSE 22
EXPOSE 8388
EXPOSE 8787

#yum install Package
RUN yum -y install openssh-server
RUN yum -y install python-setuptools && easy_install pip
RUN easy_install supervisor

#set sshd------------------------------------------------------
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ""
RUN sed -ri 's/session    required     pam_loginuid.so/#session    required     pam_loginuid.so/g' /etc/pam.d/sshd
RUN mkdir -p /root/.ssh && chown root.root /root && chmod 700 /root/.ssh
RUN echo 'root:$ROOT_PASS' | chpasswd
 
#install shadowsocks ------------------------------------------------------ 
RUN pip install shadowsocks 

#install supervisor------------------------------
RUN pip install --no-deps --ignore-installed --pre supervisor 
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisord.conf

#install proxychains --------------------------------------------------- 
RUN yum install -y bind-utils
RUN rpm -ivh ftp://195.220.108.108/linux/sourceforge/m/ma/magicspecs/apt/3.0/x86_64/RPMS.p/proxychains-3.1-17mgc30.x86_64.rpm
RUN sed -i 'N;$!P;D' /etc/proxychains.conf
RUN sed -i '$a http 127.0.0.1 8787' /etc/proxychains.conf
 
#install lantern_linux_amd64 ----------------------------------------------
RUN yum install -y wget 
RUN wget https://github.com/kendou/lantern/raw/master/lantern_linux_amd64 -O /usr/bin/lantern_linux_amd64
RUN chmod +x /usr/bin/lantern_linux_amd64 

#run supervisor
CMD ["/usr/bin/supervisord -c /etc/supervisord.conf"]
  

