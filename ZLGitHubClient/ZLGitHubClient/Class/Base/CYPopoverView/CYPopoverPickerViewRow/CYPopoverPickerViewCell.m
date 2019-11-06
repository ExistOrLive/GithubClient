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
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    self.titleLabel.textColor = LZRGBValue_H(0x999999);
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
        self.titleLabel.textColor = LZRGBValue_H(0x333333);
       // self.titleLabel.backgroundColor = LZRGBValue_H(0xF9F9F9);
    }
    else
    {
        self.titleLabel.textColor = LZRGBValue_H(0x999999);
        self.titleLabel.backgroundColor = [UIColor whiteColor];
    }
}

@end
