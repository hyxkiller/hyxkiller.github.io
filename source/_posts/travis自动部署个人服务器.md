---
title: travis自动部署个人服务器
date: 2019-05-08 14:05:29
tags: [hexo, travis]
categories: travis
---

## 写在前面
自动部署githubio后，当然也得实现自动部署个人服务器。
首先，我提前先在服务器写好了nginx配置文件，将根路由指向固定目录下的文件。

## 实现原理
#### 坑
看了网上好多博客教程，大概意思是把本地的公钥放到服务器，然后会通过travis encrypt加密公钥文件，在``.travis.yml``里会自动生成一段openssl的代码，但我最终没有成功。我的想法是应该是travis部署服务和个人服务器公钥之间的关系，因为这样按那些做法做的话，如果换一台电脑还得再匹配出一份密钥。
#### 最终通过sshpass解决问题
+ 首先通过travis给服务器的用户名和密码加密(因为直接暴露ssh的用户名密码不安全，而travis提供了加密变量的功能)
```sh
travis encrypt DEPLOY_USER=yourusername
travis encrypt DEPLOY_PASS=yourpassword
```
+ 然后把生成的哈希填到``.travis.yml``文件的env里
```sh
env:
  global:
  - secure: ""
  - secure: ""
```
+ 之后脚本就可以使用变量了
```sh
after_success:
    - export SSHPASS=$DEPLOY_PASS
    - sshpass -e scp -o stricthostkeychecking=no -r public username:IP:/路径
```
``stricthostkeychecking=no``是绕过ssh远程主机公钥检查， ``-r``是上传文件夹的参数
