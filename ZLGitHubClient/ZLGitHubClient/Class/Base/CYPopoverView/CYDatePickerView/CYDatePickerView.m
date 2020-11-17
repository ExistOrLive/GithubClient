//
//  CYDatePickerView.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/11/2.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "CYDatePickerView.h"
#import "CYPopoverPickerViewCell.h"

@interface CYDatePickerView() <UIGestureRecognizerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (copy, nonatomic) void(^resultBlock)(NSDate *);

@property (assign, nonatomic) NSRange yearRange;

@property (assign, nonatomic) NSUInteger yearIndex;
@property (assign, nonatomic) NSUInteger monthIndex;
@property (assign, nonatomic) NSUInteger dayIndex;


@end

@implementation CYDatePickerView

+ (void) showCYDatePickerPopoverWithTitle:(NSString *)title  withYearRange:(NSRange) range withResultBlock:(void(^)(NSDate *)) resultBlock
{
    
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    
    CYDatePickerView *  PopoverView = [[NSBundle mainBundle] loadNibNamed:@"CYDatePickerView" owner:nil options:nil].firstObject;
    [PopoverView setFrame:window.bounds];
    [PopoverView setResultBlock:resultBlock];
    [PopoverView setTitle:title];
    [PopoverView setYearRange:range];
    
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
    
    [self.confirmButton setTitle:ZLLocalizedString(@"Confirm", "") forState:UIControlStateNormal];
    self.containerView.layer.cornerRadius = 8.0;
    
    [self.pickerView setBackgroundColor:[UIColor clearColor]];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
}


- (IBAction)onConfirmButtonClicked:(id)sender {
    
    if(self.resultBlock)
    {
        self.yearIndex = [self.pickerView selectedRowInComponent:0];
        self.monthIndex = [self.pickerView selectedRowInComponent:1];
        self.dayIndex = [self.pickerView selectedRowInComponent:2];
        NSString * dateStr = [NSString stringWithFormat:@"%lu-%lu-%lu",self.yearIndex+self.yearRange.location,self.monthIndex+1,self.dayIndex+1];
        NSDateFormatter * dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSDate * date = [dateFormatter dateFromString:dateStr];
        
        self.resultBlock(date);
    }
    
    [self removeFromSuperview];
}



- (void) setYearRange:(NSRange)yearRange
{
    _yearRange = yearRange;
    [self.pickerView reloadAllComponents];
}

- (void) setTitle:(NSString *) title
{
    self.titleLabel.text = title;
}

#pragma mark -

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
 
    if(component == 0)
    {
        return self.yearRange.length;
    }
    else if(component == 1)
    {
        return 12;       // 月份
    }
    else
    {
        self.monthIndex = [self.pickerView selectedRowInComponent:1];
        self.yearIndex = [self.pickerView selectedRowInComponent:0];
        switch(self.monthIndex + 1)
        {
            case 1:
            case 3:
            case 5:
            case 7:
            case 8:
            case 10:
            case 12:
            {
                return 31;
            }
                break;
            case 4:
            case 6:
            case 9:
            case 11:
            {
                return 30;
            }
            case 2:
            {
                if((self.yearRange.location + self.yearIndex)%4 == 0)
                {
                    return 29;
                }
                else
                {
                    return 28;
                }
            }
        }
    }
    
    return 0;
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
    [cell setSelected:YES];
    
    switch (component) {
        case 0:{
            
            NSString * year = [NSString stringWithFormat:@"%ld",self.yearRange.location + row];
            [cell setTitle:year];
        }
            break;
        case 1:{
            NSString * month = [NSString stringWithFormat:@"%ld",row + 1];
            [cell setTitle:month];
        }
            break;
        case 2:{
            NSString * day = [NSString stringWithFormat:@"%ld",row + 1];
            [cell setTitle:day];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    CYPopoverPickerViewCell * cell = (CYPopoverPickerViewCell *)[pickerView viewForRow:row forComponent:component];
    [cell setSelected:YES];
    
    switch(component)
    {
        case 0:
        {
            [self.pickerView reloadComponent:1];
            [self.pickerView reloadComponent:2];
        }
            break;
        case 1:
        {
            [self.pickerView reloadComponent:2];
        }
            break;
        case 2:
        {
        }
            break;
        default:
            break;
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
