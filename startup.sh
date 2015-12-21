#!/bin/sh

/usr/sbin/sshd -d
/usr/bin/lantern_linux_amd64 --addr 0.0.0.0:8787

proxychains ssserver -p 8388 -k $SSPASSWD -d start 