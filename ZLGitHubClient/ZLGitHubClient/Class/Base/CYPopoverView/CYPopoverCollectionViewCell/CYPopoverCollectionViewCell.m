//
//  CYPopoverCollectionViewCell.m
//  gtihub
//
//  Created by ZM on 2019/10/31.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "CYPopoverCollectionViewCell.h"
 
@interface CYPopoverCollectionViewCell()

@property(strong, nonatomic) UIButton * pickerButton;

@end

@implementation CYPopoverCollectionViewCell

- (instancetype) initWithCoder:(NSCoder *)coder
{
    if(self = [super initWithCoder:coder])
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


- (void) createUI
{
    self.pickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.pickerButton setBackgroundColor:[UIColor clearColor]];
    [self.pickerButton setImage:[UIImage imageNamed:@"Popover_selected"] forState:UIControlStateSelected];
    [self.pickerButton setImage:[UIImage imageNamed:@"Popover_unSelected"] forState:UIControlStateNormal];
    [self.pickerButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0,-10)];
    
    [self.pickerButton addTarget:self action:@selector(onPickerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.pickerButton];
    
    [self.pickerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
}

- (void) setTitle:(NSString *) title withIndex:(NSUInteger) index
{
    NSAttributedString * attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:LZRGBValue_H(0x999999)}];
    [self.pickerButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    
    self.pickerButton.tag = index;
}


- (void) onPickerButtonClicked:(UIButton *) button
{
    BOOL selected = !button.isSelected;
    button.selected = selected;
    
    if([self.delegate respondsToSelector:@selector(onPickerButtonClicked:isSelected:)])
    {
        [self.delegate onPickerButtonClicked:button.tag isSelected:selected];
    }
}

    

@end
