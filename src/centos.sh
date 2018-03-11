#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
if [ $(id -u) != "0" ]; then
    echo "Error: 错误，必须是 Root 用户才能执行此脚本，GCE 中切换 Root：sudo -s"
    exit 1
fi

clear

echo "========================================================================="
echo "无障碍使用 Google Docs - Form 服务：GDGDocs.org 开源了 v1.1 20140811"
echo "========================================================================="
echo "更多信息请访问：http://gdgny.org/ 南阳谷歌开发者社区"
echo "========================================================================="
echo "该脚本很大一部分外围配置均参考自 lnmp 一键安装包 感谢 lnmp.org "
echo "========================================================================="

read -p "输入要部署 GDocs 反向代理的域名： " domain

if [ ! -f "/usr/local/nginx/conf/vhost/$domain.conf" ]; then
echo "==========================="
echo "domain=$domain"
echo "==========================="
else
echo "==========================="
echo "$domain 已经存在咯!"
echo "==========================="
fi

read -p "如有指定的 Google 服务器 IP（通常用于中国大陆，不可使用 Google 北京 IP），请输入 IP 地址，否则留空即可：" google_ip

gdoc_source="docs.google.com"
short_source="goo.gl"
qr_source="chart.apis.google.com"

if [ "$google_ip" == "" ]; then
    echo "将使用默认 IP"
else
    echo "将使用 $google_ip"
    gdoc_source="$google_ip"
    short_source="$google_ip"
    qr_source="$google_ip"
fi


# Set timezone from lnmp.org
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
yum install -y ntp
ntpdate -u pool.ntp.org
date

yum -y install wget gcc

# we could use yum to install/upgrade git directly
# but we don't want to replace Git if it is installed from source code.

# 测试 Git 是否安装
git --version > /dev/null 2>&1

if [ $? -eq 0 ]; then

echo "Git 已安装，进行下一步"
else

echo "检测到该系统尚未安装git，这一步我们要安装 git"
# 安装 git
yum -y install git
fi

# 安装 Nginx Stable 版
yum -y install openssl openssl-devel pcre-devel
wget http://nginx.org/download/nginx-1.12.1.tar.gz

git clone https://github.com/agentzh/headers-more-nginx-module.git $HOME/more_module/headers-more-nginx-module/
git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module.git $HOME/more_module/ngx_http_substitutions_filter_module/
tar zxvf nginx-1.12.1.tar.gz
cd nginx-1.12.1
./configure  --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module --with-http_sub_module --add-module=$HOME/more_module/headers-more-nginx-module/  --add-module=$HOME/more_module/ngx_http_substitutions_filter_module

make && make install

# 替换 config 文件、添加 vhosts 文件夹

ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx

mkdir -p /opt/wwwroot/default
chmod +w /opt/wwwroot/default
mkdir -p /opt/wwwlogs
chmod -R 777 /opt/wwwlogs

cd ..
rm -f /usr/local/nginx/conf/nginx.conf
cp conf/nginx.conf /usr/local/nginx/conf/nginx.conf
mkdir /usr/local/nginx/conf/vhost/

\rm -r $HOME/more_module/headers-more-nginx-module/
\rm -r $HOME/more_module/ngx_http_substitutions_filter_module/
\rm -r nginx-1.12.1
rm nginx-1.12.1.tar.gz

