//
//  ChipNormalReadView.m
//  NFCReader
//
//  Created by 李黎明 on 2020/7/27.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "ChipNormalReadView.h"

@interface ChipNormalReadView ()

@property (nonatomic, strong) UIImageView *topIconImage;
@property (nonatomic, strong) UILabel *topTipsLab;
@property (nonatomic, strong) UIButton *comfirmBtn;

@property (nonatomic, strong) UITextField *adjustPowerTextField;

@property (nonatomic, assign) NSInteger curTag;

@end

@implementation ChipNormalReadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
//    self.chipInfoList = [NSMutableArray arrayWithCapacity:0];
    [self _setUpBaseView];
    return self;
}

- (void)_setUpBaseView{
    self.topIconImage = [UIImageView new];
    self.topIconImage.contentMode = UIViewContentModeScaleToFill;
    self.topIconImage.image = [UIImage imageNamed:@"douhao_icon"];
    [self addSubview:self.topIconImage];
    [self.topIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(120);
        make.width.height.mas_equalTo(150);
        make.centerX.equalTo(self);
    }];
    
    self.topTipsLab = [UILabel new];
    self.topTipsLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.topTipsLab.textColor = [UIColor colorWithHexString:@"#747474"];
    self.topTipsLab.textAlignment = NSTextAlignmentCenter;
    self.topTipsLab.numberOfLines = 0;
    [self addSubview:self.topTipsLab];
    [self.topTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topIconImage.mas_bottom).offset(60);
        make.left.equalTo(self).offset(20);
        make.centerX.equalTo(self);
    }];
    
    self.adjustPowerTextField = [UITextField new];
    self.adjustPowerTextField.placeholder = @"请输入1-5的数字";
    self.adjustPowerTextField.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.adjustPowerTextField.layer.cornerRadius = 5;
    self.adjustPowerTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.adjustPowerTextField.hidden = YES;
    UIView *takeleftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.adjustPowerTextField.leftView = takeleftview;
    self.adjustPowerTextField.leftViewMode = UITextFieldViewModeAlways;
    [self addSubview:self.adjustPowerTextField];
    [self.adjustPowerTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(140);
        make.left.equalTo(self).offset(40);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    self.comfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.comfirmBtn.layer.cornerRadius = 5;
    self.comfirmBtn.backgroundColor = [UIColor colorWithHexString:@"#347622"];
    [self.comfirmBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [self.comfirmBtn setTitleColor:[UIColor colorWithHexString:@"#52a938"] forState:UIControlStateSelected];
    self.comfirmBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.comfirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.comfirmBtn];
    [self.comfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-400);
        make.left.equalTo(self).offset(100);
        make.height.mas_equalTo(50);
        make.centerX.equalTo(self);
    }];
}

#pragma mark -- 筹码检测
- (void)_setUpChipViewWithTag:(NSInteger)tag{
    self.curTag = tag;
    if (tag==7) {
        self.topIconImage.image = [UIImage imageNamed:@"douhao_icon"];
        self.adjustPowerTextField.hidden = NO;
        self.topTipsLab.hidden = YES;
        self.topIconImage.hidden = YES;
        [self.comfirmBtn setTitle:@"开始设置" forState:UIControlStateNormal];
    }else if (tag==8){
        self.topIconImage.image = [UIImage imageNamed:@"chipSuccess_icon"];
        self.topTipsLab.text = @"兑换成功";
    }else{
        self.topIconImage.image = [UIImage imageNamed:@"douhao_icon"];
        self.adjustPowerTextField.hidden = YES;
        self.topTipsLab.hidden = NO;
        self.topIconImage.hidden = NO;
        if (tag==1) {
            self.topTipsLab.text = @"请将需要检测的筹码平整放置在感应托盘中!";
            [self.comfirmBtn setTitle:@"开始检测" forState:UIControlStateNormal];
        }else if (tag==2){
            self.topTipsLab.text = @"请将需要销毁的筹码平整放置在感应托盘中!";
            [self.comfirmBtn setTitle:@"开始读取" forState:UIControlStateNormal];
        }else if (tag==3){
            self.topTipsLab.text = @"请将筹码平整放置在感应托盘中进行读取";
            [self.comfirmBtn setTitle:@"开始读取" forState:UIControlStateNormal];
        }else if (tag==4){
            self.topTipsLab.text = @"请将需要结算的筹码平整放置在感应托盘中!";
            [self.comfirmBtn setTitle:@"开始结算" forState:UIControlStateNormal];
        }else if (tag==5){
            self.topTipsLab.text = @"请将需要存入的筹码平整放置在感应托盘中!";
            [self.comfirmBtn setTitle:@"开始存入" forState:UIControlStateNormal];
        }else if (tag==6){
            self.topTipsLab.text = @"请将需要取出的筹码平整放置在感应托盘中!";
            [self.comfirmBtn setTitle:@"开始取出" forState:UIControlStateNormal];
        }else if (tag==8){//成功
            
        }
    }
}

- (void)confirmBtnAction{
    if (self.chipReadBtnBlock) {
        self.chipReadBtnBlock(self.curTag);
    }
}

@end
