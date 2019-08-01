
```
// 发起授权认证
OAuth: shouldStartLoadWith %@ https://github.com/login/oauth/authorize?client_id=fbd34c5a34be72f66c35&scope=user,repo,gist&state=31415

// 跳到登陆界面
OAuth: shouldStartLoadWith %@ https://github.com/login?client_id=fbd34c5a34be72f66c35&return_to=%2Flogin%2Foauth%2Fauthorize%3Fclient_id%3Dfbd34c5a34be72f66c35%26scope%3Duser%252Crepo%252Cgist%26state%3D31415

OAuth: webViewDidFinishLoad https://github.com/login?client_id=fbd34c5a34be72f66c35&return_to=%2Flogin%2Foauth%2Fauthorize%3Fclient_id%3Dfbd34c5a34be72f66c35%26scope%3Duser%252Crepo%252Cgist%26state%3D31415

// 点击登陆
OAuth: shouldStartLoadWith %@ https://github.com/session

OAuth: shouldStartLoadWith %@ https://github.com/login/oauth/authorize?client_id=fbd34c5a34be72f66c35&scope=user%2Crepo%2Cgist&state=31415

//登陆 结果
OAuth: shouldStartLoadWith %@ https://github.com/organizations/MengAndJie/CallBack?code=91448390d64c455c1406&state=31415

2019-07-09 10:37:15.035921+0800 ZLGitHubClient[1164:136617] OAuth: webViewDidFinishLoad https://github.com/organizations/MengAndJie/CallBack?code=91448390d64c455c1406&state=31415

```

```
Printing description of request:
<NSURLRequest: 0x283979fc0> { URL: https://github.com/organizations/MengAndJie?code=255d8004a3318fdfb3d5&state=31415 }
Printing description of request:
<NSURLRequest: 0x283970c50> { URL: https://github.com/orgs/MengAndJie/dashboard }
```