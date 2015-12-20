FROM centos:7
MAINTAINER zhaxg <zhaxg@qq.com>

ENV SS-SERVER-PORT 8338

RUN echo "root:docker" | chpasswd 

#安装shadowsocks
RUN yum install -y python-setuptools && easy_install pip
RUN pip install shadowsocks

#安装proxychains-ng
RUM yum install -y git gcc make
RUN cd /tmp && git clone --depth=1 https://github.com/rofl0r/proxychains-ng.git
WORKDIR /tmp/proxychains-ng
RUN ./configure --prefix=/usr --sysconfdir=/etc && make install && make install-config
COPY proxychains.conf /etc/proxychains.conf

#安装lantern_linux_amd64
RUN yum install -y wget
RUN wget https://github.com/kendou/lantern/raw/master/lantern_linux_amd64 -O lantern
RUN chmod +x lantern
EXPOSE 8787

ENTRYPOINT [ "/lantern", "--addr", "0.0.0.0:8787" ]