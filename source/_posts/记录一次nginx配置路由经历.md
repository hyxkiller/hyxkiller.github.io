---
title: 记录一次Nginx配置路由经历
date: 2019-03-19 13:10:06
tags: Nginx
categories: Nginx 
---

碰到的业务场景：
因为在React项目中根目录/，有做重定向，又因为路由采用BrowserRouter，在Nginx的配置中将location / 的目录全部指向index.html，而遇到一个业务场景是要在现有的项目中有需要由一个特定的路由指向一个现成的html页面。
期初想法是新建一个location /xxx, root指向对应html,结果发现不管怎样去设置/xxx 的优先级还是会走到项目里的重定向。
后来在调研后，发现还是得在location / 下做文章，
```nginx
        location / {
            root   /usr/share/nginx/html;
            index  index.html;
            if ($uri = /xxx) {
                rewrite ^(.*)$ /$1.html last;
                break;
            }
            try_files $uri $uri/ /index.html;
        }
```
当uri碰到需要设置的/xxx路由，做一次rewrite重新匹配，指向目录下的相应html文件，last表示``完成该rewrite规则的执行后，停止处理后续rewrite指令集；然后查找匹配改变后URI的新location``.

