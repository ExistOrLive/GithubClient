//
//  NSString+ZLExtension.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/9/1.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZLExtension)

+ (NSString *) generateSerialNumber;

+ (NSString *) MIMETypeForExtention:(NSString *) ext;

+ (BOOL) isTextFileForExtension:(NSString *) ext;

-(NSString *)htmlEntityDecode;


-(NSString *)htmlEntityEncode;

@end

NS_ASSUME_NONNULL_END
