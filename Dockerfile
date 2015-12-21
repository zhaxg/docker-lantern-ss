FROM centos:7
MAINTAINER zhaxg <zhaxg@qq.com>

ENV SSPORT=8388
ENV SSPASSWD=sspassword

EXPOSE 22
EXPOSE $SSPORT

RUN yum update -y

#安装openssh-server
RUN yum install -y openssh-server
RUN mkdir /var/run/sshd 
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
CMD ["/usr/sbin/sshd", "-D"] 

#安装shadowsocks
RUN yum install -y python-setuptools && easy_install pip
RUN pip install shadowsocks
ADD shadowsocks.json /etc/

#安装proxychains-ng
RUN yum install -y git gcc make
RUN cd /tmp && git clone --depth=1 https://github.com/rofl0r/proxychains-ng.git
WORKDIR /tmp/proxychains-ng
RUN ./configure --prefix=/usr --sysconfdir=/etc && make install && make install-config
WORKDIR /
ADD proxychains.conf /etc/proxychains.conf

#安装lantern_linux_amd64
RUN yum install -y wget
RUN wget https://github.com/kendou/lantern/raw/master/lantern_linux_amd64 -O /usr/bin/lantern_linux_amd64
RUN chmod +x /usr/bin/lantern_linux_amd64 

#加入启动脚本
ADD startup.sh /usr/bin/startup.sh
RUN chmod +x /usr/bin/startup.sh

RUN echo "root:docker" | chpasswd 
ENTRYPOINT ["/usr/bin/startup.sh"]