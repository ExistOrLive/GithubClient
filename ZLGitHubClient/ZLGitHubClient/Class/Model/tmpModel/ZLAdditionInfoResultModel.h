//
//  ZLAdditionInfoResultModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/1.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZLGithubRequestErrorModel;
NS_ASSUME_NONNULL_BEGIN

@interface ZLAdditionInfoResultModel : NSObject

@property (assign, nonatomic) BOOL result;                  // 请求是否成功

@property (strong, nonatomic) NSArray * data;               // ZLGithubRepositoryModel /ZLGithubUserInfoModel

@property (strong, nonatomic) ZLGithubRequestErrorModel * errorModel;   // result 为false，有效

@property (strong, nonatomic) NSString * serialNumber;      // 流水号

@end

NS_ASSUME_NONNULL_END
