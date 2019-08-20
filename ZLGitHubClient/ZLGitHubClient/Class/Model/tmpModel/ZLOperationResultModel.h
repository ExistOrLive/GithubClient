//
//  ZLOperationResultModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/10.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLOperationResultModel : NSObject

@property (assign, nonatomic) BOOL result;                 // 结果

@property (strong, nonatomic) id data;                      // 不同operation， data 类型不同； result 为false ZLGithubRequestErrorModel

@property (strong, nonatomic) NSString * serialNumber;      // 流水号

@end

NS_ASSUME_NONNULL_END
