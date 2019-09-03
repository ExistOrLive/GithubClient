//
//  ZLGithubHttpClient.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/12.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLGithubHttpClient.h"
#import "ZLGithubAPI.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>

// Tool
#import "ZLKeyChainManager.h"
// model
#import "ZLGithubUserModel.h"
#import "ZLGithubRepositoryModel.h"
#import "ZLGithubRequestErrorModel.h"
#import "ZLSearchResultModel.h"
#import "ZLReceivedEventModel.h"

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

#pragma mark - users

/**
 *
 * 获取当前登陆的用户信息
 **/
- (void) getCurrentLoginUserInfo:(GithubResponse) block
                    serialNumber:(NSString *) serialNumber
{
    NSString * userUrl = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,currenUserUrl];
    
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"token %@",self.token] forHTTPHeaderField:@"Authorization"];
    
    void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        ZLGithubUserModel * model = [ZLGithubUserModel getInstanceWithDic:(NSDictionary *) responseObject];
        block(YES,model,serialNumber);
    };
    
    void(^failedBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
         block(NO,nil,serialNumber);
    };
    
   [self.sessionManager GET:userUrl
                 parameters:nil
                   progress:nil
                    success:successBlock
                    failure:failedBlock];
}

/**
 * @brief 根据loginName获取指定的用户信息
 * @param loginName 登陆名
 **/
- (void) getUserInfo:(GithubResponse) block
           loginName:(NSString *) loginName
        serialNumber:(NSString *) serialNumber
{
    NSString * userUrl = [NSString stringWithFormat:@"%@%@%@",GitHubAPIURL,userInfo,loginName];
    
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"token %@",self.token] forHTTPHeaderField:@"Authorization"];
    
    void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        ZLGithubUserModel * model = [ZLGithubUserModel getInstanceWithDic:(NSDictionary *) responseObject];
        block(YES,model,serialNumber);
    };
    
    void(^failedBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        block(NO,nil,serialNumber);
    };
    
    [self.sessionManager GET:userUrl
                  parameters:nil
                    progress:nil
                     success:successBlock
                     failure:failedBlock];
}


/**
 * @brief 根据loginName和userType获取指定的组织信息
 * @param loginName 登陆名
 **/
- (void) getOrgInfo:(GithubResponse) block
          loginName:(NSString *) loginName
       serialNumber:(NSString *) serialNumber
{
    NSString * userUrl = [NSString stringWithFormat:@"%@%@%@",GitHubAPIURL,orgInfo,loginName];
    
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"token %@",self.token] forHTTPHeaderField:@"Authorization"];
    
    void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        ZLGithubUserModel * model = [ZLGithubUserModel getInstanceWithDic:(NSDictionary *) responseObject];
        block(YES,model,serialNumber);
    };
    
    void(^failedBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        block(NO,nil,serialNumber);
    };
    
    [self.sessionManager GET:userUrl
                  parameters:nil
                    progress:nil
                     success:successBlock
                     failure:failedBlock];
}


- (void) searchUser:(GithubResponse) block
            keyword:(NSString *) keyword
               page:(NSUInteger) page
           per_page:(NSUInteger) per_page
       serialNumber:(NSString *) serialNumber
{
    NSString * urlForSearchUser = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,searchUserUrl];
    
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"token %@",self.token] forHTTPHeaderField:@"Authorization"];
    
    NSDictionary * params = @{@"q":keyword,
                              @"page":[NSNumber numberWithUnsignedInteger:page],
                              @"per_page":[NSNumber numberWithUnsignedInteger:per_page]};
    
    void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        ZLSearchResultModel * resultModel = [[ZLSearchResultModel alloc] init];
        resultModel.totalNumber = [[responseObject objectForKey:@"total_count"] unsignedIntegerValue];
        resultModel.incomplete_results = [[responseObject objectForKey:@"incomplete_results"] unsignedIntegerValue];
        resultModel.data = [ZLGithubUserModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"items"]];
        block(YES,resultModel,serialNumber);
    };
    
    void(^failedBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        ZLLog_Warning(@"failedBlock: responseObject[%@]",responseObject);
        
        ZLGithubRequestErrorModel * errorModel = [ZLGithubRequestErrorModel mj_objectWithKeyValues:responseObject];
        if(errorModel == nil)
        {
            errorModel = [[ZLGithubRequestErrorModel alloc] init];
        }
        errorModel.statusCode = ((NSHTTPURLResponse *)task.response).statusCode;
        
        block(NO,errorModel,serialNumber);
    };
    
    
    [self.sessionManager GET:urlForSearchUser
                  parameters:params
                    progress:nil
                     success:successBlock
                     failure:failedBlock];
}

