//
//  ZLDataBaseSql.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/17.
//  Copyright © 2019 ZM. All rights reserved.
//

#ifndef ZLDataBaseSql_h
#define ZLDataBaseSql_h

#define ZLDBVersion 2
#define ZLDBHomePath  [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DataBase"]

#pragma mark - create sql
#define DBVersionTableCreate @"CREATE TABLE DBVersion(version INTEGER DEFAULT 0)"
#define GithubUserTableCreate @"CREATE TABLE GithubUser (node_id TEXT NOT NULL, user_id TEXT NOT NULL, loginName TEXT NOT NULL, html_url TEXT,avatar_url TEXT, type INTEGER,name TEXT, company TEXT, blog TEXT, location TEXT, email  TEXT, bio TEXT, followers INTEGER, followings INTEGER, gists INTEGER, repositories INTEGER, created_at REAL, updated_at REAL, RefreshTime REAL NOT NULL, PRIMARY KEY(loginName))"

#define GithubViewerTableCreate @"CREATE TABLE GithubViewer (node_id TEXT NOT NULL, user_id TEXT NOT NULL, loginName TEXT NOT NULL, html_url TEXT,avatar_url TEXT, type INTEGER,name TEXT, company TEXT, blog TEXT, location TEXT, email  TEXT, bio TEXT, followers INTEGER, followings INTEGER, gists INTEGER, repositories INTEGER, created_at REAL, updated_at REAL, RefreshTime REAL NOT NULL, PRIMARY KEY(loginName))"

#define GithubOrgTableCreate @"CREATE TABLE GithubOrganization (node_id TEXT NOT NULL, user_id TEXT NOT NULL, loginName TEXT NOT NULL, html_url TEXT,avatar_url TEXT, type INTEGER,name TEXT, blog TEXT, location TEXT, email  TEXT, bio TEXT, members INTEGER, teams INTEGER, repositories INTEGER, created_at REAL, updated_at REAL, RefreshTime REAL NOT NULL, PRIMARY KEY(loginName))"

#define GithubRepositoryTableCreate @"CREATE TABLE GithubRepository (node_id TEXT NOT NULL, repo_id TEXT NOT NULL, full_name TEXT NOT NULL, name TEXT NOT NULL, desc_Repo TEXT, html_url TEXT, isPriva INTEGER, homepage_url TEXT, language TEXT, default_branch TEXT, sourceRepoFullName TEXT, open_issues_count INTEGER, stargazers_count INTEGER, subscribers_count INTEGER, forks_count    INTEGER, created_at REAL, updated_at REAL, pushed_at REAL, owner_node_id TEXT, owner_user_id    TEXT, owner_loginName TEXT NOT NULL, owner_html_url TEXT, owner_avatar_url TEXT, owner_type INTEGER, license_node_id TEXT, license_name TEXT, license_spdxId TEXT, license_key TEXT, RefreshTime REAL NOT NULL, PRIMARY KEY(full_name))"

#define GithubUserContributionsTableCreate @"CREATE TABLE GithubUserContributions (loginName TEXT NOT NULL, contributions TEXT, PRIMARY KEY(loginName))"





#pragma mark - query sql
#define DBVersionQuery @"select version from DBVersion"
#define GithubUserQueryByLoginName @"select * from GithubUser where loginName = ?"
#define GithubOrgQueryByLoginName @"select * from GithubOrganization where loginName = ?"
#define GithubViewerQueryByLoginName @"select * from GithubViewer where loginName = ?"
#define GithubRepoQueryByFullName @"select * from GithubRepository where full_name = ?"
#define GithubUserContributionsQueryByLogin @"select contributions from GithubUserContributions where loginName = ?"


#pragma mark - update sql

#define DBVersionInsert @"insert into DBVersion (version) values(?)"
#define DBVersionUpdate @"update DBVersion set version = ? where rowid = 1"

#define GithubUserInsert @"insert into GithubUser (user_id,node_id,loginName,html_url,avatar_url,type,name,company,blog,location,email,bio,followers,followings,gists,repositories,created_at,updated_at,RefreshTime) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"

#define GithubUserUpdate @"update GithubUser set node_id = ?,  user_id = ?, html_url = ?, avatar_url = ?, type = ?, name = ?, company = ?, blog = ?, location = ?, email = ?, bio = ?, followers = ?, followings = ?, gists = ?, repositories = ?, created_at = ?, updated_at = ?, RefreshTime = ? where loginName = ?"


#define GithubViewerInsert @"insert into GithubViewer (user_id,node_id,loginName,html_url,avatar_url,type,name,company,blog,location,email,bio,followers,followings,gists,repositories,created_at,updated_at,RefreshTime) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"

#define GithubViewerUpdate @"update GithubViewer set node_id = ?,  user_id = ?, html_url = ?, avatar_url = ?, type = ?, name = ?, company = ?, blog = ?, location = ?, email = ?, bio = ?, followers = ?, followings = ?, gists = ?, repositories = ?, created_at = ?, updated_at = ?, RefreshTime = ? where loginName = ?"

#define GithubOrganizationInsert @"insert into GithubOrganization (node_id,user_id,loginName,html_url,avatar_url,type,name,blog,location,email,bio,members,teams,repositories,created_at,updated_at,RefreshTime) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"

#define GithubOrganizationUpdate @"update GithubOrganization set node_id = ?, user_id = ?, html_url = ?, avatar_url = ?, type = ?, name = ?, blog = ?, location = ?, email = ?, bio = ?, members = ?, teams = ?, repositories = ?, created_at = ?, updated_at = ?, RefreshTime = ? where loginName = ?"

#define GithubRepoInsert @"insert into GithubRepository (repo_id,node_id,name,full_name,desc_Repo,html_url,isPriva,homepage_url,language,default_branch,sourceRepoFullName,open_issues_count,stargazers_count,subscribers_count,forks_count,updated_at,created_at,pushed_at,owner_user_id,owner_node_id,owner_loginName,owner_html_url,owner_avatar_url,owner_type,license_name,license_key,license_node_id,license_spdxId,RefreshTime) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"

#define GithubRepoUpdate @"update GithubRepository set repo_id = ?, node_id = ?, name = ?, desc_Repo = ?, html_url = ?, isPriva = ?, homepage_url = ?, language = ?, default_branch = ?, sourceRepoFullName = ?, open_issues_count = ?, stargazers_count = ?, forks_count = ?, subscribers_count = ?, updated_at = ?, created_at = ?, pushed_at = ?, owner_avatar_url = ?, owner_html_url = ?, owner_loginName = ?, owner_node_id = ?, owner_type = ?, owner_user_id = ?,license_key = ?, license_name = ?, license_node_id = ?, license_spdxId = ?, RefreshTime = ? where full_name = ?"


#define GithubUserContributionsInsert @"insert into GithubUserContributions(loginName,contributions) values(?,?)"
#define GithubUserContributionsUpdate @"update GithubUserContributions set contributions = ? where loginName = ?"



#endif /* ZLDataBaseSql_h */
