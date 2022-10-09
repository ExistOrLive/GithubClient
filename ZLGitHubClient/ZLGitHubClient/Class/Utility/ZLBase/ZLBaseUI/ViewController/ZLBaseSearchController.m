//
//  ZLSearchController.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/25.
//  Copyright © 2020 ZM. All rights reserved.
//

#import "ZLBaseSearchController.h"
#import "ZLBaseExtension/UIView+HJViewStyle.h"

@interface ZLBaseSearchBar() <UITextFieldDelegate>

@property(nonatomic,strong) UITextField *searchTextField;
@property(nonatomic,strong) UIButton *cancelButton;
@property(nonatomic,strong) UIButton *backButton;

@property(nonatomic,strong) MASConstraint *textFieldLeftContraint;

@end

@implementation ZLBaseSearchBar

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void) setUpUI{
    
    self.backgroundColor = [UIColor colorNamed:@"SearchBarBack"];
    
    self.searchTextField = [UITextField new];
    self.searchTextField.backgroundColor = [UIColor colorNamed:@"ZLExploreTextFieldBackColor"];
    self.searchTextField.cornerRadius = 5.0;
    self.searchTextField.font = [UIFont fontWithName:Font_PingFangSCRegular size:14];
    self.searchTextField.textColor = [UIColor colorNamed:@"ZLLabelColor1"];
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ZLLocalizedString(@"Search", "") attributes:@{NSFontAttributeName:[UIFont fontWithName:Font_PingFangSCRegular size:14],NSForegroundColorAttributeName:[UIColor colorNamed:@"ZLLabelColor2"]}];
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.delegate = self;
    
    UIView  *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    leftView.backgroundColor = [UIColor clearColor];
    self.searchTextField.leftView = leftView;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setAttributedTitle:[[NSAttributedString alloc] initWithString:ZLLocalizedString(@"Cancel", "") attributes:@{NSFontAttributeName:[UIFont fontWithName:Font_PingFangSCRegular size:14],NSForegroundColorAttributeName:[UIColor colorNamed:@"ZLLabelColor3"]}] forState:UIControlStateNormal];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"back_Common"] forState:UIControlStateNormal];
    
    [self addSubview:self.backButton];
    [self addSubview:self.cancelButton];
    [self addSubview:self.searchTextField];
    
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.width.equalTo(@0);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.equalTo(@50);
        make.right.equalTo(self).offset(-20);
    }];
    
    
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backButton.mas_right);
        make.height.equalTo(@40);
        make.centerY.equalTo(self);
        self.textFieldLeftContraint = make.right.equalTo(self).offset(-20);
    }];
    
    [self.cancelButton addTarget:self action:@selector(onCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self action:@selector(onBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)updateConstraints{
    
    [super updateConstraints];
    
    if(self.textFieldLeftContraint){
        [self.textFieldLeftContraint  deactivate];
        self.textFieldLeftContraint = nil;
    }
    
    self.cancelButton.hidden = (self.status == ZLBaseSearchBarStatus_Normal);
    
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        if(self.status == ZLBaseSearchBarStatus_CancelPossibleNoEditing ||
           self.status == ZLBaseSearchBarStatus_Editing) {
            self.textFieldLeftContraint = make.right.equalTo(self.cancelButton.mas_left).offset(-20);
        } else {
            self.textFieldLeftContraint = make.right.equalTo(self).offset(-20);
        }
    }];
    
    [self.backButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.showBackButton ? @40 : @0);
    }];
    
}


- (BOOL) isEditing{
    return self.status == ZLBaseSearchBarStatus_Editing;
}

- (void) startSearch{
    if(self.status == ZLBaseSearchBarStatus_Editing){
        return;
    }
    
    if(![self.searchTextField isFirstResponder]){
        [self.searchTextField becomeFirstResponder];
    }
    _status = ZLBaseSearchBarStatus_Editing;
    
    if([self.delegate respondsToSelector:@selector(searchBarStatusChange:)]){
        [self.delegate searchBarStatusChange:self];
    }
    
    [self setNeedsUpdateConstraints];
}

- (void) endSearch:(BOOL) force{
    if(force){
        if(self.status == ZLBaseSearchBarStatus_Normal){
            return;
        }
        _status = ZLBaseSearchBarStatus_Normal;
        
        if([self.delegate respondsToSelector:@selector(searchBarClearKeyWhenBecomeNormal:)]){
            if([self.delegate searchBarClearKeyWhenBecomeNormal:self]){
                self.searchTextField.text = nil;
            }
        }
        
    } else {
        if(self.status != ZLBaseSearchBarStatus_Editing){
            return;
        }
        _status = ZLBaseSearchBarStatus_CancelPossibleNoEditing;
    }
    
    if([self.delegate respondsToSelector:@selector(searchBarStatusChange:)]){
        [self.delegate searchBarStatusChange:self];
    }
    
    if([self.searchTextField canResignFirstResponder]){
        [self.searchTextField resignFirstResponder];
    }
    
    [self setNeedsUpdateConstraints];
}

