//
//  ZLDataBaseSql.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/17.
//  Copyright © 2019 ZM. All rights reserved.
//

#ifndef ZLDataBaseSql_h
#define ZLDataBaseSql_h

#define ZLDBVersion 1
#define ZLDBHomePath  [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DB"]

#pragma mark - create sql
#define dbVersionTableCreate @"create table dbversion(version int default 0)"
#define githubUserTableCreate @"create table githubUser(id char(10) unique, node_id char(25), loginName varchar(50), name varchar(50), company varchar(50), blog varchar(50), location varchar(50), email varchar(30), bio text, html_url varchar(50), avatar_url varchar(70), public_repos int default 0,public_gists int default 0, followers int default 0, following int default 0,created_at char(20),updated_at char(20))"



#pragma mark - query sql
#define dbVersionQuery @"select version from dbverison"
#define githubUserQueryById @"select * from githubUser where id = %@"

#pragma mark - update sql

#define dbversionInsert @"insert into dbversion (version) values(%d)"
#define dbversionUpdate @"update dbversion set version = %d where rowid = 1"

#define githubUserInsert @"insert into githubUser (id,node_id,loginName,name,company,blog,location,email,bio,html_url,avatar_url,public_repos,public_gists,followers,following,created_at,updated_at) values(%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%d,%d,%d,%d,%@,%@)"
#define githubUserUpdate @"update githubUser set node_id = %@,loginName = %@,name = %@,company= %@,blog = %@,location = %@,email = %@, bio = %@, html_url = %@,avatar_url = %@,public_repos = %d,public_gists = %d,followers = %d, following = %d, created_at = %@,updated_at = %@ where id = %@"


#endif /* ZLDataBaseSql_h */
