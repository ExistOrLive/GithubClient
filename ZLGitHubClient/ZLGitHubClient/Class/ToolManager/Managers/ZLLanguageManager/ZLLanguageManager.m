//
//  ZLLanguageManager.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/30.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLLanguageManager.h"

@interface ZLLanguageManager()

@property(nonatomic, strong) NSBundle * currentLanguageBundle;              //!当前语言对应的国际化文件bundle

@property(assign, nonatomic) ZLLanguageType currentLanguageType;            //!当前语言类型，默认ZLLanguageType_English

@end

@implementation ZLLanguageManager

+ (instancetype) sharedInstance
{
    static ZLLanguageManager * logManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logManager = [[ZLLanguageManager alloc] init];
    });
    return logManager;
}


- (instancetype) init
{
    if(self = [super init])
    {
        _currentLanguageType = ZLLanguageType_SimpleChinese;
        // 初始化加载默认的语言类型
        switch(_currentLanguageType)
        {
            case ZLLanguageType_English:
            {
                NSString * resourcePath = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
                _currentLanguageBundle = [NSBundle bundleWithPath:resourcePath];
            }
                break;
            case ZLLanguageType_SimpleChinese:
            {
                NSString * resourcePath = [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
                _currentLanguageBundle = [NSBundle bundleWithPath:resourcePath];
            }
                break;
        }
        
        if(!_currentLanguageBundle)
        {
            ZLLog_Warning(@"ZLLanguage: resource file for currentLanguageType[%d] load failed",_currentLanguageType);
            NSString * resourcePath = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
            _currentLanguageBundle = [NSBundle bundleWithPath:resourcePath];
        }
        
        if(!_currentLanguageBundle)
        {
            ZLLog_Warning(@"ZLLanguage: resource file for defaultLanguageType load failed");
        }
        
    }
    return self;
}


- (NSString *)localizedWithKey:(NSString *)key
{
    if(!_currentLanguageBundle)
    {
        NSString * resourcePath = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        _currentLanguageBundle = [NSBundle bundleWithPath:resourcePath];
    }
    
    NSString * localizedString = [_currentLanguageBundle localizedStringForKey:key value:key table:@"ZLGitHubClientLocalizable"];
    
    if(!localizedString)
    {
        localizedString = key;
    }
    
    return localizedString;
}

- (ZLLanguageType) currentLanguageType
{
    return _currentLanguageType;
}

- (void) setLanguageType:(ZLLanguageType) type error:(NSError **) error
{
    
}

@end
