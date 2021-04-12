//
//  ZLVideoOverlayView.m
//  BiPinHui
//
//  Created by 朱猛 on 2019/6/27.
//  Copyright © 2019 SuzhouFugu. All rights reserved.
//

#import "ZLVideoOverlayView.h"

@interface ZLVideoOverlayView()
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;

@property (weak, nonatomic) IBOutlet UIView *rateView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *rateButtons;
@property (weak, nonatomic) IBOutlet UIView *viewBeforeRecord;
@property (weak, nonatomic) IBOutlet UIView *viewAfterRecord;
@property (weak, nonatomic) IBOutlet UIView *toolView;

@end


@implementation ZLVideoOverlayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    self.rateView.layer.cornerRadius = 20.0;
    
    [self.recordProcess setProgress:0.0];
    
    [self setStatus:ZLVideoOverlayViewStatus_beforeRecord];
    
    for(UIButton * button in self.rateButtons)
    {
        if(button.tag == 0)
        {
            [button setSelected:YES];
        }
        else
        {
            [button setSelected:NO];
        }
    }
}


- (void) setStatus:(ZLVideoOverlayViewStatus)status
{
    _status = status;
    switch(status)
    {
        case ZLVideoOverlayViewStatus_beforeRecord:
        {
            [self.backButton setHidden:NO];
            [self.switchButton setHidden:NO];
            [self.toolView setHidden:NO];
            [self.rateView setHidden:NO];
            [self.viewAfterRecord setHidden:YES];
            [self.viewBeforeRecord setHidden:NO];
        }
            break;
        case ZLVideoOverlayViewStatus_recording:
        {
            [self.backButton setHidden:YES];
            [self.switchButton setHidden:YES];
            [self.toolView setHidden:YES];
            [self.rateView setHidden:YES];
            [self.viewAfterRecord setHidden:YES];
            [self.viewBeforeRecord setHidden:YES];
        }
            break;
        case ZLVideoOverlayViewStatus_AfterRecord:
        {
            [self.backButton setHidden:NO];
            [self.switchButton setHidden:NO];
            [self.toolView setHidden:NO];
            [self.rateView setHidden:NO];
            [self.viewAfterRecord setHidden:NO];
            [self.viewBeforeRecord setHidden:YES];
        }
            break;
    }
}

#pragma mark - 事件处理
- (IBAction)onButtonClicked:(id)sender
{
    if([self.delegate respondsToSelector:@selector(onVideoCaptureButtonClicked:)])
    {
        [self.delegate onVideoCaptureButtonClicked:(UIButton *)sender];
    }
}

- (IBAction)onRateButtonClicked:(id)sender {
    
    for(UIButton * button in self.rateButtons)
    {
        [button setSelected:NO];
    }
    UIButton * button = (UIButton *) sender;
    [button setSelected:YES];
    
    if([self.delegate respondsToSelector:@selector(onRateButtonClicked:)])
    {
        [self.delegate onRateButtonClicked:button];
    }
        
}


@end
