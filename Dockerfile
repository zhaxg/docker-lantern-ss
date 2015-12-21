FROM centos:7
MAINTAINER zhaxg <zhaxg@qq.com>

ENV SS_PASS
ENV ROOT_PASS 
 
EXPOSE 8388
EXPOSE 8787

RUN yum install -y wget
RUN yum install -y deltarpm epel-release
 
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
  
#install openssh-server ------------------------------------------------------
RUN yum install -y openssh-server
RUN mkdir -p /var/run/sshd && echo "root:docker" | chpasswd 
RUN /usr/sbin/sshd-keygen
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

#install shadowsocks ------------------------------------------------------
RUN yum install -y python-setuptools && easy_install pip
RUN pip install shadowsocks 

#install proxychains-ng ---------------------------------------------------
RUN yum install -y git gcc make
RUN cd /tmp && git clone --depth=1 https://github.com/rofl0r/proxychains-ng.git
RUN cd /tmp/proxychains-ng && ./configure --prefix=/usr --sysconfdir=/etc && make && make install && make install-config
ADD proxychains.conf /etc/proxychains.conf

#install lantern_linux_amd64 ----------------------------------------------
RUN wget https://github.com/kendou/lantern/raw/master/lantern_linux_amd64 -O /usr/bin/lantern_linux_amd64
RUN chmod +x /usr/bin/lantern_linux_amd64 

#install startup ---------------------------------------------------------
ADD startup.sh /usr/bin/startup.sh
RUN chmod +x /usr/bin/startup.sh 
 
ENTRYPOINT ["/usr/bin/startup.sh"]