---
title: hexo个性化配置
date: 2019-02-21 16:52:30
tags: hexo
categories: hexo
---

### 添加fork me on github
点击[这里(文字)](https://github.blog/2008-12-19-github-ribbons/)或者[这里(图表)](http://tholman.com/github-corners/)挑选样式,复制代码,将其粘贴到themes/next/layout/_layout.swig文件中的``<div class="headband"></div>``下面,注意不是里面,并将href改为你的github地址。

### 添加动态背景
就是你现在看到页面的背景线  
修改themes/next/_config.yml下的canvas_nest: **false**为canvas_nest: **true**

### 修改文章内链接文本样式
修改文件``themes\next\source\css\_common\components\post\post.styl``,添加css样式,如:
```
.post-body p a{
  color: #0593d3;
  border-bottom: none;
  border-bottom: 1px solid #0593d3;
  &:hover {
    color: #fc6423;
    border-bottom: none;
    border-bottom: 1px solid #fc6423;
  }
}
```
.post-body 是为了不影响标题,选择 p 是为了不影响首页“阅读全文”的显示样式,颜色可以自己定义。

### 修改文章底部tags前的#
修改模板``/themes/next/layout/_macro/post.swig``,搜索 rel="tag">#,将 # 换成 ``<i class="fa fa-tag"></i>``,需重启服务生效

### 在文章末尾统一添加“本文结束”标记
在``\themes\next\layout\_macro``下新建``passage-end-tag.swig``文件,并添加以下内容:
```
<div>
    {% if not is_index %}
        <div style="text-align:center;color: #ccc;font-size:14px;">-------------本文结束<i class="fa fa-paw"></i>感谢您的阅读-------------</div>
    {% endif %}
</div>
```
然后打开``\themes\next\layout\_macro\post.swig``文件，在post-body之后，post-footer之前添加以下代码(post-footer之前两个div):
```
<div>
  {% if not is_index %}
    {% include 'passage-end-tag.swig' %}
  {% endif %}
</div>
```
其实很好理解，在里面插入一个引入的.swig代码。最后再在根目录下的主题配置文件(_config.yml)的末尾添加:
```
# 文章末尾添加“本文结束”标记
passage_end_tag:
  enabled: true
```

### 侧边栏社交小图标设置
打开next主题配置文件``themes/next/_config.yml``，搜索``social_icons``，在[这里](https://fontawesome.com/icons?from=io)找到相应的图标，并将名字复制在如下位置，保存即可
```
social:
  GitHub: https://github.com/hyxkiller || github
  掘金: https://juejin.im/user/5a708d176fb9a01c9b663da5 || 掘金

social_icons:
  enable: true
  Github: github-square
  掘金: chevron-double-down
```
``enable: true``为控制icons是否显示属性

### 在网站底部增加访问量
在``\themes\next\layout\_partials\footer.swig``文件中，搜索copyright，在前面引入一个库：
```
<script async src="https://busuanzi.ibruce.info/busuanzi/2.3/busuanzi.pure.mini.js"></script>
```
再在当前文件下适当位置添加展示统计数据的代码：
```
<div class="powered-by">
    <i class="fa fa-user-md"></i><span id="busuanzi_container_site_uv">
    本站访问量:<span id="busuanzi_value_site_pv"></span>
    </span>
</div>
```
此处，``busuanzi_value_site_pv``为访问量，``busuanzi_value_site_uv``为访客数
添加后执行``hexo d -g``，刷新即可

### 添加热度
next主题集成``leanCloud``，打开``/themes/next/layout/_macro/post.swig``, 搜索``leancloud-visitors-count``，在这个span中加℃，然后在``/themes/next/languages/zh-Hans.yml``,将``visitors: 阅读次数``换为``热度``。

### 添加网站底部字数统计
安装hexo-wordcount
``npm install hexo-wordcount --save``
然后在``/themes/next/layout/_partials/footer.swig``文件尾部加上：
```
<div class="theme-info">
  <div class="powered-by"></div>
  <span class="post-count">博客全站共 totalcount(site) 字</span>
</div>
```
其中``totalcount(site)``需用双大括号包起来。

### 设置网站的图标Favicon
在[EasyIcon](https://www.easyicon.net/)中找一张ico图标,或者去别的网站下载或者制作，然后把图标放在/themes/next/source/images里，并且修改主题配置文件``themes/next/_config.yml``中的favicon为该文件名
```
favicon:
  small: /images/basketball.ico
  medium: /images/basketball.ico
  apple_touch_icon: /images/basketball.ico
  safari_pinned_tab: /images/basketball.ico
```

### 实现统计功能
安装hexo-wordcount
``npm install hexo-wordcount --save``
然后在主题配置文件中，修改以下配置：
```
post_wordcount:
  item_text: true
  wordcount: true
  min2read: true
```

### 添加百度统计
登录[百度统计](http://tongji.baidu.com/)，按步骤注册账号，之后把生成的baidu_analytics的key添加到``/themes/next/_config.yml``中的baidu_analytics，部署后查看是否成功。

### 添加评论功能
经过查看next第三方插件的官方文档和多个博客，最终决定采用``来必力``。
+ 注册账号
[来必力](https://www.livere.com/)
+ 将data-uid的值添加到``/themes/next/_config.yml``中的livere_uid，可在本地查看是否成功。

### 添加搜索功能
##### 安装 hexo-generator-searchdb
```
npm i hexo-generator-searchdb -S
```
##### 编辑站点配置文件(_config.yml)，新增以下内容到任意位置：
```
search:
  path: search.xml
  field: post
  format: html
  limit: 10000
```
##### 编辑主题配置文件(/themes/next/_config.yml)，启用本地搜索功能：
```
local_search:
  enable: true
```