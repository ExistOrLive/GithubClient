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

@property(nonatomic, strong) FMDatabaseQueue *dbQueue;

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

- (instancetype) init{
    if(self = [super init]){
        [self initialDB];
    }
    return self;
}

- (void) dealloc{
    [self.dbQueue close];
}

#pragma mark -

- (void) initialDB{
    
    NSString * dbHomePath = ZLDBHomePath;
    
    // 1.检查DBHomePath是否存在，不存在则创建
    if(![[NSFileManager defaultManager] fileExistsAtPath:dbHomePath]){
        NSError * error;
        BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:dbHomePath withIntermediateDirectories:YES attributes:nil error:&error];
        if(!result)
        {
            ZLLog_Error(@"ZLDataBase: create dbHomePath failed error=%@",error.localizedDescription);
            return;
        }
    }
        
    NSString * dbPath = [NSString stringWithFormat:@"%@/%@.db",dbHomePath,@"github"];
        
    // 2、创建db，并打开
    FMDatabaseQueue * queue = [ZLDataBaseManager initialDataBaseQueueWithPath:dbPath withkey:nil];
        
    if(!queue){
        ZLLog_Error(@"ZLDataBase: init db queue failed");
        return;
    }
    
    ZLLog_Error(@"ZLDataBase: init db queue success");
    
    //3、 创建或者更新表
    [ZLDataBaseManager createAndUpdateGithubClientTableOfDBPool:queue];
    
    self.dbQueue = queue;
 
}


- (ZLGithubUserBriefModel *) getUserOrOrgInfoWithLoginName:(NSString *) loginName{
    
    __block ZLGithubUserBriefModel * resultModel = nil;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        
        FMResultSet * resultSet = [ZLDataBaseManager queryTableInDB:db WithSql:GithubUserQueryByLoginName,loginName];
        if([resultSet next])
        {
            ZLGithubUserModel *model = [[ZLGithubUserModel alloc] init];
            model.user_id = [resultSet stringForColumn:@"user_id"];
            model.node_id = [resultSet stringForColumn:@"node_id"];
            model.loginName = [resultSet stringForColumn:@"loginName"];
            model.html_url = [resultSet stringForColumn:@"html_url"];
            model.avatar_url = [resultSet stringForColumn:@"avatar_url"];
            model.type = ZLGithubUserTypeUser;
            model.name = [resultSet stringForColumn:@"name"];
            model.company = [resultSet stringForColumn:@"company"];
            model.blog = [resultSet stringForColumn:@"blog"];
            model.location = [resultSet stringForColumn:@"location"];
            model.email = [resultSet stringForColumn:@"email"];
            model.bio = [resultSet stringForColumn:@"bio"];
            model.repositories = [resultSet intForColumn:@"repositories"];
            model.gists = [resultSet intForColumn:@"gists"];
            model.followers = [resultSet intForColumn:@"followers"];
            model.following = [resultSet intForColumn:@"followings"];
            model.created_at = [resultSet dateForColumn:@"created_at"];
            model.updated_at = [resultSet dateForColumn:@"updated_at"];
           
            resultModel = model;
        }
        [resultSet close];
        
        if(resultModel) {
            return;
        }
        
        resultSet = [ZLDataBaseManager queryTableInDB:db WithSql:GithubOrgQueryByLoginName,loginName];
        if([resultSet next])
        {
            ZLGithubOrgModel *model = [[ZLGithubOrgModel alloc] init];
            model.user_id = [resultSet stringForColumn:@"user_id"];
            model.node_id = [resultSet stringForColumn:@"node_id"];
            model.loginName = [resultSet stringForColumn:@"loginName"];
            model.html_url = [resultSet stringForColumn:@"html_url"];
            model.avatar_url = [resultSet stringForColumn:@"avatar_url"];
            model.type = ZLGithubUserTypeOrganization;
            model.name = [resultSet stringForColumn:@"name"];
            model.blog = [resultSet stringForColumn:@"blog"];
            model.location = [resultSet stringForColumn:@"location"];
            model.email = [resultSet stringForColumn:@"email"];
            model.bio = [resultSet stringForColumn:@"bio"];
            model.repositories = [resultSet intForColumn:@"repositories"];
            model.members = [resultSet intForColumn:@"members"];
            model.teams = [resultSet intForColumn:@"teams"];
            model.created_at = [resultSet dateForColumn:@"created_at"];
            model.updated_at = [resultSet dateForColumn:@"updated_at"];
            
            resultModel = model;
        }
        [resultSet close];
    
        
    }];
        
    return resultModel;
}

