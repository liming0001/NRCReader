//
//  JiaJIanCaiCell.m
//  NFCReader
//
//  Created by 李黎明 on 2019/9/5.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "JiaJIanCaiCell.h"
#import "UIView+Layout.h"
#import "DenominationView.h"
#import "NRChipAllInfo.h"
#import "NRChipInfo.h"
#import "JiaJianCaiCellView.h"

@interface JiaJIanCaiCell ()

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *midView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NRChipAllInfo *curChipInfo;
@property (nonatomic, strong) JiaJianCaiCellView *firstCellView;
@property (nonatomic, strong) JiaJianCaiCellView *secondCellView;
@property (nonatomic, strong) JiaJianCaiCellView *thridCellView;
@property (nonatomic, strong) JiaJianCaiCellView *forthCellView;
@property (nonatomic, strong) JiaJianCaiCellView *fiveCellView;
@property (nonatomic, strong) JiaJianCaiCellView *sixCellView;
@property (nonatomic, strong) JiaJianCaiCellView *sevenCellView;
@property (nonatomic, strong) JiaJianCaiCellView *eightCellView;
@property (nonatomic, strong) JiaJianCaiCellView *nineCellView;
@property (nonatomic, strong) JiaJianCaiCellView *tenCellView;
@property (nonatomic, strong) JiaJianCaiCellView *elevenCellView;

@end

