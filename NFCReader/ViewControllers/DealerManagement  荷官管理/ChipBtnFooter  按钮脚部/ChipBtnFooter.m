//
//  ChipBtnFooter.m
//  NFCReader
//
//  Created by 李黎明 on 2020/7/28.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "ChipBtnFooter.h"

@interface ChipBtnFooter ()

@property (nonatomic, strong) UIButton *footBtn;
@property (nonatomic, assign) int bottomType;

@end

@implementation ChipBtnFooter

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self _setUpBaseView];
    return self;
}

- (void)_setUpBaseView{
    self.footBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.footBtn setTitle:@"立即结算" forState:UIControlStateNormal];
    self.footBtn.frame = CGRectMake(150, 60, kScreenWidth-200-300, 40);
    self.footBtn.layer.cornerRadius = 5;
    self.footBtn.backgroundColor = [UIColor colorWithHexString:@"#347622"];
    [self.footBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.footBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.footBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.footBtn];
}

- (void)_setUpFooterBtnWithType:(int)type{
    self.bottomType = type;
    if (type==2) {
        [self.footBtn setTitle:@"全部销毁" forState:UIControlStateNormal];
    }else if (type==4){
        [self.footBtn setTitle:@"立即结算" forState:UIControlStateNormal];
    }else if (type==7){
        [self.footBtn setTitle:@"一键清除" forState:UIControlStateNormal];
    }else{
        [self.footBtn setTitle:@"立即存入" forState:UIControlStateNormal];
    }
}

- (void)footerBtnAction{
    if (self.footerBtnBlock) {
        self.footerBtnBlock(self.bottomType);
    }
}

@end
