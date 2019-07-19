---
title: React按需加载
date: 2019-01-09 23:27:50
tags: 前端
categories: 前端
---

## 方案1
#### 文件代码
```js
import React, { Component } from "react";

export default function asyncComponent(importComponent) {
    class AsyncComponent extends Component {
        constructor(props) {
            super(props);
            this.state = {
                component: null
            };
        }

        async componentDidMount() {
            const { default: component } = await importComponent();

            this.setState({
                component: component
            });
        }

        render() {
            const Component = this.state.component;

            return Component ? <Component {...this.props} /> : null;
        }
    }
    return AsyncComponent;
}
```

#### .babelrc
```js
{
    "presets": [
        "react-app",
        "env",
        "react-native-stage-0/decorator-support"
    ]
}
```

#### 装包
+ 都是处理babel的插件
```sh
npm i babel-preset-env babel-preset-react-native-stage-0 -D
```
 
#### 组件引入
```sh
import asyncComponent from 'utils/asyncComponent'
const Home = asyncComponent(() => import('./components/home'));
```

---

## 方案2

#### 引入react-loadable

+ 好处：可监听组件加载不到的状态  
+ 应用：在不用service-worker的情况下重新部署时，如果用户之前页面没有关，跳路由时，会在服务器找不到相应的chunk文件，此时会通过监听这一状态，返回一个可以自动reload的页面