@implementation JiaJIanCaiCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Initialization code
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 530, 38)];
    self.headView.backgroundColor = [UIColor redColor];
    [self addSubview:self.headView];
    
    self.chipTypeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 4, 530-20, 30)];
    self.chipTypeLab.text  =@"人民币筹码/RMB Chip";
    self.chipTypeLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.chipTypeLab.font = [UIFont systemFontOfSize:16];
    [self.headView addSubview:self.chipTypeLab];

    self.openOrCloseArow = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.openOrCloseArow setImage:[UIImage imageNamed:@"open_icon"] forState:UIControlStateNormal];
    [self.openOrCloseArow setImage:[UIImage imageNamed:@"pullDown_icon"] forState:UIControlStateSelected];
    self.openOrCloseArow.frame = CGRectMake(530-40, 6, 30, 30);
    [self.openOrCloseArow addTarget:self action:@selector(openOrClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:self.openOrCloseArow];
    
    self.openOrCloseLab = [[UILabel alloc]initWithFrame:CGRectMake(530-40-200-5, 4, 200, 30)];
    self.openOrCloseLab.text  =@"收起/Retract";
    self.openOrCloseLab.textAlignment = NSTextAlignmentRight;
    self.openOrCloseLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.openOrCloseLab.font = [UIFont systemFontOfSize:16];
    [self.headView addSubview:self.openOrCloseLab];
    
    self.desView = [[DenominationView alloc]initWithFrame:CGRectMake(0, 0, 530, 30)];
    self.desView.hidden = YES;
    self.midView = [[UIView alloc]initWithFrame:CGRectMake(0, 38, 530, 30+11*40)];
    self.midView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.midView];
    [self.midView addSubview:self.desView];
    
    self.firstCellView = [[JiaJianCaiCellView alloc]initWithFrame:CGRectMake(0, 30, 530, 40)];
    self.firstCellView.hidden = YES;
    self.firstCellView.chipNumberEditBtn.tag = 1;
    [self.midView addSubview:self.firstCellView];
    
    self.secondCellView = [[JiaJianCaiCellView alloc]initWithFrame:CGRectMake(0, 30+40, 530, 40)];
    self.secondCellView.hidden = YES;
    self.secondCellView.chipNumberEditBtn.tag = 2;
    [self.midView addSubview:self.secondCellView];
    
    self.thridCellView = [[JiaJianCaiCellView alloc]initWithFrame:CGRectMake(0, 30+2*40, 530, 40)];
    self.thridCellView.hidden = YES;
    self.thridCellView.chipNumberEditBtn.tag = 3;
    [self.midView addSubview:self.thridCellView];
    
    self.forthCellView = [[JiaJianCaiCellView alloc]initWithFrame:CGRectMake(0, 30+3*40, 530, 40)];
    self.forthCellView.hidden = YES;
    self.forthCellView.chipNumberEditBtn.tag = 4;
    [self.midView addSubview:self.forthCellView];
    
    self.fiveCellView = [[JiaJianCaiCellView alloc]initWithFrame:CGRectMake(0, 30+4*40, 530, 40)];
    self.fiveCellView.hidden = YES;
    self.fiveCellView.chipNumberEditBtn.tag = 5;
    [self.midView addSubview:self.fiveCellView];
    
    self.sixCellView = [[JiaJianCaiCellView alloc]initWithFrame:CGRectMake(0, 30+5*40, 530, 40)];
    self.sixCellView.hidden = YES;
    self.sixCellView.chipNumberEditBtn.tag = 6;
    [self.midView addSubview:self.sixCellView];
    
    self.sevenCellView = [[JiaJianCaiCellView alloc]initWithFrame:CGRectMake(0, 30+6*40, 530, 40)];
    self.sevenCellView.hidden = YES;
    self.sevenCellView.chipNumberEditBtn.tag = 7;
    [self.midView addSubview:self.sevenCellView];
    
    self.eightCellView = [[JiaJianCaiCellView alloc]initWithFrame:CGRectMake(0, 30+7*40, 530, 40)];
    self.eightCellView.hidden = YES;
    self.eightCellView.chipNumberEditBtn.tag = 8;
    [self.midView addSubview:self.eightCellView];
    
    self.nineCellView = [[JiaJianCaiCellView alloc]initWithFrame:CGRectMake(0, 30+8*40, 530, 40)];
    self.nineCellView.hidden = YES;
    self.nineCellView.chipNumberEditBtn.tag = 9;
    [self.midView addSubview:self.nineCellView];
    
    self.tenCellView = [[JiaJianCaiCellView alloc]initWithFrame:CGRectMake(0, 30+9*40, 530, 40)];
    self.tenCellView.hidden = YES;
    self.tenCellView.chipNumberEditBtn.tag = 10;
    [self.midView addSubview:self.tenCellView];
    
    self.elevenCellView = [[JiaJianCaiCellView alloc]initWithFrame:CGRectMake(0, 30+10*40, 530, 40)];
    self.elevenCellView.hidden = YES;
    self.elevenCellView.chipNumberEditBtn.tag = 11;
    [self.midView addSubview:self.elevenCellView];
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 430, 530, 30)];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"#cecece"];
    [self addSubview:self.bottomView];
    
    self.totalNumberLab = [UILabel new];
    self.totalNumberLab.text  =@"总数量:0";
    self.totalNumberLab.textAlignment = NSTextAlignmentRight;
    self.totalNumberLab.textColor = [UIColor colorWithRed:71/255.0 green:71/255.0 blue:71/255.0 alpha:1];
    self.totalNumberLab.font = [UIFont systemFontOfSize:16];
    [self.bottomView addSubview:self.totalNumberLab];
    [self.totalNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bottomView).offset(0);
        make.left.equalTo(self.bottomView).offset(20);
    }];
    
    self.totalMoneyLab = [UILabel new];
    self.totalMoneyLab.text  =@"总金额:0";
    self.totalMoneyLab.textAlignment = NSTextAlignmentRight;
    self.totalMoneyLab.textColor = [UIColor colorWithRed:71/255.0 green:71/255.0 blue:71/255.0 alpha:1];
    self.totalMoneyLab.font = [UIFont systemFontOfSize:16];
    [self.bottomView addSubview:self.totalMoneyLab];
    [self.totalMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bottomView).offset(0);
        make.left.equalTo(self.totalNumberLab.mas_right).offset(40);
    }];
    
    self.chipTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chipTypeBtn setImage:[UIImage imageNamed:@"RMB_ChipIcon"] forState:UIControlStateNormal];
    [self.chipTypeBtn setImage:[UIImage imageNamed:@"RMB_ChipIcon"] forState:UIControlStateHighlighted];
    [self.chipTypeBtn setTitle:@"RMB" forState:UIControlStateNormal];
    [self.chipTypeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.chipTypeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.bottomView addSubview:self.chipTypeBtn];
    [self.chipTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bottomView).offset(0);
        make.right.equalTo(self.bottomView).offset(-10);
    }];
    
    @weakify(self);
    [[self.firstCellView.chipNumberTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSInteger oneValue = [self.firstCellView.chipNumberLab.text integerValue];
        self.firstCellView.chipMoneyValueLab.text = [NSString stringWithFormat:@"%ld",[x integerValue]*oneValue];
        [self cacutelatuFirstValue];
        int type_status = 0;
        if ([self.curChipInfo.fcmtype intValue]==1) {//人民币码
            type_status = 0;
        }else if ([self.curChipInfo.fcmtype intValue]==6){//人民币
            type_status = 1;
        }else if ([self.curChipInfo.fcmtype intValue]==2){
            type_status = 2;
        }else if ([self.curChipInfo.fcmtype intValue]==7){
            type_status = 3;
        }
        if (self.refrashSigleValueBlock) {
            self.refrashSigleValueBlock(type_status, x, self.firstCellView.chipNumberLab.text,0);
        }
    }];
    self.firstCellView.editBtnBock = ^(NSInteger curTag) {
        @strongify(self);
        if (curTag==1) {
            self.firstCellView.chipNumberEditBtn.selected = !self.firstCellView.chipNumberEditBtn.selected;
            if (self.firstCellView.chipNumberEditBtn.selected) {
                self.firstCellView.chipNumberTF.enabled = YES;
                self.firstCellView.chipNumberTF.background = [UIImage imageNamed:@"totalBox_bg_icon"];
                self.firstCellView.chipNumberTF.placeholder = @"请输入数量";
                
                self.secondCellView.chipNumberTF.enabled = NO;
                self.secondCellView.chipNumberTF.background = nil;
                self.secondCellView.chipNumberTF.placeholder = @"";
                
                self.thridCellView.chipNumberTF.enabled = NO;
                self.thridCellView.chipNumberTF.background = nil;
                self.thridCellView.chipNumberTF.placeholder = @"";
                
                self.forthCellView.chipNumberTF.enabled = NO;
                self.forthCellView.chipNumberTF.background = nil;
                self.forthCellView.chipNumberTF.placeholder = @"";
                
                self.fiveCellView.chipNumberTF.enabled = NO;
                self.fiveCellView.chipNumberTF.background = nil;
                self.fiveCellView.chipNumberTF.placeholder = @"";
                
                self.sixCellView.chipNumberTF.enabled = NO;
                self.sixCellView.chipNumberTF.background = nil;
                self.sixCellView.chipNumberTF.placeholder = @"";
                
                self.sevenCellView.chipNumberTF.enabled = NO;
                self.sevenCellView.chipNumberTF.background = nil;
                self.sevenCellView.chipNumberTF.placeholder = @"";
                
                self.eightCellView.chipNumberTF.enabled = NO;
                self.eightCellView.chipNumberTF.background = nil;
                self.eightCellView.chipNumberTF.placeholder = @"";
                
                self.nineCellView.chipNumberTF.enabled = NO;
                self.nineCellView.chipNumberTF.background = nil;
                self.nineCellView.chipNumberTF.placeholder = @"";
                
                self.tenCellView.chipNumberTF.enabled = NO;
                self.tenCellView.chipNumberTF.background = nil;
                self.tenCellView.chipNumberTF.placeholder = @"";
                
                self.elevenCellView.chipNumberTF.enabled = NO;
                self.elevenCellView.chipNumberTF.background = nil;
                self.elevenCellView.chipNumberTF.placeholder = @"";
            }else{
                self.firstCellView.chipNumberTF.enabled = NO;
                self.firstCellView.chipNumberTF.background = nil;
                self.firstCellView.chipNumberTF.placeholder = @"";
            }
        }
    };
    
    [[self.secondCellView.chipNumberTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSInteger twoValue = [self.secondCellView.chipNumberLab.text integerValue];
        self.secondCellView.chipMoneyValueLab.text = [NSString stringWithFormat:@"%ld",[x integerValue]*twoValue];
        [self cacutelatuFirstValue];
        int type_status = 0;
        if ([self.curChipInfo.fcmtype intValue]==1) {//人民币码
            type_status = 0;
        }else if ([self.curChipInfo.fcmtype intValue]==6){//人民币
            type_status = 1;
        }else if ([self.curChipInfo.fcmtype intValue]==2){
            type_status = 2;
        }else if ([self.curChipInfo.fcmtype intValue]==7){
            type_status = 3;
        }
        if (self.refrashSigleValueBlock) {
            self.refrashSigleValueBlock(type_status, x, self.secondCellView.chipNumberLab.text,1);
        }
    }];
    
    self.secondCellView.editBtnBock = ^(NSInteger curTag) {
        @strongify(self);
        if (curTag==2) {
            self.secondCellView.chipNumberEditBtn.selected = !self.secondCellView.chipNumberEditBtn.selected;
            if (self.secondCellView.chipNumberEditBtn.selected) {
                self.secondCellView.chipNumberTF.enabled = YES;
                self.secondCellView.chipNumberTF.background = [UIImage imageNamed:@"totalBox_bg_icon"];
                self.secondCellView.chipNumberTF.placeholder = @"请输入数量";
                
                self.firstCellView.chipNumberTF.enabled = NO;
                self.firstCellView.chipNumberTF.background = nil;
                self.firstCellView.chipNumberTF.placeholder = @"";
                
                self.thridCellView.chipNumberTF.enabled = NO;
                self.thridCellView.chipNumberTF.background = nil;
                self.thridCellView.chipNumberTF.placeholder = @"";
                
                self.forthCellView.chipNumberTF.enabled = NO;
                self.forthCellView.chipNumberTF.background = nil;
                self.forthCellView.chipNumberTF.placeholder = @"";
                
                self.fiveCellView.chipNumberTF.enabled = NO;
                self.fiveCellView.chipNumberTF.background = nil;
                self.fiveCellView.chipNumberTF.placeholder = @"";
                
                self.sixCellView.chipNumberTF.enabled = NO;
                self.sixCellView.chipNumberTF.background = nil;
                self.sixCellView.chipNumberTF.placeholder = @"";
                
                self.sevenCellView.chipNumberTF.enabled = NO;
                self.sevenCellView.chipNumberTF.background = nil;
                self.sevenCellView.chipNumberTF.placeholder = @"";
                
                self.eightCellView.chipNumberTF.enabled = NO;
                self.eightCellView.chipNumberTF.background = nil;
                self.eightCellView.chipNumberTF.placeholder = @"";
                
                self.nineCellView.chipNumberTF.enabled = NO;
                self.nineCellView.chipNumberTF.background = nil;
                self.nineCellView.chipNumberTF.placeholder = @"";
                
                self.tenCellView.chipNumberTF.enabled = NO;
                self.tenCellView.chipNumberTF.background = nil;
                self.tenCellView.chipNumberTF.placeholder = @"";
                
                self.elevenCellView.chipNumberTF.enabled = NO;
                self.elevenCellView.chipNumberTF.background = nil;
                self.elevenCellView.chipNumberTF.placeholder = @"";
            }else{
                self.secondCellView.chipNumberTF.enabled = NO;
                self.secondCellView.chipNumberTF.background = nil;
                self.secondCellView.chipNumberTF.placeholder = @"";
            }
        }
    };
    
    [[self.thridCellView.chipNumberTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSInteger twoValue = [self.thridCellView.chipNumberLab.text integerValue];
        self.thridCellView.chipMoneyValueLab.text = [NSString stringWithFormat:@"%ld",[x integerValue]*twoValue];
        [self cacutelatuFirstValue];
        int type_status = 0;
        if ([self.curChipInfo.fcmtype intValue]==1) {//人民币码
            type_status = 0;
        }else if ([self.curChipInfo.fcmtype intValue]==6){//人民币
            type_status = 1;
        }else if ([self.curChipInfo.fcmtype intValue]==2){
            type_status = 2;
        }else if ([self.curChipInfo.fcmtype intValue]==7){
            type_status = 3;
        }
        if (self.refrashSigleValueBlock) {
            self.refrashSigleValueBlock(type_status, x, self.thridCellView.chipNumberLab.text,2);
        }
    }];
    
    self.thridCellView.editBtnBock = ^(NSInteger curTag) {
        @strongify(self);
        if (curTag==3) {
            self.thridCellView.chipNumberEditBtn.selected = !self.thridCellView.chipNumberEditBtn.selected;
            if (self.thridCellView.chipNumberEditBtn.selected) {
                self.thridCellView.chipNumberTF.enabled = YES;
                self.thridCellView.chipNumberTF.background = [UIImage imageNamed:@"totalBox_bg_icon"];
                self.thridCellView.chipNumberTF.placeholder = @"请输入数量";
                
                self.firstCellView.chipNumberTF.enabled = NO;
                self.firstCellView.chipNumberTF.background = nil;
                self.firstCellView.chipNumberTF.placeholder = @"";
                
                self.secondCellView.chipNumberTF.enabled = NO;
                self.secondCellView.chipNumberTF.background = nil;
                self.secondCellView.chipNumberTF.placeholder = @"";
                
                self.forthCellView.chipNumberTF.enabled = NO;
                self.forthCellView.chipNumberTF.background = nil;
                self.forthCellView.chipNumberTF.placeholder = @"";
                
                self.fiveCellView.chipNumberTF.enabled = NO;
                self.fiveCellView.chipNumberTF.background = nil;
                self.fiveCellView.chipNumberTF.placeholder = @"";
                
                self.sixCellView.chipNumberTF.enabled = NO;
                self.sixCellView.chipNumberTF.background = nil;
                self.sixCellView.chipNumberTF.placeholder = @"";
                
                self.sevenCellView.chipNumberTF.enabled = NO;
                self.sevenCellView.chipNumberTF.background = nil;
                self.sevenCellView.chipNumberTF.placeholder = @"";
                
                self.eightCellView.chipNumberTF.enabled = NO;
                self.eightCellView.chipNumberTF.background = nil;
                self.eightCellView.chipNumberTF.placeholder = @"";
                
                self.nineCellView.chipNumberTF.enabled = NO;
                self.nineCellView.chipNumberTF.background = nil;
                self.nineCellView.chipNumberTF.placeholder = @"";
                
                self.tenCellView.chipNumberTF.enabled = NO;
                self.tenCellView.chipNumberTF.background = nil;
                self.tenCellView.chipNumberTF.placeholder = @"";
                
                self.elevenCellView.chipNumberTF.enabled = NO;
                self.elevenCellView.chipNumberTF.background = nil;
                self.elevenCellView.chipNumberTF.placeholder = @"";
            }else{
                self.thridCellView.chipNumberTF.enabled = NO;
                self.thridCellView.chipNumberTF.background = nil;
                self.thridCellView.chipNumberTF.placeholder = @"";
            }
        }
    };
    
    [[self.forthCellView.chipNumberTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSInteger twoValue = [self.forthCellView.chipNumberLab.text integerValue];
        self.forthCellView.chipMoneyValueLab.text = [NSString stringWithFormat:@"%ld",[x integerValue]*twoValue];
        [self cacutelatuFirstValue];
        int type_status = 0;
        if ([self.curChipInfo.fcmtype intValue]==1) {//人民币码
            type_status = 0;
        }else if ([self.curChipInfo.fcmtype intValue]==6){//人民币
            type_status = 1;
        }else if ([self.curChipInfo.fcmtype intValue]==2){
            type_status = 2;
        }else if ([self.curChipInfo.fcmtype intValue]==7){
            type_status = 3;
        }
        if (self.refrashSigleValueBlock) {
            self.refrashSigleValueBlock(type_status, x, self.forthCellView.chipNumberLab.text,3);
        }
    }];
    
    self.forthCellView.editBtnBock = ^(NSInteger curTag) {
        @strongify(self);
        if (curTag==4) {
            self.forthCellView.chipNumberEditBtn.selected = !self.forthCellView.chipNumberEditBtn.selected;
            if (self.forthCellView.chipNumberEditBtn.selected) {
                self.forthCellView.chipNumberTF.enabled = YES;
                self.forthCellView.chipNumberTF.background = [UIImage imageNamed:@"totalBox_bg_icon"];
                self.forthCellView.chipNumberTF.placeholder = @"请输入数量";
                
                self.firstCellView.chipNumberTF.enabled = NO;
                self.firstCellView.chipNumberTF.background = nil;
                self.firstCellView.chipNumberTF.placeholder = @"";
                
                self.secondCellView.chipNumberTF.enabled = NO;
                self.secondCellView.chipNumberTF.background = nil;
                self.secondCellView.chipNumberTF.placeholder = @"";
                
                self.thridCellView.chipNumberTF.enabled = NO;
                self.thridCellView.chipNumberTF.background = nil;
                self.thridCellView.chipNumberTF.placeholder = @"";
                
                self.fiveCellView.chipNumberTF.enabled = NO;
                self.fiveCellView.chipNumberTF.background = nil;
                self.fiveCellView.chipNumberTF.placeholder = @"";
                
                self.sixCellView.chipNumberTF.enabled = NO;
                self.sixCellView.chipNumberTF.background = nil;
                self.sixCellView.chipNumberTF.placeholder = @"";
                
                self.sevenCellView.chipNumberTF.enabled = NO;
                self.sevenCellView.chipNumberTF.background = nil;
                self.sevenCellView.chipNumberTF.placeholder = @"";
                
                self.eightCellView.chipNumberTF.enabled = NO;
                self.eightCellView.chipNumberTF.background = nil;
                self.eightCellView.chipNumberTF.placeholder = @"";
                
                self.nineCellView.chipNumberTF.enabled = NO;
                self.nineCellView.chipNumberTF.background = nil;
                self.nineCellView.chipNumberTF.placeholder = @"";
                
                self.tenCellView.chipNumberTF.enabled = NO;
                self.tenCellView.chipNumberTF.background = nil;
                self.tenCellView.chipNumberTF.placeholder = @"";
                
                self.elevenCellView.chipNumberTF.enabled = NO;
                self.elevenCellView.chipNumberTF.background = nil;
                self.elevenCellView.chipNumberTF.placeholder = @"";
            }else{
                self.forthCellView.chipNumberTF.enabled = NO;
                self.forthCellView.chipNumberTF.background = nil;
                self.forthCellView.chipNumberTF.placeholder = @"";
            }
        }
    };
    
    [[self.fiveCellView.chipNumberTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSInteger twoValue = [self.fiveCellView.chipNumberLab.text integerValue];
        self.fiveCellView.chipMoneyValueLab.text = [NSString stringWithFormat:@"%ld",[x integerValue]*twoValue];
        [self cacutelatuFirstValue];
        int type_status = 0;
        if ([self.curChipInfo.fcmtype intValue]==1) {//人民币码
            type_status = 0;
        }else if ([self.curChipInfo.fcmtype intValue]==6){//人民币
            type_status = 1;
        }else if ([self.curChipInfo.fcmtype intValue]==2){
            type_status = 2;
        }else if ([self.curChipInfo.fcmtype intValue]==7){
            type_status = 3;
        }
        if (self.refrashSigleValueBlock) {
            self.refrashSigleValueBlock(type_status, x, self.fiveCellView.chipNumberLab.text,4);
        }
    }];
    
    self.fiveCellView.editBtnBock = ^(NSInteger curTag) {
        @strongify(self);
        if (curTag==5) {
            self.fiveCellView.chipNumberEditBtn.selected = !self.fiveCellView.chipNumberEditBtn.selected;
            if (self.fiveCellView.chipNumberEditBtn.selected) {
                self.fiveCellView.chipNumberTF.enabled = YES;
                self.fiveCellView.chipNumberTF.background = [UIImage imageNamed:@"totalBox_bg_icon"];
                self.fiveCellView.chipNumberTF.placeholder = @"请输入数量";
                
                self.firstCellView.chipNumberTF.enabled = NO;
                self.firstCellView.chipNumberTF.background = nil;
                self.firstCellView.chipNumberTF.placeholder = @"";
                
                self.secondCellView.chipNumberTF.enabled = NO;
                self.secondCellView.chipNumberTF.background = nil;
                self.secondCellView.chipNumberTF.placeholder = @"";
                
                self.thridCellView.chipNumberTF.enabled = NO;
                self.thridCellView.chipNumberTF.background = nil;
                self.thridCellView.chipNumberTF.placeholder = @"";
                
                self.forthCellView.chipNumberTF.enabled = NO;
                self.forthCellView.chipNumberTF.background = nil;
                self.forthCellView.chipNumberTF.placeholder = @"";
                
                self.sixCellView.chipNumberTF.enabled = NO;
                self.sixCellView.chipNumberTF.background = nil;
                self.sixCellView.chipNumberTF.placeholder = @"";
                
                self.sevenCellView.chipNumberTF.enabled = NO;
                self.sevenCellView.chipNumberTF.background = nil;
                self.sevenCellView.chipNumberTF.placeholder = @"";
                
                self.eightCellView.chipNumberTF.enabled = NO;
                self.eightCellView.chipNumberTF.background = nil;
                self.eightCellView.chipNumberTF.placeholder = @"";
                
                self.nineCellView.chipNumberTF.enabled = NO;
                self.nineCellView.chipNumberTF.background = nil;
                self.nineCellView.chipNumberTF.placeholder = @"";
                
                self.tenCellView.chipNumberTF.enabled = NO;
                self.tenCellView.chipNumberTF.background = nil;
                self.tenCellView.chipNumberTF.placeholder = @"";
                
                self.elevenCellView.chipNumberTF.enabled = NO;
                self.elevenCellView.chipNumberTF.background = nil;
                self.elevenCellView.chipNumberTF.placeholder = @"";
            }else{
                self.fiveCellView.chipNumberTF.enabled = NO;
                self.fiveCellView.chipNumberTF.background = nil;
                self.fiveCellView.chipNumberTF.placeholder = @"";
            }
        }
    };
    
    [[self.sixCellView.chipNumberTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSInteger twoValue = [self.sixCellView.chipNumberLab.text integerValue];
        self.sixCellView.chipMoneyValueLab.text = [NSString stringWithFormat:@"%ld",[x integerValue]*twoValue];
        [self cacutelatuFirstValue];
        int type_status = 0;
        if ([self.curChipInfo.fcmtype intValue]==1) {//人民币码
            type_status = 0;
        }else if ([self.curChipInfo.fcmtype intValue]==6){//人民币
            type_status = 1;
        }else if ([self.curChipInfo.fcmtype intValue]==2){
            type_status = 2;
        }else if ([self.curChipInfo.fcmtype intValue]==7){
            type_status = 3;
        }
        if (self.refrashSigleValueBlock) {
            self.refrashSigleValueBlock(type_status, x, self.sixCellView.chipNumberLab.text,5);
        }
    }];
    
    self.sixCellView.editBtnBock = ^(NSInteger curTag) {
        @strongify(self);
        if (curTag==6) {
            self.sixCellView.chipNumberEditBtn.selected = !self.sixCellView.chipNumberEditBtn.selected;
            if (self.sixCellView.chipNumberEditBtn.selected) {
                self.sixCellView.chipNumberTF.enabled = YES;
                self.sixCellView.chipNumberTF.background = [UIImage imageNamed:@"totalBox_bg_icon"];
                self.sixCellView.chipNumberTF.placeholder = @"请输入数量";
                
                self.firstCellView.chipNumberTF.enabled = NO;
                self.firstCellView.chipNumberTF.background = nil;
                self.firstCellView.chipNumberTF.placeholder = @"";
                
                self.secondCellView.chipNumberTF.enabled = NO;
                self.secondCellView.chipNumberTF.background = nil;
                self.secondCellView.chipNumberTF.placeholder = @"";
                
                self.thridCellView.chipNumberTF.enabled = NO;
                self.thridCellView.chipNumberTF.background = nil;
                self.thridCellView.chipNumberTF.placeholder = @"";
                
                self.forthCellView.chipNumberTF.enabled = NO;
                self.forthCellView.chipNumberTF.background = nil;
                self.forthCellView.chipNumberTF.placeholder = @"";
                
                self.fiveCellView.chipNumberTF.enabled = NO;
                self.fiveCellView.chipNumberTF.background = nil;
                self.fiveCellView.chipNumberTF.placeholder = @"";
                
                self.sevenCellView.chipNumberTF.enabled = NO;
                self.sevenCellView.chipNumberTF.background = nil;
                self.sevenCellView.chipNumberTF.placeholder = @"";
                
                self.eightCellView.chipNumberTF.enabled = NO;
                self.eightCellView.chipNumberTF.background = nil;
                self.eightCellView.chipNumberTF.placeholder = @"";
                
                self.nineCellView.chipNumberTF.enabled = NO;
                self.nineCellView.chipNumberTF.background = nil;
                self.nineCellView.chipNumberTF.placeholder = @"";
                
                self.tenCellView.chipNumberTF.enabled = NO;
                self.tenCellView.chipNumberTF.background = nil;
                self.tenCellView.chipNumberTF.placeholder = @"";
                
                self.elevenCellView.chipNumberTF.enabled = NO;
                self.elevenCellView.chipNumberTF.background = nil;
                self.elevenCellView.chipNumberTF.placeholder = @"";
            }else{
                self.sixCellView.chipNumberTF.enabled = NO;
                self.sixCellView.chipNumberTF.background = nil;
                self.sixCellView.chipNumberTF.placeholder = @"";
            }
        }
    };
    
    [[self.sevenCellView.chipNumberTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSInteger twoValue = [self.sevenCellView.chipNumberLab.text integerValue];
        self.sevenCellView.chipMoneyValueLab.text = [NSString stringWithFormat:@"%ld",[x integerValue]*twoValue];
        [self cacutelatuFirstValue];
        int type_status = 0;
        if ([self.curChipInfo.fcmtype intValue]==1) {//人民币码
            type_status = 0;
        }else if ([self.curChipInfo.fcmtype intValue]==6){//人民币
            type_status = 1;
        }else if ([self.curChipInfo.fcmtype intValue]==2){
            type_status = 2;
        }else if ([self.curChipInfo.fcmtype intValue]==7){
            type_status = 3;
        }
        if (self.refrashSigleValueBlock) {
            self.refrashSigleValueBlock(type_status, x, self.sevenCellView.chipNumberLab.text,6);
        }
    }];
    
    self.sevenCellView.editBtnBock = ^(NSInteger curTag) {
        @strongify(self);
        if (curTag==7) {
            self.sevenCellView.chipNumberEditBtn.selected = !self.sevenCellView.chipNumberEditBtn.selected;
            if (self.sevenCellView.chipNumberEditBtn.selected) {
                self.sevenCellView.chipNumberTF.enabled = YES;
                self.sevenCellView.chipNumberTF.background = [UIImage imageNamed:@"totalBox_bg_icon"];
                self.sevenCellView.chipNumberTF.placeholder = @"请输入数量";
                
                self.firstCellView.chipNumberTF.enabled = NO;
                self.firstCellView.chipNumberTF.background = nil;
                self.firstCellView.chipNumberTF.placeholder = @"";
                
                self.secondCellView.chipNumberTF.enabled = NO;
                self.secondCellView.chipNumberTF.background = nil;
                self.secondCellView.chipNumberTF.placeholder = @"";
                
                self.thridCellView.chipNumberTF.enabled = NO;
                self.thridCellView.chipNumberTF.background = nil;
                self.thridCellView.chipNumberTF.placeholder = @"";
                
                self.forthCellView.chipNumberTF.enabled = NO;
                self.forthCellView.chipNumberTF.background = nil;
                self.forthCellView.chipNumberTF.placeholder = @"";
                
                self.fiveCellView.chipNumberTF.enabled = NO;
                self.fiveCellView.chipNumberTF.background = nil;
                self.fiveCellView.chipNumberTF.placeholder = @"";
                
                self.sixCellView.chipNumberTF.enabled = NO;
                self.sixCellView.chipNumberTF.background = nil;
                self.sixCellView.chipNumberTF.placeholder = @"";
                
                self.eightCellView.chipNumberTF.enabled = NO;
                self.eightCellView.chipNumberTF.background = nil;
                self.eightCellView.chipNumberTF.placeholder = @"";
                
                self.nineCellView.chipNumberTF.enabled = NO;
                self.nineCellView.chipNumberTF.background = nil;
                self.nineCellView.chipNumberTF.placeholder = @"";
                
                self.tenCellView.chipNumberTF.enabled = NO;
                self.tenCellView.chipNumberTF.background = nil;
                self.tenCellView.chipNumberTF.placeholder = @"";
                
                self.elevenCellView.chipNumberTF.enabled = NO;
                self.elevenCellView.chipNumberTF.background = nil;
                self.elevenCellView.chipNumberTF.placeholder = @"";
            }else{
                self.sevenCellView.chipNumberTF.enabled = NO;
                self.sevenCellView.chipNumberTF.background = nil;
                self.sevenCellView.chipNumberTF.placeholder = @"";
            }
        }
    };
    
    [[self.eightCellView.chipNumberTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSInteger twoValue = [self.eightCellView.chipNumberLab.text integerValue];
        self.eightCellView.chipMoneyValueLab.text = [NSString stringWithFormat:@"%ld",[x integerValue]*twoValue];
        [self cacutelatuFirstValue];
        int type_status = 0;
        if ([self.curChipInfo.fcmtype intValue]==1) {//人民币码
            type_status = 0;
        }else if ([self.curChipInfo.fcmtype intValue]==6){//人民币
            type_status = 1;
        }else if ([self.curChipInfo.fcmtype intValue]==2){
            type_status = 2;
        }else if ([self.curChipInfo.fcmtype intValue]==7){
            type_status = 3;
        }
        if (self.refrashSigleValueBlock) {
            self.refrashSigleValueBlock(type_status, x, self.eightCellView.chipNumberLab.text,7);
        }
    }];
    
    self.eightCellView.editBtnBock = ^(NSInteger curTag) {
        @strongify(self);
        if (curTag==8) {
            self.eightCellView.chipNumberEditBtn.selected = !self.eightCellView.chipNumberEditBtn.selected;
            if (self.eightCellView.chipNumberEditBtn.selected) {
                self.eightCellView.chipNumberTF.enabled = YES;
                self.eightCellView.chipNumberTF.background = [UIImage imageNamed:@"totalBox_bg_icon"];
                self.eightCellView.chipNumberTF.placeholder = @"请输入数量";
                
                self.firstCellView.chipNumberTF.enabled = NO;
                self.firstCellView.chipNumberTF.background = nil;
                self.firstCellView.chipNumberTF.placeholder = @"";
                
                self.secondCellView.chipNumberTF.enabled = NO;
                self.secondCellView.chipNumberTF.background = nil;
                self.secondCellView.chipNumberTF.placeholder = @"";
                
                self.thridCellView.chipNumberTF.enabled = NO;
                self.thridCellView.chipNumberTF.background = nil;
                self.thridCellView.chipNumberTF.placeholder = @"";
                
                self.forthCellView.chipNumberTF.enabled = NO;
                self.forthCellView.chipNumberTF.background = nil;
                self.forthCellView.chipNumberTF.placeholder = @"";
                
                self.fiveCellView.chipNumberTF.enabled = NO;
                self.fiveCellView.chipNumberTF.background = nil;
                self.fiveCellView.chipNumberTF.placeholder = @"";
                
                self.sixCellView.chipNumberTF.enabled = NO;
                self.sixCellView.chipNumberTF.background = nil;
                self.sixCellView.chipNumberTF.placeholder = @"";
                
                self.sevenCellView.chipNumberTF.enabled = NO;
                self.sevenCellView.chipNumberTF.background = nil;
                self.sevenCellView.chipNumberTF.placeholder = @"";
                
                self.nineCellView.chipNumberTF.enabled = NO;
                self.nineCellView.chipNumberTF.background = nil;
                self.nineCellView.chipNumberTF.placeholder = @"";
                
                self.tenCellView.chipNumberTF.enabled = NO;
                self.tenCellView.chipNumberTF.background = nil;
                self.tenCellView.chipNumberTF.placeholder = @"";
                
                self.elevenCellView.chipNumberTF.enabled = NO;
                self.elevenCellView.chipNumberTF.background = nil;
                self.elevenCellView.chipNumberTF.placeholder = @"";
            }else{
                self.eightCellView.chipNumberTF.enabled = NO;
                self.eightCellView.chipNumberTF.background = nil;
                self.eightCellView.chipNumberTF.placeholder = @"";
            }
        }
    };
    
    [[self.nineCellView.chipNumberTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSInteger twoValue = [self.nineCellView.chipNumberLab.text integerValue];
        self.nineCellView.chipMoneyValueLab.text = [NSString stringWithFormat:@"%ld",[x integerValue]*twoValue];
        [self cacutelatuFirstValue];
        int type_status = 0;
        if ([self.curChipInfo.fcmtype intValue]==1) {//人民币码
            type_status = 0;
        }else if ([self.curChipInfo.fcmtype intValue]==6){//人民币
            type_status = 1;
        }else if ([self.curChipInfo.fcmtype intValue]==2){
            type_status = 2;
        }else if ([self.curChipInfo.fcmtype intValue]==7){
            type_status = 3;
        }
        if (self.refrashSigleValueBlock) {
            self.refrashSigleValueBlock(type_status, x, self.nineCellView.chipNumberLab.text,8);
        }
    }];
    
    self.nineCellView.editBtnBock = ^(NSInteger curTag) {
        @strongify(self);
        if (curTag==9) {
            self.nineCellView.chipNumberEditBtn.selected = !self.nineCellView.chipNumberEditBtn.selected;
            if (self.nineCellView.chipNumberEditBtn.selected) {
                self.nineCellView.chipNumberTF.enabled = YES;
                self.nineCellView.chipNumberTF.background = [UIImage imageNamed:@"totalBox_bg_icon"];
                self.nineCellView.chipNumberTF.placeholder = @"请输入数量";
                
                self.firstCellView.chipNumberTF.enabled = NO;
                self.firstCellView.chipNumberTF.background = nil;
                self.firstCellView.chipNumberTF.placeholder = @"";
                
                self.secondCellView.chipNumberTF.enabled = NO;
                self.secondCellView.chipNumberTF.background = nil;
                self.secondCellView.chipNumberTF.placeholder = @"";
                
                self.thridCellView.chipNumberTF.enabled = NO;
                self.thridCellView.chipNumberTF.background = nil;
                self.thridCellView.chipNumberTF.placeholder = @"";
                
                self.forthCellView.chipNumberTF.enabled = NO;
                self.forthCellView.chipNumberTF.background = nil;
                self.forthCellView.chipNumberTF.placeholder = @"";
                
                self.fiveCellView.chipNumberTF.enabled = NO;
                self.fiveCellView.chipNumberTF.background = nil;
                self.fiveCellView.chipNumberTF.placeholder = @"";
                
                self.sixCellView.chipNumberTF.enabled = NO;
                self.sixCellView.chipNumberTF.background = nil;
                self.sixCellView.chipNumberTF.placeholder = @"";
                
                self.sevenCellView.chipNumberTF.enabled = NO;
                self.sevenCellView.chipNumberTF.background = nil;
                self.sevenCellView.chipNumberTF.placeholder = @"";
                
                self.eightCellView.chipNumberTF.enabled = NO;
                self.eightCellView.chipNumberTF.background = nil;
                self.eightCellView.chipNumberTF.placeholder = @"";
                
                self.tenCellView.chipNumberTF.enabled = NO;
                self.tenCellView.chipNumberTF.background = nil;
                self.tenCellView.chipNumberTF.placeholder = @"";
                
                self.elevenCellView.chipNumberTF.enabled = NO;
                self.elevenCellView.chipNumberTF.background = nil;
                self.elevenCellView.chipNumberTF.placeholder = @"";
            }else{
                self.nineCellView.chipNumberTF.enabled = NO;
                self.nineCellView.chipNumberTF.background = nil;
                self.nineCellView.chipNumberTF.placeholder = @"";
            }
        }
    };
    
    [[self.tenCellView.chipNumberTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSInteger twoValue = [self.secondCellView.chipNumberLab.text integerValue];
        self.tenCellView.chipMoneyValueLab.text = [NSString stringWithFormat:@"%ld",[x integerValue]*twoValue];
        [self cacutelatuFirstValue];
        int type_status = 0;
        if ([self.curChipInfo.fcmtype intValue]==1) {//人民币码
            type_status = 0;
        }else if ([self.curChipInfo.fcmtype intValue]==6){//人民币
            type_status = 1;
        }else if ([self.curChipInfo.fcmtype intValue]==2){
            type_status = 2;
        }else if ([self.curChipInfo.fcmtype intValue]==7){
            type_status = 3;
        }
        if (self.refrashSigleValueBlock) {
            self.refrashSigleValueBlock(type_status, x, self.tenCellView.chipNumberLab.text,9);
        }
    }];
    
    self.tenCellView.editBtnBock = ^(NSInteger curTag) {
        @strongify(self);
        if (curTag==10) {
            self.tenCellView.chipNumberEditBtn.selected = !self.tenCellView.chipNumberEditBtn.selected;
            if (self.tenCellView.chipNumberEditBtn.selected) {
                self.tenCellView.chipNumberTF.enabled = YES;
                self.tenCellView.chipNumberTF.background = [UIImage imageNamed:@"totalBox_bg_icon"];
                self.tenCellView.chipNumberTF.placeholder = @"请输入数量";
                
                self.firstCellView.chipNumberTF.enabled = NO;
                self.firstCellView.chipNumberTF.background = nil;
                self.firstCellView.chipNumberTF.placeholder = @"";
                
                self.secondCellView.chipNumberTF.enabled = NO;
                self.secondCellView.chipNumberTF.background = nil;
                self.secondCellView.chipNumberTF.placeholder = @"";
                
                self.thridCellView.chipNumberTF.enabled = NO;
                self.thridCellView.chipNumberTF.background = nil;
                self.thridCellView.chipNumberTF.placeholder = @"";
                
                self.forthCellView.chipNumberTF.enabled = NO;
                self.forthCellView.chipNumberTF.background = nil;
                self.forthCellView.chipNumberTF.placeholder = @"";
                
                self.fiveCellView.chipNumberTF.enabled = NO;
                self.fiveCellView.chipNumberTF.background = nil;
                self.fiveCellView.chipNumberTF.placeholder = @"";
                
                self.sixCellView.chipNumberTF.enabled = NO;
                self.sixCellView.chipNumberTF.background = nil;
                self.sixCellView.chipNumberTF.placeholder = @"";
                
                self.sevenCellView.chipNumberTF.enabled = NO;
                self.sevenCellView.chipNumberTF.background = nil;
                self.sevenCellView.chipNumberTF.placeholder = @"";
                
                self.eightCellView.chipNumberTF.enabled = NO;
                self.eightCellView.chipNumberTF.background = nil;
                self.eightCellView.chipNumberTF.placeholder = @"";
                
                self.nineCellView.chipNumberTF.enabled = NO;
                self.nineCellView.chipNumberTF.background = nil;
                self.nineCellView.chipNumberTF.placeholder = @"";
                
                self.elevenCellView.chipNumberTF.enabled = NO;
                self.elevenCellView.chipNumberTF.background = nil;
                self.elevenCellView.chipNumberTF.placeholder = @"";
            }else{
                self.tenCellView.chipNumberTF.enabled = NO;
                self.tenCellView.chipNumberTF.background = nil;
                self.tenCellView.chipNumberTF.placeholder = @"";
            }
        }
    };
    
    [[self.elevenCellView.chipNumberTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSInteger twoValue = [self.elevenCellView.chipNumberLab.text integerValue];
        self.elevenCellView.chipMoneyValueLab.text = [NSString stringWithFormat:@"%ld",[x integerValue]*twoValue];
        [self cacutelatuFirstValue];
        int type_status = 0;
        if ([self.curChipInfo.fcmtype intValue]==1) {//人民币码
            type_status = 0;
        }else if ([self.curChipInfo.fcmtype intValue]==6){//人民币
            type_status = 1;
        }else if ([self.curChipInfo.fcmtype intValue]==2){
            type_status = 2;
        }else if ([self.curChipInfo.fcmtype intValue]==7){
            type_status = 3;
        }
        if (self.refrashSigleValueBlock) {
            self.refrashSigleValueBlock(type_status, x, self.elevenCellView.chipNumberLab.text,10);
        }
    }];
    
    self.elevenCellView.editBtnBock = ^(NSInteger curTag) {
        @strongify(self);
        if (curTag==11) {
            self.elevenCellView.chipNumberEditBtn.selected = !self.elevenCellView.chipNumberEditBtn.selected;
            if (self.elevenCellView.chipNumberEditBtn.selected) {
                self.elevenCellView.chipNumberTF.enabled = YES;
                self.elevenCellView.chipNumberTF.background = [UIImage imageNamed:@"totalBox_bg_icon"];
                self.elevenCellView.chipNumberTF.placeholder = @"请输入数量";
                
                self.firstCellView.chipNumberTF.enabled = NO;
                self.firstCellView.chipNumberTF.background = nil;
                self.firstCellView.chipNumberTF.placeholder = @"";
                
                self.secondCellView.chipNumberTF.enabled = NO;
                self.secondCellView.chipNumberTF.background = nil;
                self.secondCellView.chipNumberTF.placeholder = @"";
                
                self.thridCellView.chipNumberTF.enabled = NO;
                self.thridCellView.chipNumberTF.background = nil;
                self.thridCellView.chipNumberTF.placeholder = @"";
                
                self.forthCellView.chipNumberTF.enabled = NO;
                self.forthCellView.chipNumberTF.background = nil;
                self.forthCellView.chipNumberTF.placeholder = @"";
                
                self.fiveCellView.chipNumberTF.enabled = NO;
                self.fiveCellView.chipNumberTF.background = nil;
                self.fiveCellView.chipNumberTF.placeholder = @"";
                
                self.sixCellView.chipNumberTF.enabled = NO;
                self.sixCellView.chipNumberTF.background = nil;
                self.sixCellView.chipNumberTF.placeholder = @"";
                
                self.sevenCellView.chipNumberTF.enabled = NO;
                self.sevenCellView.chipNumberTF.background = nil;
                self.sevenCellView.chipNumberTF.placeholder = @"";
                
                self.eightCellView.chipNumberTF.enabled = NO;
                self.eightCellView.chipNumberTF.background = nil;
                self.eightCellView.chipNumberTF.placeholder = @"";
                
                self.nineCellView.chipNumberTF.enabled = NO;
                self.nineCellView.chipNumberTF.background = nil;
                self.nineCellView.chipNumberTF.placeholder = @"";
                
                self.tenCellView.chipNumberTF.enabled = NO;
                self.tenCellView.chipNumberTF.background = nil;
                self.tenCellView.chipNumberTF.placeholder = @"";
            }else{
                self.elevenCellView.chipNumberTF.enabled = NO;
                self.elevenCellView.chipNumberTF.background = nil;
                self.elevenCellView.chipNumberTF.placeholder = @"";
            }
        }
    };
    return self;
}

