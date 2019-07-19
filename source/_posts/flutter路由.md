---
title: flutter路由
date: 2019-02-20 23:37:03
tags: flutter
categories: flutter
---

#### 路由
1. 静态路由   
    在相应MaterialApp组件内定义Route，再在需要跳转的地方用以下方法跳转。
    ```dart
    定义：
    return MaterialApp(
      // 命名路由，无法动态传参
      routes: <String, WidgetBuilder>{
        '/search': (BuildContext context) => SearchWidget(),
      },
    );
    跳转：
    onPressed: () => Navigator.of(context).pushNamed('/search')
    或
    onPressed: () => Navigator.pushNamed(context, '/search')
    ```
2. 动态路由     
    不需要定义
    ```dart
    跳转：
    Navigator.push(context, MaterialPageRoute(builder: (_){
        return TestRoute(title: '传参');
    }));
    或
    Navigator.of(context).push(MaterialPageRoute(builder: (_){
        return TestRoute(title: '传参');
    }));
    接收：
    接收组件需为动态组件
    class TestRoute extends StatefulWidget {
        final String title; // 储存传递过来的参数
        TestRoute({this.title}); // 本页面的构造器，接收传递过来的参数
  
        @override
        _TestRouteState createState() => _TestRouteState();
    }

    class _TestRouteState extends State<TestRoute> {
        @override
        Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.title), // 使用
            ),
        );
    }
    ```
