---
title: hexo添加分类标签等选项
date: 2019-02-22 18:01:45
tags: hexo
categories: hexo
---

直接在主题设置文件内打开tags，categories等选项时，页面确实出现了两个选项按钮，但跳转后没有相应路由地址，需要执行``hexo new page tags``生成，成功后会提示``INFO  Created: ~/Desktop/blog/source/tags/index.md``，找到该文件，添加type: 'tags'，如
```
---
title: tags
date: 2019-02-22 17:44:17
type: 'tags'
---
```
其他类似~