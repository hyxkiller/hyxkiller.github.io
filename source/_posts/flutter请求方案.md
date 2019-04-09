---
title: flutter请求方案
date: 2019-02-20 23:41:36
tags: flutter
categories: flutter
---

#### 请求
1. pubspec.yaml文件中dev_dependencies下加: http: ^0.11.3+17
    ```
    dev_dependencies:
        flutter_test:
            sdk: flutter
        http: ^0.11.3+17
    ```
2. 引入     
    import 'package:http/http.dart' as http;
3. 使用
    ```
    String url = 'http://localhost:9002/tabs';
    var res = await http.get(url);
    List list = json.decode(res.body);
    setState(() {
      newTitle = list;
    });
    ```