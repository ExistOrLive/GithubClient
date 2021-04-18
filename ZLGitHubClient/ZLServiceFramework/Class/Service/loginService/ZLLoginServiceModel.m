//
//  ZLLoginServiceModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/7.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLLoginServiceModel.h"

#import "ZLGithubAPI.h"

// network
#import "ZLGithubHttpClient.h"

// model
#import "ZLLoginProcessModel.h"

//
#import "ZLSharedDataManager.h"

@interface ZLLoginServiceModel()

@property(nonatomic,assign) ZLLoginStep step;

@property(nonatomic,assign) NSString * currentLoginSerialNumber;

@end

@implementation ZLLoginServiceModel

@synthesize step = _step;
@synthesize currentLoginSerialNumber = _currentLoginSerialNumber;

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:ZLGithubTokenInvalid_Notification];
}

- (instancetype) init {
    if(self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGithubTokenInvalid) name:ZLGithubTokenInvalid_Notification object:nil];
    }
    return self;
}


+ (instancetype) sharedServiceModel
{
    static ZLLoginServiceModel * serviceModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceModel = [[ZLLoginServiceModel alloc] init];
    });
    return serviceModel;
}

- (NSString *)accessToken{
    __block NSString *accessToken = nil;
    [ZLBaseServiceModel dispatchSyncInOperationQueue:^{
        accessToken = [ZLSharedDataManager sharedInstance].githubAccessToken;
    }];
    return accessToken;
}

/**
 *
 * 当前登陆的过程
 **/
- (ZLLoginStep) currentLoginStep
{
    return self.step;
}

- (ZLLoginStep) step{
    __block ZLLoginStep step;
    [ZLBaseServiceModel dispatchSyncInOperationQueue:^{
        step = self->_step;
    }];
    return step;
}

- (void) setStep:(ZLLoginStep)step{
    [ZLBaseServiceModel dispatchSyncInOperationQueue:^{
        ZLLog_Info(@"ZLLoginProcess: enter step[%d]",step);
        self->_step = step;
    }];
}

- (NSString *) currentLoginSerialNumber{
    __block NSString* number;
    [ZLBaseServiceModel dispatchSyncInOperationQueue:^{
        number = self->_currentLoginSerialNumber;
    }];
    return number;
    
}

- (void) setCurrentLoginSerialNumber:(NSString *)currentLoginSerialNumber{
    [ZLBaseServiceModel dispatchSyncInOperationQueue:^{
        self->_currentLoginSerialNumber = currentLoginSerialNumber;
    }];
}


#pragma mark - oauth login action

- (void) startOAuth:(NSString *) serialNumber 
{
    [ZLBaseServiceModel dispatchSyncInOperationQueue:^{
        
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
            
            if(result)
            {
                weakSelf.step = processModel.loginStep;
            }
            else
            {
                ZLGithubRequestErrorModel *model = (ZLGithubRequestErrorModel *)response;
                [ZLAppEventForOC loginEventWithResult:1 step:weakSelf.step way:0 error:model.message];
                weakSelf.step = ZLLoginStep_init;
                weakSelf.currentLoginSerialNumber = nil;
            }
            
            ZLMainThreadDispatch([weakSelf postNotification:ZLLoginResult_Notification withParams:processModel];)
     
        } serialNumber:serialNumber];
        
    }];
}


- (void) stopLogin:(NSString *) serialNumber
{
    [ZLBaseServiceModel dispatchSyncInOperationQueue:^{
        
        if(self.step != ZLLoginStep_init)
        {
            [ZLAppEventForOC loginEventWithResult:2 step:self.step way:0 error:nil];
            
            ZLLog_Info(@"ZLLoginProcess: stopLogin[%@]",serialNumber);
            self.step = ZLLoginStep_init;
            self.currentLoginSerialNumber = nil;
        }
        
    }];
}

/**
 * 注销登录
 *
 **/
- (void) logout:(NSString *) serialNumber
{
    [ZLBaseServiceModel dispatchSyncInOperationQueue:^{
        
        ZLLog_Info(@"ZLLogoutProcess: logout[%@]",serialNumber);
        self.step = ZLLoginStep_init;
        self.currentLoginSerialNumber = nil;
                
        [[ZLGithubHttpClient defaultClient] logout:nil serialNumber:serialNumber];
        
        [[ZLSharedDataManager sharedInstance] clearGithubTokenAndUserInfo];
                
        ZLMainThreadDispatch([self postNotification:ZLLogoutResult_Notification withParams:[NSNull null]];)
        
    }];
}

- (void) getAccessToken:(NSString *) queryString
           serialNumber:(NSString *) serialNumber{
    
    [ZLBaseServiceModel dispatchSyncInOperationQueue:^{
        
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
            
            if(![weakSelf.currentLoginSerialNumber isEqualToString:processModel.serialNumber])
            {
                return;
            }
            
            ZLLog_Info(@"ZLLoginResult: result[%d] response[%d] serialNumber[%@]",result,response,serialNumber);
            
            if(result)
            {
                [ZLAppEventForOC loginEventWithResult:0 step:weakSelf.step way:0 error:nil];
                weakSelf.step = processModel.loginStep;
            }
            else
            {
                ZLGithubRequestErrorModel *model = (ZLGithubRequestErrorModel *) response;
                [ZLAppEventForOC loginEventWithResult:1 step:weakSelf.step way:0 error:model.message];
                weakSelf.step = ZLLoginStep_init;
                weakSelf.currentLoginSerialNumber = nil;
            }
            
            ZLMainThreadDispatch([weakSelf postNotification:ZLLoginResult_Notification withParams:processModel];)

        } queryString:queryString serialNumber:serialNumber];
    }];
}

#pragma mark - token login action

- (void) checkTokenIsValid:(NSString *) token
              serialNumber:(NSString *) serialNumber{
    
    [ZLBaseServiceModel dispatchSyncInOperationQueue:^{
        
        ZLLog_Info(@"ZLLoginProcess: checkTokenIsValid[%@]",serialNumber);
        self.step = ZLLoginStep_checkToken;
        
        __weak typeof(self) weakSelf = self;
        GithubResponse response = ^(BOOL result, id processModel, NSString *serialNumber){
            
            ZLLog_Info(@"ZLLoginResult: result[%d] response[%d] serialNumber[%@]",result,processModel,serialNumber);
            
            if(result) {
                [[ZLSharedDataManager sharedInstance] setGithubAccessToken:token];
                [ZLAppEventForOC loginEventWithResult:0 step:weakSelf.step way:1 error:nil];
                weakSelf.step = ZLLoginStep_Success;
            } else {
                ZLLoginProcessModel *model = (ZLLoginProcessModel *)processModel;
                [ZLAppEventForOC loginEventWithResult:1 step:weakSelf.step way:1 error:model.errorModel.message];
                weakSelf.step = ZLLoginStep_init;
            }
            
            ZLMainThreadDispatch([weakSelf postNotification:ZLLoginResult_Notification withParams:processModel];)
        };
        
        [[ZLGithubHttpClient defaultClient] checkTokenIsValid:response
                                                        token:token
                                                 serialNumber:serialNumber];
        
    }];
}


#pragma mark -

- (void) onGithubTokenInvalid {

    ZLLog_Info(@"ZLLogoutProcess: onGithubTokenInvliad");
    
    [self logout:[NSString generateSerialNumber]];

}



@end
