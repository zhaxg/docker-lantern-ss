FROM index.tenxcloud.com/tenxcloud/centos:latest
MAINTAINER zhaxg <zhaxg@qq.com>

ENV SS_PASS docker 
 
EXPOSE 8388
EXPOSE 8787

#install shadowsocks ------------------------------------------------------
RUN yum install -y python-setuptools && easy_install pip
RUN pip install shadowsocks 

#install proxychains-ng --------------------------------------------------- 
RUN rpm -ivh ftp://195.220.108.108/linux/fedora/linux/releases/23/Everything/x86_64/os/Packages/p/proxychains-ng-4.10-2.fc23.x86_64.rpm
RUN sed -i '$d' /etc/proxychains.conf
RUN sed -i '$a http 127.0.0.1 8787' /etc/proxychains.conf
 
#install lantern_linux_amd64 ----------------------------------------------
RUN yum install -y wget 
RUN wget https://github.com/kendou/lantern/raw/master/lantern_linux_amd64 -O /usr/bin/lantern_linux_amd64
RUN chmod +x /usr/bin/lantern_linux_amd64 
 
CMD sh -c 'lantern_linux_amd64 --addr 0.0.0.0:8787 && proxychains4 ssserver -p 8388 -k $SS_PASS -d start'