cat > /usr/local/nginx/conf/vhost/$domain.conf << eof
# 注意，这里提供的 dn-ggpt.qbox.me 等，是七牛为公益开发者社区的提供的赞助，请商业公司自行搭建，谢谢。
server
     {
          listen       80;
          server_name $domain;
          # conf ssl if you need
          # SSL 配置请参见 gdgny.org/project/gdgdocs
          location / {
            proxy_set_header Accept-Encoding '';
            subs_filter_types text/css text/js;
            proxy_pass https://$gdoc_source/;
            subs_filter docs.google.com  $domain
            subs_filter lh1.googleusercontent.com dn-ggpt.qbox.me;
            subs_filter lh2.googleusercontent.com dn-ggpt.qbox.me;
            subs_filter lh3.googleusercontent.com dn-ggpt.qbox.me;
            subs_filter lh4.googleusercontent.com dn-ggpt.qbox.me;
            subs_filter lh5.googleusercontent.com dn-ggpt.qbox.me;
            subs_filter lh6.googleusercontent.com dn-ggpt.qbox.me;
            subs_filter lh7.googleusercontent.com dn-ggpt.qbox.me;
            subs_filter lh8.googleusercontent.com dn-ggpt.qbox.me;
            subs_filter lh9.googleusercontent.com dn-ggpt.qbox.me;
            subs_filter lh10.googleusercontent.com dn-ggpt.qbox.me;
            subs_filter ssl.gstatic.com dn-gstatic.qbox.me;
            subs_filter www.gstatic.com dn-gstatic.qbox.me;

            proxy_redirect          off;
            proxy_set_header        X-Real-IP       \$remote_addr;
            proxy_set_header        X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header        Cookie "";
            proxy_hide_header       Set-Cookie;
            more_clear_headers      "P3P";

            proxy_hide_header Location;
          }

          location /r/ {
                proxy_pass         https://$short_source/;
                proxy_set_header   Host goo.gl;
                proxy_set_header   X-Real-IP  \$remote_addr;
                proxy_set_header   X-Forwarded-For \$proxy_add_x_forwarded_for;
           }

          location ^~ /qr/ {
                proxy_pass         https://$qr_source/chart?cht=qr&chs=500x500&chld=H|0&chl=http%3A//$domain/r/;
                proxy_set_header   Host chart.apis.google.com;
                proxy_set_header   X-Real-IP  \$remote_addr;
                proxy_set_header   X-Forwarded-For \$proxy_add_x_forwarded_for;
           }
     }
eof

cat > /usr/local/nginx/conf/vhost/lb.$domain.conf << eof
# 注意，这里提供的 dn-ggpt.qbox.me 等，是七牛为公益开发者社区的提供的赞助，请商业公司自行搭建，谢谢。
server
     {
          listen       80;
          server_name 0.$domain 1.$domain 2.$domain;
          # conf ssl if you need
          # SSL 配置请参见 gdgny.org/project/gdgdocs
          add_header Access-Control-Allow-Credentials true;
          add_header Access-Control-Allow-Headers "X-Same-Domain";
          location / {
            proxy_set_header Accept-Encoding '';
            subs_filter_types text/css text/js;
            proxy_pass https://0.$gdoc_source/;
            subs_filter docs.google.com  $domain
            subs_filter lh1.googleusercontent.com dn-ggpt.qbox.me;
            subs_filter lh2.googleusercontent.com dn-ggpt.qbox.me;
            subs_filter lh3.googleusercontent.com dn-ggpt.qbox.me;
            subs_filter lh4.googleusercontent.com dn-ggpt.qbox.me;
            subs_filter lh5.googleusercontent.com dn-ggpt.qbox.me;
            subs_filter lh6.googleusercontent.com dn-ggpt.qbox.me;
            subs_filter lh7.googleusercontent.com dn-ggpt.qbox.me;
            subs_filter lh8.googleusercontent.com dn-ggpt.qbox.me;
            subs_filter lh9.googleusercontent.com dn-ggpt.qbox.me;
            subs_filter lh10.googleusercontent.com dn-ggpt.qbox.me;
            subs_filter ssl.gstatic.com dn-gstatic.qbox.me;
            subs_filter www.gstatic.com dn-gstatic.qbox.me;

            proxy_redirect          off;
            proxy_set_header        X-Real-IP       \$remote_addr;
            proxy_set_header        X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header        Cookie "";
            proxy_hide_header       Set-Cookie;
            more_clear_headers      "P3P";

            proxy_hide_header Location;
          }

          location /r/ {
                proxy_pass         https://$short_source/;
                proxy_set_header   Host goo.gl;
                proxy_set_header   X-Real-IP  \$remote_addr;
                proxy_set_header   X-Forwarded-For \$proxy_add_x_forwarded_for;
           }

          location ^~ /qr/ {
                proxy_pass         https://$qr_source/chart?cht=qr&chs=500x500&chld=H|0&chl=http%3A//$domain/r/;
                proxy_set_header   Host chart.apis.google.com;
                proxy_set_header   X-Real-IP  \$remote_addr;
                proxy_set_header   X-Forwarded-For \$proxy_add_x_forwarded_for;
           }
     }
eof

echo "Test Nginx configure file......"
/usr/local/nginx/sbin/nginx -t
echo "Restart Nginx......"
killall nginx
/usr/local/nginx/sbin/nginx
echo "搞定"
