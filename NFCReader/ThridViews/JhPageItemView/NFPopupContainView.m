//
//  NFPopupContainView.m
//  JhPageItemView
//
//  Created by 李黎明 on 2019/7/15.
//  Copyright © 2019 Jh. All rights reserved.
//

#import "NFPopupContainView.h"

@implementation NFPopupContainView

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        
        UILabel *title_lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, kScreenWidth-20-40, 20)];
        title_lab.text = @"台面露珠";
        title_lab.textAlignment = NSTextAlignmentCenter;
        title_lab.font = [UIFont systemFontOfSize:18];
        [self addSubview:title_lab];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(kScreenWidth-40-30, 15, 20, 20);
        [cancelButton setImage:[UIImage imageNamed:@"pop_cancel"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelPupopView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
    } return self;
}

- (void)cancelPupopView{
    [self.container dismiss];
}

// 准备弹出(初始化弹层位置)
- (void)willPopupContainer:(DSHPopupContainer *)container; {
    CGRect frame = self.frame;
    frame.size = CGSizeMake(kScreenWidth-40, 300*2+180);
    frame.origin.x = 20;
    frame.origin.y = 150;
    self.frame = frame;
}

// 已弹出(做弹出动画)
- (void)didPopupContainer:(DSHPopupContainer *)container duration:(NSTimeInterval)duration; {
    self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeScale(1.f, 1.f);
    }];
}

// 将要移除(做移除动画)
- (void)willDismissContainer:(DSHPopupContainer *)container duration:(NSTimeInterval)duration; {
    CGRect frame = self.frame;
    frame.origin.y = container.frame.size.height;
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0.f;
    }];
}
@end