- (void) setShowBackButton:(BOOL)showBackButton {
    if(showBackButton == _showBackButton) {
        return;
    }
    _showBackButton = showBackButton;
    
    [self setNeedsUpdateConstraints];
}

#pragma mark UITextFieldDelegte

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self startSearch];
    
    if([self.delegate respondsToSelector:@selector(searchBarDidBecomeEdit:)]){
        [self.delegate searchBarDidBecomeEdit:self];
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    if([self.delegate respondsToSelector:@selector(searchBarHiddenCancelButtonWhenEndEdit:)]){
        if([self.delegate searchBarHiddenCancelButtonWhenEndEdit:self]) {
            [self endSearch:YES];
        } else {
            [self endSearch:NO];
        }
    } else {
        [self endSearch:YES];
    }
    
    if([self.delegate respondsToSelector:@selector(searchBarDidEndEdit:)]){
        [self.delegate searchBarDidEndEdit:self];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField canResignFirstResponder]){
        [textField resignFirstResponder];
    }
    if([self.delegate respondsToSelector:@selector(searchBarConfirmSearch:withSearchKey:)]){
        [self.delegate searchBarConfirmSearch:self withSearchKey:self.searchTextField.text];
    }
    return YES;
}


#pragma mark cancelButton

- (void) onCancelButtonClicked:(UIButton *) button{
    [self endSearch:YES];
    if([self.delegate respondsToSelector:@selector(searchBarCancel:)]){
        [self.delegate searchBarCancel:self];
    }
}

- (void) onBackButtonClicked:(UIButton *) button{
    if([self.delegate respondsToSelector:@selector(searchBarBack:)]){
        [self.delegate searchBarBack:self];
    }
}

@end






#pragma mark - ZLBaseSearchController

@interface ZLBaseSearchController() <ZLBaseSearchBarDelegate,UIViewControllerTransitioningDelegate>

@property(nonatomic,strong) ZLBaseSearchBar *searchBar;

@property(nonatomic,strong) UIView *searchBarContainerView2;

@end


@implementation ZLBaseSearchController

- (instancetype) initWithResultController:(UIViewController *)resultController{
    if(self = [super init]){
        _resultContoller = resultController;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        [self setUpUI];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void) startSearch{
    [self.searchBar startSearch];
}

- (void) endSearch:(BOOL) force{
    [self.searchBar endSearch:force];
}


- (void) setUpUI {
    
    _searchBarContainerView = [UIView new];
    self.searchBarContainerView.backgroundColor = [UIColor clearColor];
    
    self.searchBar = [ZLBaseSearchBar new];
    [self.searchBarContainerView addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.searchBarContainerView);
        make.left.equalTo(self.searchBarContainerView.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.searchBarContainerView.mas_safeAreaLayoutGuideRight);
    }];
    self.searchBar.delegate = self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.searchBarContainerView2 = [UIView new];
    self.searchBarContainerView2.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.searchBarContainerView2];
    [self.searchBarContainerView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@60);
    }];
    
    
    if(self.resultContoller){
        [self.resultContoller willMoveToParentViewController:self];
        [self.contentView addSubview:self.resultContoller.view];
        [self.resultContoller.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.searchBarContainerView2.mas_bottom);
            make.left.right.bottom.equalTo(self.contentView);
        }];
        [self addChildViewController:self.resultContoller];
        [self.resultContoller didMoveToParentViewController:self];
    }
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    

}

- (void) moveInSearchBar{
    [self.searchBarContainerView2 addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchBarContainerView2.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.searchBarContainerView2.mas_safeAreaLayoutGuideRight);
        make.top.bottom.equalTo(self.searchBarContainerView2);
    }];
}

- (void) moveOutSearchBar{
    [self.searchBarContainerView addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchBarContainerView.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.searchBarContainerView.mas_safeAreaLayoutGuideRight);
        make.top.bottom.equalTo(self.searchBarContainerView);
    }];
}

#pragma mark ZLBaseSearchBarDelegate