- (void) updateUserPublicProfile:(GithubResponse) block
                            name:(NSString *) name
                           email:(NSString *) email
                            blog:(NSString *) blog
                         company:(NSString *) company
                        location:(NSString *) location
                        hireable:(NSNumber *) hireable
                             bio:(NSString *) bio
                    serialNumber:(NSString *) serialNumber
{
    NSString * userUrl = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,currenUserUrl];
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    {
        if(name)
            [params setObject:name forKey:@"name"];
        if(email)
            [params setObject:email forKey:@"email"];
        if(blog)
            [params setObject:blog forKey:@"blog"];
        if(company)
            [params setObject:company forKey:@"company"];
        if(location)
            [params setObject:location forKey:@"location"];
        if(hireable)
            [params setObject:hireable forKey:@"hireable"];
        if(bio)
            [params setObject:bio forKey:@"bio"];
    }
    
    self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"token %@",self.token] forHTTPHeaderField:@"Authorization"];
    
    void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        ZLGithubUserModel * model = [ZLGithubUserModel getInstanceWithDic:(NSDictionary *) responseObject];
        block(YES,model,serialNumber);
    };
    
    void(^failedBlock)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) =
    ^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
    {
        block(NO,nil,serialNumber);
    };
    
    [self.sessionManager PATCH:userUrl
                    parameters:params
                       success:successBlock
                       failure:failedBlock];
    
    self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
}

#pragma mark - repositories

- (void) getRepositoriesForCurrentLoginUser:(GithubResponse) block
                                       page:(NSUInteger) page
                                   per_page:(NSUInteger) per_page
                               serialNumber:(NSString *) serialNumber
{
    NSString * urlForRepo = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,currentUserRepoUrl];
    
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"token %@",self.token] forHTTPHeaderField:@"Authorization"];
    
    NSDictionary * params = @{@"page":[NSNumber numberWithUnsignedInteger:page],
                              @"per_page":[NSNumber numberWithUnsignedInteger:per_page]};
    
    void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSArray * array = [[ZLGithubRepositoryModel mj_objectArrayWithKeyValuesArray:responseObject] copy];
        
        block(YES,array,serialNumber);
    };
    
    void(^failedBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        ZLLog_Warning(@"failedBlock: responseObject[%@]",responseObject);
        
        ZLGithubRequestErrorModel * errorModel = [ZLGithubRequestErrorModel mj_objectWithKeyValues:responseObject];
        if(errorModel == nil)
        {
            errorModel = [[ZLGithubRequestErrorModel alloc] init];
        }
        errorModel.statusCode = ((NSHTTPURLResponse *)task.response).statusCode;
        
        block(NO,errorModel,serialNumber);
    };
    
    
    [self.sessionManager GET:urlForRepo
                  parameters:params
                    progress:nil
                     success:successBlock
                     failure:failedBlock];

}





- (void) getRepositoriesForUser:(GithubResponse) block
                      loginName:(NSString*) loginName
                           page:(NSUInteger) page
                       per_page:(NSUInteger) per_page
                   serialNumber:(NSString *) serialNumber
{
    NSString * urlForRepo = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,userRepoUrl];
    urlForRepo = [NSString stringWithFormat:urlForRepo,loginName];
    
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"token %@",self.token] forHTTPHeaderField:@"Authorization"];
    
    NSDictionary * params = @{@"page":[NSNumber numberWithUnsignedInteger:page],
                              @"per_page":[NSNumber numberWithUnsignedInteger:per_page]};
    
    void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSArray * array = [[ZLGithubRepositoryModel mj_objectArrayWithKeyValuesArray:responseObject] copy];
        
        block(YES,array,serialNumber);
    };
    
    void(^failedBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        ZLLog_Warning(@"failedBlock: responseObject[%@]",responseObject);
        
        ZLGithubRequestErrorModel * errorModel = [ZLGithubRequestErrorModel mj_objectWithKeyValues:responseObject];
        if(errorModel == nil)
        {
            errorModel = [[ZLGithubRequestErrorModel alloc] init];
        }
        errorModel.statusCode = ((NSHTTPURLResponse *)task.response).statusCode;
        
        block(NO,errorModel,serialNumber);
    };
    
    
    [self.sessionManager GET:urlForRepo
                  parameters:params
                    progress:nil
                     success:successBlock
                     failure:failedBlock];
}


