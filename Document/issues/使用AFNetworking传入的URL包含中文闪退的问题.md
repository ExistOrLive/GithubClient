# 使用AFNetworking传入的URL包含中文闪退的问题

在使用AFNetworking的过程，如果像AFNetworking传入一个包含中文字符的URL串，这时候应用会闪退报错。

例如传入以下的URL 

```
https://api.github.com/repos/longxiaochi/Algorithm/contents/eclipse-workspace/01-复杂度

```

URL串在传递给AFNetworking时已经是一个包含协议名，主机名以及路径的完整URL，此时AFNetworking不会对URL串中的非法字符进行`Percent Encoding`。因此AFNetworking无法解释包含非法字符的URL串，就会报错。


## 解决办法：

`Percent Encoding`需要在URL的各个组件组合之前执行。因此对URL的各个组件执行以下方法。

```objc
- (nullable NSString *)stringByAddingPercentEncodingWithAllowedCharacters:(NSCharacterSet *)allowedCharacters;
```
## 参考文档

[HTTP URL Percent Encoding and Decoding ](https://github.com/ExistOrLive/DocumentForLearning/blob/master/%E8%AE%A1%E7%AE%97%E6%9C%BA%E7%BD%91%E7%BB%9C/HTTP/HTTP-URL.md)




