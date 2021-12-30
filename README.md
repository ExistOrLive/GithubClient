# ZLGithubClient
![ZLGithub TestFlight](https://github.com/MengAndJie/GithubClient/workflows/ZLGithub%20TestFlight/badge.svg)
![language](https://img.shields.io/github/languages/top/existorlive/githubclient)
![CodeSize](https://img.shields.io/github/languages/code-size/existorlive/GitHubClient)
![license](https://img.shields.io/github/license/existorlive/githubclient)
![commit](https://img.shields.io/github/last-commit/mengandjie/githubclient)
![stars](https://img.shields.io/github/stars/existorlive/githubclient)

## Github iOS 客户端  by Existorlive

<div><a href="https://apps.apple.com/app/gorillas/id1498787032"><img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/appstoredownload.png" width=150></a></div>

- Objective-c 2.0
- Swift 5 
- Cocoapods 1.9.1
- iOS >= 11.0

基于 [Github REST V3 API](https://docs.github.com/en/rest) 和 [Github GraphQL V4 API](https://docs.github.com/en/free-pro-team@latest/graphql) 开发的iOS客户端。目前支持以下的功能：

- 支持 Github OAuth 登录和 Access Token 登录
- 查询和修改登录用户的 profile
- 查看登录用户的 repositories，gists，followers，following
- 查看 repositories 和 users 的趋势榜
- 根据关键字搜索 repositories 和 users，支持 advanced search
- 支持 watch，star 以及 fork 指定的 repository；支持 follow 指定的用户
- 查看指定 repository 的 commit，branch，language，pull request 以及 issues 等
- 支持简单查阅 repository 的代码
- 支持查阅 Notification

## 寻求志同道合的合作开发者，若有意请联系<a src="2068531506@qq.com">2068531506@qq.com</a>

#### Github OAuth login and Access Token login 

<div align="left">
<img src="https://gitee.com/zxhubs/git-hub-client-material/raw/master/GitHubClientMaterial/001.jpeg"/>
</div>

#### Workboard 

<div align="left">
<img src="https://gitee.com/zxhubs/git-hub-client-material/raw/master/GitHubClientMaterial/002.jpeg"/>
</div>


#### Notification 

<div align="left">
<img src="https://gitee.com/zxhubs/git-hub-client-material/raw/master/GitHubClientMaterial/003.jpeg"/>
</div>


#### Trending 

<div align="left">
<img src="https://gitee.com/zxhubs/git-hub-client-material/raw/master/GitHubClientMaterial/004.jpeg"/>
</div>

#### Profile

<div align="left">
<img src="https://gitee.com/zxhubs/git-hub-client-material/raw/master/GitHubClientMaterial/005.jpeg"/>
</div>

#### Search

<div align="left">
<img src="https://gitee.com/zxhubs/git-hub-client-material/raw/master/GitHubClientMaterial/006.jpeg"/>
</div>

#### User Info

<div align="left">
<img src="https://gitee.com/zxhubs/git-hub-client-material/raw/master/GitHubClientMaterial/007.jpeg"/>
</div>


#### Repository Info

<div align="left">
<img src="https://gitee.com/zxhubs/git-hub-client-material/raw/master/GitHubClientMaterial/008.jpeg"/>
</div>



#### View markdown and code 

<div align="left">
<img src="https://gitee.com/zxhubs/git-hub-client-material/raw/master/GitHubClientMaterial/009.jpeg"/>
</div>
<div align="left">
<img src="https://gitee.com/zxhubs/git-hub-client-material/raw/master/GitHubClientMaterial/010.jpeg"/>
</div>

## Trend Repositories Widget

<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_4547.PNG" width="300"/>

## Contributions Widget

<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_4552.PNG" width="300"/>


## 新手使用 GitHubClient 源码使用指南

> 在使用源码前，需要 Github 的账户下创建一个 OAuth Application，具体请参考官方文档 [Creating an OAuth App](https://docs.github.com/en/developers/apps/creating-an-oauth-app)

> 创建 OAuth Application 后，获得`Client ID` 和 `Client Secret`。打开工程下`ZLGithubAppKey.h`文件，替换宏`MyClientID` 和 `MyClientSecret`

步骤一、clone 源码之后，在你的 Mac 上安装 CocoaPods。

步骤二、打开 `终端`，切换到工程文件的目录下。比如你的工程文件下载到了 Mac 的桌面上，在 `终端` app 中输入`cd /User/admin（替换你自己的电脑用户名）/Desktop/GithubClient-master/ZLGitHubClient`。

步骤三、输入 `pod install` 安装工程所依赖的库。显示如下即安装成功。
<div align="left">
<img src="https://gitee.com/zxhubs/git-hub-client-material/raw/master/GitHubClientMaterial/pod_install.jpg" width="450"/>
</div>

步骤四、在 Xcode 中打开运行本工程文件，请注意⚠️打开的是 `ZLGitHubClient.xcworkspace` 并非是 `ZLGitHubClient.xcodeproj`，请务必注意后缀。恭喜成功运行了👏👏👏。

## 常见问题解答
>  在上述指南中可能会遇到的一些疑惑。
- Q：CocoaPods 是什么？
A：CocoaPods 是 macOS 和 iOS 平台非常流行的包管理工具，用来帮助我们管理第三方依赖库的工具。通过调用第三方库，可以用于拓展软件的功能。
---
- Q：为什么需要 CocoaPods？
A：在实际开发过程中避免不了去使用第三方的库，所以会使用到 CocoaPods。pod 是由 ruby 语言编写的，是记录引用库的名称，执行 `pod install` 即在把远程仓库下载至本地。
---
- Q：在使用 `pod install` 命令时速度过慢？
A：解决方案之一可以采取科学上网的方式。举例：采取代理，给 git 设置全局代理，在终端输入命令 `git config --global http.proxy socks5://127.0.0.1:7890` 其中 socks5 的的端口号为你所使用代理的端口号，本演示的端口号是 7890，请注意替换 7890。如果需要移除上述全局代理请在终端输入命令 `git config --global --unset http.proxy`。
---
- Q：在使用 `Podfile` 文件是什么？
A：用于描述一个或多个 `Xcode Project` 中各个 `Targets` 之间的依赖关系
---
- Q：在使用 `Lockfile` 文件是什么？
A：用于记录最后一次 CocoaPods 所安装的 Pod 依赖库版本的信息快照。生成的 Podfile.lock。在 pod install 过程，Podfile 会结合它来确认最终所安装的 Pod 版本。
---
- Q：xcworkspace 和 xcodeproj 的区别？
A：xcodeproj bundle 内包含 project.workspace。而当我们通过 pod install 命令添加 Pod 依赖后，Xcode 工程目录下会多出 .workspace，它是 Xcodeproj 替我们生成的，用于管理当前的 .project 与 Pods.pbxproj。
---
pod install 执行过程思维导图
<div align="left">
<img src="https://gitee.com/zxhubs/git-hub-client-material/raw/master/GitHubClientMaterial/podinstall.jpg" width="550"/>
</div>

## 结语
普通的代码千篇一律，优秀的代码万里挑一。开源就如星星之火正在燎原，本项目是开源世界中小小一隅，如果有感兴趣的开发者欢迎加入。
