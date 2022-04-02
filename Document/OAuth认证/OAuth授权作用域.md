# GitHub OAuth授权作用域

授权范围限制了token访问GitHub资源的范围。

## 1. 查询 token 的授权作用域

请求 GitHub API ，响应的header中包含了token的授权作用域

```sh
curl -H "Authorization: token OAUTH-TOKEN" https://api.github.com/users/codertocat -I
HTTP/2 200
X-OAuth-Scopes: repo, user
X-Accepted-OAuth-Scopes: user
```
- X-OAuth-Scopes

        token 的授权作用域

- X-Accepted-OAuth-Scopes

        该请求需要的授权作用域

## 2. 可以请求的授权作用域


[Available scopes](https://docs.github.com/en/developers/apps/building-oauth-apps/scopes-for-oauth-apps#available-scopes)


## 3. 请求的作用域 和 授权的作用域

一般来说，token 被授权的作用域应该与请求的作用域一致。但是，也存在用户未完全授权你请求的作用域，只授权了部分的作用域。

在授权流程之后，用户也可以修改token的作用域 `https://github.com/settings/connections/applications/:clientid`

因此需要处理调用某个域的借口，但是未授权该域的情况。

- 通知用户未授权该作用域，并调整应用的行为符合已授权的作用域

- 重新进入授权流程，获取对应的额外权限

## 4. 标准化作用域

当token请求了多个作用域，token将作用域保存在一个标准化列表中。 当授权一个新的token，这个token的某个作用域已经隐式包含其他作用域，那么被隐式包含的作用域将被废弃

例如，请求授权 `user,gist,user:email` 作用域， `user:email`将被废弃，因为`user:email`包含在`user`作用域中。




## 参考文档

[1. Scopes for OAuth Apps](https://docs.github.com/en/developers/apps/building-oauth-apps/scopes-for-oauth-apps)