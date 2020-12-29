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

+ (void) trendingRepoWithDateRange:(FixedRepoDateRange) dateRange
                      withLanguage:(FixedRepoLanguage) language
                withCompleteHandle:(void(^)(BOOL,NSArray *)) handle{

    NSString * url = @"https://github.com/trending";
    
    NSString * languageStr = @"";
    switch (language) {
        case FixedRepoLanguageUnknown:
        case FixedRepoLanguageAny:
            break;
        case FixedRepoLanguageC:
            languageStr = @"C";
            break;
        case FixedRepoLanguageCPlusPlus:
            languageStr = @"C++";
            break;
        case FixedRepoLanguageC4:
            languageStr = @"C#";
            break;
        case FixedRepoLanguageCMake:
            languageStr = @"CMake";
            break;
        case FixedRepoLanguageCSS:
            languageStr = @"CSS";
            break;
        case FixedRepoLanguageCSV:
            languageStr = @"CSV";
            break;
        case FixedRepoLanguageD:
            languageStr = @"D";
            break;
        case FixedRepoLanguageDart:
            languageStr = @"Dart";
            break;
        case FixedRepoLanguageDockerfile:
            languageStr = @"Dockerfile";
            break;
        case FixedRepoLanguageGo:
            languageStr = @"Go";
            break;
        case FixedRepoLanguageGradle:
            languageStr = @"Gradle";
            break;
        case FixedRepoLanguageGraphQL:
            languageStr = @"GraphQL";
            break;
        case FixedRepoLanguageGroovy:
            languageStr = @"Groovy";
            break;
        case FixedRepoLanguageHTML:
            languageStr = @"HTML";
            break;
        case FixedRepoLanguageJSON:
            languageStr = @"JSON";
            break;
        case FixedRepoLanguageJava:
            languageStr = @"Java";
            break;
        case FixedRepoLanguageJavaScript:
            languageStr = @"JavaScript";
            break;
        case FixedRepoLanguageKotlin:
            languageStr = @"Kotlin";
            break;
        case FixedRepoLanguageMATLAB:
            languageStr = @"MATLAB";
            break;
        case FixedRepoLanguageMarkdown:
            languageStr = @"Markdown";
            break;
        case FixedRepoLanguageMetal:
            languageStr = @"Metal";
            break;
        case FixedRepoLanguageObjectiveC:
            languageStr = @"Objective-C";
            break;
        case FixedRepoLanguageObjectiveCPLUSPLUS:
            languageStr = @"Objective-C++";
            break;
        case FixedRepoLanguagePHP:
            languageStr = @"PHP";
            break;
        case FixedRepoLanguagePascal:
            languageStr = @"Pascal";
            break;
        case FixedRepoLanguagePerl:
            languageStr = @"Perl";
            break;
        case FixedRepoLanguagePowerShell:
            languageStr = @"PowerShell";
            break;
        case FixedRepoLanguagePython:
            languageStr = @"Python";
            break;
        case FixedRepoLanguageRuby:
            languageStr = @"Ruby";
            break;
        case FixedRepoLanguageSQL:
            languageStr = @"SQL";
            break;
        case FixedRepoLanguageShell:
            languageStr = @"Shell";
            break;
        case FixedRepoLanguageSwift:
            languageStr = @"Swift";
            break;
        case FixedRepoLanguageVue:
            languageStr = @"Vue";
            break;
        case FixedRepoLanguageXML:
            languageStr = @"XML";
            break;
        case FixedRepoLanguageYAML:
            languageStr = @"YAML";
            break;
    }
    url = [url stringByAppendingPathComponent:[languageStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]]];
    
    switch (dateRange) {
        case FixedRepoDateRangeDaily:
            url = [url stringByAppendingString:@"?since=daily"];
            break;
        case FixedRepoDateRangeWeekly:
            url = [url stringByAppendingString:@"?since=weekly"];
            break;
        case FixedRepoDateRangeMonthly:
            url = [url stringByAppendingString:@"?since=monthly"];
            break;
        default:
            break;
    }

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
                    model.ownerName = [model.fullName componentsSeparatedByString:@"/"].firstObject;
                    model.RepoName = [model.fullName componentsSeparatedByString:@"/"].lastObject;
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
