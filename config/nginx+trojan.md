# Trojan + NGINX 多網站共存

利用 NGINX 的 Stream 模塊 sni_preread 功能，可以做到讓 Trojan 和其他網站在同一台機器上共享 443 端口。

### default.conf
//將 /etc/nginx/sites-available/default 的內容改成如下，可以實現全局 https 跳轉
~~~
server {
listen 80 default_server;
listen [::]:80 default_server;
server_name _;
return 301 https://$host$request_uri;
}
~~~
### nginx.conf
在 /etc/nginx/nginx.conf 加入這段, 原先的內容不要刪
~~~
stream {
    map $ssl_preread_server_name $backend_name {
      vip.chuwanfeng.top trojan;
      chuwanfeng.top v2board;
    }

	upstream v2board {
		server 127.0.0.1:1444;
	}

	upstream trojan {
		server 127.0.0.1:1443;
	}

	server {
		listen 443 reuseport;
		listen [::]:443 reuseport;
		proxy_pass  $backend_name;
		ssl_preread on;
	}
}
~~~
### trojan-go.conf
~~~
{
  "run_type": "server",
  "local_addr": "127.0.0.1",
  "local_port": 8080,
  "remote_addr": "127.0.0.1",
  "remote_port": 80,
  "log_level": 5,
  "password": [
    "your_awesome_password"
  ],
  "ssl": {
    "verify_hostname": true,
    "cert": "/etc/ssl/trojan/fullchain.crt",
    "key": "/etc/ssl/trojan/key.key",
    "sni": "trojan.example.com",
    "alpn": [
      "http/1.1"
    ]
  },
  "router": {
    "enabled": false
  }
}
~~~
### trojan.conf
 trojan 偽裝站設置

 將此檔案放到以下三種位置之一

 位置1 (推荐): 放到 /etc/nginx/sites-available 下, 建立軟鏈到 /etc/nginx/sites-enabled
 
 位置2: 放到 /etc/nginx/conf.d
 
 位置3: 放到 /etc/nginx/sites-enabled
~~~
server {
listen 127.0.0.1:80;
server_name vip.chuwanfeng.top;

    root /var/www/html;
    index index.php index.html index.htm;
}
~~~
### web.conf
 其他網站全部監聽 127.0.0.1:8443, 在這個端口進行 TLS 握手
 
將此檔案放到以下三種位置之一

位置1 (推荐): 放到 /etc/nginx/sites-available 下, 建立軟鏈到 /etc/nginx/sites-enabled

位置2: 放到 /etc/nginx/conf.d

位置3: 放到 /etc/nginx/sites-enabled
~~~
server {
  listen 127.0.0.1:8443 ssl http2;
  server_name chuwanfeng.top;

    ssl_certificate /path/to/fullchain.crt;
    ssl_certificate_key /path/to/key.key;
    ssl_protocols TLSv1.2 TLSv1.3;

    location / {
    }
}
~~~

~~~
stream {
        map $ssl_preread_server_name $backend_name {
        vip.chuwanfeng.top trojan;
        chuwanfeng.top v2board;
      }

	  upstream v2board {
		  server 127.0.0.1:1444; #面板网站
	  }

	  upstream trojan {
		  server 127.0.0.1:1443;
	  }

	  server {
		  listen 443 reuseport;
		  listen [::]:443 reuseport;
		  proxy_pass  $backend_name;
		  ssl_preread on;
	  }
}
~~~

--with-cc-opt='-g -O2 -ffile-prefix-map=/build/nginx-AoTv4W/nginx-1.22.1=. 
-fstack-protector-strong -Wformat -Werror=format-security -fPIC -Wdate-time 
-D_FORTIFY_SOURCE=2' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -fPIC' 
--prefix=/usr/share/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log 
--error-log-path=stderr --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid 
--modules-path=/usr/lib/nginx/modules --http-client-body-temp-path=/var/lib/nginx/body
--http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy 
--http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-compat 
--with-debug --with-pcre-jit --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module 
--with-http_auth_request_module --with-http_v2_module --with-http_dav_module --with-http_slice_module --with-threads
--with-http_addition_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module 
--with-http_mp4_module --with-http_random_index_module --with-http_secure_link_module --with-http_sub_module 
--with-mail_ssl_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-stream_realip_module 
--with-http_geoip_module=dynamic --with-http_image_filter_module=dynamic --with-http_perl_module=dynamic 
--with-http_xslt_module=dynamic --with-mail=dynamic --with-stream=dynamic --with-stream_geoip_module=dynamic
