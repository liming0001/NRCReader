//
//  EPPopAlertShowView.m
//  TestPopView
//
//  Created by smarter on 2018/8/6.
//  Copyright © 2018年 Ellipal. All rights reserved.
//

#import "EPPopAlertShowView.h"
#import "NRCustomerInfo.h"

@interface EPPopAlertShowView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *moneyInfoView;
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UILabel *guestNumberLab;//客人洗码号
@property (nonatomic, strong) UILabel *winStatusLab;//输赢状态
@property (nonatomic, strong) UILabel *principalMoneyLab;//本金

@property (nonatomic, strong) UILabel *tipsInfoLab;//提示信息

@property (nonatomic, strong) UILabel *xiazhuLab;//下注
@property (nonatomic, strong) UILabel *addcompensateLab;//应加赔
@property (nonatomic, strong) UILabel *shazhuLab;//杀注

@property (nonatomic, strong) UIButton *readChipMoney_button;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) NRCustomerInfo *curInfo;

@property (nonatomic, strong) AlertbuttonClickAction alertHarder;

@end

@implementation EPPopAlertShowView

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
        self.guestNumberLab.text = self.curInfo.guestNumber;
        self.winStatusLab.text = self.curInfo.winStatus;
        self.principalMoneyLab.text = self.curInfo.principalMoney;
        self.compensateCodeLab.text = self.curInfo.compensateCode;
        self.drawWaterMoneyLab.text = self.curInfo.drawWaterMoney;
        self.compensateMoneyLab.text = self.curInfo.compensateMoney;
        self.totalMoneyLab.text = self.curInfo.totalMoney;
        self.tipsInfoLab.text = self.curInfo.tipsInfo;
        
        self.shazhuLab.text = self.curInfo.shazhu;
        self.xiazhuLab.text = self.curInfo.xiazhu;
        self.addcompensateLab.text = self.curInfo.add_chipMoney;
        
        if (self.curInfo.isWinOrLose) {
            self.havepayChipLab.hidden = NO;
            self.principalMoneyLab.hidden = NO;
            self.compensateCodeLab.hidden = NO;
            self.drawWaterMoneyLab.hidden = NO;
            self.compensateMoneyLab.hidden = NO;
            self.totalMoneyLab.hidden = NO;
            self.shazhuLab.hidden = YES;
            self.xiazhuLab.hidden = YES;
            self.addcompensateLab.hidden = YES;
        }else{
            self.havepayChipLab.hidden = YES;
            self.principalMoneyLab.hidden = YES;
            self.compensateCodeLab.hidden = YES;
            self.drawWaterMoneyLab.hidden = YES;
            self.compensateMoneyLab.hidden = YES;
            self.totalMoneyLab.hidden = YES;
            self.shazhuLab.hidden = NO;
            self.xiazhuLab.hidden = NO;
            if (self.curInfo.isCow) {
                self.addcompensateLab.hidden = NO;
                self.havepayChipLab.hidden = YES;
            }
            if (self.curInfo.isTiger) {
                self.havepayChipLab.hidden = NO;
            }
        }
        if (self.curInfo.isCash) {
            self.readChipMoney_button.hidden = YES;
            self.havepayChipLab.hidden = YES;
        }
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
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.left.equalTo(self.contentView).offset(20);
        make.centerX.equalTo(self.contentView);
    }];
    
    self.moneyInfoView = [UIView new];
    self.moneyInfoView.backgroundColor = [UIColor colorWithHexString:@"#0e1a24"];
    self.moneyInfoView.layer.masksToBounds = YES;
    self.moneyInfoView.layer.cornerRadius = 10;
    [self.contentView addSubview:self.moneyInfoView];
    [self.moneyInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.contentView).offset(20);
        make.height.mas_offset(200);
        make.centerX.equalTo(self.contentView);
    }];
    
    self.guestNumberLab = [UILabel new];
    self.guestNumberLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.guestNumberLab.font = [UIFont systemFontOfSize:14];
    self.guestNumberLab.numberOfLines = 2;
    [self.moneyInfoView addSubview:self.guestNumberLab];
    [self.guestNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyInfoView).offset(20);
        make.left.equalTo(self.moneyInfoView).offset(10);
        make.width.mas_offset((kScreenWidth-300-60-10)/2);
    }];
    
    self.winStatusLab = [UILabel new];
    self.winStatusLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.winStatusLab.font = [UIFont systemFontOfSize:14];
    self.winStatusLab.numberOfLines = 2;
    self.winStatusLab.textAlignment = NSTextAlignmentRight;
    [self.moneyInfoView addSubview:self.winStatusLab];
    [self.winStatusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyInfoView).offset(20);
        make.left.equalTo(self.guestNumberLab.mas_right).offset(10);
        make.width.mas_offset((kScreenWidth-300-60-10)/2);
    }];
    
    self.xiazhuLab = [UILabel new];
    self.xiazhuLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.xiazhuLab.font = [UIFont systemFontOfSize:14];
    self.xiazhuLab.textAlignment = NSTextAlignmentCenter;
    self.xiazhuLab.hidden = YES;
    [self.moneyInfoView addSubview:self.xiazhuLab];
    [self.xiazhuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.guestNumberLab.mas_bottom).offset(20);
        make.left.equalTo(self.moneyInfoView).offset(10);
        make.height.mas_offset(20);
        make.centerX.equalTo(self.moneyInfoView);
    }];
    
    self.addcompensateLab = [UILabel new];
    self.addcompensateLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.addcompensateLab.font = [UIFont systemFontOfSize:18];
    self.addcompensateLab.textAlignment = NSTextAlignmentLeft;
    self.addcompensateLab.hidden = YES;
    self.addcompensateLab.textColor = [UIColor colorWithHexString:@"#347622"];
    [self.moneyInfoView addSubview:self.addcompensateLab];
    [self.addcompensateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xiazhuLab.mas_bottom).offset(10);
        make.left.equalTo(self.moneyInfoView).offset(10);
        make.height.mas_offset(20);
        make.centerX.equalTo(self.moneyInfoView);
    }];
    
    self.shazhuLab = [UILabel new];
    self.shazhuLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.shazhuLab.font = [UIFont systemFontOfSize:20];
    self.shazhuLab.textAlignment = NSTextAlignmentCenter;
    self.shazhuLab.hidden = YES;
    [self.moneyInfoView addSubview:self.shazhuLab];
    [self.shazhuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addcompensateLab.mas_bottom).offset(20);
        make.left.equalTo(self.moneyInfoView).offset(10);
        make.centerX.equalTo(self.moneyInfoView);
    }];
    
    self.principalMoneyLab = [UILabel new];
    self.principalMoneyLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.principalMoneyLab.font = [UIFont systemFontOfSize:14];
    self.principalMoneyLab.numberOfLines = 0;
    self.principalMoneyLab.text = [NSString stringWithFormat:@"已赔付筹码\n%@:0",[EPStr getStr:kEPPeifuChip note:@"已赔付筹码:"]];
    [self.moneyInfoView addSubview:self.principalMoneyLab];
    [self.principalMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.guestNumberLab.mas_bottom).offset(40);
        make.left.equalTo(self.moneyInfoView).offset(10);
        make.centerX.equalTo(self.moneyInfoView);
    }];
    
    self.havepayChipLab = [UILabel new];
    self.havepayChipLab.textColor = [UIColor colorWithHexString:@"#f2bc41"];
    self.havepayChipLab.font = [UIFont systemFontOfSize:14];
    self.havepayChipLab.text = [NSString stringWithFormat:@"已赔付筹码\n%@:0",[EPStr getStr:kEPPeifuChip note:@"已赔付筹码:"]];
    self.havepayChipLab.numberOfLines = 0;
    self.havepayChipLab.hidden = YES;
    [self.moneyInfoView addSubview:self.havepayChipLab];
    [self.havepayChipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.principalMoneyLab.mas_bottom).offset(0);
        make.right.equalTo(self.moneyInfoView).offset(-10);
    }];
    
    self.compensateCodeLab = [UILabel new];
    self.compensateCodeLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.compensateCodeLab.font = [UIFont systemFontOfSize:14];
    [self.moneyInfoView addSubview:self.compensateCodeLab];
    [self.compensateCodeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.principalMoneyLab.mas_bottom).offset(10);
        make.left.equalTo(self.moneyInfoView).offset(10);
        make.height.mas_offset(20);
        make.centerX.equalTo(self.moneyInfoView);
    }];
    
    self.drawWaterMoneyLab = [UILabel new];
    self.drawWaterMoneyLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.drawWaterMoneyLab.font = [UIFont systemFontOfSize:14];
    [self.moneyInfoView addSubview:self.drawWaterMoneyLab];
    [self.drawWaterMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.compensateCodeLab.mas_bottom).offset(10);
        make.left.equalTo(self.moneyInfoView).offset(10);
        make.height.mas_offset(20);
        make.centerX.equalTo(self.moneyInfoView);
    }];
    
    self.compensateMoneyLab = [UILabel new];
    self.compensateMoneyLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.compensateMoneyLab.font = [UIFont systemFontOfSize:14];
    [self.moneyInfoView addSubview:self.compensateMoneyLab];
    [self.compensateMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.drawWaterMoneyLab.mas_bottom).offset(10);
        make.left.equalTo(self.moneyInfoView).offset(10);
        make.height.mas_offset(20);
    }];
    
    self.totalMoneyLab = [UILabel new];
    self.totalMoneyLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.totalMoneyLab.font = [UIFont systemFontOfSize:16];
    [self.moneyInfoView addSubview:self.totalMoneyLab];
    [self.totalMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moneyInfoView).offset(-10);
        make.bottom.equalTo(self.moneyInfoView).offset(-30);
    }];
    
    self.tipsInfoLab = [UILabel new];
    self.tipsInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.tipsInfoLab.font = [UIFont systemFontOfSize:14];
    self.tipsInfoLab.numberOfLines = 0;
    [self.contentView addSubview:self.tipsInfoLab];
    [self.tipsInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyInfoView.mas_bottom).offset(20);
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
     [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"cancel_button"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-20);
        make.left.equalTo(self.sureButton.mas_right).offset(20);
        make.height.mas_equalTo(40);
        make.width.mas_offset((kScreenWidth-300-40-20)/2);
    }];
    
    if (self.curInfo.isWinOrLose||self.curInfo.isCow||self.curInfo.isTiger) {
        self.readChipMoney_button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.readChipMoney_button.layer.cornerRadius = 5;
        self.readChipMoney_button.titleLabel.numberOfLines = 0;
        [self.readChipMoney_button setBackgroundImage:[UIImage imageNamed:@"button_selected"] forState:UIControlStateNormal];
        self.readChipMoney_button.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.readChipMoney_button addTarget:self action:@selector(readCurChipsMoney) forControlEvents:UIControlEventTouchUpInside];
        [self.readChipMoney_button setTitle:@"水钱识别" forState:UIControlStateNormal];
        [self.contentView addSubview:self.readChipMoney_button];
        [self.readChipMoney_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-5);
            make.height.mas_equalTo(30);
            make.width.mas_offset(120);
        }];
    }
    
    if (self.curInfo.isTiger) {
        self.havepayChipLab.text = @"已识别找回筹码:0";
    }
}

+ (EPPopAlertShowView *)showInWindowWithNRCustomerInfo:(NRCustomerInfo *)customerInfo handler:(AlertbuttonClickAction)handler{
    
    EPPopAlertShowView *popUpView = [[EPPopAlertShowView alloc] initWithNRCustomerInfo:customerInfo];
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
    if (self.curInfo.isTiger) {
        if ([self.havepayChipLab.text isEqualToString:@"已识别找回筹码:0"]) {
            [[EPToast makeText:@"未检测到找回筹码"]showWithType:ShortTime];
            //响警告声音
            [EPSound playWithSoundName:@"wram_sound"];
            return;
        }
    }
    self.alertHarder(1);
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
