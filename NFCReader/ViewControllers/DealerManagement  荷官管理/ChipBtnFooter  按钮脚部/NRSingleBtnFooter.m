//
//  NRSingleBtnFooter.m
//  NFCReader
//
//  Created by 李黎明 on 2020/9/20.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "NRSingleBtnFooter.h"

@interface NRSingleBtnFooter ()

@property (nonatomic, strong) UIButton *continueAddBtn;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, assign) int bottomType;

@end

@implementation NRSingleBtnFooter

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self _setUpBaseView];
    return self;
}

- (void)_setUpBaseView{
    CGFloat cell_width = (kScreenWidth-200-20)/2;
    self.continueAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.continueAddBtn setTitle:@"继续加码" forState:UIControlStateNormal];
    self.continueAddBtn.layer.cornerRadius = 5;
    self.continueAddBtn.backgroundColor = [UIColor colorWithHexString:@"#347622"];
    [self.continueAddBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.continueAddBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    self.continueAddBtn.tag  =1;
    [self.continueAddBtn addTarget:self action:@selector(footerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.continueAddBtn];
    [self.continueAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.width.mas_equalTo(cell_width);
        make.left.equalTo(self).offset(100);
        make.centerY.equalTo(self);
    }];
    
    self.doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.doneBtn setTitle:@"完成加码" forState:UIControlStateNormal];
    self.doneBtn.layer.cornerRadius = 5;
    self.doneBtn.backgroundColor = [UIColor colorWithHexString:@"#347622"];
    [self.doneBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.doneBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    self.doneBtn.tag  =2;
    [self.doneBtn addTarget:self action:@selector(footerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.doneBtn];
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.width.mas_equalTo(cell_width);
        make.left.equalTo(self.continueAddBtn.mas_right).offset(20);
        make.centerY.equalTo(self);
    }];
    
}

- (void)footerBtnAction:(UIButton *)btn{
    if (self.btnActionBlock) {
        self.btnActionBlock((int)btn.tag);
    }
}

@end
