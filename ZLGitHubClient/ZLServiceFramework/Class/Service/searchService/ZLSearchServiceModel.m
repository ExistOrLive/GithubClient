//
//  ZLSearchServiceModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/8.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLSearchServiceModel.h"

// model
#import "ZLSearchFilterInfoModel.h"
#import "ZLSearchResultModel.h"
#import "ZLOperationResultModel.h"

// network
#import "ZLGithubHttpClient.h"


@implementation ZLSearchServiceModel

+ (instancetype) sharedServiceModel
{
    static ZLSearchServiceModel * serviceModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceModel = [[ZLSearchServiceModel alloc] init];
    });
    return serviceModel;
}


#pragma mark - search rest api


- (void) searchInfoWithKeyWord:(NSString *) keyWord
                          type:(ZLSearchType) type
                    filterInfo:(ZLSearchFilterInfoModel * __nullable) filterInfo
                          page:(NSUInteger) page
                      per_page:(NSUInteger) per_page
                  serialNumber:(NSString *) serialNumber{
    switch(type){
        case ZLSearchTypeUsers:{
            [self searchUserInfoKeyWord:keyWord filterInfo:filterInfo page:page per_page:per_page serialNumber:serialNumber];
            break;
        }
        case ZLSearchTypeRepositories:{
            [self searchRepoInfoKeyWord:keyWord filterInfo:filterInfo page:page per_page:per_page serialNumber:serialNumber];
            break;
        }
        default:
            break;
    }
}

- (void) searchUserInfoKeyWord:(NSString *) keyWord
                    filterInfo:(ZLSearchFilterInfoModel * __nullable) filterInfo
                          page:(NSUInteger) page
                      per_page:(NSUInteger) per_page
                  serialNumber:(NSString *) serialNumber{
    __weak typeof(self) weakSelf = self;
    GithubResponse response = ^(BOOL result,id responseObject,NSString * serialNumber){
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        ZLMainThreadDispatch([weakSelf postNotification:ZLSearchResult_Notification withParams:repoResultModel];)
    };
    
    NSString * finalKeyWord = keyWord;
    
    if(filterInfo){
       finalKeyWord =  [filterInfo finalKeyWordForUserFilter:keyWord];
    }

    [[ZLGithubHttpClient defaultClient] searchUser:response
                                           keyword:finalKeyWord
                                              sort:filterInfo.order
                                             order:filterInfo.isAsc
                                              page:page
                                          per_page:per_page
                                      serialNumber:serialNumber];
}


- (void) searchRepoInfoKeyWord:(NSString *) keyWord
                    filterInfo:(ZLSearchFilterInfoModel * __nullable) filterInfo
                          page:(NSUInteger) page
                      per_page:(NSUInteger) per_page
                  serialNumber:(NSString *) serialNumber{
    
    __weak typeof(self) weakSelf = self;
    GithubResponse response = ^(BOOL result,id responseObject,NSString * serialNumber){
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        ZLMainThreadDispatch([weakSelf postNotification:ZLSearchResult_Notification withParams:repoResultModel];)
    };
    
    
    NSString * finalKeyWord = keyWord;
    
    if(filterInfo){
       finalKeyWord =  [filterInfo finalKeyWordForRepoFilter:keyWord];
    }
  
    
    [[ZLGithubHttpClient defaultClient] searchRepos:response
                                            keyword:finalKeyWord
                                               sort:filterInfo.order
                                              order:filterInfo.isAsc
                                               page:page
                                           per_page:per_page
                                       serialNumber:serialNumber];
}


