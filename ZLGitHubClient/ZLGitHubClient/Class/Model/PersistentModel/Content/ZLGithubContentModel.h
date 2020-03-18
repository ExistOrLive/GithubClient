//
//  ZLGithubContentModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/18.
//  Copyright © 2020 ZM. All rights reserved.
//

#import "ZLBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZLGithubContentModel : ZLBaseObject

@property(nonatomic, strong) NSString * html_url;

@property(nonatomic, strong) NSString * url;

@property(nonatomic, strong) NSString * __nullable download_url;

@property(nonatomic, strong) NSString * git_url;

@property(nonatomic, strong) NSString * name;

@property(nonatomic, strong) NSString * path;

@property(nonatomic, strong) NSString * type;              // dir / file

@property(nonatomic, strong) NSString * __nullable content;

@property(nonatomic, strong) NSString * __nullable encoding;

@end

NS_ASSUME_NONNULL_END
