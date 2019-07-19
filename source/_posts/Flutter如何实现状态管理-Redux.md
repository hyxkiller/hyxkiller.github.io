---
title: Flutter如何实现状态管理-Redux
date: 2019-02-25 17:58:24
tags: flutter
categories: flutter
---

从前端的角度实现Flutter状态管理自然是用Redux，至于RxDart、BLoC，暂时还未涉及。

#### 简单回忆一下Redux：
1. Store存储和管理全局State
2. Action用于定义一个State变化的行为
3. Reducer用于根据Action行为产生新State

#### 接下来开始引入并一步步实现：    
+ 需要将redux及flutter_redux两个库引入，在pubspec.yaml（相当于package.json）文件中：
    ```dart
    dependencies:
        redux: ^3.0.0
        flutter_redux: ^0.5.2
    ```
+ 根据Redux数据流走向，首先定义一个公共Store
    ```dart
    class HYXState {
        ThemeData themeData;
        Locale locale;
        <!--构造方法-->
        HYXState({this.themeData, this.locale});
    }
    存储了主题颜色和国际化语种
    ```
+ 定义Action
    ```dart
    class RefreshLocaleAction {
      final Locale locale;
      RefreshLocaleAction(this.locale);
    }
    
    class RefreshThemeDataAction {
      final ThemeData themeData;
      RefreshThemeDataAction(this.themeData);
    }
    ```
+ 定义Reducer
    ```dart
    import 'package:redux/redux.dart';
    import './actions.dart';
    
    <!--通过 flutter_redux 的 combineReducers，创建 Reducer<State> -->
    final themeDataReducer = combineReducers<ThemeData>([
      <!--将Action与处理Action的方法，用TypedReducer绑定-->
      TypedReducer<ThemeData, RefreshThemeDataAction>(_refresh),
    ]);
    
    <!--定义处理Action的方法，返回新State-->
    ThemeData _refresh(ThemeData themeData, action){
      themeData = action.themeData;
      return themeData;
    }
    
    final localeReducer = combineReducers<Locale>([
      TypedReducer<Locale, RefreshLocaleAction>(_changeLocale),
    ]);
    Locale _changeLocale(Locale locale, RefreshLocaleAction action){
      locale = action.locale;
      return locale;
    }
    ```
+ 需要定义Reducer方法appReducer（**自定义方法，用于创建store）**，将Store中的每一个参数和action绑定起来，数据流为**用户每发出一个RefreshLocaleAction，会触发器_refresh方法，之后更新HYXState中的locale**
    ```dart
    import './reducer.dart';
    
    HYXState appReducer(HYXState state, action) {
      return HYXState(
        themeData: themeDataReducer(state.themeData, action),
        locale: localeReducer(state.locale, action),
      );
    }
    ```
+ 捋清楚好上面的流程后，可以开始实例化store并使用了。类似react-redux提供的Provider包在index.js最外层一样，flutter_redux也提供了StoreProvider用于包括需要的MaterialApp外层，贴出部分重要代码。
    ```dart
    import 'package:flutter_redux/flutter_redux.dart';
    import 'package:redux/redux.dart';
    import 'package:demo1/redux/store.dart';
    
    class Home extends StatefulWidget {
      @override
      _HomeState createState() => new _HomeState();
    }
    
    class _HomeState extends State<Home> {
      <!--引入自定义的appReducer，将其余初始化state绑定-->
      final store = Store<HYXState>(appReducer,
          initialState: HYXState(
            // themeData:
            locale: Locale('zh', 'CN'),
          ));
    
      @override
      Widget build(BuildContext context) {
        return StoreProvider(
          store: store,
          child: MaterialApp(
            <!--你自己child，可以在其内部使用该store中的state-->
          ),
        );
      }
    }
    ```
+ flutter_redux提供了一个StoreConnector方法，将其包在子组件外，t通过converter转化store.state的数据，通过builder返回的组件，也可以使用StoreProvider。
    ```dart
    Widget _itemBuilder(BuildContext context, int index) {
        return StoreConnector<HYXState, Locale>(
          converter: (store) => store.state.locale,
          builder: (context, locale){
            return Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(locale.toString()),
                      width: 200,
                    ),
                  ],
                )
            );
          },
        );
    或：
    Widget build(BuildContext context) {
        return StoreBuilder<HYXState>(
          builder: (context, store) {
            return Container(
              child: Column(
                children: <Widget>[
                  Text(store.state.locale.toString()),
                ],
              ),
            );
          },
        );
      }
    ```
+ 如何触发更新？
    ```dart
    在StoreProvider中使用时，用：
    store.dispatch(RefreshLocaleAction(locale));
    ```

至此，Flutter状态管理方案之一Redux基本用法介绍结束，虽然写法比较繁琐，但定义好一套结构后，在复杂业务逻辑中使用起来还是事半功倍的。