//
//  NRBaseViewController.h
//  NFCReader
//
//  Created by 李黎明 on 2019/4/12.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPTitleBar.h"
#import "EPTitleBarItem.h"

#define kEPTitleBarItemColorWhite [UIColor whiteColor]
#define kEPTitleBarItemColorBlack [UIColor colorWithRed:40/255. green:40/255. blue:40/255. alpha:1]
#define kEPTitleBarItemColorBlue [UIColor colorWithRed:48/255. green:124/255. blue:249/255. alpha:1]

typedef enum : NSInteger {
    kEPNetWorkError =0,
    kEPDataLoadError = 1
} EPLoadingType;

NS_ASSUME_NONNULL_BEGIN

@interface NRBaseViewController : UIViewController

@property (nonatomic, readonly) EPTitleBar *titleBar;

// If you want, override it.
- (void)configureTitleBar;

- (void)takeTitleBarToFront;

- (void)setLeftItemForGoBack;

- (void)configureTitleBarToBlack;
- (void)configureTitleBarToWhite;

- (void)showWaitingView;
- (void)hideWaitingView;

- (void)showWaitingViewInWindow;
- (void)hideWaitingViewInWindow;

- (void)reloadDataInView;
- (void)showLoadingViewWithTop:(CGFloat)topOffset;
- (void)hideLoadingView;
- (void)showWaitingViewWithText:(NSString *)text;
- (void)showLoadingResultWithType:(EPLoadingType)loadingType;

- (void)showMessage:(NSString *)message;
- (void)showLognMessage:(NSString *)message;
- (void)showSoundMessage:(NSString *)message;
- (void)showMessage:(NSString *)message withSuccess:(BOOL)sucess;
- (void)showLongMessage:(NSString *)message withSuccess:(BOOL)sucess;

@end

NS_ASSUME_NONNULL_END
