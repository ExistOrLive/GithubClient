//
//  ZLWebContentViewModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/28.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLWebContentViewModel.h"
#import <WebKit/WebKit.h>

@interface ZLWebContentViewModel()<WKUIDelegate,WKNavigationDelegate>

// view
@property(weak, nonatomic) ZLWebContentView * webContentView;

@property(strong, nonatomic) NSURL * url;

@end

@implementation ZLWebContentViewModel


- (void) bindModel:(id _Nullable) targetModel andView:(UIView *) targetView
{
    if(![targetView isKindOfClass:[ZLWebContentView class]])
    {
        ZLLog_Warning(@"targetView is not ZLWebContentView,so return");
        return;
    }
    
    self.webContentView = (ZLWebContentView *)targetView;
    self.webContentView.webView.UIDelegate = self;
    self.webContentView.webView.navigationDelegate = self;
    
    self.url = (NSURL *) targetModel;
    
    if(!self.url)
    {
        ZLLog_Warning(@"targetModel is not a valid URL,so return");
        return;
    }
    
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [self.webContentView.webView loadRequest:request];
}


- (IBAction)onBackButtonClicked:(id)sender {
    [self.viewController.navigationController popViewControllerAnimated:YES];
}

#pragma mark - WKUIDelegate,WKNavigationDelegate

- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    return webView;
}

- (void)webViewDidClose:(WKWebView *)webView
{
    
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler
{
    
}



- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow);
}

// Decides whether to allow or cancel a navigation after its response is known.
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

//Invoked when a main frame navigation starts.
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    
}


- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    
}


- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
    
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    
}


- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    
}

//  @discussion If you do not implement this method, the web view will respond to the authentication challenge with the NSURLSessionAuthChallengeRejectProtectionSpace disposition.
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
//{
//
//}


- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    
}

@end
