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

// network
#import "ZLGithubHttpClient.h"

// html parse
#import "OCGumbo.h"
#import "OCGumbo+Query.h"

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


#pragma mark - search


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
    NSString * sortFiled = nil;
    BOOL isAsc = NO;
    
    if(filterInfo){
       finalKeyWord =  [filterInfo finalKeyWordForUserFilter:keyWord];
       sortFiled = [filterInfo getSortFiled];
       isAsc = [filterInfo getIsAsc];
    }

    [[ZLGithubHttpClient defaultClient] searchUser:response
                                           keyword:finalKeyWord
                                              sort:sortFiled
                                             order:isAsc
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
    NSString * sortFiled = nil;
    BOOL isAsc = NO;
    
    if(filterInfo){
       finalKeyWord =  [filterInfo finalKeyWordForRepoFilter:keyWord];
       sortFiled = [filterInfo getSortFiled];
       isAsc = [filterInfo getIsAsc];
    }
  
    
    [[ZLGithubHttpClient defaultClient] searchRepos:response
                                            keyword:finalKeyWord
                                               sort:sortFiled
                                              order:isAsc
                                               page:page
                                           per_page:per_page
                                       serialNumber:serialNumber];
}


#pragma mark - trending

- (void) trendingWithType:(ZLSearchType) type
                 language:(NSString *__nullable) language
                dateRange:(ZLDateRange) dateRange
             serialNumber:(NSString *) serialNumber
           completeHandle:(void(^)(ZLOperationResultModel *)) handle{

    switch(type){
         case ZLSearchTypeUsers:{
             [self trendingUserWithLanguage:language dateRange:dateRange serialNumber:serialNumber completeHandle:handle];
             break;
         }
         case ZLSearchTypeRepositories:{
             [self trendingRepoWithLanguage:language dateRange:dateRange serialNumber:serialNumber completeHandle:handle];
             break;
         }
         default:
             break;
     }

}


- (void) trendingUserWithLanguage:(NSString *__nullable) language
                        dateRange:(ZLDateRange) dateRange
                     serialNumber:(NSString *) serialNumber
                   completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    NSString * url = @"https://github.com/trending/developers";
    if([language length] > 0){
        url = [url stringByAppendingPathComponent:language];
    }
    switch (dateRange) {
        case ZLDateRangeDaily:
            url = [url stringByAppendingString:@"?since=daily"];
            break;
        case ZLDateRangeWeakly:
            url = [url stringByAppendingString:@"?since=weekly"];
            break;
        case ZLDateRangeMonthly:
            url = [url stringByAppendingString:@"?since=monthly"];
            break;
        default:
            break;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

        NSError *error = nil;
        NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:url]
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
        ZLOperationResultModel * operationResultModel = [[ZLOperationResultModel alloc] init];
        if(error) {
            operationResultModel.result = false;
            operationResultModel.serialNumber = serialNumber;
            ZLGithubRequestErrorModel *model = [[ZLGithubRequestErrorModel alloc] init];
            model.message = error.localizedDescription;
        } else {
            OCGumboDocument *doc = [[OCGumboDocument alloc] initWithHTMLString:html];

        }

        ZLMainThreadDispatch({
            if(handle){
                handle(operationResultModel);
            }
        })
    });
}


- (void) trendingRepoWithLanguage:(NSString *) language
                        dateRange:(ZLDateRange) dateRange
                     serialNumber:(NSString *) serialNumber
                   completeHandle:(void(^)(ZLOperationResultModel *)) handle{

    NSString * url = @"https://github.com/trending";
    if([language length] > 0){
        url = [url stringByAppendingPathComponent:language];
    }
    switch (dateRange) {
        case ZLDateRangeDaily:
            url = [url stringByAppendingString:@"?since=daily"];
            break;
        case ZLDateRangeWeakly:
            url = [url stringByAppendingString:@"?since=weekly"];
            break;
        case ZLDateRangeMonthly:
            url = [url stringByAppendingString:@"?since=monthly"];
            break;
        default:
            break;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

        NSError *error = nil;
        NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:url]
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
        ZLOperationResultModel * operationResultModel = [[ZLOperationResultModel alloc] init];
        if(error) {
            operationResultModel.result = false;
            operationResultModel.serialNumber = serialNumber;
            ZLGithubRequestErrorModel *model = [[ZLGithubRequestErrorModel alloc] init];
            model.message = error.localizedDescription;
        } else {
            OCGumboDocument *doc = [[OCGumboDocument alloc] initWithHTMLString:html];
            NSMutableArray * repoArray = [NSMutableArray new];

            NSArray *articles = doc.Query(@"article");
            for(OCGumboElement *article in articles){
                OCGumboElement *h1 =  article.Query(@"h1").firstObject;
                OCGumboElement *a = h1.Query(@"a").firstObject;
                NSString * fullName = a.attr(@"href");
                if([fullName length] > 0){
                    ZLGithubRepositoryModel * model = [ZLGithubRepositoryModel new];
                    model.full_name = [fullName substringFromIndex:1];
                    [repoArray addObject:model];
                }
            }
            operationResultModel.data = repoArray;
            operationResultModel.result = true;
            operationResultModel.serialNumber = serialNumber;
        }

        ZLMainThreadDispatch({
            if(handle){
                handle(operationResultModel);
            }
        })
    });
}


@end
