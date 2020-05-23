//
//  ZLGithubHttpClient.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/12.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLGithubHttpClient.h"
#import "ZLGithubAPI.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <MJExtension/MJExtension.h>

// Tool
#import "ZLSharedDataManager.h"
#import "NSDate+localizeStr.h"
// model
#import "ZLGithubUserModel.h"
#import "ZLGithubRepositoryModel.h"
#import "ZLGithubRequestErrorModel.h"
#import "ZLSearchResultModel.h"
#import "ZLGithubEventModel.h"
#import "ZLLoginProcessModel.h"
#import "ZLGithubRequestErrorModel.h"
#import "ZLGithubGistModel.h"
#import "ZLGithubRepositoryReadMeModel.h"
#import "ZLGithubPullRequestModel.h"
#import "ZLGithubCommitModel.h"
#import "ZLGithubRepositoryBranchModel.h"
#import "ZLGithubContentModel.h"
#import "ZLGithubIssueModel.h"

static NSString * ZLGithubLoginCookiesKey = @"ZLGithubLoginCookiesKey";

@interface ZLGithubHttpClient()

@property (nonatomic, strong) AFHTTPSessionManager * sessionManager;

@property (nonatomic, strong) NSURLSessionConfiguration * httpConfig;

@property (nonatomic, strong) NSString * token;

@property (nonatomic, copy) void(^ loginBlock)(NSURLRequest * _Nullable request,BOOL isNeedContinuedLogin,BOOL success);


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
        // 通知github返回的数据是json格式
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [_sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];

        // 处理success，failed的队列,不要抛到主线程
        _sessionManager.completionQueue = dispatch_queue_create("AFURLSessionManagerCompleteQueue", DISPATCH_QUEUE_SERIAL);
        
        // 获取用户token
        _token = [[ZLSharedDataManager sharedInstance] githubAccessToken];
        
    }
    return self;
}


#pragma mark -

- (void) GETRequestWithURL:(NSString *) URL WithParams:(NSDictionary *) params WithResponseBlock:(GithubResponse) block serialNumber:(NSString *) serialNumber{
    [self requestWithMethod:@"GET"
                    withURL:URL
                 WithParams:params
          WithResponseBlock:block
               serialNumber:serialNumber];
}


- (void) POSTRequestWithURL:(NSString *) URL WithParams:(NSDictionary *) params WithResponseBlock:(GithubResponse) block serialNumber:(NSString *) serialNumber{
    [self requestWithMethod:@"POST"
                    withURL:URL
                 WithParams:params
          WithResponseBlock:block
               serialNumber:serialNumber];
}


- (void) requestWithMethod:(NSString *)method
                   withURL:(NSString *) URL
                WithParams:(NSDictionary *) params
         WithResponseBlock:(GithubResponse) block
              serialNumber:(NSString *) serialNumber{
    
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"token %@",self.token] forHTTPHeaderField:@"Authorization"];
    
    void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        block(YES,responseObject,serialNumber);
    };
    
    void(^failedBlock)(NSURLSessionDataTask * _Nonnull task, NSError *  _Nonnull error) =
    ^(NSURLSessionDataTask * _Nonnull task, NSError *  _Nonnull error)
    {
        ZLGithubRequestErrorModel * model = [[ZLGithubRequestErrorModel alloc] init];
        model.statusCode = ((NSHTTPURLResponse *)task.response).statusCode;
        model.message = error.localizedDescription;
        ZLLog_Warning(@"response error [%@]",model);
        
        block(NO,model,serialNumber);
        
        if(model.statusCode == 401)
        {
            // token 过期失效
            ZLMainThreadDispatch([[NSNotificationCenter defaultCenter] postNotificationName:ZLGithubTokenInvalid_Notification object:nil];)
            
        }
    };
    
    if([@"POST" isEqualToString:method]) {
        [self.sessionManager POST:URL
                       parameters:params
                         progress:nil
                          success:successBlock
                          failure:failedBlock];
    } else if([@"GET" isEqualToString:method]) {
        
        [self.sessionManager GET:URL
                      parameters:params
                        progress:nil
                         success:successBlock
                         failure:failedBlock];
        
    } else if([@"DELETE" isEqualToString:method]) {
        
        [self.sessionManager DELETE:URL
                         parameters:params
                            success:successBlock
                            failure:failedBlock];
        
    } else if([@"PUT" isEqualToString:method]) {
        
        [self.sessionManager PUT:URL
                      parameters:params
                         success:successBlock
                         failure:failedBlock];
        
    }
}


