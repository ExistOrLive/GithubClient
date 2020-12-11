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
    //[self clearCookiesForWkWebView];
}

- (void) bindModel:(id _Nullable) targetModel andView:(UIView *) targetView
{
    if(![targetView isKindOfClass:[ZLWebContentView class]])
    {
        ZLLog_Warning(@"targetView is not ZLWebContentView,so return");
        return;
    }
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"run_more"] forState:UIControlStateNormal];
    [rightButton setFrame:CGRectMake(0, 0, 60, 60)];
    [rightButton addTarget:self action:@selector(onAdditionButtonClickWithButton:) forControlEvents:UIControlEventTouchUpInside];
    ZLBaseViewController *vc = (ZLBaseViewController *)self.viewController;
    vc.zlNavigationBar.rightButton = rightButton;
    
    self.webContentView = (ZLWebContentView *)targetView;
    self.webContentView.delegate = self;
    
    self.url = (NSURL *) targetModel;
        
    if(!self.url || !self.url.resourceSpecifier){
        ZLLog_Warning(@"targetModel is not a valid URL,so return");
        [ZLToastView showMessage:@"Invalid URL"];
        return;
    }
    
    if(!self.url.scheme || (![@"https" isEqualToString:self.url.scheme] && ![@"http" isEqualToString:self.url.scheme] )){
        if([[UIApplication sharedApplication] canOpenURL:self.url]){
            [[UIApplication sharedApplication] openURL:self.url options:@{} completionHandler:nil];
            return;
        }
    }
    
    if(!self.url.scheme ){
        NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@",self.url.resourceSpecifier]];
        self.url = url;
    }
    
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [self.webContentView.webView loadRequest:request];
}



- (void) onAdditionButtonClickWithButton:(UIButton *) button {
    
    NSURL *url = self.webContentView.webView.URL;
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
    activityVC.popoverPresentationController.sourceView = button;
    activityVC.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypeOpenInIBooks,UIActivityTypeMarkupAsPDF];

    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
        }else {
        }
    };
    [self.viewController presentViewController:activityVC animated:YES completion:nil];
    
}

#pragma mark - ZLWebContentViewDelegate

- (void)webView:(WKWebView * _Nonnull)webView navigationAction:(WKNavigationAction * _Nonnull)navigationAction decisionHandler:(void (^ _Nonnull)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}


- (void)webView:(WKWebView * _Nonnull)webView navigationResponse:(WKNavigationResponse * _Nonnull)navigationResponse decisionHandler:(void (^ _Nonnull)(WKNavigationResponsePolicy))decisionHandler { 
    decisionHandler(WKNavigationResponsePolicyAllow);
}


- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    NSURL *url = webView.URL;
    if(!url.scheme || (![@"https" isEqualToString:url.scheme] && ![@"http" isEqualToString:url.scheme] )){
        if([[UIApplication sharedApplication] canOpenURL:url]){
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            return;
        }
    }
    
}

- (void) onTitleChangeWithTitle:(NSString *) title{
    if(title){
        self.viewController.title = title;
    }
}


#pragma mark - 清除cookie

-(void) clearCookiesForWkWebView
{
    NSArray * types = @[WKWebsiteDataTypeCookies,WKWebsiteDataTypeSessionStorage];
    NSSet * set = [NSSet setWithArray:types];
 
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:set modifiedSince:date completionHandler:^{}];
}


@end
