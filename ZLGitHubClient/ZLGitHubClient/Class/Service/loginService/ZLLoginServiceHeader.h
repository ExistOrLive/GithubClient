//
//  ZLLoginServiceHeader.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/18.
//  Copyright © 2019 ZM. All rights reserved.
//

#ifndef ZLLoginServiceHeader_h
#define ZLLoginServiceHeader_h

typedef enum : NSUInteger {
    ZLLoginStep_init,
    ZLLoginStep_checkIsLogined,
    ZLLoginStep_logining,
    ZLLoginStep_getToken,
    ZLLoginStep_Success,
} ZLLoginStep;


static const NSNotificationName ZLLoginResult_Notification = @"ZLLoginResult_Notification";


#endif /* ZLLoginServiceHeader_h */