- (void) searchBarStatusChange:(ZLBaseSearchBar *) searchBar {
    
    switch (searchBar.status) {
            
        case ZLBaseSearchBarStatus_Editing:{
            
            if(self.sourceViewController && !self.presentingViewController){
                if(![self.delegate respondsToSelector:@selector(searchControllerShouldShowResultController:)] || [self.delegate searchControllerShouldShowResultController:self]){
                    self.modalPresentationStyle = UIModalPresentationFullScreen;
                    self.transitioningDelegate = self;
                    [self.sourceViewController presentViewController:self animated:YES completion:^{
                        if([self.delegate respondsToSelector:@selector(searchControllerDidShowResultController:)]){
                            [self.delegate searchControllerDidShowResultController:self];
                        }
                    }];
                }
            }
            
        }
            break;
        case ZLBaseSearchBarStatus_Normal:{
            
            if(self.presentingViewController) {
                [self dismissViewControllerAnimated:YES completion:^{
                    if([self.delegate respondsToSelector:@selector(searchControllerDidDismissResultController:)]){
                        [self.delegate searchControllerDidDismissResultController:self];
                    }
                }];
            }
            
        }
            break;
            
        case ZLBaseSearchBarStatus_CancelPossibleNoEditing:{
            
        }
            break;
    }
    
}

- (void) searchBarDidBecomeEdit:(ZLBaseSearchBar *) searchBar{
    if([self.delegate respondsToSelector:@selector(searchControllerDidBecomeEdit:)]){
        [self.delegate searchControllerDidBecomeEdit:self];
    }
    
}

- (void) searchBarDidEndEdit:(ZLBaseSearchBar *) searchBar{
    if([self.delegate respondsToSelector:@selector(searchControllerDidEndEdit:)]){
        [self.delegate searchControllerDidEndEdit:self];
    }
}

- (void) searchBarConfirmSearch:(ZLBaseSearchBar *) searchBar withSearchKey:(NSString *) searchKey{
    if([self.delegate respondsToSelector:@selector(searchControllerConfirmSearch:withSearchKey:)]){
        [self.delegate searchControllerConfirmSearch:self withSearchKey:searchKey];
    }
    
    [self.resultContoller onZLSearchKeyConfirm:searchKey];
}

- (void) searchBarCancel:(ZLBaseSearchBar *)searchBar{
    [self.searchBar endSearch:YES];
    if([self.delegate respondsToSelector:@selector(searchControllerCancel:)]){
        [self.delegate searchControllerCancel:self];
    }
}

- (void)searchBarBack:(ZLBaseSearchBar *)searchBar{
   
}

- (BOOL) searchBarClearKeyWhenBecomeNormal:(ZLBaseSearchBar *) searchBar{
    return YES;
}

- (BOOL) searchBarHiddenCancelButtonWhenEndEdit:(ZLBaseSearchBar *) searchBar{
    return NO;
}


@end


#pragma mark - UIBaseSearchControllerTransition

@interface ZLSearchBaseControllerTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

@property(nonatomic, assign) BOOL presenting;

@end

@implementation ZLSearchBaseControllerTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 1;
}


// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    UIView *containerView = transitionContext.containerView;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView =
        [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView =
        [transitionContext viewForKey:UITransitionContextToViewKey];

    fromView.frame = containerView.bounds;
    toView.frame = containerView.bounds;
    if(self.presenting){
        [containerView addSubview:fromView];
        [containerView addSubview:toView];
    } else {
        [containerView addSubview:toView];
        [containerView addSubview:fromView];
    }
    fromView.hidden = NO;
    toView.hidden = YES;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
        animations:^{
        fromView.hidden = YES;
        toView.hidden = NO;
        if(self.presenting){
            ZLBaseSearchController *controller = (ZLBaseSearchController*)toViewController;
            [controller moveInSearchBar];
        } else {
            ZLBaseSearchController *controller = (ZLBaseSearchController*)fromViewController;
            [controller moveOutSearchBar];
        }
        }
        completion:^(BOOL finished) {
          BOOL success = ![transitionContext transitionWasCancelled];

          // After a failed presentation or successful dismissal, remove the
          // view.
          if ((self.presenting && !success) || (!self.presenting && success)) {
              [toView removeFromSuperview];
          }

          // Notify UIKit that the transition has finished
          [transitionContext completeTransition:success];
        }];
}


@end

#pragma mark  UIViewControllerTransitionDelegate

@interface ZLBaseSearchController (TransitionDelegate)

@end

@implementation ZLBaseSearchController (TransitionDelegate)

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    ZLSearchBaseControllerTransitioning *transition = [ZLSearchBaseControllerTransitioning new];
    transition.presenting = YES;
    return  transition;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    ZLSearchBaseControllerTransitioning *transition = [ZLSearchBaseControllerTransitioning new];
    return  transition;
}


@end







#pragma mark - 

@implementation UIViewController (ZLBaseSearchVC)

- (void) onZLSearchKeyUpdate:(NSString *)searchKey{
    // wait implemented
}

- (void) onZLSearchKeyConfirm:(NSString *)searchKey{
    
}

@end
