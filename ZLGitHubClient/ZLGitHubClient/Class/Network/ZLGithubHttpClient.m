//
//  ZLGithubHttpClient.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/12.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLGithubHttpClient.h"
#import <AFNetworking/AFNetworking.h>

// Tool
#import "ZLKeyChainManager.h"
// model
#import "ZLGithubUserModel.h"

#define MyClientID          @"fbd34c5a34be72f66c35"
#define MyClientSecret      @"02e5eb8a2805f6492d3d1ff7c5a618d73e1edb35"
#define OAuthState          @"31415"
#define OAuthScope          @"user,repo,gist"

#pragma mark - OAuth 相关接口

#define GitHubMainURL       @"https://github.com"

#define OAuthAuthorizeURL       @"https://github.com/login/oauth/authorize"
#define OAuthLoginURL           @"https://github.com/login"
#define OAuthHomePageURL        @"https://github.com/organizations/MengAndJie/Home"
#define OAuthCallBackURL        @"https://github.com/organizations/MengAndJie/CallBack"
#define OAuthAccessTokenURL     @"https://github.com/login/oauth/access_token"

#pragma mark - github业务接口

#define GitHubAPIURL @"https://api.github.com"

#define currenUserUrl @"/user"


@interface ZLGithubHttpClient()

@property (nonatomic, strong) AFHTTPSessionManager * sessionManager;

@property (nonatomic, strong) NSURLSessionConfiguration * httpConfig;

@property (nonatomic, copy) void(^ loginBlock)(NSURLRequest * _Nullable request,BOOL isNeedContinuedLogin,BOOL success);

@property (nonatomic, strong) NSString * token;

@end

@implementation ZLGithubHttpClient

+ (instancetype) defaultClient
{
    static ZLGithubHttpClient * client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[ZLGithubHttpClient alloc] init];
    });
    
    return client;
}

- (instancetype) init
{
    if(self = [super init])
    {
        _httpConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:_httpConfig];
        
        // 处理success，failed的队列
        _sessionManager.completionQueue = dispatch_queue_create("AFURLSessionManagerCompleteQueue", DISPATCH_QUEUE_SERIAL);
        
    }
    return self;
}

/**
 *
 * OAuth 认证
 **/
- (void) startOAuth:(void(^)(NSURLRequest * _Nullable request,BOOL isNeedContinuedLogin,BOOL success)) block
{
    // 保持loginBlock
    self.loginBlock = block;
    
    NSString * urlStr = [NSString stringWithFormat:@"%@?client_id=%@&scope=%@&state=%@",OAuthAuthorizeURL,MyClientID,OAuthScope,OAuthState];
    
    __weak typeof(self) weakSelf = self;
    [self.sessionManager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nullable(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request) {
        
        if(![task.originalRequest.URL.absoluteString isEqualToString:urlStr])
        {
            return request;
        }
        
        if([request.URL.absoluteString hasPrefix:OAuthLoginURL])
        {
             // 需要输入密码登陆
             weakSelf.loginBlock(request,YES,NO);
             return nil;
        }
        else if([request.URL.absoluteString hasPrefix:OAuthCallBackURL])
        {
            // OAuth 收到结果，接下来获取token
            [weakSelf getAccessToken:request.URL.query];
            return nil;
        }
        
        return request;
    }];
    
    self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [self.sessionManager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse * response = (NSHTTPURLResponse*)task.response;
      
        if(!NSLocationInRange(response.statusCode, NSMakeRange(100, 300)))
        {
            weakSelf.loginBlock(task.currentRequest, NO, NO);
        }
    }];
    
}


- (void) getAccessToken:(NSString *) queryString
{
    if(![queryString containsString:@"code"] || ![queryString containsString:@"state"])
    {
        ZLLog_Error(@"queryString = %@, code or state not exist",queryString);
        return;
    }
    
    NSString * code = nil;
    NSString * state = nil;
    
    NSArray * entrys = [queryString componentsSeparatedByString:@"&"];
    
    for(NSString * entry in entrys)
    {
        NSArray * tmpArray = [entry componentsSeparatedByString:@"="];
        if([tmpArray.firstObject isEqualToString:@"code"])
        {
            code = tmpArray.lastObject;
        }
        if([tmpArray.firstObject isEqualToString:@"state"])
        {
            state = tmpArray.lastObject;
        }
    }
    
    if(![state isEqualToString:OAuthState])
    {
        ZLLog_Error(@"queryString = %@, statet is not match",queryString);
        return;
    }
    
    NSDictionary * params = @{@"client_id":MyClientID,@"client_secret":MyClientSecret,@"code":code,@"state":state};
   
    self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 设置接受的格式，否则默认body是以查询字符串的格式
    [self.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    __weak typeof(self) weakSelf = self;
    void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSDictionary * dic = (NSDictionary *) responseObject;
        weakSelf.token = [dic objectForKey:@"access_token"];
        [[ZLKeyChainManager sharedInstance] updateUserAccount:nil withAccessToken:weakSelf.token];
        weakSelf.loginBlock(task.currentRequest, NO, YES);
    };
    
    void(^failedBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        weakSelf.loginBlock(task.currentRequest, NO, NO);
    };
    
    [self.sessionManager POST:OAuthAccessTokenURL
                   parameters:params
                     progress:nil
                      success:successBlock
                      failure:failedBlock];
    
}



/**
 *
 * 获取当前登陆的用户信息
 **/
- (void) getCurrentLoginUserInfo:(void(^)(BOOL,ZLGithubUserModel *)) block
{
    NSString * userUrl = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,currenUserUrl];
    
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"token %@",self.token] forHTTPHeaderField:@"Authorization"];
    
    void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        ZLGithubUserModel * model = [ZLGithubUserModel getInstanceWithDic:(NSDictionary *) responseObject];
        block(YES,model);
    };
    
    void(^failedBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        block(NO,nil);
    };
    
   [self.sessionManager GET:userUrl
                 parameters:nil
                   progress:nil
                    success:successBlock
                    failure:failedBlock];
}

@end