#pragma mark - OAuth

/**
 *
 * OAuth 认证
 **/
- (void) startOAuth:(GithubResponse) block
       serialNumber:(NSString *) serialNumber
{
    NSString * urlStr = [NSString stringWithFormat:@"%@?client_id=%@&scope=%@&state=%@",OAuthAuthorizeURL,MyClientID,OAuthScope,OAuthState];
    
    __weak typeof(self) weakSelf = self;
    [self.sessionManager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nullable(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request) {
        
        if(![task.originalRequest.URL.absoluteString isEqualToString:urlStr])
        {
            return request;
        }
        
        // 需要输入密码登陆
        if([request.URL.absoluteString hasPrefix:OAuthLoginURL])
        {
            ZLLoginProcessModel * loginProcessModel = [[ZLLoginProcessModel alloc] init];
            loginProcessModel.result = YES;
            loginProcessModel.loginStep = ZLLoginStep_logining;
            loginProcessModel.loginRequest = request;
            loginProcessModel.serialNumber = serialNumber;
            block(YES, loginProcessModel, serialNumber);
            return nil;
        }
        // 获取token
        else if([request.URL.absoluteString hasPrefix:OAuthCallBackURL])
        {
            ZLLoginProcessModel * loginProcessModel = [[ZLLoginProcessModel alloc] init];
            loginProcessModel.result = YES;
            loginProcessModel.loginStep = ZLLoginStep_getToken;
            loginProcessModel.serialNumber = serialNumber;
            block(YES, loginProcessModel, serialNumber);
            
            // OAuth 收到结果，接下来获取token
            [weakSelf getAccessToken:block queryString:request.URL.query serialNumber:serialNumber];
            return nil;
        }
        
        return request;
    }];
    

        
    [self.sessionManager GET:urlStr
                  parameters:nil
                    progress:nil
                     success:nil
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse * response = (NSHTTPURLResponse*)task.response;
        if(!NSLocationInRange(response.statusCode, NSMakeRange(100, 300)))
        {
            ZLLoginProcessModel * processModel = [[ZLLoginProcessModel alloc] init];
            processModel.result = false;
            processModel.loginStep = ZLLoginStep_checkIsLogined;
            processModel.serialNumber = serialNumber;
            block(NO,processModel,serialNumber);
        }
        
    }];
    
}


- (void) getAccessToken:(GithubResponse) block
            queryString:(NSString *) queryString
           serialNumber:(NSString *) serialNumber
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
    
    __weak typeof(self) weakSelf = self;
    void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSDictionary * dic = (NSDictionary *) responseObject;
        weakSelf.token = [dic objectForKey:@"access_token"];
        [[ZLSharedDataManager sharedInstance] setGithubAccessToken:weakSelf.token];
        
        ZLLoginProcessModel * processModel = [[ZLLoginProcessModel alloc] init];
        processModel.result = YES;
        processModel.loginStep = ZLLoginStep_Success;
        processModel.serialNumber = serialNumber;
        block(YES,processModel,serialNumber);
    };
    
    void(^failedBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) =
    ^(NSURLSessionDataTask * _Nonnull task, NSError *  error)
    {
        ZLLoginProcessModel * processModel = [[ZLLoginProcessModel alloc] init];
        processModel.result = false;
        processModel.loginStep = ZLLoginStep_getToken;
        processModel.serialNumber = serialNumber;
        block(NO,processModel,serialNumber);
    };
    
    [self.sessionManager POST:OAuthAccessTokenURL
                   parameters:params
                     progress:nil
                      success:successBlock
                      failure:failedBlock];
    
}



- (void) logout:(GithubResponse) block
   serialNumber:(NSString *) serialNumber
{
    NSArray * types = @[WKWebsiteDataTypeCookies,WKWebsiteDataTypeSessionStorage];
    NSSet * set = [NSSet setWithArray:types];

    NSDate * date = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:set modifiedSince:date completionHandler:^{}];

    NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:GitHubMainURL]];
    for(NSHTTPCookie * cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }

    // 注销成功，清空用户token和信息
    self.token = nil;
    [[ZLSharedDataManager sharedInstance] clearGithubTokenAndUserInfo];
    
    block(YES,nil,serialNumber);
    
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
    
    GithubResponse newResponse = ^(BOOL result,id _Nullable responseObject,NSString * _Nonnull serailNumber){
        
        if(result)
        {
            responseObject = [ZLGithubUserModel getInstanceWithDic:responseObject];
        }
        block(result,responseObject,serialNumber);
    };
    
    [self GETRequestWithURL:userUrl
                 WithParams:nil
          WithResponseBlock:newResponse
               serialNumber:serialNumber];
}

