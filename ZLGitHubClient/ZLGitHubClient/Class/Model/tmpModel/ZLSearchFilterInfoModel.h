//
//  ZLSearchFilterInfoModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/8.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLSearchFilterInfoModel : NSObject

@property(nonatomic,strong) NSString * order;
@property(nonatomic,strong) NSString * language;
@property(nonatomic,strong) NSString * firstCreatedTimeStr;
@property(nonatomic,strong) NSString * secondCreatedTimeStr;
@property(nonatomic,assign) NSUInteger firstStarNum;
@property(nonatomic,assign) NSUInteger secondStarNum;
@property(nonatomic,assign) NSUInteger firstForkNum;
@property(nonatomic,assign) NSUInteger secondForkNum;
@property(nonatomic,assign) double     size;

- (NSString *) finalKeyWordForRepoFilter:(NSString *) keyWord;

@end

NS_ASSUME_NONNULL_END
