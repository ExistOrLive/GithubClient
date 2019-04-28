//
//  ZLDataBaseManager.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/4/28.
//  Copyright © 2019年 ZTE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLDataBaseManager : NSObject

+ (instancetype) sharedInstance;

- (BOOL) createDataBaseWithPath:(NSString *) dataBasePath dataBaseKey:(NSString *) dataBaseKey;

@end
