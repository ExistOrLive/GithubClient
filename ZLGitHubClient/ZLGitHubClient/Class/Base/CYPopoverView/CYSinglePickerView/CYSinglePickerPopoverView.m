//
//  CYSinglePickerView.m
//  gtihub
//
//  Created by ZM on 2019/10/31.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "CYSinglePickerPopoverView.h"
#import "CYPopoverTableViewCell.h"
#import "CYPopoverPickerViewCell.h"

#define CYPopoverTableViewCellHeight 30

@interface CYSinglePickerPopoverView() <UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (assign, nonatomic) NSUInteger initIndex;                     // 初始index
@property (strong, nonatomic) NSArray<NSString *> * itemTitlesArray;    //
@property (copy, nonatomic) void(^resultBlock)(NSUInteger);                    // 回调

@end

@implementation CYSinglePickerPopoverView

+ (void) showCYSinglePickerPopoverWithTitle:(NSString *)title withInitIndex:(NSUInteger)initIndex withDataArray:(NSArray<NSString *> *)dataArray  withResultBlock:(void(^)(NSUInteger)) resultBlock
{
    
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    
    CYSinglePickerPopoverView *  PopoverView = [[NSBundle mainBundle] loadNibNamed:@"CYSinglePickerPopoverView" owner:nil options:nil].firstObject;
    [PopoverView setFrame:window.bounds];
    PopoverView.resultBlock = resultBlock;
    PopoverView.itemTitlesArray = dataArray;
    [PopoverView setTitle:title];
    [PopoverView setInitIndex:initIndex];
    
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
        
    self.containerView.layer.cornerRadius = 8.0;
    
    [self.pickerView setBackgroundColor:[UIColor clearColor]];

    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
}

- (IBAction)onConfirmButtonClicked:(id)sender {
    
    if(self.resultBlock)
    {
        NSUInteger currentIndex = [self.pickerView selectedRowInComponent:0];
        self.resultBlock(currentIndex);
    }

    [self removeFromSuperview];
}



- (void) setItemTitlesArray:(NSArray<NSString *> *)itemTitlesArray
{
    _itemTitlesArray = itemTitlesArray;
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:self.initIndex inComponent:0 animated:NO];
}

- (void) setTitle:(NSString *) title
{
    self.titleLabel.text = title;
}

- (void) setInitIndex:(NSUInteger)initIndex
{
    _initIndex = initIndex;
    
    [self.pickerView selectRow:initIndex inComponent:0 animated:NO];
}

#pragma mark -

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.itemTitlesArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    CYPopoverPickerViewCell * cell = (CYPopoverPickerViewCell *) view;
    if(!cell)
    {
        cell = [CYPopoverPickerViewCell new];
    }
    [cell setTitle:self.itemTitlesArray[row]];
    [cell setSelected:YES];
    
    return cell;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

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
