# ZLGitClient开发日志

> Github客户端

## 2018-12-27

- 研究[Github开发者文档][1]，GitHub的API以[GraphQL][2]的方式提供
  
  GraphQL的定义及使用，具体[参考文档][3]和[官方网站][4]

- 创建ZLGithubClient工程，引入GraphQL所需的pod库[Apollo][5]
  
  Apollo库采用Swift语言编写，因此工程需要采用OC与Swift混编的架构，具体操作参考[OC工程引入Swift代码][6]

----

## 2019-03-07

### 引入`CocoaLumberjack`日志框架

- 首先在Cocoapods中引入CocoaLumberjack

![Cocoapods 引入日志模块][7]

- 创建`ZLLogManager`类，用于封装和管理日志模块

> `ZLLogManager`类实现了`ZLLogModuleProtocol`协议，该协议定义了日志模块的外部调用方法

> 然后通过中间件`SYDCentralPivot`获取`ZLLogManager`单例,注入到`ZLToolManager`的属性`zlLogModule`

> 外部通过宏定义调用实现了`ZLLogModuleProtocol`协议的`zlLogModule`的相应方法。

这样就可以实现工具模块的解耦合


## 2019-07-15 

[github API接口][8]

## 2019-08-24

引入`MMMarkdown`,支持将markdown转换为HTML，用webview浏览

问题： 
    
    - MMMarkDown转换后的HTML效果不好
    - 使用AFNetworking，获取readme文件，后期派生AFHTTPResponseSerializer，实现在AFNetworking处理流程中将markdown转为html









[1]: https://developer.github.com
[2]: https://developer.github.com/v4/explorer/
[3]: https://segmentfault.com/a/1190000014131950
[4]: http://graphql.cn
[5]: https://github.com/apollographql/apollo-ios
[6]: ../../iOS/Swift/Swift与OC混编/OC工程引入Swift代码.md
[7]: pic/引入日志模块.png
[8]: https://developer.github.com/v3/

