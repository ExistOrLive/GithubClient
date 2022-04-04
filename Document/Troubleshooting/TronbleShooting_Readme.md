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
