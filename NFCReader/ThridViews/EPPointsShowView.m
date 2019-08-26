//
//  EPPointsShowView.m
//  NFCReader
//
//  Created by 李黎明 on 2019/5/13.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "EPPointsShowView.h"
#import "NRChipResultInfo.h"

@interface EPPointsShowView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NRChipResultInfo *curInfo;
@property (nonatomic, strong) pointsAlertbuttonClickAction alertHarder;

@end

@implementation EPPointsShowView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        self.alpha = 0;
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(instancetype)initWithNRChipResultInfo:(NRChipResultInfo *)resultInfo{
    self = [self init];
    if (self) {
        self.curInfo = resultInfo;
        [self _initializeUI];
    }
    return self;
}


- (void) _initializeUI {
    
    UIButton *normalBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    [normalBUtton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:normalBUtton];
    [normalBUtton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self).offset(0);
    }];
    
    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5;
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(400);
        make.width.mas_offset(520);
        make.center.equalTo(self);
    }];
    
    CGFloat button_width = 520/4;
    for (int i=0; i<self.curInfo.topTitleList.count; i++) {
        NSString *topTitle = self.curInfo.topTitleList[i];
        UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [topButton setTitle:topTitle forState:UIControlStateNormal];
        topButton.layer.borderWidth = 0.5;
        topButton.titleLabel.numberOfLines = 0;
        topButton.layer.borderColor = [UIColor colorWithHexString:@"#f6f6f6"].CGColor;
        [topButton setTitleColor:[UIColor colorWithHexString:self.curInfo.firstColor] forState:UIControlStateNormal];
        [topButton setTitleColor:[UIColor colorWithHexString:self.curInfo.secondColor] forState:UIControlStateHighlighted];
        topButton.titleLabel.font = [UIFont systemFontOfSize:18];
        topButton.tag = 10+i;
        [topButton addTarget:self action:@selector(ressultButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:topButton];
        [topButton mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat bu_offset = i*button_width;
            make.top.equalTo(self.contentView).offset(0);
            make.left.equalTo(self.contentView).offset(bu_offset);
            make.height.mas_equalTo(80);
            make.width.mas_equalTo(button_width);
        }];
    }
    CGFloat bottom_width = 520/3;
    for (int i=0; i<self.curInfo.bottomTitleList.count; i++) {
        NSString *bottomTitle = self.curInfo.bottomTitleList[i];
        UIButton *preButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [preButton setTitle:bottomTitle forState:UIControlStateNormal];
        preButton.layer.borderWidth = 0.5;
        preButton.layer.borderColor = [UIColor colorWithHexString:@"#f6f6f6"].CGColor;
        [preButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [preButton setTitleColor:[UIColor colorWithHexString:self.curInfo.secondColor] forState:UIControlStateHighlighted];
        preButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [preButton addTarget:self action:@selector(ressultButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        preButton.tag = 9-i;
        [self.contentView addSubview:preButton];
        [preButton mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i>=0&&i<3) {
                make.top.equalTo(self.contentView).offset(80);
                make.left.equalTo(self.contentView).offset(i*bottom_width);
            }else if (i>=3&&i<6){
                make.top.equalTo(self.contentView).offset(160);
                make.left.equalTo(self.contentView).offset((i-3)*bottom_width);
            }else{
                make.top.equalTo(self.contentView).offset(240);
                make.left.equalTo(self.contentView).offset((i-6)*bottom_width);
            }
            make.height.mas_equalTo(80);
            make.width.mas_equalTo(bottom_width);
        }];
    }
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomButton setTitle:[EPStr getStr:kEPNoCow note:@"无牛"] forState:UIControlStateNormal];
    bottomButton.layer.borderWidth = 0.5;
    bottomButton.layer.borderColor = [UIColor colorWithHexString:@"#f6f6f6"].CGColor;
    [bottomButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    bottomButton.backgroundColor = [UIColor colorWithHexString:self.curInfo.secondColor];
    bottomButton.titleLabel.font = [UIFont systemFontOfSize:18];
    bottomButton.tag = 99;
    [bottomButton addTarget:self action:@selector(ressultButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:bottomButton];
    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(0);
        make.left.right.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(80);
    }];
}

+ (void)showInWindowWithNRChipResultInfo:(NRChipResultInfo *)resultInfo handler:(pointsAlertbuttonClickAction)handler{
    
    EPPointsShowView *popUpView = [[EPPointsShowView alloc] initWithNRChipResultInfo:resultInfo];
    popUpView.alertHarder = handler;
    [popUpView showInWindow];
}

-(void)showInWindow {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self showInView:window];
}

-(void)showInView:(UIView *)view{
    [view addSubview:self];
    self.contentView.center = self.center;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];
    [self showAlertAnimation];
}

- (void)showAlertAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .3;
    
    [self.contentView.layer addAnimation:animation forKey:@"showAlert"];
}

- (void)dismissAlertAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeRemoved;
    animation.duration = .2;
    
    [self.contentView.layer addAnimation:animation forKey:@"dismissAlert"];
}

- (void)_hide {
    [self dismissAlertAnimation];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    }];
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)sureAction{
    [self _hide];
}

- (void)ressultButtonAction:(UIButton *)btn{
    [EPSound playWithSoundName:@"click_sound"];
    _alertHarder((int)btn.tag);
    [self _hide];
}

@end