/**
 * @brief 根据loginName获取指定的用户信息
 * @param loginName 登陆名
 **/
- (void) getUserInfo:(GithubResponse) block
           loginName:(NSString *) loginName
        serialNumber:(NSString *) serialNumber
{
    NSString * userUrl = [NSString stringWithFormat:@"%@%@%@",GitHubAPIURL,githubUserInfo,loginName];
    
    GithubResponse newResponse = ^(BOOL result,id _Nullable responseObject,NSString * _Nonnull serailNumber){
        
        if(result)
        {
            responseObject = [ZLGithubUserModel getInstanceWithDic:responseObject];
        }
        block(result,responseObject,serialNumber);
    };
    
    [self GETRequestWithURL:userUrl
                 WithParams:nil
          WithResponseBlock:newResponse
               serialNumber:serialNumber];
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
    
    GithubResponse newResponse = ^(BOOL result,id _Nullable responseObject,NSString * _Nonnull serailNumber){
        
        if(result)
        {
            responseObject = [ZLGithubUserModel getInstanceWithDic:responseObject];
        }
        block(result,responseObject,serialNumber);
    };
    
    [self GETRequestWithURL:userUrl
                 WithParams:nil
          WithResponseBlock:newResponse
               serialNumber:serialNumber];
}


- (void) searchUser:(GithubResponse) block
            keyword:(NSString *) keyword
               sort:(NSString *) sort
              order:(BOOL) isAsc
               page:(NSUInteger) page
           per_page:(NSUInteger) per_page
       serialNumber:(NSString *) serialNumber
{
    NSString * urlForSearchUser = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,searchUserUrl];
    
    NSMutableDictionary * params = [@{@"q":keyword,
                                      @"page":[NSNumber numberWithUnsignedInteger:page],
                                      @"per_page":[NSNumber numberWithUnsignedInteger:per_page]} mutableCopy];
    if(sort && [sort length] == 0)
    {
        [params setObject:sort forKey:@"sort"];
        [params setObject:isAsc ? @"asc":@"desc" forKey:@"order"];
    }
    
    GithubResponse newResponse = ^(BOOL result,id _Nullable responseObject,NSString * _Nonnull serailNumber){
        
        if(result)
        {
            ZLSearchResultModel * resultModel = [[ZLSearchResultModel alloc] init];
            resultModel.totalNumber = [[responseObject objectForKey:@"total_count"] unsignedIntegerValue];
            resultModel.incomplete_results = [[responseObject objectForKey:@"incomplete_results"] unsignedIntegerValue];
            resultModel.data = [ZLGithubUserModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"items"]];
            responseObject = resultModel;
        }
        block(result,responseObject,serialNumber);
    };
    
    [self GETRequestWithURL:urlForSearchUser
                 WithParams:params
          WithResponseBlock:newResponse
               serialNumber:serialNumber];
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
}

#pragma mark - repositories

- (void) getRepositoriesForCurrentLoginUser:(GithubResponse) block
                                       page:(NSUInteger) page
                                   per_page:(NSUInteger) per_page
                               serialNumber:(NSString *) serialNumber
{
    NSString * urlForRepo = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,currentUserRepoUrl];
    
    NSDictionary * params = @{@"page":[NSNumber numberWithUnsignedInteger:page],
                              @"per_page":[NSNumber numberWithUnsignedInteger:per_page]};
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        
        if(result)
        {
            responseObject = [[ZLGithubRepositoryModel mj_objectArrayWithKeyValuesArray:responseObject] copy];
        }
        block(result,responseObject,serialNumber);
    };
    
    [self GETRequestWithURL:urlForRepo
                 WithParams:params
          WithResponseBlock:newBlock
               serialNumber:serialNumber];
    
}