- (void) searchIssuesInfoKeyWord:(NSString *) keyWord
                      filterInfo:(ZLSearchFilterInfoModel * __nullable) filterInfo
                            page:(NSUInteger) page
                        per_page:(NSUInteger) per_page
                    serialNumber:(NSString *) serialNumber{
    
    __weak typeof(self) weakSelf = self;
    GithubResponse response = ^(BOOL result,id responseObject,NSString * serialNumber){
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        ZLMainThreadDispatch([weakSelf postNotification:ZLSearchResult_Notification withParams:repoResultModel];)
    };
    
    
    NSString * finalKeyWord = keyWord;
    
    if(filterInfo){
       finalKeyWord =  [filterInfo finalKeyWordForRepoFilter:keyWord];
    }
  
    
    [[ZLGithubHttpClient defaultClient] searchRepos:response
                                            keyword:finalKeyWord
                                               sort:filterInfo.order
                                              order:filterInfo.isAsc
                                               page:page
                                           per_page:per_page
                                       serialNumber:serialNumber];
}






- (void) searchInfoWithKeyWord:(NSString *) keyWord
                          type:(ZLSearchType) type
                    filterInfo:(ZLSearchFilterInfoModel * __nullable) filterInfo
                          page:(NSUInteger) page
                      per_page:(NSUInteger) per_page
                  serialNumber:(NSString *) serialNumber
                completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    switch(type){
        case ZLSearchTypeUsers:{
            [self searchUserInfoKeyWord:keyWord
                             filterInfo:filterInfo
                                   page:page
                               per_page:per_page
                           serialNumber:serialNumber
                         completeHandle:handle];
            break;
        }
        case ZLSearchTypeRepositories:{
            [self searchRepoInfoKeyWord:keyWord
                             filterInfo:filterInfo
                                   page:page
                               per_page:per_page
                           serialNumber:serialNumber
                         completeHandle:handle];
            break;
        }
        default:
            break;
    }
}


- (void) searchUserInfoKeyWord:(NSString *) keyWord
                    filterInfo:(ZLSearchFilterInfoModel * __nullable) filterInfo
                          page:(NSUInteger) page
                      per_page:(NSUInteger) per_page
                  serialNumber:(NSString *) serialNumber
                completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    GithubResponse response = ^(BOOL result,id responseObject,NSString * serialNumber){
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        ZLMainThreadDispatch(handle(repoResultModel);)
    };
    
    NSString * finalKeyWord = keyWord;
    
    if(filterInfo){
       finalKeyWord =  [filterInfo finalKeyWordForUserFilter:keyWord];
    }

    [[ZLGithubHttpClient defaultClient] searchUser:response
                                           keyword:finalKeyWord
                                              sort:filterInfo.order
                                             order:filterInfo.isAsc
                                              page:page
                                          per_page:per_page
                                      serialNumber:serialNumber];
}


- (void) searchRepoInfoKeyWord:(NSString *) keyWord
                    filterInfo:(ZLSearchFilterInfoModel * __nullable) filterInfo
                          page:(NSUInteger) page
                      per_page:(NSUInteger) per_page
                  serialNumber:(NSString *) serialNumber
                completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    GithubResponse response = ^(BOOL result,id responseObject,NSString * serialNumber){
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        ZLMainThreadDispatch(handle(repoResultModel);)
    };
    
    
    NSString * finalKeyWord = keyWord;
    
    if(filterInfo){
       finalKeyWord =  [filterInfo finalKeyWordForRepoFilter:keyWord];
    }
  
    
    [[ZLGithubHttpClient defaultClient] searchRepos:response
                                            keyword:finalKeyWord
                                               sort:filterInfo.order
                                              order:filterInfo.isAsc
                                               page:page
                                           per_page:per_page
                                       serialNumber:serialNumber];
}

#pragma mark - search graphql api

