//
//  EPResultShowView.m
//  NFCReader
//
//  Created by 李黎明 on 2019/5/13.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "EPResultShowView.h"
#import "NRChipResultInfo.h"

@interface EPResultShowView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *firstButton;
@property (nonatomic, strong) UIButton *secondButton;
@property (nonatomic, strong) UIButton *thirdButton;
@property (nonatomic, strong) UIButton *forthButton;
@property (nonatomic, strong) UIButton *fiveButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UILabel *tipsLab;//提示
@property (nonatomic, strong) NRChipResultInfo *curInfo;
@property (nonatomic, strong) resultAlertbuttonClickAction alertHarder;
@property (nonatomic, strong) NSMutableArray *resultList;

@end

@implementation EPResultShowView

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
    self.resultList = [NSMutableArray array];
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
        if (self.curInfo.hasMore==1) {
            make.height.mas_offset(200);
        }else if (self.curInfo.hasMore==2){
            make.height.mas_offset(300);
        }else{
            make.height.mas_offset(438);
        }
        make.width.mas_offset(200);
        make.center.equalTo(self);
    }];
    
    self.firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.firstButton setTitle:self.curInfo.firstName forState:UIControlStateNormal];
    [self.firstButton setTitleColor:[UIColor colorWithHexString:self.curInfo.firstColor] forState:UIControlStateNormal];
    [self.firstButton setImage:[UIImage imageNamed:@"list_icon_buttonselect"] forState:UIControlStateSelected];
    self.firstButton.titleLabel.font = [UIFont systemFontOfSize:20];
    self.firstButton.tag = 1;
    [self.firstButton addTarget:self action:@selector(ressultButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.firstButton];
    [self.firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0);
        make.left.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(70);
        make.centerX.equalTo(self.contentView);
    }];
    
    self.secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.secondButton setTitle:self.curInfo.secondName forState:UIControlStateNormal];
    [self.secondButton setImage:[UIImage imageNamed:@"list_icon_buttonselect"] forState:UIControlStateSelected];
    [self.secondButton setTitleColor:[UIColor colorWithHexString:self.curInfo.secondColor] forState:UIControlStateNormal];
    self.secondButton.titleLabel.font = [UIFont systemFontOfSize:20];
    self.secondButton.tag = 2;
    [self.secondButton addTarget:self action:@selector(ressultButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.secondButton];
    [self.secondButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstButton.mas_bottom).offset(0);
        make.left.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(70);
        make.centerX.equalTo(self.contentView);
    }];
    
    if (self.curInfo.hasMore>1) {
        self.thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.thirdButton setTitle:self.curInfo.thirdName forState:UIControlStateNormal];
        [self.thirdButton setImage:[UIImage imageNamed:@"list_icon_buttonselect"] forState:UIControlStateSelected];
        [self.thirdButton setTitleColor:[UIColor colorWithHexString:self.curInfo.thirdColor] forState:UIControlStateNormal];
        self.thirdButton.titleLabel.font = [UIFont systemFontOfSize:20];
        self.thirdButton.tag = 3;
        [self.thirdButton addTarget:self action:@selector(ressultButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.thirdButton];
        [self.thirdButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.secondButton.mas_bottom).offset(0);
            make.left.equalTo(self.contentView).offset(0);
            make.height.mas_equalTo(70);
            make.centerX.equalTo(self.contentView);
        }];
        if (self.curInfo.hasMore>2) {
            self.forthButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.forthButton setTitle:self.curInfo.forthName forState:UIControlStateNormal];
            [self.forthButton setImage:[UIImage imageNamed:@"list_icon_buttonselect"] forState:UIControlStateSelected];
            [self.forthButton setTitleColor:[UIColor colorWithHexString:self.curInfo.forthColor] forState:UIControlStateNormal];
            self.forthButton.titleLabel.font = [UIFont systemFontOfSize:20];
            self.forthButton.tag = 4;
            [self.forthButton addTarget:self action:@selector(ressultButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.forthButton];
            [self.forthButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.thirdButton.mas_bottom).offset(0);
                make.left.equalTo(self.contentView).offset(0);
                make.height.mas_equalTo(70);
                make.centerX.equalTo(self.contentView);
            }];
            
            self.fiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.fiveButton setTitle:self.curInfo.fiveName forState:UIControlStateNormal];
            [self.fiveButton setImage:[UIImage imageNamed:@"list_icon_buttonselect"] forState:UIControlStateSelected];
            [self.fiveButton setTitleColor:[UIColor colorWithHexString:self.curInfo.fiveColor] forState:UIControlStateNormal];
            self.fiveButton.titleLabel.font = [UIFont systemFontOfSize:20];
            self.fiveButton.tag = 5;
            [self.fiveButton addTarget:self action:@selector(ressultButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.fiveButton];
            [self.fiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.forthButton.mas_bottom).offset(0);
                make.left.equalTo(self.contentView).offset(0);
                make.height.mas_equalTo(70);
                make.centerX.equalTo(self.contentView);
            }];
        }
    }
    
    self.tipsLab = [UILabel new];
    self.tipsLab.textColor = [UIColor colorWithHexString:self.curInfo.firstColor];
    self.tipsLab.font = [UIFont systemFontOfSize:12];
    self.tipsLab.text = self.curInfo.tips;
    self.tipsLab.numberOfLines = 0;
    self.tipsLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.tipsLab];
    [self.tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.curInfo.hasMore==1) {
            make.top.equalTo(self.secondButton.mas_bottom).offset(0);
        }else if (self.curInfo.hasMore==2){
            make.top.equalTo(self.thirdButton.mas_bottom).offset(0);
        }else{
            make.top.equalTo(self.fiveButton.mas_bottom).offset(0);
        }
        make.left.equalTo(self.contentView).offset(0);