- (void) getRepositoriesForUser:(GithubResponse) block
                      loginName:(NSString*) loginName
                           page:(NSUInteger) page
                       per_page:(NSUInteger) per_page
                   serialNumber:(NSString *) serialNumber
{
    NSString * urlForRepo = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,userRepoUrl];
    urlForRepo = [NSString stringWithFormat:urlForRepo,loginName];
    
    NSDictionary * params = @{@"page":[NSNumber numberWithUnsignedInteger:page],
                              @"per_page":[NSNumber numberWithUnsignedInteger:per_page]};
    
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        
        if(result)
        {
            responseObject = [[ZLGithubRepositoryModel mj_objectArrayWithKeyValuesArray:responseObject] copy];
        }
        block(result,responseObject,serialNumber);
    };
    
    [self GETRequestWithURL:urlForRepo
                 WithParams:params
          WithResponseBlock:newBlock
               serialNumber:serialNumber];
}


- (void) getStarredRepositoriesForCurrentLoginUser:(GithubResponse) block
                                              page:(NSUInteger) page
                                          per_page:(NSUInteger) per_page
                                      serialNumber:(NSString *) serialNumber
{
    NSString * urlForRepo = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,currentUserStarredURL];
    
    NSDictionary * params = @{@"page":[NSNumber numberWithUnsignedInteger:page],
                              @"per_page":[NSNumber numberWithUnsignedInteger:per_page]};
    
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        
        if(result)
        {
            responseObject = [[ZLGithubRepositoryModel mj_objectArrayWithKeyValuesArray:responseObject] copy];
        }
        block(result,responseObject,serialNumber);
    };
    
    [self GETRequestWithURL:urlForRepo
                 WithParams:params
          WithResponseBlock:newBlock
               serialNumber:serialNumber];
    
}


- (void) getStarredRepositoriesForUser:(GithubResponse) block
                             loginName:(NSString*) loginName
                                  page:(NSUInteger) page
                              per_page:(NSUInteger) per_page
                          serialNumber:(NSString *) serialNumber
{
    NSString * urlForRepo = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,userStarredURL];
    urlForRepo = [NSString stringWithFormat:urlForRepo,loginName];
    
    NSDictionary * params = @{@"page":[NSNumber numberWithUnsignedInteger:page],
                              @"per_page":[NSNumber numberWithUnsignedInteger:per_page]};
    
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        
        if(result)
        {
            responseObject = [[ZLGithubRepositoryModel mj_objectArrayWithKeyValuesArray:responseObject] copy];
        }
        block(result,responseObject,serialNumber);
    };
    
    [self GETRequestWithURL:urlForRepo
                 WithParams:params
          WithResponseBlock:newBlock
               serialNumber:serialNumber];
    
}


- (void) searchRepos:(GithubResponse) block
             keyword:(NSString *) keyword
                sort:(NSString *) sort
               order:(BOOL) isAsc
                page:(NSUInteger) page
            per_page:(NSUInteger) per_page
        serialNumber:(NSString *) serialNumber
{
    NSString * urlForSearchUser = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,searchRepoUrl];
    
    NSMutableDictionary * params = [@{@"q":keyword,
                                      @"page":[NSNumber numberWithUnsignedInteger:page],
                                      @"per_page":[NSNumber numberWithUnsignedInteger:per_page]} mutableCopy];
    
    if(sort && [sort length] > 0)
    {
        [params setObject:sort forKey:@"sort"];
        [params setObject:isAsc ? @"asc":@"desc" forKey:@"order"];
    }
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        
        if(result)
        {
            ZLSearchResultModel * resultModel = [[ZLSearchResultModel alloc] init];
            resultModel.totalNumber = [[responseObject objectForKey:@"total_count"] unsignedIntegerValue];
            resultModel.incomplete_results = [[responseObject objectForKey:@"incomplete_results"] unsignedIntegerValue];
            resultModel.data = [ZLGithubRepositoryModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"items"]];
            responseObject = resultModel;
        }
        block(result,responseObject,serialNumber);
    };
    
    [self GETRequestWithURL:urlForSearchUser
                 WithParams:params
          WithResponseBlock:newBlock
               serialNumber:serialNumber];
}


- (void) getRepositoryInfo:(GithubResponse) block
                  fullName:(NSString *) fullName
              serialNumber:(NSString *) serialNumber
{
    NSString * urlForRepo = [NSString stringWithFormat:@"%@%@/%@",GitHubAPIURL,reposUrl,fullName];
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        
        if(result)
        {
            ZLGithubRepositoryModel * model = [ZLGithubRepositoryModel mj_objectWithKeyValues:responseObject];
            responseObject = model;
        }
        block(result,responseObject,serialNumber);
    };
    
    [self GETRequestWithURL:urlForRepo
                 WithParams:nil
          WithResponseBlock:newBlock
               serialNumber:serialNumber];
    
}


