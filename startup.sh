#!/bin/sh

proxychains ssserver -p $SSPORT -k $SSPASSWD -d start
/usr/bin/lantern_linux_amd64 --addr 0.0.0.0:8787