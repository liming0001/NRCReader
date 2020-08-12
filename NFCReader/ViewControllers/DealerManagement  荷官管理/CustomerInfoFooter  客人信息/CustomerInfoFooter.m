//
//  CustomerInfoFooter.m
//  NFCReader
//
//  Created by 李黎明 on 2020/7/28.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "CustomerInfoFooter.h"

@interface CustomerInfoFooter ()
//上级信息
@property (nonatomic, strong) UILabel *superiorInfoLab;
@property (nonatomic, strong) UILabel *superiorNameLab;
@property (nonatomic, strong) UILabel *superiorWashNumberLab;
@property (nonatomic, strong) UILabel *superiorMoneyLab;
@property (nonatomic, strong) UILabel *superiorTellLab;
@property (nonatomic, strong) UILabel *codeLinesLab;//出码额度
//当前客人
@property (nonatomic, strong) UILabel *curCustomerInfoLab;
@property (nonatomic, strong) UILabel *curCustomerWashNumberLab;
@property (nonatomic, strong) UILabel *curCustomerNameLab;
@property (nonatomic, strong) UILabel *curCustomerTellLab;
@property (nonatomic, strong) UILabel *curCodeLinesLab;//客人出码额度

@property (nonatomic, strong) NSMutableArray *cashExchangeList;
@property (nonatomic, strong) UITextField *cashCodeTextField;
@property (nonatomic, strong) UITextField *authorizationTextField;//授权
@property (nonatomic, strong) UITextField *noteTextField;//备注
@property (nonatomic, strong) UIButton *cashExchangeConfirmButton;

@property (nonatomic, assign) NSInteger curTag;

@end

@implementation CustomerInfoFooter

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self _setUpBaseView];
    return self;
}

