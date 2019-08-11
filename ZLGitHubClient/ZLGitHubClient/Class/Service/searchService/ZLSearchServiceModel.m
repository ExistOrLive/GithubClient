//
//  ZLSearchServiceModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/8.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLSearchServiceModel.h"

// model
#import "ZLSearchFilterInfoModel.h"
#import "ZLSearchResultModel.h"

// network
#import "ZLGithubHttpClient.h"

@implementation ZLSearchServiceModel

+ (instancetype) sharedServiceModel
{
    static ZLSearchServiceModel * serviceModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceModel = [[ZLSearchServiceModel alloc] init];
    });
    return serviceModel;
}

- (void) searchInfoWithKeyWord:(NSString *) keyWord
                          type:(ZLSearchType) type
                    filterInfo:(ZLSearchFilterInfoModel * __nullable) filterInfo
                          page:(NSUInteger) page
                      per_page:(NSUInteger) per_page
                  serialNumber:(NSString *) serialNumber
{
    switch(type)
    {
        case ZLSearchTypeUsers:
        {
            [self searchUserInfoKeyWord:keyWord filterInfo:filterInfo page:page per_page:per_page serialNumber:serialNumber];
            break;
        }
        case ZLSearchTypeRepositories:
        {
            [self searchRepoInfoKeyWord:keyWord filterInfo:filterInfo page:page per_page:per_page serialNumber:serialNumber];
            break;
        }
        default:
            break;
    }
}

- (void) searchUserInfoKeyWord:(NSString *) keyWord
                    filterInfo:(ZLSearchFilterInfoModel * __nullable) filterInfo
                          page:(NSUInteger) page
                      per_page:(NSUInteger) per_page
                  serialNumber:(NSString *) serialNumber
{
    GithubResponse response = ^(BOOL result,id responseObject,NSString * serialNumber){
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        ZLMainThreadDispatch([self postNotification:ZLSearchResult_Notification withParams:repoResultModel])
    };
    
    
    
    [[ZLGithubHttpClient defaultClient] searchUser:response
                                           keyword:keyWord
                                              page:page
                                          per_page:per_page
                                      serialNumber:serialNumber];
}


- (void) searchRepoInfoKeyWord:(NSString *) keyWord
                    filterInfo:(ZLSearchFilterInfoModel * __nullable) filterInfo
                          page:(NSUInteger) page
                      per_page:(NSUInteger) per_page
                  serialNumber:(NSString *) serialNumber
{
    GithubResponse response = ^(BOOL result,id responseObject,NSString * serialNumber){
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        ZLMainThreadDispatch([self postNotification:ZLSearchResult_Notification withParams:repoResultModel])
    };
    
    [[ZLGithubHttpClient defaultClient] searchRepos:response
                                            keyword:keyWord
                                               page:page
                                           per_page:per_page
                                       serialNumber:serialNumber];
}



@end
