---
title: React多页面应用如何配置
date: 2019-01-09 23:30:29
tags: 前端
categories: 前端
---

#### 修改webpack.config文件    
主要是entry(入口), output(出口), plugin(插件)   
+ entry换为对象，有几个页面加几个数组         
    ```
    entry: {
        home: [
            require.resolve('./polyfills'),
            require.resolve('react-dev-utils/webpackHotDevClient'),
            path.resolve(paths.appSrc, "index.js")
        ],
        login: [
            require.resolve('./polyfills'),
            require.resolve('react-dev-utils/webpackHotDevClient'),
            path.resolve(paths.appSrc, "login/index.js")
        ],
        register: [
            require.resolve('./polyfills'),
            require.resolve('react-dev-utils/webpackHotDevClient'),
            path.resolve(paths.appSrc, "register/index.js")
        ],
    }
    ```
+ output输出文件名加一层
    ```
    output: {
        filename: 'static/js/[name].[hash:8].js',
        chunkFilename: 'static/js/[name].[hash:8].chunk.js',
    }
    ```
+ plugin把所有页面都用webpackHtmlPlugin解析
    ```
    new HtmlWebpackPlugin({
      inject: true,
      chunks: ['home'],
      template: paths.appHtml,
      filename: 'home.html'
    }),
    new HtmlWebpackPlugin({
      inject: true,
      chunks: ['login'],
      template: paths.appHtml,
      filename: 'login.html'
    }),
    new HtmlWebpackPlugin({
      inject: true,
      chunks: ['register'],
      template: paths.appHtml,
      filename: 'register.html'
    }),
    ```