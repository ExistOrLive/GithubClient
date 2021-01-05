//
//  CYPopoverPickerViewRow.m
//  gtihub
//
//  Created by ZM on 2019/11/1.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "CYPopoverPickerViewCell.h"
#import "UIColor+HexColor.h"

@interface CYPopoverPickerViewCell()

@property(nonatomic,strong) UILabel * titleLabel;

@end

@implementation CYPopoverPickerViewCell

- (instancetype) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self createUI];
    }
    
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)coder
{
    if(self = [super initWithCoder:coder])
    {
        [self createUI];
    }
    
    return self;
}

- (void) createUI
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.backgroundColor = UIColor.clearColor;
    self.titleLabel.textColor = [UIColor colorNamed:@"ZLLabelColor2"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


- (void) setTitle:(NSString *) title
{
    self.titleLabel.text = title;
}

- (void) setSelected:(BOOL) selected
{
    if(selected)
    {
        self.titleLabel.textColor = [UIColor colorNamed:@"ZLLabelColor2"];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    else
    {
        self.titleLabel.textColor = [UIColor colorNamed:@"ZLLabelColor2"];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
}

@end
