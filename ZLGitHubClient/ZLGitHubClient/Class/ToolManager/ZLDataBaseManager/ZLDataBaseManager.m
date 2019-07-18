//
//  ZLDataBaseManager.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/4/28.
//  Copyright © 2019年 ZM. All rights reserved.
//

#import "ZLDataBaseManager.h"
#import "ZLDataBaseSql.h"
#import <FMDB/FMDB.h>


@interface ZLDataBaseManager()

@property(strong, nonatomic) NSString * currentUser;              //! userid

@property(strong, nonatomic) NSMutableDictionary * dbDic;         //! userid -> FMDB

@property(strong, nonatomic) dispatch_queue_t concurrentQueue;      //! 并发队列 读并发 写互斥

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
        _concurrentQueue = dispatch_queue_create("ZLDataBaseManager", DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

- (void) dealloc
{
    for(FMDatabase * db in self.dbDic.allValues)
    {
        [db close];
    }
    [self.dbDic removeAllObjects];
}

#pragma mark -

- (void) initialDBForUser:(NSString *) userId
{
    if(!userId || userId.length == 0)
    {
        ZLLog_Info(@"ZLDataBase: userid is nil");
        return;
    }
    
    dispatch_barrier_async(self.concurrentQueue, ^{
        
        // 检查当前用户的数据库是否已经正常打开
        FMDatabase * tmpdb = [self.dbDic objectForKey:userId];
        if(tmpdb && [tmpdb goodConnection])
        {
            self.currentUser = userId;
            return;
        }

        NSString * dbHomePath = ZLDBHomePath;
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:dbHomePath])
        {
            NSError * error;
            BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:dbHomePath withIntermediateDirectories:YES attributes:nil error:&error];
            if(!result)
            {
                ZLLog_Error(@"ZLDataBase: create dbHomePath failed error=%@",error.localizedDescription);
                return;
            }
        }
        
        NSString * dbPath = [NSString stringWithFormat:@"%@\%@.db",dbHomePath,userId];
        
        
        // 1、创建db，并打开
        FMDatabase * db = [ZLDataBaseManager initialDataBaseWithPath:dbPath withkey:@"123456"];
        
        if(!db)
        {
            ZLLog_Error(@"ZLDataBase: init db for %@ failed",userId);
            return;
        }
        
        ZLLog_Error(@"ZLDataBase: init db for %@ success",userId);
        
        //2、 创建或者更新表
        [ZLDataBaseManager createZLGithubClientTableForDB:db];
        
        [self.dbDic setObject:db forKey:userId];
        self.currentUser = userId;
        
    });
}

- (ZLGithubUserModel *) getUserInfoWithUserId:(NSString *) userId
{
    __block ZLGithubUserModel * model = nil;
    dispatch_sync(self.concurrentQueue, ^{
        
        FMDatabase * database = [self.dbDic objectForKey:self.currentUser];
        if(!database)
        {
            ZLLog_Error(@"ZLDataBase: FMDB for currrent user[%@] not exist",self.currentUser);
        }
        
        FMResultSet * resultSet = [ZLDataBaseManager queryTableInDB:database WithSql:githubUserQueryById,userId];
        
        if([resultSet next])
        {
            model = [[ZLGithubUserModel alloc] init];
            model.identity = [resultSet stringForColumn:@"id"];
            model.node_id = [resultSet stringForColumn:@"node_id"];
            model.loginName = [resultSet stringForColumn:@"name"];
            model.company = [resultSet stringForColumn:@"company"];
            model.blog = [resultSet stringForColumn:@"blog"];
            model.location = [resultSet stringForColumn:@"location"];
            model.email = [resultSet stringForColumn:@"email"];
            model.bio = [resultSet stringForColumn:@"bio"];
            model.html_url = [resultSet stringForColumn:@"html_url"];
            model.avatar_url = [resultSet stringForColumn:@"avatar_url"];
            model.public_repos = [resultSet intForColumn:@"public_repos"];
            model.public_gists = [resultSet intForColumn:@"public_gists"];
            model.followers = [resultSet intForColumn:@"followers"];
            model.following = [resultSet intForColumn:@"following"];
            model.created_at = [resultSet stringForColumn:@"create_at"];
            model.updated_at = [resultSet stringForColumn:@"updated_at"];
        }
        
        ZLLog_Error(@"ZLDataBase: currentUserInfo[%@]",model);
    });
    return model;
}

- (void) insertOrUpdateUserInfo:(ZLGithubUserModel *) model
{
    if(model.identity.length == 0)
    {
        ZLLog_Info(@"ZLDataBase: ZLGithubUserModel is invalid");
        return;
    }
    
    dispatch_async(self.concurrentQueue, ^{
       
        FMDatabase * database = [self.dbDic objectForKey:self.currentUser];
        if(!database)
        {
            ZLLog_Error(@"ZLDataBase: FMDB for currrent user[%@] not exist",self.currentUser);
        }
        
        FMResultSet * resultSet = [ZLDataBaseManager queryTableInDB:database WithSql:githubUserQueryById,model.identity];
        
        if([resultSet next])
        {
            ZLLog_Info(@"ZLDataBase: record for model[%@] is exist, so update");
            
            [ZLDataBaseManager updateTableInDB:database WithSql:githubUserUpdate,model.node_id,model.loginName,model.name,model.company,model.blog,model.location,model.email,model.bio,model.html_url,model.avatar_url,model.public_repos,model.public_gists,model.followers,model.following,model.created_at,model.updated_at,model.identity];
        }
        else if(resultSet)
        {
            ZLLog_Info(@"ZLDataBase: record for model[%@] not exist, so insert");
            
            [ZLDataBaseManager updateTableInDB:database WithSql:githubUserInsert,model.identity,model.node_id,model.loginName,model.name,model.company,model.blog,model.location,model.email,model.bio,model.html_url,model.avatar_url,model.public_repos,model.public_gists,model.followers,model.following,model.created_at,model.updated_at];
        }
        else
        {
            ZLLog_Error(@"ZLDataBase: query user[%@] failed",model);
        }
    });
}


