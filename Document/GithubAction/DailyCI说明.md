# DailyCI.yml 说明文档

## 概述
本文件描述了ZLGithub客户端的每日持续集成（DailyCI）工作流的配置和步骤。该工作流每天自动运行，用于构建和上传应用程序到TestFlight。

## 触发条件
- **schedule**: 每天北京时间凌晨两点自动触发
- **push**: 当有代码推送到`testflight/**`分支时触发
- **workflow_dispatch**: 手动触发

## 工作流步骤

### 1. checkout

**作用**: 从GitHub仓库中检出代码。
**参数**:
- `ref`: 指定检出的分支为`master`

### 2. download secret file
**作用**: 下载密钥文件并移动到指定位置。
**工作目录**: `./ZLGitHubClient`

**环境变量**:
- `GITHUBTOKEN`: GitHub API的访问令牌

获取GitHub API的访问令牌：
1. 登录到GitHub。
2. 在右上角的头像菜单中，选择"Settings"。
3. 在左侧导航栏中，选择"Developer settings"。
4. 在"Personal access tokens"下，生成Token

**命令**:
```sh
pip3 install requests --break-system-packages
python3 DownloadSecretFile/DownloadSecrectFile.py $GITHUBTOKEN
mv ZLGithubAppKey.h ZLGitHubClient/System/ZLSupportFiles/ZLGithubAppKey.h
mv GoogleService-Info.plist ZLGitHubClient/GoogleService-Info.plist
```

### 3. construct build enviroment
**作用**: 构建项目的依赖环境。
**工作目录**: `./ZLGitHubClient`

**命令**:
```sh
gem cleanup
gem install bundler
bundle install
bundle exec pod repo update
bundle exec pod install
echo "construct build enviroment success"
```

### 4. archive and upload app
**作用**: 打包应用程序并上传到TestFlight。
**工作目录**: `./ZLGitHubClient`
**环境变量**:
- `MATCH_KEYCHAIN_NAME`: Keychain的名称，用于暂存证书
- `MATCH_KEYCHAIN_PASSWORD`: Keychain的密码
- `MATCH_GITHUB_URL`: 保存证书的GitHub仓库的URL
- `MATCH_GIT_BASIC_AUTHORIZATION`: 用于GitHub仓库的基本认证信息
- `MATCH_PASSWORD`: Match的密码，用于解密证书

match相关环境变量获取参考：[match](https://docs.fastlane.tools/actions/match/)


- `APPSTOREAPIISSUERID`: App Store Connect API的Issuer ID， 用于访问App Store Connect API
- `APPSTOREAPIKEY`: App Store Connect API的密钥
- `APPSTOREAPIKEYID`: App Store Connect API的密钥ID

获取App Store Connect API的密钥ID和密钥：

1. 登录到App Store Connect。
2. 在"用户和访问"下，选择"App Store Connect API"
3. 单击“+”创建密钥。


**命令**:
```sh
pwd
bundle exec fastlane github_action_testFlight
echo "ipa build and upload success"
```

### 5. upload github artifact
**作用**: 将构建的IPA文件上传为GitHub的Artifact。
**条件**: 仅在成功时执行
**参数**:
- `name`: Artifact的名称为`ZLGitHubClient`
- `path`: 上传的文件路径为`./ZLGitHubClient/fastlane/ipa/TestFlight`

### 6. upload dSYM to firebase
**作用**: 将dSYM文件上传到Firebase Crashlytics，用于符号化崩溃报告。
**工作目录**: `./ZLGitHubClient`
**命令**:
```sh
unzip fastlane/ipa/TestFlight/ZLGitHubClient.app.dSYM.zip -d dSYMS
find ./dSYMS -name "*.dSYM" | sed 's/\ /\\ /' | xargs Pods/FirebaseCrashlytics/upload-symbols -gsp ZLGitHubClient/GoogleService-Info.plist -p ios
```

## 参考文档
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [Fastlane 文档](https://docs.fastlane.tools)
- [Firebase Crashlytics 文档](https://firebase.google.com/docs/crashlytics)