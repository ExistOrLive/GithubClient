//
//  CYPopoverCollectionViewCell.h
//  gtihub
//
//  Created by ZM on 2019/10/31.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CYPopoverCollectionViewCellDelegate <NSObject>

- (void) onPickerButtonClicked:(NSUInteger) index isSelected:(BOOL) isSelected;

@end

@interface CYPopoverCollectionViewCell : UICollectionViewCell

@property(nonatomic,weak) id<CYPopoverCollectionViewCellDelegate> delegate;

- (void) setTitle:(NSString *) title withIndex:(NSUInteger) index;

@end

NS_ASSUME_NONNULL_END