- (void) searchInfoWithKeyWord:(NSString *_Nonnull) keyWord
                          type:(ZLSearchType) type
                    filterInfo:(ZLSearchFilterInfoModel * __nullable) filterInfo
                         after:(NSString * _Nullable) after
                  serialNumber:(NSString *_Nonnull) serialNumber
                completeHandle:(void(^_Nonnull)(ZLOperationResultModel *_Nonnull)) handle{
    
    GithubResponse response = ^(BOOL result,id responseObject,NSString * serialNumber){
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        ZLMainThreadDispatch(handle(repoResultModel);)
    };
    
    NSString * query = keyWord;
    SearchTypeForOC searchType;
    
    switch(type){
        case ZLSearchTypeUsers:{
            query = filterInfo ? [filterInfo GraphqlQueryForUserFilter:keyWord] : keyWord;
            searchType = SearchTypeForOCUser;
        }
            break;
        case ZLSearchTypeOrganizations:{
            query = filterInfo ? [filterInfo GraphqlQueryForOrgFilter:keyWord] : keyWord;
            searchType = SearchTypeForOCUser;
        }
            break;
        case ZLSearchTypeRepositories:{
            query = filterInfo ? [filterInfo GraphqlQueryForRepoFilter:keyWord] : keyWord;
            searchType = SearchTypeForOCRepo;
        }
            break;
        case ZLSearchTypeIssues:{
            query = filterInfo ? [filterInfo GraphqlQueryForIssueFilter:keyWord] : keyWord;
            searchType = SearchTypeForOCIssue;
        }
            break;
        case ZLSearchTypePullRequests:{
            query = filterInfo ? [filterInfo GraphqlQueryForPullRequestFilter:keyWord] : keyWord;
            searchType = SearchTypeForOCIssue;
        }
            break;
    }
    
    [[ZLGithubHttpClient defaultClient] searchItemAfter:after
                                                  query:query
                                                   type:searchType
                                           serialNumber:serialNumber
                                                  block:response];
    
}





#pragma mark - trending

- (void) trendingWithType:(ZLSearchType) type
                 language:(NSString *__nullable) language
                dateRange:(ZLDateRange) dateRange
             serialNumber:(NSString *) serialNumber
           completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    GithubResponse response = ^(BOOL result,id responseObject,NSString * serialNumber){
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        ZLMainThreadDispatch(handle(repoResultModel);)
    };

    switch(type){
         case ZLSearchTypeUsers:{
             
             [[ZLGithubHttpClient defaultClient] trendingUser:response
                                                     language:language
                                                    dateRange:dateRange
                                                 serialNumber:serialNumber];
             break;
         }
         case ZLSearchTypeRepositories:{
             
             [[ZLGithubHttpClient defaultClient] trendingRepo:response
                                                     language:language
                                                    dateRange:dateRange
                                                 serialNumber:serialNumber];
             break;
         }
         default:
             break;
     }

}







