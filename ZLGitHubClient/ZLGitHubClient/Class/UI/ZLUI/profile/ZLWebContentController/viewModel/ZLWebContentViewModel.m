//
//  ZLWebContentViewModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/28.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLWebContentViewModel.h"
#import <WebKit/WebKit.h>

@interface ZLWebContentViewModel()<ZLWebContentViewDelegate>

// view
@property(weak, nonatomic) ZLWebContentView * webContentView;

@property(strong, nonatomic) NSURL * url;

@end

@implementation ZLWebContentViewModel

- (void) dealloc
{
    [self clearCookiesForWkWebView];
}

- (void) bindModel:(id _Nullable) targetModel andView:(UIView *) targetView
{
    if(![targetView isKindOfClass:[ZLWebContentView class]])
    {
        ZLLog_Warning(@"targetView is not ZLWebContentView,so return");
        return;
    }
    
    self.webContentView = (ZLWebContentView *)targetView;
    self.webContentView.delegate = self;
    
    self.url = (NSURL *) targetModel;
    
    if(!self.url)
    {
        ZLLog_Warning(@"targetModel is not a valid URL,so return");
        return;
    }
    
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    NSString *token = [[ZLSharedDataManager sharedInstance] githubAccessToken];
    [request setValue:[NSString stringWithFormat:@"token %@",token] forHTTPHeaderField:@"Authorization"];
    [self.webContentView.webView loadRequest:request];
}


#pragma mark - ZLWebContentViewDelegate

- (void) onBackButtonClickWithButton:(UIButton *)button
{
     [self.viewController.navigationController popViewControllerAnimated:true];
}

- (void) onAdditionButtonClickWithButton:(UIButton *) button {
    
    NSURL *url = self.webContentView.webView.URL;
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypeOpenInIBooks,UIActivityTypeMarkupAsPDF];

    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
        }else {
        }
    };
    [self.viewController presentViewController:activityVC animated:YES completion:nil];
    
}

- (void)webView:(WKWebView * _Nonnull)webView navigationAction:(WKNavigationAction * _Nonnull)navigationAction decisionHandler:(void (^ _Nonnull)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}


- (void)webView:(WKWebView * _Nonnull)webView navigationResponse:(WKNavigationResponse * _Nonnull)navigationResponse decisionHandler:(void (^ _Nonnull)(WKNavigationResponsePolicy))decisionHandler { 
    decisionHandler(WKNavigationResponsePolicyAllow);
}


-(void) clearCookiesForWkWebView
{
    NSArray * types = @[WKWebsiteDataTypeCookies,WKWebsiteDataTypeSessionStorage];
    NSSet * set = [NSSet setWithArray:types];
 
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:set modifiedSince:date completionHandler:^{}];
}


@end
