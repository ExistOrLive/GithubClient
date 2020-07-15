//
//  ZLLoginServiceModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/7.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLLoginServiceModel.h"

// network
#import "ZLGithubHttpClient.h"

// model
#import "ZLLoginProcessModel.h"

@interface ZLLoginServiceModel()

@property(nonatomic,assign) ZLLoginStep step;

@property(nonatomic,assign) NSString * currentLoginSerialNumber;

@end

@implementation ZLLoginServiceModel

+ (instancetype) sharedServiceModel
{
    static ZLLoginServiceModel * serviceModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceModel = [[ZLLoginServiceModel alloc] init];
    });
    return serviceModel;
}

- (void) stopLogin:(NSString *) serialNumber
{
    if(self.step != ZLLoginStep_init)
    {
        ZLLog_Info(@"ZLLoginProcess: stopLogin[%@]",serialNumber);
        self.step = ZLLoginStep_init;
        self.currentLoginSerialNumber = nil;
    }
}

/**
 * 注销登录
 *
 **/
- (void) logout:(NSString *) serialNumber
{
    
    ZLLog_Info(@"ZLLogoutProcess: logout[%@]",serialNumber);
    self.step = ZLLoginStep_init;
    self.currentLoginSerialNumber = nil;
    
    GithubResponse  response = ^(BOOL result,id _Nullable responseObject,NSString * serialNumber)
    {
        ZLLog_Info(@"ZLLogoutProcess: result[%d] serialNumber[%@]",result,serialNumber);
        
        ZLOperationResultModel * resultModel = [ZLOperationResultModel new];
        resultModel.result = result;
        resultModel.serialNumber = serialNumber;
        
        ZLMainThreadDispatch([self postNotification:ZLLogoutResult_Notification withParams:resultModel];)
    };
    
    [[ZLGithubHttpClient defaultClient] logout:response serialNumber:serialNumber];
    
}


/**
 *
 * 当前登陆的过程
 **/
- (ZLLoginStep) currentLoginStep
{
    return self.step;
}

- (void) setStep:(ZLLoginStep)step{
    ZLLog_Info(@"ZLLoginProcess: enter step[%d]",step);
    _step = step;
}

- (void) startOAuth:(NSString *) serialNumber 
{
    self.step = ZLLoginStep_checkIsLogined;
    self.currentLoginSerialNumber = serialNumber;
    
    __weak typeof(self) weakSelf = self;
    
    ZLLog_Info(@"ZLLoginProcess: startOAuth[%@]",serialNumber);
    
    [[ZLGithubHttpClient defaultClient] startOAuth:^(BOOL result, id _Nullable response, NSString * _Nonnull serialNumber) {
        
        ZLLoginProcessModel * processModel = (ZLLoginProcessModel *)response;
        
        if(![self.currentLoginSerialNumber isEqualToString:processModel.serialNumber])
        {
            return;
        }
        
        ZLLog_Info(@"ZLLoginProcess: result[%d] response[%d] serialNumber[%@]",result,response,serialNumber);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(result)
            {
                self.step = processModel.loginStep;
            }
            else
            {
                self.step = ZLLoginStep_init;
                self.currentLoginSerialNumber = nil;
            }
            
            [weakSelf postNotification:ZLLoginResult_Notification withParams:processModel];
        });
        
    } serialNumber:serialNumber];
    
}

- (void) getAccessToken:(NSString *) queryString
           serialNumber:(NSString *) serialNumber
{
    ZLLog_Info(@"ZLLoginProcess: getAccessToken[%@]",serialNumber);
    
    if(![serialNumber isEqualToString:self.currentLoginSerialNumber])
    {
        ZLLog_Info(@"getAccessToken serialNumber not match,so  return");
        return;
    }
    
    self.step = ZLLoginStep_getToken;
    
    __weak typeof(self) weakSelf = self;
    [[ZLGithubHttpClient defaultClient] getAccessToken:^(BOOL result, id _Nullable response, NSString * _Nonnull serialNumber) {
        
        ZLLoginProcessModel * processModel = (ZLLoginProcessModel *)response;
        
        if(![self.currentLoginSerialNumber isEqualToString:processModel.serialNumber])
        {
            return;
        }
        
        ZLLog_Info(@"ZLLoginResult: result[%d] response[%d] serialNumber[%@]",result,response,serialNumber);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(result)
            {
                self.step = processModel.loginStep;
            }
            else
            {
                self.step = ZLLoginStep_init;
                self.currentLoginSerialNumber = nil;
            }
            
            [weakSelf postNotification:ZLLoginResult_Notification withParams:processModel];
        });
        
        
        
    } queryString:queryString serialNumber:serialNumber];
}


- (void) checkTokenIsValid:(NSString *) token
              serialNumber:(NSString *) serialNumber{
    
    ZLLog_Info(@"ZLLoginProcess: checkTokenIsValid[%@]",serialNumber);
    self.step = ZLLoginStep_checkToken;
    
    __weak typeof(self) weakSelf = self;
    GithubResponse response = ^(BOOL result, id processModel, NSString *serialNumber){
        
        ZLLog_Info(@"ZLLoginResult: result[%d] response[%d] serialNumber[%@]",result,processModel,serialNumber);
        
        ZLMainThreadDispatch(
        if(result) {
            weakSelf.step = ZLLoginStep_Success;
        } else {
            weakSelf.step = ZLLoginStep_init;
        }
        [weakSelf postNotification:ZLLoginResult_Notification withParams:processModel];

                             )
    };
    
    [[ZLGithubHttpClient defaultClient] checkTokenIsValid:response
                                                    token:token
                                             serialNumber:serialNumber];
}



@end
