FROM centos:7

LABEL maintainer="xiaolin"

WORKDIR /root/

ENV NODE_ID=0 SPEEDTEST=6 CLOUDSAFE=0 AUTOEXEC=0 ANTISSATTACK=0 MU_SUFFIX=zhaoj.in MU_REGEX=%5m%id.%suffix API_INTERFACE=modwebapi WEBAPI_URL=https://zhaoj.in WEBAPI_TOKEN=glzjin MYSQL_HOST=127.0.0.1 MYSQL_PORT=3306 MYSQL_USER=ss MYSQL_PASS=ss MYSQL_DB=shadowsocks REDIRECT=github.com FAST_OPEN=false


#ss
RUN  yum -y install wget\
	&& yum -y install libffi libffi-devel openssl-devel\
	&& wget https://bootstrap.pypa.io/pip/3.5/get-pip.py\
  && python get-pip.py\
	&& yum -y install git\
	&& yum -y groupinstall "Development Tools"\
  && wget https://github.com/jedisct1/libsodium/releases/download/1.0.11/libsodium-1.0.11.tar.gz\
&& tar xf libsodium-1.0.11.tar.gz && cd libsodium-1.0.11\
&& ./configure && make -j2 && make install\
&& echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf\
&& ldconfig && cd

#准备
RUN  pip install git+https://github.com/sivel/speedtest-cli.git\
	&& git clone -b py2 https://github.com/Lin-UN/shadowsocks-mod.git\
	&& cd shadowsocks-mod\
	&& pip install -r requirements.txt


CMD sed -i "s#'zhaoj.in'#'jd.hk'#" /root/shadowsocks-mod/apiconfig.py\
  &&  sed -i "s#https://zhaoj.in#${WEBAPI_URL}#" /root/shadowsocks-mod/apiconfig.py\
  &&  sed -i "s#glzjin#${WEBAPI_TOKEN}#" /root/shadowsocks-mod/apiconfig.py\
  &&  sed -i '2d' /root/shadowsocks-mod/apiconfig.py\
  &&  sed -i "2a\NODE_ID = ${NODE_ID}" /root/shadowsocks-mod/apiconfig.py && python /root/shadowsocks-mod/server.py
