//
//  ZLAdditionInfoServiceModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/31.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLAdditionServiceModel.h"

// HTTP
#import "ZLGithubHTTPClient.h"

// ServiceModel
#import "ZLUserServiceModel.h"

// Model
#import "ZLOperationResultModel.h"

#import "ZLSharedDataManager.h"

@implementation ZLAdditionServiceModel

+ (instancetype) sharedServiceModel
{
    static ZLAdditionServiceModel * model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[ZLAdditionServiceModel alloc] init];
    });
    return model;
}



#pragma mark -

- (NSArray<NSString *> *)githubLanguageList{
    __block NSArray<NSString *>* languageList = nil;
    [ZLBaseServiceModel dispatchSyncInOperationQueue:^{
        languageList = [ZLSharedDataManager sharedInstance].githubLanguageList;
    }];
    return languageList;
}

/**
 * @brief 获取language列表
 *
 **/
- (NSArray<NSString *> * _Nullable) getLanguagesWithSerialNumber:(NSString *) serialNumber
                                                  completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    NSArray<NSString *>* languageList = [self githubLanguageList];
    
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * resultModel = [[ZLOperationResultModel alloc] init];
        resultModel.result = result;
        resultModel.serialNumber = serialNumber;
        resultModel.data = responseObject;
        
        if(result && [responseObject isKindOfClass:[NSArray class]]){
            [[ZLSharedDataManager sharedInstance] setGithubLanguageList:responseObject];
        }
        
        if(handle){
            ZLMainThreadDispatch(handle(resultModel);)
        }
    };
    
    [[ZLGithubHttpClient defaultClient] getLanguagesList:responseBlock
                                            serialNumber:serialNumber];
    
    return languageList;
}



- (void) renderCodeToMarkdownWithCode:(NSString *) code
                         serialNumber:(NSString *) serialNumber
                       completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * resultModel = [[ZLOperationResultModel alloc] init];
        resultModel.result = result;
        resultModel.serialNumber = serialNumber;
        resultModel.data = responseObject;
        
        if(handle){
            ZLMainThreadDispatch(handle(resultModel);)
        }
    };
    
    [[ZLGithubHttpClient defaultClient] renderCodeToMarkdown:responseBlock code:code serialNumber:serialNumber];
    
    
}


#pragma mark - config

/**
 * @brief 获取功能配置
 *
 **/

- (void) getGithubClientConfig:(NSString *) serialNumber{
    
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        if(result){
            ZLGithubConfigModel *model = responseObject;
            [[ZLSharedDataManager sharedInstance] setConfigModel:model];
            ZLMainThreadDispatch({
                [[NSNotificationCenter defaultCenter] postNotificationName:ZLGithubConfigUpdate_Notification object:nil];
            })
        }
    };
    
    [[ZLGithubHttpClient defaultClient] getGithubClientConfig:responseBlock serialNumber:serialNumber];
}


- (ZLGithubConfigModel *)config{
    __block ZLGithubConfigModel* config = nil;
    [ZLBaseServiceModel dispatchSyncInOperationQueue:^{
        config = [[ZLSharedDataManager sharedInstance] configModel];
    }];
    return config;
}






@end
