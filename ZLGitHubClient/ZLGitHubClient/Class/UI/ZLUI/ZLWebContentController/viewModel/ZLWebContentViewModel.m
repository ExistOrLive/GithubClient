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



@end
