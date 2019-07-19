---
title: Flutter如何国际化
date: 2019-03-06 16:49:59
tags: flutter
categories: flutter
---

要做一个多语言的Flutter应用，有两种引入国际化的方法，一种是自定义Localizations结合Redux实现，可以做到实时切换，另一种是借助第三方工具intl，这里只介绍第一种方式（可结合上一篇状态管理一起学习）。

自定义多语言需要实现LocalizationsDelegate和Localizations，通过Localizations使用locale加载当前delegate。

+ 实现LocalizationsDelegate
```dart
class DemoLocalizationDelegate extends LocalizationsDelegate<DemoLocalizations> {
  DemoLocalizationDelegate();
  @override
  <!--支持的语言-->
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);
  
  <!--根据locale，创建一个对象用于提供当前locale下的文本显示-->
  @override
  Future<DemoLocalizations> load(Locale locale) {
    return SynchronousFuture<DemoLocalizations>(DemoLocalizations(locale));
  }
  
  @override
  bool shouldReload(DemoLocalizationDelegate old) => false;
  
  static DemoLocalizationDelegate delegate = DemoLocalizationDelegate();
}
```
DemoLocalizations为一个自定义对象，会根据创建时的Locale，
+ 实现Localizations
```dart
class DemoLocalizations {
  final Locale locale;
  DemoLocalizations(this.locale);
  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
  }

  static Map<String, LocaleBase> _localizedValues = {
    'zh': LocaleZHCN(),
    'en': LocaleENUS(),
  };

  <!--根据不同 locale.languageCode 加载不同语言对应-->
  LocaleBase get currentLocalized {
    return _localizedValues[locale.languageCode];
  }
}
```
+ 实现语言实体基类
```dart
abstract class LocaleBase {
  String title;
  String haha;
}
```
+ 实现语言实体
```dart
import 'localeBase.dart';

class LocaleZHCN extends LocaleBase {
  @override
  String title = '您好';
  @override
  String haha = '哈哈';
}
```
+ 此外，还需要创建一个Localizations的Widget，通过StoreBuilder绑定store，然后用Localizations.override包裹所有页面。将Store和Localizations的locale绑定。
```dart
class LocalizationsWidget extends StatefulWidget {
  final Widget child;
  LocalizationsWidget({this.child}) : super();

  @override
  _LocalizationsWidgetState createState() => _LocalizationsWidgetState();
}

class _LocalizationsWidgetState extends State<LocalizationsWidget> {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<HYXState>(builder: (context, store){
      return Localizations.override(
        child: widget.child,
        context: context,
        locale: store.state.locale,
      );
    });
  }
}
```
+ 最后，在相应MaterialApp中引入
```dart
import 'package:flutter_redux/flutter_redux.dart';

@override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        localizationsDelegates: [
          DemoLocalizationDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [store.state.locale],
        locale: store.state.locale,
      ),
    );
  }
```
+ 使用字段
```dart
DemoLocalizations.of(context).currentLocalized.title
```
+ 切换语言
```dart
static changeLocale(Store<HYXState> store, int index) {
    Locale locale = store.state.locale;
    switch (index) {
      case 0:
        locale = Locale('zh', 'CN');
        break;
      case 1:
        locale = Locale('en', 'US');
        break;
    }
    store.dispatch(RefreshLocaleAction(locale));
  }
```