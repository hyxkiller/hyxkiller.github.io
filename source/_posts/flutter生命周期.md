---
title: flutter生命周期
date: 2019-02-20 23:40:50
tags: flutter
categories: flutter
---

#### 生命周期
阶段 | 调用次数 | 是否支持setState
--- | --- | ---
constructor | 1 | 否
initState | 1 | 无效
didChangeDependencies | >=1 | 无效
didUpdateWidget| >=1 | 无效
deactivate | >=1 | 否
dispose | 1 | 否
