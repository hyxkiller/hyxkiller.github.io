---
title: React项目部署Nginx配置
date: 2019-01-09 23:32:52
tags: [前端, Nginx]
categories: Nginx
---

### nginx基础命令 
#### 下载
 - brew install nginx
#### 启动
 - nginx
#### 重启
 - nginx -s reload
#### 关闭
 - 查看主进程号  ps -ef | grep nginx
 - 从容停止 kill -QUIT 主进程号
 - 快速停止 kill -TERM 主进程号
 - 强制停止 kill -9 nginx
---
### 配置步骤
- 把build后的包放到nginx根目录下
- 修改/usr/local/etc/nginx/nginx.conf文件配置
- 
        location / {
            root   build;
            index  index.html index.htm;
            try_files $uri $uri/ /index.html;
        }

        client_max_body_size 2m;

        location ^~ /api/ {
            proxy_pass 后端部署地址;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header   Host             $host;
            proxy_set_header   X-Real-IP        $remote_addr;
            proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
        }
        
        location ~* /.html$ { 
            add_header Cache-Control "no-store, no-cache";
        }
        location ~* /.(?:jpg|jpeg|gif|png|ico|cur|gz|svg|svgz|mp4|ogg|ogv|webm|htc|eot|ttf)$ { expires max;}
        location ~* /.(?:css|js|js/.map)$ { expires max;}

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    ```
    1.root 为根目录默认路径
    2.try_files $uri $uri/ /index.html;
    因为browserRouter的原因，需要将每个uri指向index.html
    3.location ~* /.html$ 为html设置不缓存
    4.client_max_body_size限制上传文件大小
    5.error_page可以自定义错误页和访问设置
    ```

### location的四种类别
```
=   location = path 优先级最高，但要全路径匹配  
^~  location ^~ path 优先级第二
~ or ~* location ~ path [~正则匹配区分大小写，~*不区分大小写]

```