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

基于[Github REST V3 API](https://docs.github.com/en/rest)和[Github GraphQL V4 API](https://docs.github.com/en/free-pro-team@latest/graphql)开发的iOS客户端。目前支持以下的功能：

- 支持Github OAuth登录 和 Access Token 登录
- 查询和修改登录用户的profile
- 查看登录用户的repositories，gists，followers，following
- 查看repositories和users的趋势榜
- 根据关键字搜索repositories和users，支持advanced search
- 支持watch，star以及fork 指定的repository；支持follow指定的用户
- 查看指定repository的commit，branch，language，pull request以及issues等
- 支持简单查阅repository的代码
- 支持查阅Notification

## 寻求志同道合的合作开发者，若有意请联系<a src="2068531506@qq.com">2068531506@qq.com</a>

#### Github OAuth login and Access Token login

<div align="left">
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_4824.PNG" width="200"/>
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_4823.PNG" width="200"/>
</div>

#### Workboard

<div align="left">
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_4245.PNG" width="200"/>
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_4244.PNG" width="200"/>

</div>


#### Notification

<div align="left">
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_3783.JPG" width="200"/>
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_4070.PNG" width="200"/>

</div>


#### Trending 

<div align="left">
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_3785.JPG" width="200"/>
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_4072.PNG" width="200"/>
</div>

#### Profile

<div align="left">
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_4546.PNG" width="200"/>
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_4545.PNG" width="200"/>
</div>

#### Search

<div align="left">
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_3786.JPG" width="200"/>
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_4074.PNG" width="200"/>
</div>

#### User Info

<div align="left">
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_3788.JPG" width="200"/>
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_4083.PNG" width="200"/>
</div>


#### Repository Info

<div align="left">
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_3789.JPG" width="200"/>
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_4075.PNG" width="200"/>

</div>

<div align="left">
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_3790.JPG" width="200"/>
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_4077.PNG" width="200"/>
</div>





#### View markdown and code 

<div align="left">
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_3792.JPG" width="200"/>

<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_3791.JPG" width="400"/>
</div>

<div align="left">
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_4080.PNG" width="200"/>
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_4082.PNG" width="400"/>
</div>

<div align="left">
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_3794.JPG" width="200"/>
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_3793.JPG" width="400"/>
</div>

<div align="left">
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_4078.PNG" width="200"/>
<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_4079.PNG" width="400"/>
</div>

## Trend Repositories Widget

<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_4547.PNG" width="300"/>

## Contributions Widget

<img src="https://gitee.com/existorlive/exist-or-live-pic/raw/master/IMG_4552.PNG" width="300"/>


## 如何使用GithubClient源码

1. 在使用源码前，需要Github的账户下创建一个OAuth Application，具体请参考官方文档[Creating an OAuth App](https://docs.github.com/en/developers/apps/creating-an-oauth-app)

2. 创建OAuth Application后，获得`Client ID` 和 `Client Secret`。打开工程下`ZLGithubAppKey.h`文件，替换宏`MyClientID` 和 `MyClientSecret`

3. 在工程ZLGithubClient目录下，执行`pod install` 安装工程依赖的库

4. 在 Xcode中运行工程










