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

@interface JiaJIanCaiCell ()

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *midView;
@property (nonatomic, strong) UIView *bottomView;

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
    
    self.desView = [[[NSBundle mainBundle]loadNibNamed:@"DenominationView" owner:nil options:nil]lastObject];
    
    self.midView = [[UIView alloc]initWithFrame:CGRectMake(0, 38, 530, 347)];
    self.midView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.midView];
    [self.midView addSubview:self.desView];
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 385, 530, 30)];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"#cecece"];
    [self addSubview:self.bottomView];
    
    self.totalNumberLab = [UILabel new];
    self.totalNumberLab.text  =@"总数量/Total quantity:0";
    self.totalNumberLab.textAlignment = NSTextAlignmentRight;
    self.totalNumberLab.textColor = [UIColor colorWithRed:71/255.0 green:71/255.0 blue:71/255.0 alpha:1];
    self.totalNumberLab.font = [UIFont systemFontOfSize:16];
    [self.bottomView addSubview:self.totalNumberLab];
    [self.totalNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bottomView).offset(0);
        make.left.equalTo(self.bottomView).offset(20);
    }];
    
    self.totalMoneyLab = [UILabel new];
    self.totalMoneyLab.text  =@"总金额/Total amount:0";
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
    [[self.desView.oneValueTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSInteger oneValue = [self.desView.oneValueLab.text integerValue];
        self.desView.oneValueTotalLab.text = [NSString stringWithFormat:@"%ld",[x integerValue]*oneValue];
        [self cacutelatuFirstValue];
        if (self.refrashSigleValueBlock) {
            self.refrashSigleValueBlock((int)self.cellIndex, x, self.desView.oneValueLab.text,0);
        }
    }];
    
    [[self.desView.twoValueTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSInteger twoValue = [self.desView.twoValueLab.text integerValue];
        self.desView.twoValueTotalLab.text = [NSString stringWithFormat:@"%ld",[x integerValue]*twoValue];
        [self cacutelatuFirstValue];
        if (self.refrashSigleValueBlock) {
            self.refrashSigleValueBlock((int)self.cellIndex, x, self.desView.twoValueLab.text,1);
        }
    }];
    
    [[self.desView.threeValueTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSInteger twoValue = [self.desView.threeValueLab.text integerValue];
        self.desView.threeValueTotalLab.text = [NSString stringWithFormat:@"%ld",[x integerValue]*twoValue];
        [self cacutelatuFirstValue];
        if (self.refrashSigleValueBlock) {
            self.refrashSigleValueBlock((int)self.cellIndex, x, self.desView.threeValueLab.text,2);
        }
    }];
    
    [[self.desView.thridValueTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSInteger twoValue = [self.desView.thridValueLab.text integerValue];
        self.desView.thridValueTotalLab.text = [NSString stringWithFormat:@"%ld",[x integerValue]*twoValue];
        [self cacutelatuFirstValue];
        if (self.refrashSigleValueBlock) {
            self.refrashSigleValueBlock((int)self.cellIndex, x, self.desView.thridValueLab.text,3);
        }
    }];
    
    [[self.desView.fiveValueTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSInteger twoValue = [self.desView.fiveValueLab.text integerValue];
        self.desView.fiveValueTotalLav.text = [NSString stringWithFormat:@"%ld",[x integerValue]*twoValue];
        [self cacutelatuFirstValue];
        if (self.refrashSigleValueBlock) {
            self.refrashSigleValueBlock((int)self.cellIndex, x, self.desView.fiveValueLab.text,4);
        }
    }];
    
    [[self.desView.sixValueTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSInteger twoValue = [self.desView.sixValueLab.text integerValue];
        self.desView.sixValueTotalLab.text = [NSString stringWithFormat:@"%ld",[x integerValue]*twoValue];
        [self cacutelatuFirstValue];
        if (self.refrashSigleValueBlock) {
            self.refrashSigleValueBlock((int)self.cellIndex, x, self.desView.sixValueLab.text,5);
        }
    }];
    
    [[self.desView.sevenValueTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSInteger twoValue = [self.desView.sevenValuelab.text integerValue];
        self.desView.sevenValueTotalLab.text = [NSString stringWithFormat:@"%ld",[x integerValue]*twoValue];
        [self cacutelatuFirstValue];
        if (self.refrashSigleValueBlock) {
            self.refrashSigleValueBlock((int)self.cellIndex, x, self.desView.sevenValuelab.text,6);
        }
    }];
    
    [[self.desView.eightValueTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSInteger twoValue = [self.desView.eightValueLab.text integerValue];
        self.desView.eightValueTotalLab.text = [NSString stringWithFormat:@"%ld",[x integerValue]*twoValue];
        [self cacutelatuFirstValue];
        if (self.refrashSigleValueBlock) {
            self.refrashSigleValueBlock((int)self.cellIndex, x, self.desView.eightValueLab.text,7);
        }
    }];
    
    [[self.desView.nineValueTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSInteger twoValue = [self.desView.nineValueLab.text integerValue];
        self.desView.nineValueTotalLab.text = [NSString stringWithFormat:@"%ld",[x integerValue]*twoValue];
        [self cacutelatuFirstValue];
        if (self.refrashSigleValueBlock) {
            self.refrashSigleValueBlock((int)self.cellIndex, x, self.desView.nineValueLab.text,8);
        }
    }];
    
    [[self.desView.tenValueTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSInteger twoValue = [self.desView.tenValueLab.text integerValue];
        self.desView.tenValueTotalLab.text = [NSString stringWithFormat:@"%ld",[x integerValue]*twoValue];
        [self cacutelatuFirstValue];
        if (self.refrashSigleValueBlock) {
            self.refrashSigleValueBlock((int)self.cellIndex, x, self.desView.tenValueLab.text,9);
        }
    }];
    
    [[self.desView.evlevenValueTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSInteger twoValue = [self.desView.evlevenValueLab.text integerValue];
        self.desView.evlevenValueTotalLab.text = [NSString stringWithFormat:@"%ld",[x integerValue]*twoValue];
        [self cacutelatuFirstValue];
        if (self.refrashSigleValueBlock) {
            self.refrashSigleValueBlock((int)self.cellIndex, x, self.desView.evlevenValueLab.text,10);
        }
    }];
    
    return self;
}