- (void) insertOrUpdateUserInfo:(ZLGithubUserBriefModel *) model{
    
    if(model.loginName.length == 0)
    {
        ZLLog_Info(@"ZLDataBase: ZLGithubUserBriefModel is invalid");
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        
        if([model isKindOfClass:[ZLGithubUserModel class]]) {
            
            FMResultSet * resultSet = [ZLDataBaseManager queryTableInDB:db WithSql:GithubUserQueryByLoginName,model.loginName];
            
            ZLGithubUserModel *userModel = (ZLGithubUserModel *)model;
            
            if([resultSet next]){
                
                ZLLog_Info(@"ZLDataBase: record for model[%@] is exist, so update",model.loginName);
                
                [ZLDataBaseManager updateTableInDB:db
                                           WithSql:GithubUserUpdate,userModel.node_id,userModel.user_id,userModel.html_url,userModel.avatar_url,@(ZLGithubUserTypeUser),userModel.name,userModel.company,userModel.blog,userModel.location,userModel.email,userModel.bio,@(userModel.followers),@(userModel.following),@(userModel.gists),@(userModel.repositories),userModel.created_at,userModel.updated_at,[NSDate new],userModel.loginName];
            }
            else if(resultSet)
            {
                ZLLog_Info(@"ZLDataBase: record for model[%@] not exist, so insert",model.loginName);
                
                [ZLDataBaseManager updateTableInDB:db
                                           WithSql:GithubUserInsert,userModel.user_id,userModel.node_id,userModel.loginName,userModel.html_url,userModel.avatar_url,@(ZLGithubUserTypeUser),userModel.name,userModel.company,userModel.blog,userModel.location,userModel.email,userModel.bio,@(userModel.followers),@(userModel.following),@(userModel.gists),@(userModel.repositories),userModel.created_at,userModel.updated_at,[NSDate new]];
            }
            else
            {
                ZLLog_Error(@"ZLDataBase: query user[%@] failed",model.loginName);
            }
            
            [resultSet close];
            
        }else if([model isKindOfClass:[ZLGithubOrgModel class]]) {
            
            FMResultSet * resultSet = [ZLDataBaseManager queryTableInDB:db WithSql:GithubOrgQueryByLoginName,model.loginName];
            
            ZLGithubOrgModel* orgModel = (ZLGithubOrgModel *)model;
            
            if([resultSet next])
            {
                ZLLog_Info(@"ZLDataBase: record for model[%@] is exist, so update",model.loginName);
                
                [ZLDataBaseManager updateTableInDB:db
                                           WithSql:GithubOrganizationUpdate,orgModel.node_id,orgModel.user_id,model.html_url,orgModel.avatar_url,@(ZLGithubUserTypeOrganization),orgModel.name,orgModel.blog,orgModel.location,orgModel.email,orgModel.bio,@(orgModel.members),@(orgModel.teams),@(orgModel.repositories),orgModel.created_at,orgModel.updated_at,[NSDate new],orgModel.loginName];
            }
            else if(resultSet)
            {
                ZLLog_Info(@"ZLDataBase: record for model[%@] not exist, so insert",model.loginName);
                
                [ZLDataBaseManager updateTableInDB:db
                                           WithSql:GithubOrganizationInsert,orgModel.node_id,orgModel.user_id,orgModel.loginName,model.html_url,orgModel.avatar_url,@(ZLGithubUserTypeOrganization),orgModel.name,orgModel.blog,orgModel.location,orgModel.email,orgModel.bio,@(orgModel.members),@(orgModel.teams),@(orgModel.repositories),orgModel.created_at,orgModel.updated_at,[NSDate new]];
            }
            else
            {
                ZLLog_Error(@"ZLDataBase: query org[%@] failed",model.loginName);
            }
            
            [resultSet close];
            
        }
    }];
}



- (ZLGithubUserModel *) getViewerInfoWithLoginName:(NSString *) loginName{
    
    __block ZLGithubUserModel * resultModel = nil;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
                
        FMResultSet * resultSet = [ZLDataBaseManager queryTableInDB:db WithSql:GithubViewerQueryByLoginName,loginName];
        if([resultSet next])
        {
            ZLGithubUserModel *model = [[ZLGithubUserModel alloc] init];
            model.user_id = [resultSet stringForColumn:@"user_id"];
            model.node_id = [resultSet stringForColumn:@"node_id"];
            model.loginName = [resultSet stringForColumn:@"loginName"];
            model.html_url = [resultSet stringForColumn:@"html_url"];
            model.avatar_url = [resultSet stringForColumn:@"avatar_url"];
            model.type = ZLGithubUserTypeUser;
            model.name = [resultSet stringForColumn:@"name"];
            model.company = [resultSet stringForColumn:@"company"];
            model.blog = [resultSet stringForColumn:@"blog"];
            model.location = [resultSet stringForColumn:@"location"];
            model.email = [resultSet stringForColumn:@"email"];
            model.bio = [resultSet stringForColumn:@"bio"];
            model.repositories = [resultSet intForColumn:@"repositories"];
            model.gists = [resultSet intForColumn:@"gists"];
            model.followers = [resultSet intForColumn:@"followers"];
            model.following = [resultSet intForColumn:@"followings"];
            model.created_at = [resultSet dateForColumn:@"created_at"];
            model.updated_at = [resultSet dateForColumn:@"updated_at"];
           
            resultModel = model;
        }
        [resultSet close];
    }];
    
    return resultModel;
}

