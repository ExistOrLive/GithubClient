//
//  ZLGithubRepositoryReadMeModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/2/26.
//  Copyright © 2020 ZM. All rights reserved.
//

#import "ZLBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZLGithubRepositoryReadMeModel : ZLBaseObject

@property(nonatomic, strong) NSString * name;

@property(nonatomic, strong) NSString * path;

@property(nonatomic, strong) NSString * sha;

@property(nonatomic, strong) NSString * type;

@property(nonatomic, strong) NSString * content;

@property(nonatomic, strong) NSString * encoding;

@property(nonatomic, assign) NSUInteger size;

@end

NS_ASSUME_NONNULL_END
