//
//  CYMutiPickerPopoverView.m
//  gtihub
//
//  Created by ZM on 2019/10/31.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "CYMutiPickerPopoverView.h"
#import "CYPopoverCollectionViewCell.h"

@interface CYMutiPickerPopoverView() <UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,CYPopoverCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;

@property (strong, nonatomic) NSMutableSet * indexSet;

@property (strong, nonatomic) NSArray<NSString *> * itemTitlesArray;

@property (copy, nonatomic) void(^resultBlock)(NSSet *);



@end

@implementation CYMutiPickerPopoverView

+ (void) showCYMutiPickerPopoverWithTitle:(NSString *)title withDataArray:(NSArray<NSString *> *)dataArray  withResultBlock:(void(^)(NSSet *)) resultBlock
{
    
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    
    CYMutiPickerPopoverView *  PopoverView = [[NSBundle mainBundle] loadNibNamed:@"CYMutiPickerPopoverView" owner:nil options:nil].firstObject;
    [PopoverView setFrame:window.bounds];
    PopoverView.resultBlock = resultBlock;
    PopoverView.itemTitlesArray = dataArray;
    [PopoverView setTitle:title];
    
    UITapGestureRecognizer * gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:PopoverView action:@selector(onCloseAction)];
    gestureRecognizer.delegate = PopoverView;
    [PopoverView addGestureRecognizer:gestureRecognizer];
    
    [window addSubview:PopoverView];
    [window makeKeyAndVisible];
}

- (void) onCloseAction
{
    [self removeFromSuperview];
}


#pragma mark - init

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    self.indexSet = [NSMutableSet new];
    
    self.containerView.layer.cornerRadius = 8.0;
    self.confirmButton.layer.cornerRadius = 20.0;
    
    self.collectionViewLayout.itemSize = CGSizeMake(140, 36);
    self.collectionViewLayout.minimumInteritemSpacing = 0;
    self.collectionViewLayout.minimumLineSpacing = 0;
    [self.collectionView registerClass:[CYPopoverCollectionViewCell class] forCellWithReuseIdentifier:@"CYPopoverCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (IBAction)onConfirmButtonClicked:(id)sender {
    
    if(self.resultBlock)
    {
        self.resultBlock([self.indexSet copy]);
    }
    
    [self removeFromSuperview];
}



- (void) setItemTitlesArray:(NSArray<NSString *> *)itemTitlesArray
{
    _itemTitlesArray = itemTitlesArray;
    [self.collectionView reloadData];
}

- (void) setTitle:(NSString *) title
{
    self.titleLabel.text = title;
}

#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemTitlesArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CYPopoverCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CYPopoverCollectionViewCell" forIndexPath:indexPath];
    [cell setTitle:self.itemTitlesArray[indexPath.row] withIndex:indexPath.row];
    cell.delegate = self;
    
    return cell;
}

#pragma mark -

- (void) onPickerButtonClicked:(NSUInteger) index isSelected:(BOOL) isSelected
{
    if(isSelected)
    {
        [self.indexSet addObject:@(index)];
    }
    else
    {
        [self.indexSet removeObject:@(index)];
    }
    
    if([self.indexSet count] == 0)
    {
        [self.confirmButton setEnabled:NO];
    }
    else
    {
        [self.confirmButton setEnabled:YES];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(touch.view != self)
    {
        return NO;
    }
    return YES;
}


@end