- (void) insertOrUpdateViewerInfo:(ZLGithubUserModel *) model{
    
    if(model.loginName.length == 0){
        ZLLog_Info(@"ZLDataBase: ZLGithubUserModel is invalid");
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        
        FMResultSet * resultSet = [ZLDataBaseManager queryTableInDB:db WithSql:GithubViewerQueryByLoginName,model.loginName];
        
        ZLGithubUserModel *userModel = model;
        
        if([resultSet next]){
            
            ZLLog_Info(@"ZLDataBase: record for model[%@] is exist, so update",model.loginName);
            
            [ZLDataBaseManager updateTableInDB:db
                                       WithSql:GithubViewerUpdate,userModel.node_id,userModel.user_id,userModel.html_url,userModel.avatar_url,@(ZLGithubUserTypeUser),userModel.name,userModel.company,userModel.blog,userModel.location,userModel.email,userModel.bio,@(userModel.followers),@(userModel.following),@(userModel.gists),@(userModel.repositories),userModel.created_at,userModel.updated_at,[NSDate new],userModel.loginName];
        }
        else if(resultSet){
            
            ZLLog_Info(@"ZLDataBase: record for model[%@] not exist, so insert",model.loginName);
            
            [ZLDataBaseManager updateTableInDB:db
                                       WithSql:GithubViewerInsert,userModel.user_id,userModel.node_id,userModel.loginName,userModel.html_url,userModel.avatar_url,@(ZLGithubUserTypeUser),userModel.name,userModel.company,userModel.blog,userModel.location,userModel.email,userModel.bio,@(userModel.followers),@(userModel.following),@(userModel.gists),@(userModel.repositories),userModel.created_at,userModel.updated_at,[NSDate new]];
        }
        else
        {
            ZLLog_Error(@"ZLDataBase: query viewer[%@] failed",model.loginName);
        }
        
        [resultSet close];
    }];
}




- (ZLGithubRepositoryModel *) getRepoInfoWithFullName:(NSString *) fullName{
    
    __block ZLGithubRepositoryModel * resultModel = nil;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
                
        FMResultSet * resultSet = [ZLDataBaseManager queryTableInDB:db WithSql:GithubRepoQueryByFullName,fullName];
        if([resultSet next])
        {
            ZLGithubRepositoryModel *model = [[ZLGithubRepositoryModel alloc] init];
            model.repo_id = [resultSet stringForColumn:@"repo_id"];
            model.node_id = [resultSet stringForColumn:@"node_id"];
            model.name = [resultSet stringForColumn:@"name"];
            model.full_name = [resultSet stringForColumn:@"full_name"];
            model.desc_Repo = [resultSet stringForColumn:@"desc_Repo"];
            
            model.html_url = [resultSet stringForColumn:@"html_url"];
            model.isPriva = [resultSet stringForColumn:@"isPriva"];
            model.homepage_url = [resultSet stringForColumn:@"homepage_url"];
            model.language = [resultSet stringForColumn:@"language"];
            model.default_branch = [resultSet stringForColumn:@"default_branch"];
            model.sourceRepoFullName = [resultSet stringForColumn:@"sourceRepoFullName"];
            model.open_issues_count = [resultSet intForColumn:@"open_issues_count"];
            model.stargazers_count = [resultSet intForColumn:@"stargazers_count"];
            model.subscribers_count = [resultSet intForColumn:@"subscribers_count"];
            model.forks_count = [resultSet intForColumn:@"forks_count"];
            model.created_at = [resultSet dateForColumn:@"created_at"];
            model.updated_at = [resultSet dateForColumn:@"updated_at"];
            model.pushed_at = [resultSet dateForColumn:@"pushed_at"];
            ZLGithubUserBriefModel *userModel = [ZLGithubUserBriefModel new];
            userModel.user_id = [resultSet stringForColumn:@"owner_user_id"];
            userModel.node_id = [resultSet stringForColumn:@"owner_node_id"];
            userModel.avatar_url = [resultSet stringForColumn:@"owner_avatar_url"];
            userModel.loginName = [resultSet stringForColumn:@"owner_loginName"];
            userModel.html_url = [resultSet stringForColumn:@"owner_html_url"];
            userModel.type = [resultSet intForColumn:@"owner_type"];
            model.owner = userModel;
            ZLGithubLicenseModel *licenseModel = [ZLGithubLicenseModel new];
            licenseModel.node_id = [resultSet stringForColumn:@"license_node_id"];
            licenseModel.name = [resultSet stringForColumn:@"license_name"];
            licenseModel.spdxId = [resultSet stringForColumn:@"license_spdxId"];
            licenseModel.key = [resultSet stringForColumn:@"license_key"];
            model.license = licenseModel;
            
            resultModel = model;
        }
        [resultSet close];
    }];
    
    return resultModel;
}

