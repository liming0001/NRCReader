//
//  EPPopAlertShowView.m
//  TestPopView
//
//  Created by smarter on 2018/8/6.
//  Copyright © 2018年 Ellipal. All rights reserved.
//

#import "EPPopAtipInfoView.h"
#import "NRCustomerInfo.h"

@interface EPPopAtipInfoView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *moneyInfoView;
@property (nonatomic, strong) UILabel *titleLabel;//标题


@property (nonatomic, strong) UILabel *tipsInfoLab;//提示信息

@property (nonatomic, strong) UIButton *readChipMoney_button;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) NRCustomerInfo *curInfo;

@property (nonatomic, strong) AlertbuttonClickAction alertHarder;

@end

@implementation EPPopAtipInfoView


-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        self.alpha = 0;
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

-(instancetype)initWithNRCustomerInfo:(NRCustomerInfo *)customInfo{
    self = [self init];
    if (self) {
        self.curInfo = customInfo;
        [self _initializeUI];
        self.titleLabel.text = self.curInfo.tipsTitle;
        self.tipsInfoLab.text = self.curInfo.tipsInfo;
    }
    return self;
}


- (void) _initializeUI {
    
    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#1d2933"];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 10;
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(150);
        make.height.mas_offset(400);
        make.center.equalTo(self);
    }];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.titleLabel.font = [UIFont systemFontOfSize:22];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(20);
        make.height.mas_offset(20);
        make.centerX.equalTo(self.contentView);
    }];
    
    self.moneyInfoView = [UIView new];
    self.moneyInfoView.backgroundColor = [UIColor colorWithHexString:@"#0e1a24"];
    self.moneyInfoView.layer.masksToBounds = YES;
    self.moneyInfoView.layer.cornerRadius = 10;
    [self.contentView addSubview:self.moneyInfoView];
    [self.moneyInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.height.mas_offset(200);
        make.centerX.equalTo(self.contentView);
    }];
    
    self.guestNumberLab = [UILabel new];
    self.guestNumberLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.guestNumberLab.font = [UIFont systemFontOfSize:22];
    self.guestNumberLab.text = @"客人洗码号:未知";
    self.guestNumberLab.textAlignment = NSTextAlignmentCenter;
    [self.moneyInfoView addSubview:self.guestNumberLab];
    [self.guestNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyInfoView).offset(40);
        make.left.equalTo(self.moneyInfoView).offset(10);
        make.height.mas_offset(20);
        make.centerX.equalTo(self.moneyInfoView);
    }];
    
    self.compensateMoneyLab = [UILabel new];
    self.compensateMoneyLab.textColor = [UIColor yellowColor];
    self.compensateMoneyLab.font = [UIFont systemFontOfSize:16];
    self.compensateMoneyLab.text = @"小费金额:0";
    self.compensateMoneyLab.textAlignment = NSTextAlignmentCenter;
    [self.moneyInfoView addSubview:self.compensateMoneyLab];
    [self.compensateMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.guestNumberLab.mas_bottom).offset(50);
        make.left.equalTo(self.moneyInfoView).offset(10);
        make.height.mas_offset(20);
        make.centerX.equalTo(self.moneyInfoView);
    }];
    
    self.tipsInfoLab = [UILabel new];
    self.tipsInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.tipsInfoLab.font = [UIFont systemFontOfSize:14];
    self.tipsInfoLab.numberOfLines = 0;
    [self.contentView addSubview:self.tipsInfoLab];
    [self.tipsInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyInfoView.mas_bottom).offset(30);
        make.left.equalTo(self.contentView).offset(30);
        make.centerX.equalTo(self.contentView);
    }];
    
    self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sureButton.layer.cornerRadius = 5;
    [self.sureButton setTitle:[EPStr getStr:kEPConfirm note:@"确定"] forState:UIControlStateNormal];
    [self.sureButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
//    self.sureButton.backgroundColor = [UIColor colorWithHexString:@"#347622"];
    [self.sureButton setBackgroundImage:[UIImage imageNamed:@"sureButton"] forState:UIControlStateNormal];
    [self.sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-20);
        make.left.equalTo(self.contentView).offset(20);
        make.height.mas_equalTo(40);
        make.width.mas_offset((kScreenWidth-300-40-20)/2);
    }];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.layer.cornerRadius = 5;
    [self.cancelButton setTitle:[EPStr getStr:kEPCancel note:@"取消"] forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
//    self.cancelButton.backgroundColor = [UIColor colorWithHexString:@"#b0241c"];
     [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"cancel_button"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-20);
        make.left.equalTo(self.sureButton.mas_right).offset(20);
        make.height.mas_equalTo(40);
        make.width.mas_offset((kScreenWidth-300-40-20)/2);
    }];
    
//    self.readChipMoney_button = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.readChipMoney_button.layer.cornerRadius = 5;
//    //        self.readChipMoney_button.backgroundColor = [UIColor colorWithHexString:@"#357522"];
//    [self.readChipMoney_button setBackgroundImage:[UIImage imageNamed:@"button_selected"] forState:UIControlStateNormal];
//    self.readChipMoney_button.titleLabel.font = [UIFont systemFontOfSize:16];
//    [self.readChipMoney_button addTarget:self action:@selector(readCurChipsMoney) forControlEvents:UIControlEventTouchUpInside];
//    [self.readChipMoney_button setTitle:@"识别小费金额" forState:UIControlStateNormal];
//    [self.contentView addSubview:self.readChipMoney_button];
//    [self.readChipMoney_button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(10);
//        make.right.equalTo(self.contentView).offset(-5);
//        make.height.mas_equalTo(30);
//        make.width.mas_offset(120);
//    }];
}

+ (EPPopAtipInfoView *)showInWindowWithNRCustomerInfo:(NRCustomerInfo *)customerInfo handler:(AlertbuttonClickAction)handler{
    
    EPPopAtipInfoView *popUpView = [[EPPopAtipInfoView alloc] initWithNRCustomerInfo:customerInfo];
    popUpView.alertHarder = handler;
    [popUpView showInWindow];
    return popUpView;
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
    self.alertHarder(1);
//    [self _hide];
}

- (void)cancelAction{
    self.alertHarder(0);
   [self _hide];
}

#pragma mark - 识别筹码金额
- (void)readCurChipsMoney{
    self.alertHarder(2);
}

@end
