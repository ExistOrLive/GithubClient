//
//  ZLWidgetService.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/12/26.
//  Copyright © 2020 ZM. All rights reserved.
//

#import "ZLWidgetService.h"
#import "OCGumbo.h"
#import "OCGumbo+Query.h"

@implementation ZLSimpleRepoModel

@end


@implementation ZLWidgetService

+ (void) trendingRepoWithCompleteHandle:(void(^)(BOOL,NSArray *)) handle{

    NSString * url = @"https://github.com/trending?since=daily";
 
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        NSError *error = nil;
        NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:url]
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
        BOOL result = false;
        NSMutableArray *array = [NSMutableArray new];
        if(!error) {
            OCGumboDocument *doc = [[OCGumboDocument alloc] initWithHTMLString:html];
            NSArray *articles = doc.Query(@"article");
            for(OCGumboElement *article in articles){
                OCGumboElement *h1 =  article.Query(@"h1").firstObject;
                OCGumboElement *p =  article.Query(@"p").firstObject;
                OCGumboElement *a = h1.Query(@"a").firstObject;
                NSString * fullName = a.attr(@"href");
                NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"\n "];
                NSString * desc = nil;
                if(p){
                    desc = [p.text() stringByTrimmingCharactersInSet:set];
                }
                NSString *language = @"";
                int forkNumber = 0;
                int starNumber = 0;
                NSArray<OCGumboElement *>* spanElements = article.Query(@"span");
                for(OCGumboElement *element in spanElements){
                    if([@"programmingLanguage" isEqualToString:element.attr(@"itemprop")]){
                        language = element.text();
                        break;
                    }
                }
                if([fullName length] > 0){
                    ZLSimpleRepoModel *model = [ZLSimpleRepoModel new];
                    model.fullName = [fullName substringFromIndex:1];
                    model.ownerName = [fullName componentsSeparatedByString:@"/"].firstObject;
                    model.desc = desc;
                    model.language = language;
                    model.forkNumber = forkNumber;
                    model.starNumber = starNumber;
                    [array addObject:model];
                }
            }
            result = true;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            handle(result,array);
        });
    });
}



@end