/**
* @brief 根据fullName直接获取Repo readme 信息
* @param block 请求回调
* @param fullName octocat/Hello-World
* @param serialNumber 流水号 通过block回调原样返回
**/
- (void) getRepositoryReadMeInfo:(GithubResponse) block
                        fullName:(NSString *) fullName
                    serialNumber:(NSString *) serialNumber
{
    NSString * urlForRepoReadMe = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,reposReadMeUrl];
    urlForRepoReadMe = [NSString stringWithFormat:urlForRepoReadMe,fullName];
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        
        if(result)
        {
            ZLGithubContentModel * model = [ZLGithubContentModel mj_objectWithKeyValues:responseObject];
            responseObject = model;
        }
        block(result,responseObject,serialNumber);
    };
    
    [self GETRequestWithURL:urlForRepoReadMe
                 WithParams:nil
          WithResponseBlock:newBlock
               serialNumber:serialNumber];
}



/**
* @brief 根据fullName直接获取Repo readme 信息
* @param block 请求回调
* @param fullName octocat/Hello-World
* @param serialNumber 流水号 通过block回调原样返回
**/
- (void) getRepositoryPullRequestInfo:(GithubResponse) block
                             fullName:(NSString *) fullName
                                state:(NSString *) state
                         serialNumber:(NSString *) serialNumber
{
    NSString * urlForRepoReadMe = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,repoPullRequestUrl];
      urlForRepoReadMe = [NSString stringWithFormat:urlForRepoReadMe,fullName];
    
    NSDictionary * params = @{@"state":state};
      
      GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
          
          if(result)
          {
              NSArray<ZLGithubPullRequestModel *> * model = [ZLGithubPullRequestModel mj_objectArrayWithKeyValuesArray:responseObject];
              responseObject = model;
          }
          block(result,responseObject,serialNumber);
      };
      
      [self GETRequestWithURL:urlForRepoReadMe
                   WithParams:params
            WithResponseBlock:newBlock
                 serialNumber:serialNumber];
}


/**
* @brief 根据fullName直接获取Repo readme 信息
* @param block 请求回调
* @param fullName octocat/Hello-World
* @param serialNumber 流水号 通过block回调原样返回
**/
- (void) getRepositoryCommitsInfo:(GithubResponse) block
                         fullName:(NSString *) fullName
                           branch:(NSString *) branch
                            until:(NSDate *) untilDate
                            since:(NSDate *) sinceDate
                     serialNumber:(NSString *) serialNumber
{
    NSString * urlForRepoCommits = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,repoCommitsUrl];
    urlForRepoCommits = [NSString stringWithFormat:urlForRepoCommits,fullName];
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    if(untilDate) {
        [params setObject:[untilDate dateStrForYYYYMMDDTHHMMSSZForTimeZone0] forKey:@"until"];
    }
    if(sinceDate) {
        [params setObject:[sinceDate dateStrForYYYYMMDDTHHMMSSZForTimeZone0] forKey:@"since"];
    }
    if([branch length] > 0) {
        [params setObject:branch forKey:@"sha"];
    }
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        
        if(result)
        {
            NSArray<ZLGithubCommitModel *> * model = [ZLGithubCommitModel mj_objectArrayWithKeyValuesArray:responseObject];
            responseObject = model;
        }
        block(result,responseObject,serialNumber);
    };
    
    [self GETRequestWithURL:urlForRepoCommits
                 WithParams:params
          WithResponseBlock:newBlock
               serialNumber:serialNumber];
}


- (void) getRepositoryBranchesInfo:(GithubResponse) block
                          fullName:(NSString *) fullName
                      serialNumber:(NSString *) serialNumber
{
    NSString * urlForRepoBranches = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,repoBranchedUrl];
    urlForRepoBranches = [NSString stringWithFormat:urlForRepoBranches,fullName];
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        
        if(result)
        {
            NSArray<ZLGithubRepositoryBranchModel *> * model = [ZLGithubRepositoryBranchModel mj_objectArrayWithKeyValuesArray:responseObject];
            responseObject = model;
        }
        block(result,responseObject,serialNumber);
    };
    
    [self GETRequestWithURL:urlForRepoBranches
                 WithParams:nil
          WithResponseBlock:newBlock
               serialNumber:serialNumber];
}