- (void) searchRepos:(GithubResponse) block
             keyword:(NSString *) keyword
                page:(NSUInteger) page
            per_page:(NSUInteger) per_page
        serialNumber:(NSString *) serialNumber
{
    NSString * urlForSearchUser = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,searchRepoUrl];
    
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"token %@",self.token] forHTTPHeaderField:@"Authorization"];
    
    NSDictionary * params = @{@"q":keyword,
                              @"page":[NSNumber numberWithUnsignedInteger:page],
                              @"per_page":[NSNumber numberWithUnsignedInteger:per_page]};
    
    void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        ZLSearchResultModel * resultModel = [[ZLSearchResultModel alloc] init];
        resultModel.totalNumber = [[responseObject objectForKey:@"total_count"] unsignedIntegerValue];
        resultModel.incomplete_results = [[responseObject objectForKey:@"incomplete_results"] unsignedIntegerValue];
        resultModel.data = [ZLGithubRepositoryModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"items"]];
        block(YES,resultModel,serialNumber);
    };
    
    void(^failedBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        ZLLog_Warning(@"failedBlock: responseObject[%@]",responseObject);
        
        ZLGithubRequestErrorModel * errorModel = [ZLGithubRequestErrorModel mj_objectWithKeyValues:responseObject];
        if(errorModel == nil)
        {
            errorModel = [[ZLGithubRequestErrorModel alloc] init];
        }
        errorModel.statusCode = ((NSHTTPURLResponse *)task.response).statusCode;
        
        block(NO,errorModel,serialNumber);
    };
    
    
    [self.sessionManager GET:urlForSearchUser
                  parameters:params
                    progress:nil
                     success:successBlock
                     failure:failedBlock];
}


- (void) getRepositoryInfo:(GithubResponse) block
                  fullName:(NSString *) fullName
              serialNumber:(NSString *) serialNumber
{
    NSString * urlForRepo = [NSString stringWithFormat:@"%@%@/%@",GitHubAPIURL,reposUrl,fullName];
    
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"token %@",self.token] forHTTPHeaderField:@"Authorization"];
    
    void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        ZLGithubRepositoryModel * model = [ZLGithubRepositoryModel mj_objectWithKeyValues:responseObject];
        
        block(YES,model,serialNumber);
    };
    
    void(^failedBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        ZLLog_Warning(@"failedBlock: responseObject[%@]",responseObject);
        
        ZLGithubRequestErrorModel * errorModel = [ZLGithubRequestErrorModel mj_objectWithKeyValues:responseObject];
        if(errorModel == nil)
        {
            errorModel = [[ZLGithubRequestErrorModel alloc] init];
        }
        errorModel.statusCode = ((NSHTTPURLResponse *)task.response).statusCode;
        
        block(NO,errorModel,serialNumber);
    };
    
    
    [self.sessionManager GET:urlForRepo
                  parameters:nil
                    progress:nil
                     success:successBlock
                     failure:failedBlock];
    
}



#pragma mark - followers


- (void) getFollowersForUser:(GithubResponse) block
                   loginName:(NSString*) loginName
                        page:(NSUInteger) page
                    per_page:(NSUInteger) per_page
                serialNumber:(NSString *) serialNumber
{
    NSString * urlForFollowers = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,userfollowersUrl];
    urlForFollowers = [NSString stringWithFormat:urlForFollowers,loginName];
    
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"token %@",self.token] forHTTPHeaderField:@"Authorization"];
    
    NSDictionary * params = @{@"page":[NSNumber numberWithUnsignedInteger:page],
                              @"per_page":[NSNumber numberWithUnsignedInteger:per_page]};
    
    void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSArray * array = [[ZLGithubUserModel mj_objectArrayWithKeyValuesArray:responseObject] copy];
        
        block(YES,array,serialNumber);
    };
    
    void(^failedBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        ZLLog_Warning(@"failedBlock: responseObject[%@]",responseObject);
        
        ZLGithubRequestErrorModel * errorModel = [ZLGithubRequestErrorModel mj_objectWithKeyValues:responseObject];
        if(errorModel == nil)
        {
            errorModel = [[ZLGithubRequestErrorModel alloc] init];
        }
        errorModel.statusCode = ((NSHTTPURLResponse *)task.response).statusCode;
        
        block(NO,errorModel,serialNumber);
    };
    
    
    [self.sessionManager GET:urlForFollowers
                  parameters:params
                    progress:nil
                     success:successBlock
                     failure:failedBlock];
}




