//
//  ZLDataBaseManager.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/4/28.
//  Copyright © 2019年 ZM. All rights reserved.
//

#import "ZLDataBaseManager.h"
#import <FMDB/FMDB.h>

@interface ZLDataBaseManager()

@property(nonatomic,strong) NSMutableDictionary * dbDic;         //! key -> FMDB

@end


@implementation ZLDataBaseManager

+ (instancetype) sharedInstance
{
    static ZLDataBaseManager * dbManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbManager = [[ZLDataBaseManager alloc] init];
    });
    
    return dbManager;
}

- (instancetype) init
{
    if(self = [super init])
    {
        _dbDic = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (BOOL) createDataBaseWithPath:(NSString *) dataBasePath dataBaseKey:(NSString *) dataBaseKey
{
    ZLLog_Info(@"ZLDataBase: createDatabaseWithPath[%@] key[%@]",dataBasePath,dataBaseKey);
    
    if(!dataBaseKey||[dataBaseKey length] == 0 || !dataBasePath || [dataBasePath length] == 0)
    {
        ZLLog_Info(@"ZLDataBase: dataBasePath or dataBaseKey is invalid");
        return NO;
    }
    
    FMDatabase * dataBase = [FMDatabase databaseWithPath:dataBasePath];
    
    BOOL openResult = [dataBase open];            // sqlite3_open()
    
    if(openResult)
    {
        [self.dbDic setObject:dataBase forKey:dataBaseKey];
        
        return YES;
    }
    else
    {
         ZLLog_Info(@"ZLDataBase: dataBase for [%@] open failed [%d]",dataBaseKey,1);
        return NO;
    }
}


- (BOOL) initDataBaseForKey:(NSString *) dataBaseKey withBlock:(id) initBlock
{
    return false;
}


- (void) dealloc
{
    [self.dbDic removeAllObjects];
}

@end