- (void) getRepositoryContentsInfo:(GithubResponse) block
                          fullName:(NSString *) fullName
                              path:(NSString *) path
                            branch:(NSString *) branch
                      serialNumber:(NSString *) serialNumber
{
    NSString * urlForRepoContent = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,repoContentsUrl];
    urlForRepoContent = [NSString stringWithFormat:urlForRepoContent,fullName,path];
    
    NSDictionary * params = @{@"ref":branch};
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        
        if(result)
        {
            NSArray<ZLGithubContentModel *> * model = [ZLGithubContentModel mj_objectArrayWithKeyValuesArray:responseObject];
            responseObject = model;
        }
        block(result,responseObject,serialNumber);
    };
    
    [self GETRequestWithURL:urlForRepoContent
                 WithParams:params
          WithResponseBlock:newBlock
               serialNumber:serialNumber];
}

- (void) getRepositoryFileInfo:(GithubResponse) block
                      fullName:(NSString *) fullName
                          path:(NSString *) path
                        branch:(NSString *) branch
                  serialNumber:(NSString *) serialNumber
{
    NSString * urlForRepoContent = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,repoContentsUrl];
    urlForRepoContent = [NSString stringWithFormat:urlForRepoContent,fullName,path];
    
    NSDictionary * params = @{@"ref":branch};
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        
        if(result)
        {
            ZLGithubContentModel * model = [ZLGithubContentModel mj_objectWithKeyValues:responseObject];
            responseObject = model;
        }
        block(result,responseObject,serialNumber);
    };
    
    [self GETRequestWithURL:urlForRepoContent
                 WithParams:params
          WithResponseBlock:newBlock
               serialNumber:serialNumber];
}


- (void) getRepositoryContributors:(GithubResponse) block
                          fullName:(NSString *) fullName
                      serialNumber:(NSString *) serialNumber{
    NSString * urlForRepoContributor = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,repoContributorsUrl];
    urlForRepoContributor = [NSString stringWithFormat:urlForRepoContributor,fullName];
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        
        if(result)
        {
            NSArray<ZLGithubUserModel *> * model = [ZLGithubUserModel mj_objectArrayWithKeyValuesArray:responseObject];
            responseObject = model;
        }
        block(result,responseObject,serialNumber);
    };
    
    [self GETRequestWithURL:urlForRepoContributor
                 WithParams:@{}
          WithResponseBlock:newBlock
               serialNumber:serialNumber];
}



- (void) getStarRepositoryStatus:(GithubResponse) block
                        fullName:(NSString *) fullName
                    serialNumber:(NSString *) serialNumber{
    NSString * urlForRepoStar = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,repoStarred];
    urlForRepoStar = [NSString stringWithFormat:urlForRepoStar,fullName];
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        if(result) {
            block(YES,@{@"isStar":@(YES)},serialNumber);
        } else {
            ZLGithubRequestErrorModel *errorModel = responseObject;
            if(errorModel.statusCode == 404) {
                block(YES,@{@"isStar":@(NO)},serialNumber);
            } else {
                block(result,responseObject,serialNumber);
            }
        }
    };
    
    [self GETRequestWithURL:urlForRepoStar
                 WithParams:@{}
          WithResponseBlock:newBlock
               serialNumber:serialNumber];
}

- (void) starRepository:(GithubResponse) block
               fullName:(NSString *) fullName
           serialNumber:(NSString *) serialNumber{
    NSString * urlForRepoStar = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,repoStarred];
    urlForRepoStar = [NSString stringWithFormat:urlForRepoStar,fullName];
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        block(result,responseObject,serialNumber);
    };
    
    [self requestWithMethod:@"PUT" withURL:urlForRepoStar WithParams:@{} WithResponseBlock:newBlock serialNumber:serialNumber];
}

- (void) unstarRepository:(GithubResponse) block
                fullName:(NSString *) fullName
            serialNumber:(NSString *) serialNumber{
    NSString * urlForRepoStar = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,repoStarred];
    urlForRepoStar = [NSString stringWithFormat:urlForRepoStar,fullName];
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        block(result,responseObject,serialNumber);
    };
    
    [self requestWithMethod:@"DELETE" withURL:urlForRepoStar WithParams:@{} WithResponseBlock:newBlock serialNumber:serialNumber];
}