- (void)_setUpBaseView{
    self.backgroundColor = [UIColor clearColor];
    CGFloat label_width = 200;
    CGFloat label_x = 20;
    CGFloat label_topSpace = 20;
    self.superiorInfoLab = [[UILabel alloc]initWithFrame:CGRectMake(label_x, 30, label_width, 25)];
    self.superiorInfoLab.font = [UIFont fontWithName:@"PingFang SC" size:28];
    self.superiorInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.superiorInfoLab.numberOfLines = 0;
    self.superiorInfoLab.text = @"上级信息";
    [self addSubview:self.superiorInfoLab];
    
    self.superiorNameLab = [[UILabel alloc]initWithFrame:CGRectMake(label_x, CGRectGetMaxY(self.superiorInfoLab.frame)+label_topSpace, label_width, 20)];
    self.superiorNameLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.superiorNameLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.superiorNameLab.numberOfLines = 0;
    self.superiorNameLab.text = @"代理姓名: --";
    [self addSubview:self.superiorNameLab];
    
    self.superiorWashNumberLab = [[UILabel alloc]initWithFrame:CGRectMake(label_x, CGRectGetMaxY(self.superiorNameLab.frame)+label_topSpace, label_width, 20)];
    self.superiorWashNumberLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.superiorWashNumberLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.superiorWashNumberLab.numberOfLines = 0;
    self.superiorWashNumberLab.text = @"洗 码 号: --";
    [self addSubview:self.superiorWashNumberLab];
    
    self.superiorMoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(label_x, CGRectGetMaxY(self.superiorWashNumberLab.frame)+label_topSpace, label_width, 20)];
    self.superiorMoneyLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.superiorMoneyLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.superiorMoneyLab.numberOfLines = 0;
    self.superiorMoneyLab.text = @"风 险 金: --";
    [self addSubview:self.superiorMoneyLab];
    
    self.superiorTellLab = [[UILabel alloc]initWithFrame:CGRectMake(label_x, CGRectGetMaxY(self.superiorMoneyLab.frame)+label_topSpace, label_width, 20)];
    self.superiorTellLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.superiorTellLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.superiorTellLab.numberOfLines = 0;
    self.superiorTellLab.text = @"联系电话: --";
    [self addSubview:self.superiorTellLab];
    
    self.codeLinesLab = [[UILabel alloc]initWithFrame:CGRectMake(label_x, CGRectGetMaxY(self.superiorTellLab.frame)+label_topSpace, label_width, 20)];
    self.codeLinesLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.codeLinesLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.codeLinesLab.numberOfLines = 0;
    self.codeLinesLab.text = @"出码额度: --";
    [self addSubview:self.codeLinesLab];
    
    self.curCustomerInfoLab = [[UILabel alloc]initWithFrame:CGRectMake(label_x, CGRectGetMaxY(self.codeLinesLab.frame)+30, label_width, 20)];
    self.curCustomerInfoLab.font = [UIFont fontWithName:@"PingFang SC" size:28];
    self.curCustomerInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.curCustomerInfoLab.numberOfLines = 0;
    self.curCustomerInfoLab.text = @"当前客人";
    [self addSubview:self.curCustomerInfoLab];
    
    self.curCustomerWashNumberLab = [[UILabel alloc]initWithFrame:CGRectMake(label_x, CGRectGetMaxY(self.curCustomerInfoLab.frame)+label_topSpace, label_width, 20)];
    self.curCustomerWashNumberLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.curCustomerWashNumberLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.curCustomerWashNumberLab.numberOfLines = 0;
    self.curCustomerWashNumberLab.text = @"洗 码 号: --";
    [self addSubview:self.curCustomerWashNumberLab];
    
    self.curCustomerNameLab = [[UILabel alloc]initWithFrame:CGRectMake(label_x, CGRectGetMaxY(self.curCustomerWashNumberLab.frame)+label_topSpace, label_width, 20)];
    self.curCustomerNameLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.curCustomerNameLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.curCustomerNameLab.numberOfLines = 0;
    self.curCustomerNameLab.text = @"客人姓名: --";
    [self addSubview:self.curCustomerNameLab];
    
    self.curCustomerTellLab = [[UILabel alloc]initWithFrame:CGRectMake(label_x, CGRectGetMaxY(self.curCustomerNameLab.frame)+label_topSpace, label_width, 20)];
    self.curCustomerTellLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.curCustomerTellLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.curCustomerTellLab.numberOfLines = 0;
    self.curCustomerTellLab.text = @"联系电话: --";
    [self addSubview:self.curCustomerTellLab];
    
    self.curCodeLinesLab = [[UILabel alloc]initWithFrame:CGRectMake(label_x, CGRectGetMaxY(self.curCustomerTellLab.frame)+label_topSpace, label_width, 20)];
    self.curCodeLinesLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.curCodeLinesLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.curCodeLinesLab.numberOfLines = 0;
    self.curCodeLinesLab.text = @"出码额度: --";
    [self addSubview:self.curCodeLinesLab];
    
    CGFloat textFld_w = self.frame.size.width-200-40;
    self.cashCodeTextField = [[UITextField alloc]initWithFrame:CGRectMake(textFld_w, CGRectGetMaxY(self.superiorInfoLab.frame)+label_topSpace, 200, 40)];
    self.cashCodeTextField.placeholder = @"请输入客人洗码号";
    self.cashCodeTextField.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.cashCodeTextField.layer.cornerRadius = 5;
    self.cashCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.cashCodeTextField.leftView = leftview;
    self.cashCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    [self addSubview:self.cashCodeTextField];
    
    self.authorizationTextField = [[UITextField alloc]initWithFrame:CGRectMake(textFld_w, CGRectGetMaxY(self.cashCodeTextField.frame)+20, 200, 40)];
    self.authorizationTextField.placeholder = @"请输入授权人姓名";
    self.authorizationTextField.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.authorizationTextField.layer.cornerRadius = 5;
    UIView *artoleftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.authorizationTextField.leftView = artoleftview;
    self.authorizationTextField.leftViewMode = UITextFieldViewModeAlways;
    [self addSubview:self.authorizationTextField];
    
    self.noteTextField = [[UITextField alloc]initWithFrame:CGRectMake(textFld_w, CGRectGetMaxY(self.authorizationTextField.frame)+20, 200, 60)];
    self.noteTextField.placeholder = @"请输入备注";
    self.noteTextField.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.noteTextField.layer.cornerRadius = 5;
    UIView *noteleftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.noteTextField.leftView = noteleftview;
    self.noteTextField.leftViewMode = UITextFieldViewModeAlways;
    [self addSubview:self.noteTextField];
    
    self.cashExchangeConfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cashExchangeConfirmButton setTitle:@"确认现金换筹码" forState:UIControlStateNormal];
    self.cashExchangeConfirmButton.frame = CGRectMake(150, CGRectGetMaxY(self.curCodeLinesLab.frame)+100, kScreenWidth-200-300, 40);
    self.cashExchangeConfirmButton.layer.cornerRadius = 5;
    self.cashExchangeConfirmButton.backgroundColor = [UIColor colorWithHexString:@"#347622"];
    [self.cashExchangeConfirmButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.cashExchangeConfirmButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.cashExchangeConfirmButton addTarget:self action:@selector(customerConfirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cashExchangeConfirmButton];
    
    //筹码兑换界面
    @weakify(self);
    [[self.cashCodeTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if ([[x NullToBlankString] length]!=0) {
            [PublicHttpTool getInfoByXmh:x WithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
                @strongify(self);
                if (success) {
                    NSDictionary *dict = (NSDictionary *)data;
                    if ([dict count]!=0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [PublicHttpTool shareInstance].exchangeWashNumber = dict[@"member_xmh"];
                            if (self.curTag==3) {
                                self.superiorNameLab.text = [NSString stringWithFormat:@"代理姓名: %@",dict[@"agent_name"]];
                                self.superiorWashNumberLab.text = [NSString stringWithFormat:@"洗 码 号: %@",dict[@"agent_xmh"]];
                                self.superiorMoneyLab.text = [NSString stringWithFormat:@"风 险 金: %@",dict[@"risk_money"]];
                                self.superiorTellLab.text = [NSString stringWithFormat:@"联系电话: %@",dict[@"agent_phone"]];
                                self.codeLinesLab.text = [NSString stringWithFormat:@"出码额度: %@",dict[@"agent_cm"]];
                                self.curCustomerNameLab.text = [NSString stringWithFormat:@"客人姓名: %@",dict[@"member_name"]];
                                self.curCustomerWashNumberLab.text = [NSString stringWithFormat:@"洗 码 号: %@",dict[@"member_xmh"]];
                                self.curCustomerTellLab.text = [NSString stringWithFormat:@"联系电话: %@",dict[@"member_phone"]];
                                self.curCodeLinesLab.text = [NSString stringWithFormat:@"出码额度: %@",dict[@"member_cm"]];
                            }
                        });
                    }else{
                        [PublicHttpTool shareInstance].exchangeWashNumber = @"";
                        [self clearCustomerInfo];
                    }
                }
            }];
        }
    }];
    [[self.authorizationTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        if ([[x NullToBlankString] length]!=0) {
            if (self.curTag==3) {
                [PublicHttpTool shareInstance].authorName = x;
            }else{
                [PublicHttpTool shareInstance].takeOutPsd = x;
            }
        }
    }];
    [[self.noteTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        if ([[x NullToBlankString] length]!=0) {
            [PublicHttpTool shareInstance].notes = x;
        }
    }];
}

