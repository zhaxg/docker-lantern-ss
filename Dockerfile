FROM index.tenxcloud.com/tenxcloud/centos:latest
MAINTAINER zhaxg <zhaxg@qq.com>
 
ENV SSPASSWD=sspassword
 
EXPOSE 8388
EXPOSE 8787

#install shadowsocks ------------------------------------------------------
RUN yum install -y python-setuptools && easy_install pip
RUN pip install shadowsocks
ADD shadowsocks.json /etc/

#install proxychains-ng ---------------------------------------------------
RUN yum install -y git gcc make
RUN cd /tmp && git clone --depth=1 https://github.com/rofl0r/proxychains-ng.git
WORKDIR /tmp/proxychains-ng
RUN ./configure --prefix=/usr --sysconfdir=/etc && make install && make install-config
WORKDIR /
ADD proxychains.conf /etc/proxychains.conf

#install lantern_linux_amd64 ----------------------------------------------
RUN yum install -y wget
RUN wget https://github.com/kendou/lantern/raw/master/lantern_linux_amd64 -O /usr/bin/lantern_linux_amd64
RUN chmod +x /usr/bin/lantern_linux_amd64 

#install startup ---------------------------------------------------------
ADD startup.sh /usr/bin/startup.sh
RUN chmod +x /usr/bin/startup.sh 

ENTRYPOINT ["/usr/bin/startup.sh"]