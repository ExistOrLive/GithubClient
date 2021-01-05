//
//  ZLSearchController.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/25.
//  Copyright © 2020 ZM. All rights reserved.
//

#import "ZLBaseViewController.h"
#import "ZLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class ZLBaseSearchBar;
@class ZLBaseSearchController;

typedef enum : NSUInteger {
    ZLBaseSearchBarStatus_Normal,
    ZLBaseSearchBarStatus_Editing,
    ZLBaseSearchBarStatus_CancelPossibleNoEditing,
} ZLBaseSearchBarStatus;

@protocol ZLBaseSearchBarDelegate<NSObject>

@optional

- (void) searchBarStatusChange:(ZLBaseSearchBar *) searchBar;

- (void) searchBarDidBecomeEdit:(ZLBaseSearchBar *) searchBar;

- (void) searchBarDidEndEdit:(ZLBaseSearchBar *) searchBar;

- (void) searchBarConfirmSearch:(ZLBaseSearchBar *) searchBar withSearchKey:(NSString *) searchKey;

- (void) searchBarCancel:(ZLBaseSearchBar *) searchBar;

- (void) searchBarBack:(ZLBaseSearchBar *)searchBar;

- (BOOL) searchBarHiddenCancelButtonWhenEndEdit:(ZLBaseSearchBar *) searchBar;

- (BOOL) searchBarClearKeyWhenBecomeNormal:(ZLBaseSearchBar *) searchBar;

@end





@interface ZLBaseSearchBar : ZLBaseView

@property(nonatomic, readonly) ZLBaseSearchBarStatus status;

@property(nonatomic, readonly, getter=isEditing) BOOL editing;

@property(nonatomic, assign) BOOL showBackButton;

@property(nonatomic, weak) id<ZLBaseSearchBarDelegate> delegate;

- (void) startSearch;

- (void) endSearch:(BOOL) force;


@end




@protocol ZLBaseSearchControllerDelegate<NSObject>

@optional

- (void) searchControllerDidBecomeEdit:(ZLBaseSearchController *) searchController;

- (void) searchControllerDidEndEdit:(ZLBaseSearchController *) searchController;

- (void) searchControllerConfirmSearch:(ZLBaseSearchController *) searchController withSearchKey:(NSString *) searchKey;

- (BOOL) searchControllerShouldShowResultController:(ZLBaseSearchController *) searchController;

- (void) searchControllerDidShowResultController:(ZLBaseSearchController *) searchController;

- (void) searchControllerDidDismissResultController:(ZLBaseSearchController *) searchController;

- (void) searchControllerCancel:(ZLBaseSearchController *) searchController;

@end


@interface ZLBaseSearchController : ZLBaseViewController

@property(nonatomic,strong,readonly) UIViewController *resultContoller;
@property(nonatomic,weak) UIViewController *sourceViewController;
@property(nonatomic,strong,readonly) UIView *searchBarContainerView;

@property(nonatomic,weak) id<ZLBaseSearchControllerDelegate> delegate;

- (instancetype) initWithResultController:(UIViewController *)resultController;

- (void) startSearch;

- (void) endSearch:(BOOL) force;

@end


@interface UIViewController (ZLBaseSearchController)

- (void) onZLSearchKeyUpdate:(NSString *)searchKey;

- (void) onZLSearchKeyConfirm:(NSString *)searchKey;

@end

NS_ASSUME_NONNULL_END
