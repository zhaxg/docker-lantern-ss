FROM centos:latest
MAINTAINER zhaxg<zhaxg@qq.com>
 
#yum install Package
RUN yum -y install openssh-server
RUN yum -y install python-setuptools && easy_install supervisor && easy_install pip && pip install shadowsocks 

#set sshd
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ""
RUN sed -ri 's/session    required     pam_loginuid.so/#session    required     pam_loginuid.so/g' /etc/pam.d/sshd
RUN mkdir -p /root/.ssh && chown root.root /root && chmod 700 /root/.ssh
RUN echo 'root:docker' | chpasswd
 
#set supervisor
RUN mkdir -p /var/log/supervisor
 
#-----------------------------------------------------------
RUN yum install -y bind-utils 
RUN rpm -ivh ftp://195.220.108.108/linux/fedora/linux/releases/23/Everything/x86_64/os/Packages/p/proxychains-ng-4.10-2.fc23.x86_64.rpm

RUN yum install -y wget
RUN wget https://github.com/kendou/lantern/raw/master/lantern_linux_amd64 -O /usr/bin/lantern 
RUN chmod +x /usr/bin/lantern

ADD zzproxychains.conf /etc/proxychains.conf
ADD zzsupervisord.conf /etc/supervisord.conf
#-----------------------------------------------------------

#set port
EXPOSE 22
EXPOSE 8388
EXPOSE 8787
  
#run supervisor
CMD ["/usr/bin/supervisord"]