- (void) getWatchRepositoryStatus:(GithubResponse) block
                         fullName:(NSString *) fullName
                     serialNumber:(NSString *) serialNumber{
    NSString * urlForRepoSubscription = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,repoSubscription];
    urlForRepoSubscription = [NSString stringWithFormat:urlForRepoSubscription,fullName];
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        if(result) {
            block(YES,@{@"isWatch":@(YES)},serialNumber);
        } else {
            ZLGithubRequestErrorModel *errorModel = responseObject;
            if(errorModel.statusCode == 404) {
                block(YES,@{@"isWatch":@(NO)},serialNumber);
            } else {
                block(result,responseObject,serialNumber);
            }
        }
    };
    
    [self GETRequestWithURL:urlForRepoSubscription
                 WithParams:@{}
          WithResponseBlock:newBlock
               serialNumber:serialNumber];
}

- (void) watchRepository:(GithubResponse) block
                fullName:(NSString *) fullName
            serialNumber:(NSString *) serialNumber{
    NSString * urlForRepoSubscription = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,repoSubscription];
    urlForRepoSubscription = [NSString stringWithFormat:urlForRepoSubscription,fullName];
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        block(result,responseObject,serialNumber);
    };
    
    [self requestWithMethod:@"PUT" withURL:urlForRepoSubscription WithParams:@{} WithResponseBlock:newBlock serialNumber:serialNumber];
}

- (void) unwatchRepository:(GithubResponse) block
                fullName:(NSString *) fullName
            serialNumber:(NSString *) serialNumber{
    NSString * urlForRepoSubscription = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,repoSubscription];
    urlForRepoSubscription = [NSString stringWithFormat:urlForRepoSubscription,fullName];
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        block(result,responseObject,serialNumber);
    };
    
    [self requestWithMethod:@"DELETE" withURL:urlForRepoSubscription WithParams:@{} WithResponseBlock:newBlock serialNumber:serialNumber];
}





#pragma mark - gists

- (void) getGistsForCurrentUser:(GithubResponse) block
                           page:(NSUInteger) page
                       per_page:(NSUInteger) per_page
                   serialNumber:(NSString *) serialNumber
{
    NSString * urlForGist = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,gistUrl];
    
    NSDictionary * params = @{@"page":[NSNumber numberWithUnsignedInteger:page],
                              @"per_page":[NSNumber numberWithUnsignedInteger:per_page]};
    
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        
        if(result)
        {
            responseObject = [[ZLGithubGistModel mj_objectArrayWithKeyValuesArray:responseObject] copy];
        }
        block(result,responseObject,serialNumber);
    };
    
    [self GETRequestWithURL:urlForGist
                 WithParams:params
          WithResponseBlock:newBlock
               serialNumber:serialNumber];
}

- (void) getGistsForUser:(GithubResponse) block
               loginName:(NSString *) loginName
                    page:(NSUInteger) page
                per_page:(NSUInteger) per_page
            serialNumber:(NSString *) serialNumber
{
    NSString * urlForGist = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,userGistUrl];
    urlForGist = [NSString stringWithFormat:urlForGist,loginName];
      
    NSDictionary * params = @{@"page":[NSNumber numberWithUnsignedInteger:page],
                                @"per_page":[NSNumber numberWithUnsignedInteger:per_page]};
      
      
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
          
          if(result)
          {
              responseObject = [[ZLGithubGistModel mj_objectArrayWithKeyValuesArray:responseObject] copy];
          }
          block(result,responseObject,serialNumber);
    };
      
    [self GETRequestWithURL:urlForGist
                   WithParams:params
            WithResponseBlock:newBlock
                 serialNumber:serialNumber];
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
    
    NSDictionary * params = @{@"page":[NSNumber numberWithUnsignedInteger:page],
                              @"per_page":[NSNumber numberWithUnsignedInteger:per_page]};
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        
        if(result)
        {
            NSArray * array = [[ZLGithubUserModel mj_objectArrayWithKeyValuesArray:responseObject] copy];
            responseObject = array;
        }
        block(result,responseObject,serialNumber);
    };
    
    [self GETRequestWithURL:urlForFollowers
                 WithParams:params
          WithResponseBlock:newBlock
               serialNumber:serialNumber];
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
    
    
    NSDictionary * params = @{@"page":[NSNumber numberWithUnsignedInteger:page],
                              @"per_page":[NSNumber numberWithUnsignedInteger:per_page]};
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        
        if(result)
        {
            NSArray * array = [[ZLGithubUserModel mj_objectArrayWithKeyValuesArray:responseObject] copy];
            responseObject = array;
        }
        block(result,responseObject,serialNumber);
    };
    
    [self GETRequestWithURL:urlForFollowing
                 WithParams:params
          WithResponseBlock:newBlock
               serialNumber:serialNumber];
    
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
    
    NSDictionary * params = @{@"page":[NSNumber numberWithUnsignedInteger:page],
                              @"per_page":[NSNumber numberWithUnsignedInteger:per_page]};
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        if(result)
        {
            NSArray * array = [[ZLGithubEventModel mj_objectArrayWithKeyValuesArray:responseObject] copy];
            responseObject = array;
        }
        block(result,responseObject,serialNumber);
    };
    
    
    [self GETRequestWithURL:urlForReceivedEvent
                 WithParams:params
          WithResponseBlock:newBlock
               serialNumber:serialNumber];
}