/***
 
 <article class="Box-row">
   <div class="float-right">
       <div class="js-toggler-container js-social-container starring-container ">
     <form class="starred js-social-form" action="/facebookexperimental/Recoil/unstar" accept-charset="UTF-8" method="post"><input type="hidden" name="authenticity_token" value="k+xaTr30nN0tHrpCzVKQyHjPkvV2mVAgA4nwAgXlYjcZMy9JZ5rHKHbzhcjpb6vfrH2sIbaD+ibXdg2zPAQJAg==">
       <input type="hidden" name="context" value="trending">
       <button type="submit" class="btn btn-sm  js-toggler-target" aria-label="Unstar this repository" title="Unstar facebookexperimental/Recoil" data-hydro-click="{&quot;event_type&quot;:&quot;repository.click&quot;,&quot;payload&quot;:{&quot;target&quot;:&quot;UNSTAR_BUTTON&quot;,&quot;repository_id&quot;:261279710,&quot;originating_url&quot;:&quot;https://github.com/trending&quot;,&quot;user_id&quot;:18443373}}" data-hydro-click-hmac="0bc204e29d90c71949704fbbfa48d766e62cb6665ba2b75ae7d2060d513670b0" data-ga-click="Repository, click unstar button, action:trending#index; text:Unstar">        <svg height="16" class="octicon octicon-star v-align-text-bottom" vertical_align="text_bottom" viewBox="0 0 14 16" version="1.1" width="14" aria-hidden="true"><path fill-rule="evenodd" d="M14 6l-4.9-.64L7 1 4.9 5.36 0 6l3.6 3.26L2.67 14 7 11.67 11.33 14l-.93-4.74L14 6z"></path></svg>

         Unstar
 </button></form>
     <form class="unstarred js-social-form" action="/facebookexperimental/Recoil/star" accept-charset="UTF-8" method="post"><input type="hidden" name="authenticity_token" value="j9rAvRwhFp9yFJ/LoamUBnerqm5ngpB41yxcxzghO4p1+CX7J/ikGh7yb8T1CCRZpjNoksnNuAwBINho87iocg==">
       <input type="hidden" name="context" value="trending">
       <button type="submit" class="btn btn-sm  js-toggler-target" aria-label="Unstar this repository" title="Star facebookexperimental/Recoil" data-hydro-click="{&quot;event_type&quot;:&quot;repository.click&quot;,&quot;payload&quot;:{&quot;target&quot;:&quot;STAR_BUTTON&quot;,&quot;repository_id&quot;:261279710,&quot;originating_url&quot;:&quot;https://github.com/trending&quot;,&quot;user_id&quot;:18443373}}" data-hydro-click-hmac="ecb3b13e964fcda1d5a216bd4fd614b0a0bf4c573914e93fa95facda59ea5972" data-ga-click="Repository, click star button, action:trending#index; text:Star">        <svg height="16" class="octicon octicon-star v-align-text-bottom" vertical_align="text_bottom" viewBox="0 0 14 16" version="1.1" width="14" aria-hidden="true"><path fill-rule="evenodd" d="M14 6l-4.9-.64L7 1 4.9 5.36 0 6l3.6 3.26L2.67 14 7 11.67 11.33 14l-.93-4.74L14 6z"></path></svg>

         Star
 </button></form>  </div>

   </div>

   <h1 class="h3 lh-condensed">
     <a href="/facebookexperimental/Recoil" data-hydro-click="{&quot;event_type&quot;:&quot;explore.click&quot;,&quot;payload&quot;:{&quot;click_context&quot;:&quot;TRENDING_REPOSITORIES_PAGE&quot;,&quot;click_target&quot;:&quot;REPOSITORY&quot;,&quot;click_visual_representation&quot;:&quot;REPOSITORY_NAME_HEADING&quot;,&quot;actor_id&quot;:18443373,&quot;record_id&quot;:261279710,&quot;originating_url&quot;:&quot;https://github.com/trending&quot;,&quot;user_id&quot;:18443373}}" data-hydro-click-hmac="f5335efb9adc2524152569c6b0293f764e8325c19d7a4ebafc5e840e059cd1d0" class="md-opjjpmhoiojifppkkcdabiobhakljdgm_doc">
       <svg height="16" class="octicon octicon-repo mr-1 text-gray" mr="1" color="gray" viewBox="0 0 12 16" version="1.1" width="12" aria-hidden="true"><path fill-rule="evenodd" d="M4 9H3V8h1v1zm0-3H3v1h1V6zm0-2H3v1h1V4zm0-2H3v1h1V2zm8-1v12c0 .55-.45 1-1 1H6v2l-1.5-1.5L3 16v-2H1c-.55 0-1-.45-1-1V1c0-.55.45-1 1-1h10c.55 0 1 .45 1 1zm-1 10H1v2h2v-1h3v1h5v-2zm0-10H2v9h9V1z"></path></svg>


       <span class="text-normal">
         facebookexperimental /
 </span>


       Recoil
 </a>

   </h1>

     <p class="col-9 text-gray my-1 pr-4">
       Recoil is an experimental state management library for React apps. It provides several capabilities that are difficult to achieve with React alone, while being compatible with the newest features of React.
     </p>

   <div class="f6 text-gray mt-2">
       <span class="d-inline-block ml-0 mr-3">
   <span class="repo-language-color" style="background-color: #f1e05a"></span>
   <span itemprop="programmingLanguage">JavaScript</span>
 </span>


       <a class="muted-link d-inline-block mr-3 md-opjjpmhoiojifppkkcdabiobhakljdgm_doc" href="/facebookexperimental/Recoil/stargazers">
         <svg height="16" class="octicon octicon-star" aria-label="star" viewBox="0 0 14 16" version="1.1" width="14" aria-hidden="true"><path fill-rule="evenodd" d="M14 6l-4.9-.64L7 1 4.9 5.36 0 6l3.6 3.26L2.67 14 7 11.67 11.33 14l-.93-4.74L14 6z"></path></svg>

         2,519
 </a>


       <a class="muted-link d-inline-block mr-3 md-opjjpmhoiojifppkkcdabiobhakljdgm_doc" href="/facebookexperimental/Recoil/network/members.Recoil">
         <svg height="16" class="octicon octicon-repo-forked" aria-label="fork" viewBox="0 0 10 16" version="1.1" width="10" aria-hidden="true"><path fill-rule="evenodd" d="M8 1a1.993 1.993 0 00-1 3.72V6L5 8 3 6V4.72A1.993 1.993 0 002 1a1.993 1.993 0 00-1 3.72V6.5l3 3v1.78A1.993 1.993 0 005 15a1.993 1.993 0 001-3.72V9.5l3-3V4.72A1.993 1.993 0 008 1zM2 4.2C1.34 4.2.8 3.65.8 3c0-.65.55-1.2 1.2-1.2.65 0 1.2.55 1.2 1.2 0 .65-.55 1.2-1.2 1.2zm3 10c-.66 0-1.2-.55-1.2-1.2 0-.65.55-1.2 1.2-1.2.65 0 1.2.55 1.2 1.2 0 .65-.55 1.2-1.2 1.2zm3-10c-.66 0-1.2-.55-1.2-1.2 0-.65.55-1.2 1.2-1.2.65 0 1.2.55 1.2 1.2 0 .65-.55 1.2-1.2 1.2z"></path></svg>

         70
 </a>


       <span class="d-inline-block mr-3">
         Built by

           <a class="d-inline-block md-opjjpmhoiojifppkkcdabiobhakljdgm_doc" data-hydro-click="{&quot;event_type&quot;:&quot;explore.click&quot;,&quot;payload&quot;:{&quot;click_context&quot;:&quot;TRENDING_REPOSITORIES_PAGE&quot;,&quot;click_target&quot;:&quot;CONTRIBUTING_DEVELOPER&quot;,&quot;click_visual_representation&quot;:&quot;DEVELOPER_AVATAR&quot;,&quot;actor_id&quot;:null,&quot;record_id&quot;:null,&quot;originating_url&quot;:&quot;https://github.com/trending&quot;,&quot;user_id&quot;:10084374}}" data-hydro-click-hmac="2a8a1a04515c6cc022374c47adab297d0de1a16fa3518649a74c21820d2284dd" data-hovercard-type="user" data-hovercard-url="/users/csantos42/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self" href="/csantos42"><img class="avatar mb-1 avatar-user" src="https://avatars2.githubusercontent.com/u/17487971?s=40&amp;v=4" width="20" height="20" alt="@csantos42"></a>
           <a class="d-inline-block md-opjjpmhoiojifppkkcdabiobhakljdgm_doc" data-hydro-click="{&quot;event_type&quot;:&quot;explore.click&quot;,&quot;payload&quot;:{&quot;click_context&quot;:&quot;TRENDING_REPOSITORIES_PAGE&quot;,&quot;click_target&quot;:&quot;CONTRIBUTING_DEVELOPER&quot;,&quot;click_visual_representation&quot;:&quot;DEVELOPER_AVATAR&quot;,&quot;actor_id&quot;:null,&quot;record_id&quot;:null,&quot;originating_url&quot;:&quot;https://github.com/trending&quot;,&quot;user_id&quot;:10084374}}" data-hydro-click-hmac="2a8a1a04515c6cc022374c47adab297d0de1a16fa3518649a74c21820d2284dd" data-hovercard-type="user" data-hovercard-url="/users/vjeux/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self" href="/vjeux"><img class="avatar mb-1 avatar-user" src="https://avatars3.githubusercontent.com/u/197597?s=40&amp;v=4" width="20" height="20" alt="@vjeux"></a>
           <a class="d-inline-block md-opjjpmhoiojifppkkcdabiobhakljdgm_doc" data-hydro-click="{&quot;event_type&quot;:&quot;explore.click&quot;,&quot;payload&quot;:{&quot;click_context&quot;:&quot;TRENDING_REPOSITORIES_PAGE&quot;,&quot;click_target&quot;:&quot;CONTRIBUTING_DEVELOPER&quot;,&quot;click_visual_representation&quot;:&quot;DEVELOPER_AVATAR&quot;,&quot;actor_id&quot;:null,&quot;record_id&quot;:null,&quot;originating_url&quot;:&quot;https://github.com/trending&quot;,&quot;user_id&quot;:10084374}}" data-hydro-click-hmac="2a8a1a04515c6cc022374c47adab297d0de1a16fa3518649a74c21820d2284dd" data-hovercard-type="user" data-hovercard-url="/users/claudiopro/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self" href="/claudiopro"><img class="avatar mb-1 avatar-user" src="https://avatars1.githubusercontent.com/u/860099?s=40&amp;v=4" width="20" height="20" alt="@claudiopro"></a>
           <a class="d-inline-block md-opjjpmhoiojifppkkcdabiobhakljdgm_doc" data-hydro-click="{&quot;event_type&quot;:&quot;explore.click&quot;,&quot;payload&quot;:{&quot;click_context&quot;:&quot;TRENDING_REPOSITORIES_PAGE&quot;,&quot;click_target&quot;:&quot;CONTRIBUTING_DEVELOPER&quot;,&quot;click_visual_representation&quot;:&quot;DEVELOPER_AVATAR&quot;,&quot;actor_id&quot;:null,&quot;record_id&quot;:null,&quot;originating_url&quot;:&quot;https://github.com/trending&quot;,&quot;user_id&quot;:10084374}}" data-hydro-click-hmac="2a8a1a04515c6cc022374c47adab297d0de1a16fa3518649a74c21820d2284dd" data-hovercard-type="user" data-hovercard-url="/users/kevinfrei/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self" href="/kevinfrei"><img class="avatar mb-1 avatar-user" src="https://avatars2.githubusercontent.com/u/2213896?s=40&amp;v=4" width="20" height="20" alt="@kevinfrei"></a>
           <a class="d-inline-block md-opjjpmhoiojifppkkcdabiobhakljdgm_doc" data-hydro-click="{&quot;event_type&quot;:&quot;explore.click&quot;,&quot;payload&quot;:{&quot;click_context&quot;:&quot;TRENDING_REPOSITORIES_PAGE&quot;,&quot;click_target&quot;:&quot;CONTRIBUTING_DEVELOPER&quot;,&quot;click_visual_representation&quot;:&quot;DEVELOPER_AVATAR&quot;,&quot;actor_id&quot;:null,&quot;record_id&quot;:null,&quot;originating_url&quot;:&quot;https://github.com/trending&quot;,&quot;user_id&quot;:10084374}}" data-hydro-click-hmac="2a8a1a04515c6cc022374c47adab297d0de1a16fa3518649a74c21820d2284dd" data-hovercard-type="user" data-hovercard-url="/users/davidmccabe/hovercard" data-octo-click="hovercard-link-click" data-octo-dimensions="link_type:self" href="/davidmccabe"><img class="avatar mb-1 avatar-user" src="https://avatars1.githubusercontent.com/u/132485?s=40&amp;v=4" width="20" height="20" alt="@davidmccabe"></a>
 </span>


       <span class="d-inline-block float-sm-right">
         <svg height="16" class="octicon octicon-star" viewBox="0 0 14 16" version="1.1" width="14" aria-hidden="true"><path fill-rule="evenodd" d="M14 6l-4.9-.64L7 1 4.9 5.36 0 6l3.6 3.26L2.67 14 7 11.67 11.33 14l-.93-4.74L14 6z"></path></svg>

         876 stars today
 </span>

   </div>
 </article>
 
 */