#pragma mark - following

- (void) getFollowingForUser:(GithubResponse) block
                   loginName:(NSString*) loginName
                        page:(NSUInteger) page
                    per_page:(NSUInteger) per_page
                serialNumber:(NSString *) serialNumber
{
    NSString * urlForFollowing = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,userfollowingUrl];
    urlForFollowing = [NSString stringWithFormat:urlForFollowing,loginName];
    
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"token %@",self.token] forHTTPHeaderField:@"Authorization"];
    
    NSDictionary * params = @{@"page":[NSNumber numberWithUnsignedInteger:page],
                              @"per_page":[NSNumber numberWithUnsignedInteger:per_page]};
    
    void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSArray * array = [[ZLGithubUserModel mj_objectArrayWithKeyValuesArray:responseObject] copy];
        
        block(YES,array,serialNumber);
    };
    
    void(^failedBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        ZLLog_Warning(@"failedBlock: responseObject[%@]",responseObject);
        
        ZLGithubRequestErrorModel * errorModel = [ZLGithubRequestErrorModel mj_objectWithKeyValues:responseObject];
        if(errorModel == nil)
        {
            errorModel = [[ZLGithubRequestErrorModel alloc] init];
        }
        errorModel.statusCode = ((NSHTTPURLResponse *)task.response).statusCode;
        
        block(NO,errorModel,serialNumber);
    };
    
    
    [self.sessionManager GET:urlForFollowing
                  parameters:params
                    progress:nil
                     success:successBlock
                     failure:failedBlock];
}

#pragma mark - events

- (void)getReceivedEventsForUser:(NSString *)userName
                                 page:(NSUInteger)page
                             per_page:(NSUInteger)per_page
                         serialNumber:(NSString *)serialNumber
                        responseBlock:(GithubResponse)block
{
    NSString * urlForReceivedEvent = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,userReceivedEventUrl];
    urlForReceivedEvent = [NSString stringWithFormat:urlForReceivedEvent,userName];
    
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"token %@",self.token] forHTTPHeaderField:@"Authorization"];
    
    NSDictionary * params = @{@"page":[NSNumber numberWithUnsignedInteger:page],
                              @"per_page":[NSNumber numberWithUnsignedInteger:per_page]};
    
    void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSArray * array = [[ZLReceivedEventModel mj_objectArrayWithKeyValuesArray:responseObject] copy];
        
        if(array && array.count > 0)
        {
            for (ZLReceivedEventModel *eventModel in array)
            {
                NSDictionary *dic = eventModel.payload;
                if (dic.count > 0)
                {
                    if(eventModel.type == ZLReceivedEventType_PushEvent)
                    {
                        ZLPayloadModel *tempPayloadModel = [ZLPayloadModel mj_objectWithKeyValues:dic];
                        NSArray *commitArray = [ZLCommitInfoModel mj_objectArrayWithKeyValuesArray: tempPayloadModel.commits];
                        tempPayloadModel.commits = commitArray;
                        eventModel.payload = tempPayloadModel;
                    }
                    else if (eventModel.type == ZLReceivedEventType_PullRequestEvent)
                    {
                        //TODO::
                    }
                }
            }
        }
        
        block(YES,array,serialNumber);
    };
    
    void(^failedBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        ZLLog_Warning(@"failedBlock: responseObject[%@]",responseObject);
        
        ZLGithubRequestErrorModel * errorModel = [ZLGithubRequestErrorModel mj_objectWithKeyValues:responseObject];
        if(errorModel == nil)
        {
            errorModel = [[ZLGithubRequestErrorModel alloc] init];
        }
        errorModel.statusCode = ((NSHTTPURLResponse *)task.response).statusCode;

        block(NO,errorModel,serialNumber);
    };
    
    
    [self.sessionManager GET:urlForReceivedEvent
                  parameters:params
                    progress:nil
                     success:successBlock
                     failure:failedBlock];
    
    
}
@end
