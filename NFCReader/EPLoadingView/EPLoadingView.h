//
//  EPLoadingView.h
//  Ellipal_update
//
//  Created by smarter on 2018/8/23.
//  Copyright © 2018年 afuiot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReloadButtonClickedCompleted)(UIButton *sender);

@interface EPLoadingView : UIView
@property (nonatomic, copy) ReloadButtonClickedCompleted reloadButtonClickedCompleted;


- (void)showFriendlyLoadingWithAnimated:(BOOL)animated;

/**
 * 隐藏页面加载动画及信息提示
 */
- (void)hideLoadingView;

/**
 * 重新加载提示
 */
- (void)showReloadView;

@end
