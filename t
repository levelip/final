IPADDR_GLOBAL=$(/sbin/ip addr show eth0 2>/dev/null | /bin/grep 'inet ' | /bin/sed -e 's/.*inet \([^ ]*\)\/.*/\1/')
yum install build-essential autoconf libtool openssl-devel gcc -y
yum install git -y
git clone https://github.com/madeye/shadowsocks-libev.git
cd shadowsocks-libev
./configure
make && make install
#curl "https://raw.githubusercontent.com/xiaoyawl/OneInStack/master/init.d/Shadowsocks-init" -o  /etc/init.d/shadowsocks
yes | cp shadowsocks /etc/init.d/shadowsocks
chmod +x /etc/init.d/shadowsocks
chkconfig --add shadowsocks
chkconfig shadowsocks on
iptables -I INPUT 4 -p tcp -m state --state NEW -m tcp --dport 3955 -j ACCEPT

mkdir /etc/shadowsocks
cat > /etc/shadowsocks/config.json<<EOF
{
    "server":"0.0.0.0",
    "server_port":3955,
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"yO6AEnfZ",
    "timeout":300,
    "method":"aes-256-cfb",
}

EOF
cat > /etc/shadowsocks.json<<EOF
{
    "server":"0.0.0.0",
    "local_address":"127.0.0.1",
    "local_port":1080,
    "port_password":{
	"3955":"123456"
    },
    "timeout":300,
    "method":"aes-256-cfb",
    "fast_open":false
}
EOF
