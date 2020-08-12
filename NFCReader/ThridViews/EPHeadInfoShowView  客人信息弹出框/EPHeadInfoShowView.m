//
//  EPPopAlertShowView.m
//  TestPopView
//
//  Created by smarter on 2018/8/6.
//  Copyright © 2018年 Ellipal. All rights reserved.
//

#import "EPHeadInfoShowView.h"
#import "EPHeadInfo.h"

@interface EPHeadInfoShowView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *moneyInfoView;
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) EPHeadInfo *curInfo;

@end

@implementation EPHeadInfoShowView


-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        self.alpha = 0;
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

-(instancetype)initWithEPHeadInfo:(EPHeadInfo *)headInfo{
    self = [self init];
    if (self) {
        self.curInfo = headInfo;
        [self _initializeUI];
        self.titleLabel.text = @"客人信息";
        self.guestNumberLab.text = [NSString stringWithFormat:@"客人ID:%@",headInfo.fxmh];
        self.chumaMoneyLab.text = [NSString stringWithFormat:@"今日出码:%@",headInfo.chip_out];
        self.ximaMoneyLab.text = [NSString stringWithFormat:@"今日洗码:%@",headInfo.loss];
        self.shuyingMoneyLab.text = [NSString stringWithFormat:@"今日输赢:%@",headInfo.bonus];
        self.tableValueLab.text = [NSString stringWithFormat:@"本桌输赢:%@",headInfo.table_bonus];
        if ([headInfo.bonus intValue]<0) {
            self.shuyingMoneyLab.textColor = [UIColor redColor];
            self.tableValueLab.textColor = [UIColor redColor];
        }else{
            self.shuyingMoneyLab.textColor = [UIColor colorWithHexString:@"#5DA149"];
            self.tableValueLab.textColor = [UIColor colorWithHexString:@"#5DA149"];
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
        make.height.mas_offset(300);
        make.center.equalTo(self);
    }];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
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
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(20);
        make.height.mas_offset(230);
        make.centerX.equalTo(self.contentView);
    }];
    
    self.guestNumberLab = [UILabel new];
    self.guestNumberLab.textColor = [UIColor yellowColor];
    self.guestNumberLab.font = [UIFont systemFontOfSize:22];
    self.guestNumberLab.textAlignment = NSTextAlignmentCenter;
    [self.moneyInfoView addSubview:self.guestNumberLab];
    [self.guestNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyInfoView).offset(30);
        make.left.equalTo(self.moneyInfoView).offset(10);
        make.height.mas_offset(20);
        make.centerX.equalTo(self.moneyInfoView);
    }];
    
    self.chumaMoneyLab = [UILabel new];
    self.chumaMoneyLab.textColor = [UIColor whiteColor];
    self.chumaMoneyLab.font = [UIFont systemFontOfSize:20];
    self.chumaMoneyLab.textAlignment = NSTextAlignmentCenter;
    [self.moneyInfoView addSubview:self.chumaMoneyLab];
    [self.chumaMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.guestNumberLab.mas_bottom).offset(30);
        make.left.equalTo(self.moneyInfoView).offset(10);
        make.height.mas_offset(20);
        make.centerX.equalTo(self.moneyInfoView);
    }];
    
    self.ximaMoneyLab = [UILabel new];
    self.ximaMoneyLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.ximaMoneyLab.font = [UIFont systemFontOfSize:20];
    self.ximaMoneyLab.textAlignment = NSTextAlignmentCenter;
    [self.moneyInfoView addSubview:self.ximaMoneyLab];
    [self.ximaMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chumaMoneyLab.mas_bottom).offset(30);
        make.left.equalTo(self.moneyInfoView).offset(10);
        make.centerX.equalTo(self.moneyInfoView);
        make.height.mas_offset(20);
    }];
    
    self.shuyingMoneyLab = [UILabel new];
    self.shuyingMoneyLab.textColor = [UIColor colorWithHexString:@"#5DA149"];
    self.shuyingMoneyLab.font = [UIFont systemFontOfSize:20];
    self.shuyingMoneyLab.textAlignment = NSTextAlignmentCenter;
    [self.moneyInfoView addSubview:self.shuyingMoneyLab];
    [self.shuyingMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ximaMoneyLab.mas_bottom).offset(30);
        make.left.equalTo(self.moneyInfoView).offset(30);
        make.centerX.equalTo(self.moneyInfoView);
        make.height.mas_offset(20);
    }];
    
    self.tableValueLab = [UILabel new];
    self.tableValueLab.textColor = [UIColor colorWithHexString:@"#5DA149"];
    self.tableValueLab.font = [UIFont systemFontOfSize:20];
    self.tableValueLab.textAlignment = NSTextAlignmentCenter;
    [self.moneyInfoView addSubview:self.tableValueLab];
    [self.tableValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shuyingMoneyLab.mas_bottom).offset(30);
        make.left.equalTo(self.moneyInfoView).offset(30);
        make.centerX.equalTo(self.moneyInfoView);
        make.height.mas_offset(20);
    }];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.top.equalTo(self).offset(0);
    }];
}

+ (EPHeadInfoShowView *)showInWindowWithEPHeadInfo:(EPHeadInfo *)headInfo{
    
    EPHeadInfoShowView *popUpView = [[EPHeadInfoShowView alloc] initWithEPHeadInfo:headInfo];
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

- (void)cancelAction{
   [self _hide];
}

@end