#pragma mark - create Table

+ (void) createZLGithubClientTableForDB:(FMDatabase *)db
{
    int version = [self getDBVersionForDB:db];
    
    switch(version)
    {
        case 0:
        {
            // version表
            [self updateTableInDB:db WithSql:dbVersionTableCreate];
            // GitHubUser
            [self updateTableInDB:db WithSql:githubUserTableCreate];
        }
        case ZLDBVersion:
            break;
        default:
            break;
    }
    
    if(version == 0)
    {
        [self insertDBVersionForDB:db withVersion:ZLDBVersion];
    }
    else
    {
        [self updateDBVersionForDB:db withVersion:ZLDBVersion];
    }
}


/**
 *
 * 获取当前表版本号
 **/
+ (int) getDBVersionForDB:(FMDatabase *)db
{
    FMResultSet * result = [self queryTableInDB:db WithSql:dbVersionQuery];
    
    int version = 0;
    while([result next])
    {
        version = [result intForColumn:@"version"];
    }
    
    ZLLog_Info(@"ZLDataBase: current db version = %d",version);
    return version;
}

/**
 *
 * 更新表版本号
 **/
+ (BOOL) updateDBVersionForDB:(FMDatabase *)db withVersion:(int) version
{
    BOOL result = [self updateTableInDB:db WithSql:dbversionUpdate,version];
    ZLLog_Info(@"ZLDataBase: updateDBVersionForDB result= %d version=%d",result,version);
    return result;
}

/**
 *
 * 插入表版本号
 **/
+ (BOOL) insertDBVersionForDB:(FMDatabase *)db withVersion:(int) version
{
    BOOL result = [self updateTableInDB:db WithSql:dbversionInsert,version];
    ZLLog_Info(@"ZLDataBase: updateDBVersionForDB result= %d verson=%d",result,version);
    return result;
}






#pragma mark -

+ (FMDatabase *) initialDataBaseWithPath:(NSString *) dataBasePath withkey:(NSString *) dataBaseKey
{
    ZLLog_Info(@"ZLDataBase: createDatabaseWithPath[%@] key[%@]",dataBasePath,dataBaseKey);
    
    if(!dataBaseKey||[dataBaseKey length] == 0 || !dataBasePath || [dataBasePath length] == 0)
    {
        ZLLog_Info(@"ZLDataBase: dataBasePath or dataBaseKey is invalid");
        return nil;
    }
    
    FMDatabase * dataBase = [FMDatabase databaseWithPath:dataBasePath];
    
    BOOL openResult = [dataBase open];            // sqlite3_open()
    
    if(openResult)
    {
        // [dataBase setKey:dataBaseKey];
        return dataBase;
    }
    else
    {
        ZLLog_Info(@"ZLDataBase: dataBase for [%@] open failed [%d]",dataBaseKey,1);
        return nil;
    }
}

+ (BOOL) updateTableInDB:(FMDatabase *) db WithSql:(NSString *) sql withArgumentsInArray:(NSArray *) array
{
    ZLLog_Info(@"ZLDataBase: dbUpdate sql=%@ db=%@",sql,db);
    
    BOOL result = [db executeUpdate:sql withArgumentsInArray:array];

    if(!result)
    {
        ZLLog_Error(@"ZLDataBase: dbUpdate Error sql=%@ error=%@ errorMessage=%@",sql,db.lastError,db.lastErrorMessage);
    }
    
    return result;
}

+ (BOOL) updateTableInDB:(FMDatabase *) db WithSql:(NSString *) sql,...
{
    va_list vaList;
    va_start(vaList, sql);
    
    ZLLog_Info(@"ZLDataBase: dbUpdate sql=%@ db=%@",sql,db);
    
    BOOL result = [db executeUpdate:sql withVAList:vaList];
    
    va_end(vaList);
    
    if(!result)
    {
        ZLLog_Error(@"ZLDataBase: dbUpdate Error sql=%@ error=%@ errorMessage=%@",sql,db.lastError,db.lastErrorMessage);
    }
    
    return result;
}

+ (FMResultSet *) queryTableInDB:(FMDatabase *) db WithSql:(NSString *) sql withArgumentsInArray:(NSArray *) array
{
    ZLLog_Info(@"ZLDataBase: dbQuery sql=%@ db=%@",sql,db);
    
    FMResultSet * resultSet = [db executeQuery:sql withArgumentsInArray:array];
    
    if(!resultSet)
    {
        ZLLog_Error(@"ZLDataBase: dbQuery Error sql=%@ error=%@ errorMessage=%@",sql,db.lastError,db.lastErrorMessage);
    }
    
    return resultSet;
}

+ (FMResultSet *) queryTableInDB:(FMDatabase *) db WithSql:(NSString *) sql,...
{
    va_list vaList;
    va_start(vaList, sql);
    
    ZLLog_Info(@"ZLDataBase: dbQuery sql=%@ db=%@",sql,db);
    
    FMResultSet * resultSet = [db executeQuery:sql withVAList:vaList];
    
    va_end(vaList);
    
    if(!resultSet)
    {
        ZLLog_Error(@"ZLDataBase: dbQuery Error sql=%@ error=%@ errorMessage=%@",sql,db.lastError,db.lastErrorMessage);
    }
    
    return resultSet;
}




@end