//        make.height.mas_offset(20);
        make.centerX.equalTo(self.contentView);
    }];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setTitle:[EPStr getStr:kEPConfirm note:@"确定"] forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.backgroundColor = [UIColor colorWithHexString:@"#357522"];
    [self.contentView addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLab.mas_bottom).offset(0);
        make.left.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(60);
        make.centerX.equalTo(self.contentView);
    }];
    
}

+ (void)showInWindowWithNRChipResultInfo:(NRChipResultInfo *)resultInfo handler:(resultAlertbuttonClickAction)handler{
    
    EPResultShowView *popUpView = [[EPResultShowView alloc] initWithNRChipResultInfo:resultInfo];
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
    int winType = (int)btn.tag;
    if (winType==1) {
        if ([self.resultList containsObject:[NSNumber numberWithInteger:2]]||[self.resultList containsObject:[NSNumber numberWithInteger:3]]) {
            [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
            return;
        }
    }else if (winType==2){
        if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:3]]) {
            [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
            return;
        }
    }else if (winType==3){
        if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:2]]||[self.resultList containsObject:[NSNumber numberWithInteger:4]]||[self.resultList containsObject:[NSNumber numberWithInteger:5]]) {
            [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
            return;
        }
    }else if (winType==4){
        if ([self.resultList containsObject:[NSNumber numberWithInteger:3]]) {
            [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
            return;
        }
    }else if (winType==5){
        if ([self.resultList containsObject:[NSNumber numberWithInteger:3]]) {
            [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
            return;
        }
    }
    btn.selected = !btn.selected;
    if (btn.selected) {
        if (![self.resultList containsObject:[NSNumber numberWithInteger:btn.tag]]) {
            [self.resultList addObject:[NSNumber numberWithInteger:btn.tag]];
        }
    }else{
        if ([self.resultList containsObject:[NSNumber numberWithInteger:btn.tag]]) {
            [self.resultList removeObject:[NSNumber numberWithInteger:btn.tag]];
        }
    }
}

- (void)confirmButtonAction:(UIButton *)btn{
    if (self.resultList.count==0) {
        [[EPToast makeText:@"请选择结果"]showWithType:ShortTime];
        return;
    }
    
    _alertHarder(self.resultList);
    [self _hide];
}

@end
