//
//  EPPopAlertShowView.m
//  TestPopView
//
//  Created by smarter on 2018/8/6.
//  Copyright © 2018年 Ellipal. All rights reserved.
//

#import "EPDaSanInfoView.h"
#import "NRChipInfoModel.h"

@interface EPDaSanInfoView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *moneyInfoView;
@property (nonatomic, strong) UILabel *titleLabel;//标题


@property (nonatomic, strong) UILabel *tipsInfoLab;//提示信息

@property (nonatomic, strong) UIButton *readChipMoney_button;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) NRChipInfoModel *curInfo;

@property (nonatomic, strong) AlertbuttonClickAction alertHarder;

@end

@implementation EPDaSanInfoView


-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        self.alpha = 0;
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

-(instancetype)initWithNRCustomerInfo:(NRChipInfoModel *)customInfo{
    self = [self init];
    if (self) {
        self.curInfo = customInfo;
        [self _initializeUI];
        self.titleLabel.text = @"提示信息";
        self.tipsInfoLab.text = [NSString stringWithFormat:@"请认真核对以上信息，确认是否进行下一步操作\n%@",[EPStr getStr:kEPNextTips note:@"请认真核对以上信息，确认是否进行下一步操作"]];
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
    
    self.infoLab = [UILabel new];
    self.infoLab.textColor = [UIColor yellowColor];
    self.infoLab.font = [UIFont systemFontOfSize:16];
    self.infoLab.text = @"请放入相同金额散筹码";
    self.infoLab.textAlignment = NSTextAlignmentCenter;
    [self.moneyInfoView addSubview:self.infoLab];
    [self.infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyInfoView).offset(30);
        make.left.equalTo(self.moneyInfoView).offset(10);
        make.height.mas_offset(20);
        make.centerX.equalTo(self.moneyInfoView);
    }];
    
    self.guestNumberLab = [UILabel new];
    self.guestNumberLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.guestNumberLab.font = [UIFont systemFontOfSize:22];
    self.guestNumberLab.text = [NSString stringWithFormat:@"客人洗码号:%@",self.curInfo.guestWashesNumber];
    self.guestNumberLab.textAlignment = NSTextAlignmentCenter;
    [self.moneyInfoView addSubview:self.guestNumberLab];
    [self.guestNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoLab.mas_bottom).offset(20);
        make.left.equalTo(self.moneyInfoView).offset(10);
        make.height.mas_offset(20);
        make.centerX.equalTo(self.moneyInfoView);
    }];
    
    self.totalMoneyLab = [UILabel new];
    self.totalMoneyLab.textColor = [UIColor greenColor];
    self.totalMoneyLab.font = [UIFont systemFontOfSize:16];
    self.totalMoneyLab.text = [NSString stringWithFormat:@"打散金额:%@",self.curInfo.chipDenomination];
    self.totalMoneyLab.textAlignment = NSTextAlignmentCenter;
    [self.moneyInfoView addSubview:self.totalMoneyLab];
    [self.totalMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.guestNumberLab.mas_bottom).offset(20);
        make.left.equalTo(self.moneyInfoView).offset(10);
        make.height.mas_offset(20);
        make.centerX.equalTo(self.moneyInfoView);
    }];
    
    self.hasPayMoneyLab = [UILabel new];
    self.hasPayMoneyLab.textColor = [UIColor redColor];
    self.hasPayMoneyLab.font = [UIFont systemFontOfSize:16];
    self.hasPayMoneyLab.text = [NSString stringWithFormat:@"已放入金额:0"];
    self.hasPayMoneyLab.textAlignment = NSTextAlignmentCenter;
    [self.moneyInfoView addSubview:self.hasPayMoneyLab];
    [self.hasPayMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalMoneyLab.mas_bottom).offset(20);
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
     [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"cancel_button"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-20);
        make.left.equalTo(self.sureButton.mas_right).offset(20);
        make.height.mas_equalTo(40);
        make.width.mas_offset((kScreenWidth-300-40-20)/2);
    }];
     
}

+ (EPDaSanInfoView *)showInWindowWithNRCustomerInfo:(NRChipInfoModel *)customerInfo handler:(AlertbuttonClickAction)handler{
    EPDaSanInfoView *popUpView = [[EPDaSanInfoView alloc] initWithNRCustomerInfo:customerInfo];
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
