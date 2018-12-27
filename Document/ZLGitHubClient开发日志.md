# ZLGitClient开发日志

> Github客户端

## 2018-12-27

- 研究[Github开发者文档][1]，GitHub的API以[GraphQL][2]的方式提供
  
  GraphQL的定义及使用，具体[参考文档][3]和[官方网站][4]

- 创建ZLGithubClient工程，引入GraphQL所需的pod库[Apollo][5]
  
  Apollo库采用Swift语言编写，因此工程需要采用OC与Swift混编的架构，具体操作参考[OC工程引入Swift代码][6]

----


[1]: https://developer.github.com
[2]: https://developer.github.com/v4/explorer/
[3]: https://segmentfault.com/a/1190000014131950
[4]: http://graphql.cn
[5]: https://github.com/apollographql/apollo-ios
[6]: ../../iOS/Swift/Swift与OC混编/OC工程引入Swift代码.md