- (void)getEventsForUser:(NSString *)userName
                    page:(NSUInteger)page
                per_page:(NSUInteger)per_page
            serialNumber:(NSString *)serialNumber
           responseBlock:(GithubResponse)block
{
    NSString * urlForEvent = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,userEventUrl];
    urlForEvent = [NSString stringWithFormat:urlForEvent,userName];
    
    NSDictionary * params = @{@"page":[NSNumber numberWithUnsignedInteger:page],
                              @"per_page":[NSNumber numberWithUnsignedInteger:per_page]};
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        if(result)
        {
            NSArray * array = [[ZLGithubEventModel mj_objectArrayWithKeyValuesArray:responseObject] copy];
            responseObject = array;
        }
        block(result,responseObject,serialNumber);
    };
    
    
    [self GETRequestWithURL:urlForEvent
                 WithParams:params
          WithResponseBlock:newBlock
               serialNumber:serialNumber];
}




#pragma mark - Issues

- (void) getRepositoryIssues:(GithubResponse) block
                    fullName:(NSString *) fullName
                serialNumber:(NSString *) serialNumber{
    
    NSString * urlForRepoContributor = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,repoIssuesUrl];
    urlForRepoContributor = [NSString stringWithFormat:urlForRepoContributor,fullName];
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        
        if(result)
        {
            NSArray<ZLGithubIssueModel *> * model = [ZLGithubIssueModel mj_objectArrayWithKeyValuesArray:responseObject];
            responseObject = model;
        }
        block(result,responseObject,serialNumber);
    };
    
    [self GETRequestWithURL:urlForRepoContributor
                 WithParams:@{}
          WithResponseBlock:newBlock
               serialNumber:serialNumber];
    
    
}

- (void) createIssue:(GithubResponse) block
            fullName:(NSString *) fullName
               title:(NSString *) title
             content:(NSString *) content
              labels:(NSArray *) labels
           assignees:(NSArray *) assignees
        serialNumber:(NSString *) serialNumber{
    
    NSString * urlForRepoContributor = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,createIssueUrl];
    urlForRepoContributor = [NSString stringWithFormat:urlForRepoContributor,fullName];
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        if(!result){
            ZLGithubRequestErrorModel *model = responseObject;
            if(model.statusCode == 410){  // 410 gone issues are disabled in the repository
                model.message = @"issues are disabled in the repository";
            }
        }
        block(result,responseObject,serialNumber);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    {
        if(title)
            [params setObject:title forKey:@"title"];
        if(labels)
            [params setObject:labels forKey:@"labels"];
        if(content)
            [params setObject:content forKey:@"body"];
        if(assignees)
            [params setObject:assignees forKey:@"assignees"];
    }
    
    [self POSTRequestWithURL:urlForRepoContributor
                  WithParams:params
           WithResponseBlock:newBlock
                serialNumber:serialNumber];
    
}


#pragma mark - languages

- (void) getLanguagesList:(GithubResponse) block
             serialNumber:(NSString *) serialNumber{
    NSString * urlForLanguages = [NSString stringWithFormat:@"%@%@",GitHubAPIURL,languageUrl];
    
    GithubResponse newBlock = ^(BOOL result, id _Nullable responseObject, NSString * _Nonnull serialNumber) {
        
        if(result)
        {
            NSArray* model = [((NSArray *)responseObject) valueForKey:@"name"];
            responseObject = model;
        }
        block(result,responseObject,serialNumber);
    };
    
    [self GETRequestWithURL:urlForLanguages
                 WithParams:@{}
          WithResponseBlock:newBlock
               serialNumber:serialNumber];
}


@end
