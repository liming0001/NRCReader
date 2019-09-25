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
    [self.openOrCloseArow setImage:[UIImage imageNamed:@"展开ico"] forState:UIControlStateNormal];
    [self.openOrCloseArow setImage:[UIImage imageNamed:@"收起ico"] forState:UIControlStateSelected];
    self.openOrCloseArow.frame = CGRectMake(530-40, 6, 30, 30);
    [self.openOrCloseArow addTarget:self action:@selector(openOrClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:self.openOrCloseArow];
    
    self.openOrCloseLab = [[UILabel alloc]initWithFrame:CGRectMake(530-40-200-5, 4, 200, 30)];
    self.openOrCloseLab.text  =@"收起/Retract";
    self.openOrCloseLab.textAlignment = NSTextAlignmentRight;
    self.openOrCloseLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.openOrCloseLab.font = [UIFont systemFontOfSize:16];
    [self.headView addSubview:self.openOrCloseLab];
    
    DenominationView *desView = [[[NSBundle mainBundle]loadNibNamed:@"DenominationView" owner:nil options:nil]lastObject];
    
    self.midView = [[UIView alloc]initWithFrame:CGRectMake(0, 38, 530, 347)];
    self.midView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.midView];
    [self.midView addSubview:desView];
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 385, 530, 30)];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"#cecece"];
    [self addSubview:self.bottomView];
    
    self.totalNumberLab = [UILabel new];
    self.totalNumberLab.text  =@"总数量/Total quantity:1000";
    self.totalNumberLab.textAlignment = NSTextAlignmentRight;
    self.totalNumberLab.textColor = [UIColor colorWithRed:71/255.0 green:71/255.0 blue:71/255.0 alpha:1];
    self.totalNumberLab.font = [UIFont systemFontOfSize:16];
    [self.bottomView addSubview:self.totalNumberLab];
    [self.totalNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bottomView).offset(0);
        make.left.equalTo(self.bottomView).offset(20);
    }];
    
    self.totalMoneyLab = [UILabel new];
    self.totalMoneyLab.text  =@"总数量/Total quantity:1000";
    self.totalMoneyLab.textAlignment = NSTextAlignmentRight;
    self.totalMoneyLab.textColor = [UIColor colorWithRed:71/255.0 green:71/255.0 blue:71/255.0 alpha:1];
    self.totalMoneyLab.font = [UIFont systemFontOfSize:16];
    [self.bottomView addSubview:self.totalMoneyLab];
    [self.totalMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bottomView).offset(0);
        make.left.equalTo(self.totalNumberLab.mas_right).offset(40);
    }];
    
    self.chipTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chipTypeBtn setImage:[UIImage imageNamed:@"加减彩-人民币筹码ICON"] forState:UIControlStateNormal];
    [self.chipTypeBtn setImage:[UIImage imageNamed:@"加减彩-人民币筹码ICON"] forState:UIControlStateHighlighted];
    [self.chipTypeBtn setTitle:@"RMB" forState:UIControlStateNormal];
    [self.chipTypeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.chipTypeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.bottomView addSubview:self.chipTypeBtn];
    [self.chipTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bottomView).offset(0);
        make.right.equalTo(self.bottomView).offset(-10);
    }];
    
    return self;
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