- (void) insertOrUpdateRepoInfo:(ZLGithubRepositoryModel *) model{
    
    if(model.full_name.length <= 0){
        ZLLog_Info(@"ZLDataBase: ZLGithubRepositoryModel is invalid");
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        
        FMResultSet* resultSet = [ZLDataBaseManager queryTableInDB:db WithSql:GithubRepoQueryByFullName,model.full_name];
        
        if([resultSet next]){
            
            ZLLog_Info(@"ZLDataBase: record for model[%@] is exist, so update",model.full_name);
            
            [ZLDataBaseManager updateTableInDB:db
                                       WithSql:GithubRepoUpdate,model.repo_id,model.node_id,model.name,model.desc_Repo,model.html_url,@(model.isPriva),model.homepage_url,model.language,model.default_branch,model.sourceRepoFullName,@(model.open_issues_count),@(model.stargazers_count),@(model.forks_count),@(model.subscribers_count),model.updated_at,model.created_at,model.pushed_at,model.owner.avatar_url,model.owner.html_url,model.owner.loginName,model.owner.node_id,@(model.owner.type),model.owner.user_id,model.license.key,model.license.name,model.license.node_id,model.license.spdxId,[NSDate new],model.full_name];
            
            
        } else if(resultSet){
            
            ZLLog_Info(@"ZLDataBase: record for model[%@] not exist, so insert",model.full_name);
            
            [ZLDataBaseManager updateTableInDB:db
                                       WithSql:GithubRepoInsert,model.repo_id,model.node_id,model.name,model.full_name,model.desc_Repo,model.html_url,@(model.isPriva),model.homepage_url,model.language,model.default_branch,model.sourceRepoFullName,@(model.open_issues_count),@(model.stargazers_count),@(model.subscribers_count),@(model.forks_count),model.updated_at,model.created_at,model.pushed_at,model.owner.user_id,model.owner.node_id,model.owner.loginName,model.owner.html_url,model.owner.avatar_url,@(model.owner.type),model.license.name,model.license.key,model.license.node_id,model.license.spdxId,[NSDate new]];
            
        }
        else
        {
            ZLLog_Error(@"ZLDataBase: query repo[%@] failed",model.full_name);
        }
        
        [resultSet close];

    }];
}



- (NSString *) getUserContributionsWithLoginName:(NSString *) loginName{
    
    __block NSString* contributions = nil;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
                
        FMResultSet * resultSet = [ZLDataBaseManager queryTableInDB:db WithSql:GithubUserContributionsQueryByLogin,loginName];
        if([resultSet next]){
            contributions = [resultSet stringForColumn:@"contributions"];
        }
        [resultSet close];
    }];
    
    return contributions;
}

- (void) insertOrUpdateUserContributions:(NSString *) contributions loginName:(NSString *) loginName{
    
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
                
        FMResultSet * resultSet = [ZLDataBaseManager queryTableInDB:db WithSql:GithubUserContributionsQueryByLogin,loginName];
        if([resultSet next])
        {
            [ZLDataBaseManager updateTableInDB:db WithSql:GithubUserContributionsUpdate,contributions,loginName];
        } else {
            [ZLDataBaseManager updateTableInDB:db WithSql:GithubUserContributionsInsert,loginName,contributions];
        }
        [resultSet close];
    }];
}




#pragma mark - create Table

