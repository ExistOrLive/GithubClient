//
//  CYPopTabelViewCellTableViewCell.m
//  gtihub
//
//  Created by ZM on 2019/10/31.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "CYPopoverTableViewCell.h"

@interface CYPopoverTableViewCell()

@end

@implementation CYPopoverTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createUI];
    }
    return self;
}

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
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = LZRGBValue_H(0x999999);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if(selected)
    {
        self.contentView.backgroundColor = LZRGBValue_H(0xF9F9F9);
        self.titleLabel.textColor = LZRGBValue_H(0x333333);
    }
    else
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = LZRGBValue_H(0x999999);
    }
}

@end
