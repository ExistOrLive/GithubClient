//
//  ZLGithubGistModel.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/2/10.
//  Copyright © 2020 ZM. All rights reserved.
//

#import "ZLBaseObject.h"
@class ZLGithubUserBriefModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZLGithubGistFileModel : ZLBaseObject

@property(strong, nonatomic) NSString * filename;

@property(strong, nonatomic) NSString * type;

@property(strong, nonatomic) NSString * language;

@property(strong, nonatomic) NSString * raw_url;

@property(assign, nonatomic) NSUInteger size;

@end

@interface ZLGithubGistModel : ZLBaseObject

@property(strong, nonatomic) NSString * id_gist;
@property(strong, nonatomic) NSString * node_id;
@property(strong, nonatomic) NSString * html_url;                               //！web地址
@property(strong, nonatomic) NSString * url;

@property(strong, nonatomic) NSString * desc_Gist;        // 描述

@property(assign, nonatomic) NSUInteger comments;         // 评论数

@property(assign, nonatomic, getter=isPub) BOOL pub;      // 公共

@property(strong, nonatomic, nullable) NSDate * created_at;

@property(strong, nonatomic, nullable) NSDate * updated_at;

@property(strong, nonatomic) ZLGithubUserBriefModel * owner;

@property(strong, nonatomic) NSDictionary * files;

@end

NS_ASSUME_NONNULL_END
