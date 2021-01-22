//
//  ZLLanguageManager.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/30.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLLanguageManager.h"

static NSString * ZLLanguageTypeForUserDefaults = @"ZLLanguageTypeForUserDefaults";

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


- (instancetype) init{
    
    if(self = [super init]){
        
        NSNumber * languageTypeNumber = [[NSUserDefaults standardUserDefaults] objectForKey:ZLLanguageTypeForUserDefaults];
        if(languageTypeNumber == nil) {
            _currentLanguageType = ZLLanguageType_Auto;
        } else {
            _currentLanguageType = (ZLLanguageType)[languageTypeNumber intValue];
        }
         
        // 初始化加载默认的语言类型
        switch(_currentLanguageType)
        {
            case ZLLanguageType_Auto:{
                
                // 读取系统语言设置
                //        NSString *udfLanguageCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0];
                //        NSString *pfLanguageCode = [NSLocale preferredLanguages][0];
                //        NSString *localeLanguageCode = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
                
                NSString *systemLanguage =  [[NSBundle mainBundle] preferredLocalizations][0];
                NSString * resourcePath = [[NSBundle mainBundle] pathForResource:systemLanguage ofType:@"lproj"];
                _currentLanguageBundle = [NSBundle bundleWithPath:resourcePath];
            }
                break;
            case ZLLanguageType_English:{
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
        
        if(!_currentLanguageBundle){
            ZLLog_Warning(@"ZLLanguage: resource file for currentLanguageType[%d] load failed",_currentLanguageType);
            NSString * resourcePath = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
            _currentLanguageBundle = [NSBundle bundleWithPath:resourcePath];
        }
        
        if(!_currentLanguageBundle){
            ZLLog_Warning(@"ZLLanguage: resource file for defaultLanguageType load failed");
        }
        
    }
    return self;
}


- (NSString *)localizedWithKey:(NSString *)key{
    if(!_currentLanguageBundle){
        NSString * resourcePath = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        _currentLanguageBundle = [NSBundle bundleWithPath:resourcePath];
    }
    
    NSString * localizedString = [_currentLanguageBundle localizedStringForKey:key value:key table:@"ZLGitHubClientLocalizable"];
    
    if(!localizedString){
        localizedString = key;
    }
    
    return localizedString;
}

- (ZLLanguageType) currentLanguageType{
    return _currentLanguageType;
}

- (void) setLanguageType:(ZLLanguageType) type error:(NSError **) error{
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:type] forKey:ZLLanguageTypeForUserDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];

    _currentLanguageType = type;

    switch(_currentLanguageType){
        case ZLLanguageType_Auto: {
            NSString *systemLanguage =  [[NSBundle mainBundle] preferredLocalizations][0];
            NSString * resourcePath = [[NSBundle mainBundle] pathForResource:systemLanguage ofType:@"lproj"];
            _currentLanguageBundle = [NSBundle bundleWithPath:resourcePath];
        }
            break;
        case ZLLanguageType_English:{
            NSString * resourcePath = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
            _currentLanguageBundle = [NSBundle bundleWithPath:resourcePath];
        }
            break;
        case ZLLanguageType_SimpleChinese:{
            NSString * resourcePath = [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
            _currentLanguageBundle = [NSBundle bundleWithPath:resourcePath];
        }
            break;
    }
    
    if(!_currentLanguageBundle){
        NSString * resourcePath = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        _currentLanguageBundle = [NSBundle bundleWithPath:resourcePath];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZLLanguageTypeChange_Notificaiton object:nil];
    
}

@end
