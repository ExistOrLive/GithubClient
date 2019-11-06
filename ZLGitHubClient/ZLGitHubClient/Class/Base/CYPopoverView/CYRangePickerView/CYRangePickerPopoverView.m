//
//  CYRangePickerPopoverView.m
//  gtihub
//
//  Created by ZM on 2019/10/31.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "CYRangePickerPopoverView.h"
#import "CYPopoverTableViewCell.h"
#import "CYPopoverPickerViewCell.h"

@interface CYRangePickerPopoverView() <UIPickerViewDataSource, UIPickerViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;


@property (weak, nonatomic) IBOutlet UIButton *comfirmButton;

@property (strong, nonatomic) NSArray<NSString *> * itemTitlesArray1;
@property (strong, nonatomic) NSArray<NSString *> * itemTitlesArray2;

@property (assign, nonatomic) int currentIndex1;
@property (assign, nonatomic) int currentIndex2;

@property (copy, nonatomic) void(^resultBlock)(int,int);


@end

@implementation CYRangePickerPopoverView

+ (void) showCYRangePickerPopoverWithTitle:(NSString *)title withDataArray1:(NSArray<NSString *> *)dataArray1  withDataArray2:(NSArray<NSString *> *)dataArray2 withResultBlock:(void(^)(int,int)) resultBlock
{
    
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    
    CYRangePickerPopoverView *  PopoverView = [[NSBundle mainBundle] loadNibNamed:@"CYRangePickerPopoverView" owner:nil options:nil].firstObject;
    [PopoverView setFrame:window.bounds];
    PopoverView.resultBlock = resultBlock;
    PopoverView.itemTitlesArray1 = dataArray1;
    PopoverView.itemTitlesArray2 = dataArray2;
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
    
    self.containerView.layer.cornerRadius = 8.0;
    self.comfirmButton.layer.cornerRadius = 20.0;
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
}

- (IBAction)onConfirmButtonClicked:(id)sender {
    
    if(self.resultBlock)
    {
        self.resultBlock(self.currentIndex1,self.currentIndex2);
    }
    
    [self removeFromSuperview];
}



- (void) setItemTitlesArray1:(NSArray<NSString *> *)itemTitlesArray
{
    _itemTitlesArray1 = itemTitlesArray;
    [self.pickerView reloadComponent:0];
}

- (void) setItemTitlesArray2:(NSArray<NSString *> *)itemTitlesArray
{
    _itemTitlesArray2 = itemTitlesArray;
    [self.pickerView reloadComponent:1];
}

- (void) setTitle:(NSString *) title
{
    self.titleLabel.text = title;
}

#pragma mark -

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
    {
        return self.itemTitlesArray1.count;
    }
    else
    {
        return self.itemTitlesArray2.count;
    }
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
    
    if(component == 0)
    {
        [cell setTitle:self.itemTitlesArray1[row]];
    }
    else
    {
        [cell setTitle:self.itemTitlesArray2[row]];
    }
    
    return cell;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    CYPopoverPickerViewCell * cell = (CYPopoverPickerViewCell *)[pickerView viewForRow:row forComponent:component];
    [cell setSelected:YES];
    
    if(component == 0)
    {
        self.currentIndex1 = (int)row;
    }
    else
    {
        self.currentIndex2 = (int)row;
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