- (void)cacutelatuFirstValue{
    NSInteger totalNumberValue = [self.firstCellView.chipNumberTF.text integerValue]+[self.secondCellView.chipNumberTF.text integerValue]+[self.thridCellView.chipNumberTF.text integerValue]+[self.forthCellView.chipNumberTF.text integerValue]+[self.fiveCellView.chipNumberTF.text integerValue]+[self.sixCellView.chipNumberTF.text integerValue]+[self.sevenCellView.chipNumberTF.text integerValue]+[self.eightCellView.chipNumberTF.text integerValue]+[self.nineCellView.chipNumberTF.text integerValue]+[self.tenCellView.chipNumberTF.text integerValue]+[self.elevenCellView.chipNumberTF.text integerValue];
    self.totalNumberLab.text = [NSString stringWithFormat:@"总数量:%ld",totalNumberValue];

    NSInteger totalMoneyValue = [self.firstCellView.chipMoneyValueLab.text integerValue]+[self.secondCellView.chipMoneyValueLab.text integerValue]+[self.thridCellView.chipMoneyValueLab.text integerValue]+[self.forthCellView.chipMoneyValueLab.text integerValue]+[self.fiveCellView.chipMoneyValueLab.text integerValue]+[self.sixCellView.chipMoneyValueLab.text integerValue]+[self.sevenCellView.chipMoneyValueLab.text integerValue]+[self.eightCellView.chipMoneyValueLab.text integerValue]+[self.nineCellView.chipMoneyValueLab.text integerValue]+[self.tenCellView.chipMoneyValueLab.text integerValue]+[self.elevenCellView.chipMoneyValueLab.text integerValue];
    self.totalMoneyLab.text = [NSString stringWithFormat:@"总金额:%ld",totalMoneyValue];
    int type_status = 0;
    if ([self.curChipInfo.fcmtype intValue]==1) {//人民币码
        type_status = 0;
    }else if ([self.curChipInfo.fcmtype intValue]==6){//人民币
        type_status = 1;
    }else if ([self.curChipInfo.fcmtype intValue]==2){
        type_status = 2;
    }else if ([self.curChipInfo.fcmtype intValue]==7){
        type_status = 3;
    }
    if (self.refrashBottomMoneyBlock) {
        self.refrashBottomMoneyBlock(type_status, [NSString stringWithFormat:@"%ld",totalMoneyValue]);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)openOrClose:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        if (_openOrCloseBock) {
            _openOrCloseBock(YES,_cellIndex);
        }
    }else{
        if (_openOrCloseBock) {
            _openOrCloseBock(NO,_cellIndex);
        }
    }
    
}

