//
//  ZLGithubRepositoryBranchModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/18.
//  Copyright © 2020 ZM. All rights reserved.
//

#import "ZLBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZLGithubRepositoryBranchModel : ZLBaseObject

@property(nonatomic, strong) NSString * name;

@property(nonatomic, assign) BOOL protect;

@property(nonatomic, strong) NSString * commit_sha;

@property(nonatomic, strong) NSString * commit_url;



@end

NS_ASSUME_NONNULL_END
