//
//  NRAddOrMinusFooter.m
//  NFCReader
//
//  Created by 李黎明 on 2020/9/6.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "NRAddOrMinusFooter.h"

@interface NRAddOrMinusFooter ()

@property (nonatomic, strong) UIButton *footAddBtn;
@property (nonatomic, strong) UIButton *footDoneBtn;

@end

@implementation NRAddOrMinusFooter

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self _setUpBaseView];
    return self;
}

- (void)_setUpBaseView{
    CGFloat btn_w = (kScreenWidth-200-200-20)/2;
    self.footAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.footAddBtn setTitle:@"继续加码" forState:UIControlStateNormal];
    self.footAddBtn.frame = CGRectMake(100, 60, btn_w, 40);
    self.footAddBtn.layer.cornerRadius = 5;
    self.footAddBtn.backgroundColor = [UIColor colorWithHexString:@"#347622"];
    [self.footAddBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.footAddBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    self.footAddBtn.tag = 1;
    [self.footAddBtn addTarget:self action:@selector(footerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.footAddBtn];
    
    self.footDoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.footDoneBtn setTitle:@"完成加彩" forState:UIControlStateNormal];
    self.footDoneBtn.frame = CGRectMake(CGRectGetMaxX(self.footAddBtn.frame)+20, 60, btn_w, 40);
    self.footDoneBtn.layer.cornerRadius = 5;
    self.footDoneBtn.tag = 2;
    self.footDoneBtn.backgroundColor = [UIColor colorWithHexString:@"#347622"];
    [self.footDoneBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.footDoneBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.footDoneBtn addTarget:self action:@selector(footerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.footDoneBtn];
}

- (void)_setUpFooterBtnWithType:(int)type{
    if (type==8||type==10) {
        [self.footDoneBtn setTitle:@"完成加彩" forState:UIControlStateNormal];
    }else {
        if (type==7) {
            [self.footDoneBtn setTitle:@"完成开台" forState:UIControlStateNormal];
        }else{
            [self.footDoneBtn setTitle:@"完成减彩" forState:UIControlStateNormal];
        }
    }
}

- (void)footerBtnAction:(UIButton *)btn{
    if (self.footerBtnBlock) {
        self.footerBtnBlock(btn.tag);
    }
}

@end