- (void)cacutelatuFirstValue{
    NSInteger totalNumberValue = [self.desView.oneValueTF.text integerValue]+[self.desView.twoValueTF.text integerValue]+[self.desView.threeValueTF.text integerValue]+[self.desView.thridValueTF.text integerValue]+[self.desView.fiveValueTF.text integerValue]+[self.desView.sixValueTF.text integerValue]+[self.desView.sevenValueTF.text integerValue]+[self.desView.eightValueTF.text integerValue]+[self.desView.nineValueTF.text integerValue]+[self.desView.tenValueTF.text integerValue]+[self.desView.evlevenValueTF.text integerValue];
    self.totalNumberLab.text = [NSString stringWithFormat:@"总数量/Total quantity:%ld",totalNumberValue];
    
    NSInteger totalMoneyValue = [self.desView.oneValueTotalLab.text integerValue]+[self.desView.twoValueTotalLab.text integerValue]+[self.desView.threeValueTotalLab.text integerValue]+[self.desView.thridValueTotalLab.text integerValue]+[self.desView.fiveValueTotalLav.text integerValue]+[self.desView.sixValueTotalLab.text integerValue]+[self.desView.sevenValueTotalLab.text integerValue]+[self.desView.eightValueTotalLab.text integerValue]+[self.desView.nineValueTotalLab.text integerValue]+[self.desView.tenValueTotalLab.text integerValue]+[self.desView.evlevenValueTotalLab.text integerValue];
    self.totalMoneyLab.text = [NSString stringWithFormat:@"总金额/Total amount:%ld",totalMoneyValue];
    
    if (self.refrashBottomMoneyBlock) {
        self.refrashBottomMoneyBlock((int)self.cellIndex, [NSString stringWithFormat:@"%ld",totalMoneyValue]);
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

- (void)fellCellWithOpen:(BOOL)isOpen Type:(int)type{
    [self.openOrCloseArow setSelected:isOpen];
    if (isOpen) {
        self.openOrCloseLab.text  =@"收起/Retract";
        self.midView.hidden = NO;
        self.bottomView.y = 385;
    }else{
        self.openOrCloseLab.text  =@"展开/Open";
        self.midView.hidden = YES;
        self.bottomView.y = 38;
    }
    if (type==1) {
        self.headView.backgroundColor = [UIColor redColor];
    }else if (type==2){
        self.headView.backgroundColor = [UIColor colorWithHexString:@"#469b52"];
    }else if (type==3){
        self.headView.backgroundColor = [UIColor redColor];
    }
    
    if (self.cellIndex==0) {
        self.chipTypeLab.text = @"人民币筹码/RMB Chip";
        [self.chipTypeBtn setImage:[UIImage imageNamed:@"RMB_ChipIcon"] forState:UIControlStateNormal];
        [self.chipTypeBtn setImage:[UIImage imageNamed:@"RMB_ChipIcon"] forState:UIControlStateHighlighted];
        [self.chipTypeBtn setTitle:@"RMB" forState:UIControlStateNormal];
    }else if (self.cellIndex==1){
        self.chipTypeLab.text = @"人民币现金/RMB Cash";
        [self.chipTypeBtn setImage:[UIImage imageNamed:@"RMB_CashIcon"] forState:UIControlStateNormal];
        [self.chipTypeBtn setImage:[UIImage imageNamed:@"RMB_CashIcon"] forState:UIControlStateHighlighted];
        [self.chipTypeBtn setTitle:@"RMB" forState:UIControlStateNormal];
    }else if (self.cellIndex==2){
        self.chipTypeLab.text = @"美金筹码/USD Chip";
        [self.chipTypeBtn setImage:[UIImage imageNamed:@"USD_ChipIcon"] forState:UIControlStateNormal];
        [self.chipTypeBtn setImage:[UIImage imageNamed:@"USD_ChipIcon"] forState:UIControlStateHighlighted];
        [self.chipTypeBtn setTitle:@"USD" forState:UIControlStateNormal];
    }else if (self.cellIndex==3){
        self.chipTypeLab.text = @"美金现金/USD Cash";
        [self.chipTypeBtn setImage:[UIImage imageNamed:@"USD_CashIcon"] forState:UIControlStateNormal];
        [self.chipTypeBtn setImage:[UIImage imageNamed:@"USD_CashIcon"] forState:UIControlStateHighlighted];
        [self.chipTypeBtn setTitle:@"USD" forState:UIControlStateNormal];
    }
}

+ (CGFloat)cellHeightWithOpen:(BOOL)isOpen{
    if (isOpen) {
        return 415.0;
    }else{
        return 68;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