+ (void) createAndUpdateGithubClientTableOfDBPool:(FMDatabaseQueue *)dbQueue
{
    [dbQueue inTransaction:^(FMDatabase * _Nonnull db , BOOL *rollback) {
        
        // 1. 获取当前DB的version
        int version = [self getDBVersionForDB:db];
        
        switch(version)
        {
            case 0:
            {
                // version表
                [self updateTableInDB:db WithSql:DBVersionTableCreate];
                // GitHubUser
                [self updateTableInDB:db WithSql:GithubUserTableCreate];
                // GitHubViewer
                [self updateTableInDB:db WithSql:GithubViewerTableCreate];
                // GitHubOrg
                [self updateTableInDB:db WithSql:GithubOrgTableCreate];
                // GitHubRepo
                [self updateTableInDB:db WithSql:GithubRepositoryTableCreate];
                
                [self insertDBVersionForDB:db withVersion:ZLDBVersion];
            }
            case 1:
            {
                [self updateTableInDB:db WithSql:GithubUserContributionsTableCreate];
            
                [self updateDBVersionForDB:db withVersion:ZLDBVersion];
            }
            case ZLDBVersion:
            {
                
            }
                break;
            default:
                break;
        }
    }];
}


+ (void) createAndUpdateGithubClientTableOfDB:(FMDatabase *)db
{
    // 1. 获取当前DB的version
    int version = [self getDBVersionForDB:db];
    
    switch(version)
    {
        case 0:
        {
            // version表
            [self updateTableInDB:db WithSql:DBVersionTableCreate];
            // GitHubUser
            [self updateTableInDB:db WithSql:GithubUserTableCreate];
            // GitHubViewer
            [self updateTableInDB:db WithSql:GithubViewerTableCreate];
            // GitHubOrg
            [self updateTableInDB:db WithSql:GithubOrgTableCreate];
            // GitHubRepo
            [self updateTableInDB:db WithSql:GithubRepositoryTableCreate];
            
            [self insertDBVersionForDB:db withVersion:ZLDBVersion];
        }
        case ZLDBVersion:
            break;
        default:
            break;
    }
}


/**
 *
 * 获取当前表版本号
 **/
+ (int) getDBVersionForDB:(FMDatabase *)db
{
    FMResultSet * result = [self queryTableInDB:db WithSql:DBVersionQuery];
    
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
    BOOL result = [self updateTableInDB:db WithSql:DBVersionUpdate,@(version)];
    ZLLog_Info(@"ZLDataBase: updateDBVersionForDB result= %d version=%d",result,version);
    return result;
}

/**
 *
 * 插入表版本号
 **/
+ (BOOL) insertDBVersionForDB:(FMDatabase *)db withVersion:(int) version
{
    BOOL result = [self updateTableInDB:db WithSql:DBVersionInsert,@(version)];
    ZLLog_Info(@"ZLDataBase: updateDBVersionForDB result= %d verson=%d",result,version);
    return result;
}






#pragma mark -

+ (FMDatabase *) initialDataBaseWithPath:(NSString *) dataBasePath withkey:(NSString *) dataBaseKey
{
    ZLLog_Info(@"ZLDataBase: createDatabaseWithPath[%@] key[%@]",dataBasePath,dataBaseKey);
    
    if(!dataBasePath || [dataBasePath length] == 0)
    {
        ZLLog_Info(@"ZLDataBase: dataBasePath or dataBaseKey is invalid");
        return nil;
    }
    
    FMDatabase * dataBase = [FMDatabase databaseWithPath:dataBasePath];
    
    BOOL openResult = [dataBase open];            // sqlite3_open()
    
    if(openResult)
    {
        // [dataBase setKey:dataBaseKey];
        [dataBase setShouldCacheStatements:YES];
        return dataBase;
    }
    else
    {
        ZLLog_Info(@"ZLDataBase: dataBase for [%@] open failed [%d]",dataBaseKey,1);
        return nil;
    }
}

+ (FMDatabaseQueue *) initialDataBaseQueueWithPath:(NSString *) dataBasePath withkey:(NSString *) dataBaseKey
{
    ZLLog_Info(@"ZLDataBase: createDatabaseQueueWithPath[%@] key[%@]",dataBasePath,dataBaseKey);
    
    if(!dataBasePath || [dataBasePath length] == 0)
    {
        ZLLog_Info(@"ZLDataBase: dataBasePath or dataBaseKey is invalid");
        return nil;
    }
    
    FMDatabaseQueue * dataBaseQueue = [FMDatabaseQueue databaseQueueWithPath:dataBasePath];
    
    if(dataBaseQueue)
    {
        return dataBaseQueue;
    }
    else
    {
        ZLLog_Info(@"ZLDataBase: dataBaseQueue for [%@] open failed [%d]",dataBasePath,1);
        return nil;
    }
}



/**
 * sql 中需要使用？作为占位符
 **/
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
