//
//  EPLoadingView.m
//  Ellipal_update
//
//  Created by smarter on 2018/8/23.
//  Copyright © 2018年 afuiot. All rights reserved.
//

#import "EPLoadingView.h"

@interface EPLoadingView () {
    
}

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIButton *reloadButton;

@end

@implementation EPLoadingView

- (void)reloadButtonClicked:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    if (self.reloadButtonClickedCompleted) {
        self.reloadButtonClickedCompleted(weakSelf.reloadButton);
    }
}

- (void)_setup {
    self.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.alpha = 0.;
    
    _reloadButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.reloadButton.alpha = 0.;
    [self.reloadButton setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [self.reloadButton addTarget:self action:@selector(reloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:self.activityIndicatorView];
    [self addSubview:self.reloadButton];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _setup];
    }
    return self;
}

- (void)dealloc {
    self.reloadButtonClickedCompleted = nil;
    
    [self _stopActivityIndicatorView];
    self.activityIndicatorView = nil;
    self.reloadButton = nil;
}

- (void)_stopActivityIndicatorView {
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
    }
}

- (void)_setupAllUIWithAlpha {
    self.reloadButton.alpha = 0.;
    self.activityIndicatorView.alpha = 0.;
}

- (void)showFriendlyLoadingWithAnimated:(BOOL)animated {
    [self _setupAllUIWithAlpha];
    if (animated) {
        [self showLoadingAnimation];
    } else {
        [self showPromptView];
    }
}

/**
 * 纯文字提示
 */
- (void)showPromptView{
    [self _stopActivityIndicatorView];
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.activityIndicatorView.alpha = 0.;
        self.reloadButton.alpha = 0.;
    } completion:^(BOOL finished) {
        
    }];
}

/**
 * 页面加载动画及信息提示
 */
- (void)showLoadingAnimation{
    CGPoint activityIndicatorViewCentet = CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0);
    self.activityIndicatorView.center = activityIndicatorViewCentet;
    [self.activityIndicatorView startAnimating];
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.reloadButton.alpha = 0.;
        self.activityIndicatorView.alpha = 1.;
    } completion:^(BOOL finished) {
        
    }];
}

/**
 * 隐藏页面加载动画及信息提示
 */
- (void)hideLoadingView {
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/**
 * 重新加载提示
 */
- (void)showReloadView {
    [self _setupAllUIWithAlpha];
    [self _stopActivityIndicatorView];

    // 按钮和提示
    CGPoint reloadButtonCenter = CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0);
    self.reloadButton.center = reloadButtonCenter;
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.activityIndicatorView.alpha = 0.;
        self.reloadButton.alpha = 1.;
    } completion:^(BOOL finished) {
        
    }];
}

@end
