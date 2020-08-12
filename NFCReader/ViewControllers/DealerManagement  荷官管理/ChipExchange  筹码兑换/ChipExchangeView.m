//
//  ChipExchangeView.m
//  NFCReader
//
//  Created by 李黎明 on 2020/7/27.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "ChipExchangeView.h"

@implementation ChipExchangeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self _setUpBaseView];
    return self;
}

- (void)_setUpBaseView{
    NSArray *exchangeList = @[@"现金兑换筹码",@"筹码兑换现金",@"信用出码"];
    for (int i=0; i<exchangeList.count; i++) {
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemBtn setTitle:exchangeList[i] forState:UIControlStateNormal];
        itemBtn.layer.cornerRadius = 5;
        if (i==0) {
            itemBtn.backgroundColor = [UIColor colorWithHexString:@"#347622"];
        }else if (i==1){
            itemBtn.backgroundColor = [UIColor colorWithHexString:@"#3e54af"];
        }else{
            itemBtn.backgroundColor = [UIColor colorWithHexString:@"#ef8b4a"];
        }
        [itemBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        itemBtn.tag = 1000+i;
        itemBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [itemBtn addTarget:self action:@selector(chipExchangeCashAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemBtn];
        [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(140+i*120);
            make.left.equalTo(self).offset(100);
            make.height.mas_equalTo(80);
            make.centerX.equalTo(self);
        }];
    }
}

- (void)chipExchangeCashAction:(UIButton *)btn{
    if (self.exchangeBtnBlock) {
        self.exchangeBtnBlock(btn.tag-1000);
    }
}

@end