- (void)fellCellWithOpen:(BOOL)isOpen Type:(int)type WithNRChipAllInfo:(NRChipAllInfo*)chipInfo{
    self.curChipInfo = chipInfo;
    [self.openOrCloseArow setSelected:isOpen];
    if (isOpen) {
        self.openOrCloseLab.text  =@"收起/Retract";
        self.desView.hidden = NO;
        self.midView.hidden = NO;
        NSArray *fmeList = self.curChipInfo.list;
        NSInteger count = fmeList.count;
        if (count>11) {
            count = 11;
        }
        if (count>10) {
            self.elevenCellView.hidden = NO;
        }else{
            self.elevenCellView.hidden = YES;
        }
        if (count>9) {
            self.tenCellView.hidden = NO;
        }else{
            self.tenCellView.hidden = YES;
        }
        if (count>8) {
            self.nineCellView.hidden = NO;
        }else{
            self.nineCellView.hidden = YES;
        }
        if (count>7) {
            self.eightCellView.hidden = NO;
        }else{
            self.eightCellView.hidden = YES;
        }
        if (count>6) {
            self.sevenCellView.hidden = NO;
        }else{
            self.sevenCellView.hidden = YES;
        }
        if (count>5) {
            self.sixCellView.hidden = NO;
        }else{
            self.sixCellView.hidden = YES;
        }
        if (count>4) {
            self.fiveCellView.hidden = NO;
        }else{
            self.fiveCellView.hidden = YES;
        }
        if (count>3) {
            self.forthCellView.hidden = NO;
        }else{
            self.forthCellView.hidden = YES;
        }
        if (count>2) {
            self.thridCellView.hidden = NO;
        }else{
            self.thridCellView.hidden = YES;
        }
        if (count>1) {
            self.secondCellView.hidden = NO;
        }else{
            self.secondCellView.hidden = YES;
        }
        if (count>0) {
            self.firstCellView.hidden = NO;
        }else{
            self.firstCellView.hidden = YES;
        }
        self.midView.height = (30 +count*40);
        self.bottomView.y = (30 +count*40)+38;
        fmeList = [self paixuWith:(NSMutableArray *)fmeList];
        for (int i=0; i<count; i++) {
            NRChipInfo *chiInfo = fmeList[i];
            if (i==0) {
                self.firstCellView.chipNumberLab.text = chiInfo.fme;
            }else if (i==1){
                self.secondCellView.chipNumberLab.text = chiInfo.fme;
            }else if (i==2){
                self.thridCellView.chipNumberLab.text = chiInfo.fme;
            }else if (i==3){
                self.forthCellView.chipNumberLab.text = chiInfo.fme;
            }else if (i==4){
                self.fiveCellView.chipNumberLab.text = chiInfo.fme;
            }else if (i==5){
                self.sixCellView.chipNumberLab.text = chiInfo.fme;
            }else if (i==6){
                self.sevenCellView.chipNumberLab.text = chiInfo.fme;
            }else if (i==7){
                self.eightCellView.chipNumberLab.text = chiInfo.fme;
            }else if (i==8){
                self.nineCellView.chipNumberLab.text = chiInfo.fme;
            }else if (i==9){
                self.tenCellView.chipNumberLab.text = chiInfo.fme;
            }else if (i==10){
                self.elevenCellView.chipNumberLab.text = chiInfo.fme;
            }
        }
    }else{
        self.openOrCloseLab.text  =@"展开/Open";
        self.midView.hidden = YES;
        self.desView.hidden = YES;
        self.firstCellView.hidden = YES;
        self.secondCellView.hidden = YES;
        self.thridCellView.hidden = YES;
        self.forthCellView.hidden = YES;
        self.fiveCellView.hidden = YES;
        self.sixCellView.hidden = YES;
        self.sevenCellView.hidden = YES;
        self.eightCellView.hidden = YES;
        self.nineCellView.hidden = YES;
        self.tenCellView.hidden = YES;
        self.elevenCellView.hidden = YES;
        self.bottomView.y = 38;
    }
    if (type==1) {
        self.headView.backgroundColor = [UIColor redColor];
    }else if (type==2){
        self.headView.backgroundColor = [UIColor colorWithHexString:@"#469b52"];
    }else if (type==3){
        self.headView.backgroundColor = [UIColor redColor];
    }
    self.chipTypeLab.text = self.curChipInfo.fcmtype_name;
    if ([self.curChipInfo.fcmtype intValue]==1) {//人民币码
        [self.chipTypeBtn setImage:[UIImage imageNamed:@"RMB_ChipIcon"] forState:UIControlStateNormal];
        [self.chipTypeBtn setImage:[UIImage imageNamed:@"RMB_ChipIcon"] forState:UIControlStateHighlighted];
        [self.chipTypeBtn setTitle:@"RMB" forState:UIControlStateNormal];
    }else if ([self.curChipInfo.fcmtype intValue]==6){
        [self.chipTypeBtn setImage:[UIImage imageNamed:@"RMB_CashIcon"] forState:UIControlStateNormal];
        [self.chipTypeBtn setImage:[UIImage imageNamed:@"RMB_CashIcon"] forState:UIControlStateHighlighted];
        [self.chipTypeBtn setTitle:@"RMB" forState:UIControlStateNormal];
    }else if ([self.curChipInfo.fcmtype intValue]==2){
        [self.chipTypeBtn setImage:[UIImage imageNamed:@"USD_ChipIcon"] forState:UIControlStateNormal];
        [self.chipTypeBtn setImage:[UIImage imageNamed:@"USD_ChipIcon"] forState:UIControlStateHighlighted];
        [self.chipTypeBtn setTitle:@"USD" forState:UIControlStateNormal];
    }else if ([self.curChipInfo.fcmtype intValue]==7){
        [self.chipTypeBtn setImage:[UIImage imageNamed:@"USD_CashIcon"] forState:UIControlStateNormal];
        [self.chipTypeBtn setImage:[UIImage imageNamed:@"USD_CashIcon"] forState:UIControlStateHighlighted];
        [self.chipTypeBtn setTitle:@"USD" forState:UIControlStateNormal];
    }
}

- (NSArray *)paixuWith:(NSMutableArray *)array{
    [array sortUsingComparator:^NSComparisonResult(NRChipInfo *account1, NRChipInfo *account2) {
        if ([account1.fme intValue]>[account2.fme intValue]) {
            return NSOrderedAscending;//升序
        }else if ([account1.fme intValue]<[account2.fme intValue]){
            return NSOrderedDescending;//升序
        }else{
            return NSOrderedSame;//升序
        }
    }];
    return array;
}

+ (CGFloat)cellHeightWithOpen:(BOOL)isOpen WithNRChipAllInfo:(NRChipAllInfo*)chipInfo{
    NSArray *fmeList = chipInfo.list;
    NSInteger count = fmeList.count;
    if (count>11) {
        count = 11;
    }
    if (isOpen) {
        return 98 + count*40;
    }else{
        return 68;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