- (void)_setUpCustomerInfoWithType:(int)type{
    self.curTag = type;
    if (type==3) {
        self.codeLinesLab.hidden = NO;
        self.curCodeLinesLab.hidden = NO;
        self.noteTextField.hidden = NO;
        self.authorizationTextField.placeholder = @"请输入授权人姓名";
        [self.cashExchangeConfirmButton setTitle:@"确认现金换筹码" forState:UIControlStateNormal];
    }else{
        self.codeLinesLab.hidden = YES;
        self.curCodeLinesLab.hidden = YES;
        self.noteTextField.hidden = YES;
        self.authorizationTextField.placeholder = @"请输入客人密码";
        [self.cashExchangeConfirmButton setTitle:@"确认取出" forState:UIControlStateNormal];
    }
}

- (void)customerConfirmAction{
    if (self.customerBtnBlock) {
        self.customerBtnBlock(self.curTag);
    }
}
#pragma mark -- 清除代理信息
- (void)clearCustomerInfo{
    self.superiorNameLab.text = @"代理姓名: --";
    self.superiorWashNumberLab.text = @"洗 码 号: --";
    self.superiorMoneyLab.text = @"风 险 金: --";
    self.superiorTellLab.text = [NSString stringWithFormat:@"联系电话: %@",@"--"];
    
    self.curCustomerNameLab.text = [NSString stringWithFormat:@"客人姓名: %@",@"--"];
    self.curCustomerWashNumberLab.text = [NSString stringWithFormat:@"洗 码 号: %@",@"--"];
    self.curCustomerTellLab.text = [NSString stringWithFormat:@"联系电话: %@",@"--"];
}

@end