/**
 <article class="Box-row d-flex" id="pa-flotwig">
   <a class="text-gray f6 text-center md-opjjpmhoiojifppkkcdabiobhakljdgm_doc" href="#pa-flotwig" style="width: 16px;">
     1
 </a>


   <div class="mx-3">
     <a href="/flotwig" data-hydro-click="{&quot;event_type&quot;:&quot;explore.click&quot;,&quot;payload&quot;:{&quot;click_context&quot;:&quot;TRENDING_DEVELOPERS_PAGE&quot;,&quot;click_target&quot;:&quot;OWNER&quot;,&quot;click_visual_representation&quot;:&quot;TRENDING_DEVELOPER&quot;,&quot;actor_id&quot;:18443373,&quot;record_id&quot;:1151760,&quot;originating_url&quot;:&quot;https://github.com/trending/developers&quot;,&quot;user_id&quot;:18443373}}" data-hydro-click-hmac="137d3c1d38a61e53fa3793d1514b630b8d797c2a4dd97b5e82a6ded5687ea77a" class="md-opjjpmhoiojifppkkcdabiobhakljdgm_doc">
       <img class="rounded-1 avatar-user" src="https://avatars3.githubusercontent.com/u/1151760?s=96&amp;v=4" width="48" height="48" alt="@flotwig">
 </a>

   </div>

   <div class="d-sm-flex flex-auto">
     <div class="col-sm-8 d-md-flex">
       <div class="col-md-6">
         <h1 class="h3 lh-condensed">
           <a href="/flotwig" data-hydro-click="{&quot;event_type&quot;:&quot;explore.click&quot;,&quot;payload&quot;:{&quot;click_context&quot;:&quot;TRENDING_DEVELOPERS_PAGE&quot;,&quot;click_target&quot;:&quot;OWNER&quot;,&quot;click_visual_representation&quot;:&quot;TRENDING_DEVELOPER&quot;,&quot;actor_id&quot;:18443373,&quot;record_id&quot;:1151760,&quot;originating_url&quot;:&quot;https://github.com/trending/developers&quot;,&quot;user_id&quot;:18443373}}" data-hydro-click-hmac="137d3c1d38a61e53fa3793d1514b630b8d797c2a4dd97b5e82a6ded5687ea77a" class="md-opjjpmhoiojifppkkcdabiobhakljdgm_doc">
             Zach Bloomquist
 </a>

         </h1>

           <p class="f4 text-normal mb-1">
             <a class="link-gray md-opjjpmhoiojifppkkcdabiobhakljdgm_doc" href="/flotwig" data-hydro-click="{&quot;event_type&quot;:&quot;explore.click&quot;,&quot;payload&quot;:{&quot;click_context&quot;:&quot;TRENDING_DEVELOPERS_PAGE&quot;,&quot;click_target&quot;:&quot;OWNER&quot;,&quot;click_visual_representation&quot;:&quot;TRENDING_DEVELOPER&quot;,&quot;actor_id&quot;:18443373,&quot;record_id&quot;:1151760,&quot;originating_url&quot;:&quot;https://github.com/trending/developers&quot;,&quot;user_id&quot;:18443373}}" data-hydro-click-hmac="137d3c1d38a61e53fa3793d1514b630b8d797c2a4dd97b5e82a6ded5687ea77a">
               flotwig
 </a>

           </p>
       </div>

       <div class="col-md-6">
           <div class="mt-2 mb-3 my-md-0">
             <article>
   <div class="f6 text-gray text-uppercase mb-1"><svg class="octicon octicon-flame text-orange-light mr-1" viewBox="0 0 12 16" version="1.1" width="12" height="16" aria-hidden="true"><path fill-rule="evenodd" d="M5.05.31c.81 2.17.41 3.38-.52 4.31C3.55 5.67 1.98 6.45.9 7.98c-1.45 2.05-1.7 6.53 3.53 7.7-2.2-1.16-2.67-4.52-.3-6.61-.61 2.03.53 3.33 1.94 2.86 1.39-.47 2.3.53 2.27 1.67-.02.78-.31 1.44-1.13 1.81 3.42-.59 4.78-3.42 4.78-5.56 0-2.84-2.53-3.22-1.25-5.61-1.52.13-2.03 1.13-1.89 2.75.09 1.08-1.02 1.8-1.86 1.33-.67-.41-.66-1.19-.06-1.78C8.18 5.31 8.68 2.45 5.05.32L5.03.3l.02.01z"></path></svg>Popular repo</div>
   <h1 class="h4 lh-condensed">
     <a class="css-truncate css-truncate-target md-opjjpmhoiojifppkkcdabiobhakljdgm_doc" href="/flotwig/the-one-cert" style="max-width: 175px;" data-hydro-click="{&quot;event_type&quot;:&quot;explore.click&quot;,&quot;payload&quot;:{&quot;click_context&quot;:&quot;TRENDING_DEVELOPERS_PAGE&quot;,&quot;click_target&quot;:&quot;REPOSITORY&quot;,&quot;click_visual_representation&quot;:&quot;REPOSITORY_NAME_HEADING&quot;,&quot;actor_id&quot;:18443373,&quot;record_id&quot;:185657589,&quot;originating_url&quot;:&quot;https://github.com/trending/developers&quot;,&quot;user_id&quot;:18443373}}" data-hydro-click-hmac="1b8ba5e9ff35f1fa3125b616e55fcdb4288fe1d1289c3d3010bdb385c956b9fd" data-ga-click="Explore, go to repository, location:trending developers">
         <svg class="octicon octicon-repo text-gray mr-1" viewBox="0 0 12 16" version="1.1" width="12" height="16" aria-hidden="true"><path fill-rule="evenodd" d="M4 9H3V8h1v1zm0-3H3v1h1V6zm0-2H3v1h1V4zm0-2H3v1h1V2zm8-1v12c0 .55-.45 1-1 1H6v2l-1.5-1.5L3 16v-2H1c-.55 0-1-.45-1-1V1c0-.55.45-1 1-1h10c.55 0 1 .45 1 1zm-1 10H1v2h2v-1h3v1h5v-2zm0-10H2v9h9V1z"></path></svg>
       the-one-cert
 </a>

   </h1>
     <div class="f6 text-gray mt-1">
       One cert to rule them all: SSL cert that is valid for any and all domains + all levels of subdomains
     </div>
 </article>

           </div>
       </div>
     </div>

     <div class="col-sm-4 d-flex flex-sm-justify-end ml-sm-3">

       <div class="user-profile-following-container">
         <div class="user-following-container">
           
     <span class="user-following-container js-form-toggle-container">
       <!-- '"` --><!-- </textarea></xmp> --><form class="js-form-toggle-target" action="/users/follow?target=flotwig" accept-charset="UTF-8" method="post"><input type="hidden" name="authenticity_token" value="RTyTj8DnVOFPY5Y5L2vHmFzhi0ANuQg+9RAl4zBHKotdyz+Iw9NM/6rsuZOpTXVKsne3VdUbKGYA2UMQ3gIxUw==">
         <input type="submit" name="commit" value="Follow" class="btn btn-sm btn-block " title="Follow flotwig" aria-label="Follow this person" data-disable-with="Follow">
 </form>
       <!-- '"` --><!-- </textarea></xmp> --><form class="js-form-toggle-target" hidden="hidden" action="/users/unfollow?target=flotwig" accept-charset="UTF-8" method="post"><input type="hidden" name="authenticity_token" value="YfPNN31PfcFf0b7JZOm+idigoK0mGKWwxRtxkq0Uu2M5F+4YVzY0Ee3/JspqvWb8kKj02WyC74WVhHw2ElW75A==">
         <input type="submit" name="commit" value="Unfollow" class="btn btn-sm btn-block" title="Unfollow flotwig" aria-label="Unfollow this person" data-disable-with="Unfollow">
 </form>    </span>

         </div>
       </div>
     </div>
   </div>
 </article>
 */


@end
