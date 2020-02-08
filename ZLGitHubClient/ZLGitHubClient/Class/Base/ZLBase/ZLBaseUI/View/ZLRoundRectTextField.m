
//
//  ZLRoundRectTextField.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/11/3.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLRoundRectTextField.h"

@implementation ZLRoundRectTextField

- (instancetype) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
    }
    return self;
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.layer.cornerRadius = CGRectGetHeight(frame) /2;
}


- (void) layoutSubviews
{
     self.layer.cornerRadius = CGRectGetHeight(self.frame) /2;
}

- (CGRect)borderRectForBounds:(CGRect)bounds
{
    return bounds;
}
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(CGRectGetHeight(bounds)/2,0,CGRectGetWidth(bounds) - CGRectGetHeight(bounds)/2,CGRectGetHeight(bounds));
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return CGRectMake(CGRectGetHeight(bounds)/2,0,CGRectGetWidth(bounds) - CGRectGetHeight(bounds)/2,CGRectGetHeight(bounds));
}
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(CGRectGetHeight(bounds)/2,0,CGRectGetWidth(bounds) - CGRectGetHeight(bounds)/2,CGRectGetHeight(bounds));
}

@end
