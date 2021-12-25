# Github OAuth 授权流程

ZLGithubClient 作为三方应用，在访问用户的 GitHub 资源资源之前，需要获得用户授权。GitHub 使用 OAuth 授权方式，这是一个关于授权的开放网络标准，收到广泛应用，目前版本是 OAuth2.0.

关于 OAuth2.0 的内容，请参考 [阮一峰的网络日志: 理解OAuth 2.0](https://www.ruanyifeng.com/blog/2014/05/oauth_2_0.html) 和 [RFC6749: The OAuth 2.0 Authorization Framework](https://datatracker.ietf.org/doc/html/rfc6749#section-4.2)


## 1. 在 GitHub 创建上创建 OAuth App

首先我们在GitHub上注册一个OAuth App，具体请参考 [Creating an OAuth App](https://docs.github.com/en/developers/apps/building-oauth-apps/creating-an-oauth-app)

注册 App 时,填写的 `Authorization callback URL` 将用于之后 OAuth 授权流程。

![](https://gitee.com/existorlive/exist-or-live-pic/raw/master/202112251815419.png)


注册 OAuth App 后，将得到 `Client ID` 和 `Client secret`。 这两个字符串将用于之后 OAuth 授权流程。

![](https://gitee.com/existorlive/exist-or-live-pic/raw/master/202112251805243.png)

## 2. Github OAuth 流程

Github的OAuth实现支持标准的**授权码授权类型([authorization code grant type](https://datatracker.ietf.org/doc/html/rfc6749#section-4.1))** 和 **设备授权类型([Device Authorization Grant](https://tools.ietf.org/html/rfc8628))**

具体请参考 [GitHub Document: Authorizing OAuth Apps](https://docs.github.com/en/developers/apps/building-oauth-apps/authorizing-oauth-apps#web-application-flow)

### 2.1 Web application flow (授权码授权类型)

1. 请求用户Github ID

   - URL:
     
         GET https://github.com/login/oauth/authorize

   - 参数：
     
      -  **client_id** : 
      
          **必须** 注册OAuth App时得到的`Client ID`

      -  **redirect_uri**

          **必须** 授权成功后重定向的地址

      -  **login**

           指定的登陆账号

      -  **scope**

           授权范围

      -  **state**
           
           随机数，用于防护跨域攻击

      -  **allow_signup**

            授权未成功是否进入注册流程

    **Tip**：
        
        当使用了login参数, 当弹出登陆页面时会自动填入登录账号

2. 需要登陆：重定向至GitHub登陆页

         https://github.com/login


3. 授权成功： 重定向至 redirect_uri

     授权成功后会重定向到redirect_uri，url带两个参数`code`和`state`。 `state` 是第一步的随机数参数，需要检验是否匹配；`code` 是临时码，用于获取 `access token`

4. 获取 access token

   - url

         POST https://github.com/login/oauth/access_token

   - 请求参数：

      - **client_id** 
         
          **必须** 注册app时获得的 `Client ID`

      - **client_secret** 
      
          **必须** 注册app时获得的 `Client secret`

      - **code** ： 

          **必须** 授权成功返回的 code

      - **redirect_uri**:  

    - 返回参数

      -  **access_token**

      -  **scope**
 
      -  **token_type**
        
5. 使用 Access Token 调用 Github API

       Authorization: token OAUTH-TOKEN
       GET https://api.github.com/user
    
### 2.2 Device Flow (设备授权类型)

> Device Flow 处于公开测试阶段，有可能修改

1. 请求设备和用户验证码

   - url

        POST https://github.com/login/device/code

   - 请求参数：

      - **client_id** 
         
          **必须** 注册app时获得的 `Client ID`

      - **scope**
          
          授权范围

    - 返回参数

      -  **device_code**
          
             40位设备码 用于验证设备
           
      -  **user_code**

             8位用户验证码，
 
      -  **verification_uri**

             https://github.com/login/device

      -  **expires_in**
          
             验证码超时时间，默认900秒

      -  **interval**

             请求access token的时间间隔，默认5秒；发出`POST https://github.com/login/oauth/access_token`之前必须经过5s

2. 提示用户在浏览器中输入用户验证码
  
       https://github.com/login/device

     ![](https://gitee.com/existorlive/exist-or-live-pic/raw/master/202112252220219.png)

3. 需要登陆：重定向至GitHub登陆页

         https://github.com/login

4. 登录成功: 重定向至输入用户码验证码页面

       输入验证码，验证成功，重定向至 https://github.com/login/success

5. 轮询获取 access token
  
   验证码验证成功，需要轮询发出请求，获取 access token。直到验证超时(`expires_in`)或者成功获取到 token。发出的请求的时间间隔必须不小于第一步返回的 `interval`

   - url

         POST https://github.com/login/oauth/access_token

   - 请求参数：

      - **client_id** 
         
          **必须** 注册app时获得的 `Client ID`

      - **device_code** 
      
          **必须** 第一步获取的 device_code

      - **grant_type** ： 

          **必须** `urn:ietf:params:oauth:grant-type:device_code`

    - 返回参数

      -  **access_token**

      -  **scope**
 
      -  **token_type**

[Error codes for the device flow](https://docs.github.com/en/developers/apps/building-oauth-apps/authorizing-oauth-apps#errors-for-the-device-flow)


  
![](https://gitee.com/existorlive/exist-or-live-pic/raw/master/202112252341960.png)



## 3. 授权多个token

基于 user-app-scope 的组合，用户可以创建多个token。
每个user-app-scope组合，可以创建最多10个token。当新的创建后，旧的将被废弃掉。

例如，用于可以创建一个token仅用于登陆和获取基本的用户信息，另一个token用于访问用户的私有仓库。 






## 参考文档


[1. GitHub Document: Authorizing OAuth Apps](https://docs.github.com/en/developers/apps/building-oauth-apps/authorizing-oauth-apps#web-application-flow)

[2. 阮一峰的网络日志: 理解OAuth 2.0](https://www.ruanyifeng.com/blog/2014/05/oauth_2_0.html)

[3. RFC6749: The OAuth 2.0 Authorization Framework](https://datatracker.ietf.org/doc/html/rfc6749#section-4.2)

