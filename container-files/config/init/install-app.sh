yum install -y wget
yum install -y openssh-server
yum install -y python-setuptools && easy_install pip

mkdir /var/run/sshd
sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
echo 'root:$ROOT_PASS' |chpasswd

pip install shadowsocks 

yum install -y bind-utils 
rpm -ivh ftp://195.220.108.108/linux/sourceforge/m/ma/magicspecs/apt/3.0/x86_64/RPMS.p/proxychains-3.1-17mgc30.x86_64.rpm
sed -i 'N;$!P;D' /etc/proxychains.conf
sed -i '$a http 127.0.0.1 8787' /etc/proxychains.conf 

wget https://github.com/kendou/lantern/raw/master/lantern_linux_amd64 -O /usr/bin/lantern_linux_amd64
chmod +x /usr/bin/lantern_linux_amd64 