---
title: flutter修改应用名及图标
date: 2019-02-20 23:41:11
tags: flutter
categories: flutter
---

#### 修改应用名及图标
+ 应用名 
1. Android  
    android -> app -> main -> AndroidManifest.xml下android.label="名字" 
2. iOS
    ios -> Runner -> info.plist下14行<string>名字</string>
+ 图标
1. Android  
    android -> app -> main -> res -> mipmap-xxx文件中更换图片 ->  AndroidManifest.xml下android.icon="@mipmap@name" 
2. iOS
    ios -> Runner -> AppIcon.appiconset下更换图片 -> Contents.json修改相应文件名
