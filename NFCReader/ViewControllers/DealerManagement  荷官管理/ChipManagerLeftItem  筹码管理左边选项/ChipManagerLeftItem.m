//
//  ChipManagerLeftItem.m
//  NFCReader
//
//  Created by 李黎明 on 2020/7/27.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "ChipManagerLeftItem.h"

@interface ChipManagerLeftItem ()
//筹码管理
@property (nonatomic, strong) UIButton *chipManagerButton;
@property (nonatomic, strong) UIView *chipManagerlineView;
@property (nonatomic, strong) NSMutableArray *btnList;

@end

@implementation ChipManagerLeftItem

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.btnList = [NSMutableArray array];
    [self _setUpBaseView];
    return self;
}

- (void)_setUpBaseView{
    self.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    self.chipManagerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chipManagerButton setTitle:@"筹码管理" forState:UIControlStateNormal];
    [self.chipManagerButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.chipManagerButton.titleLabel.font = [UIFont systemFontOfSize:26];
    [self addSubview:self.chipManagerButton];
    [self.chipManagerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.height.mas_equalTo(90);
        make.right.equalTo(self);
    }];
    
    self.chipManagerlineView = [UIView new];
    self.chipManagerlineView.backgroundColor = [UIColor colorWithHexString:@"#959595"];
    [self addSubview:self.chipManagerlineView];
    [self.chipManagerlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipManagerButton.mas_bottom).offset(0);
        make.left.equalTo(self);
        make.centerX.equalTo(self);
        make.height.mas_offset(1);
    }];
    
    NSArray *leftTitleItems = @[@"  筹码发行",@"  筹码检测",@"  筹码销毁",@"  筹码兑换",@"  小费结算",@"  存入筹码",@"  取出筹码",@"  一键清除"];
    NSArray *leftImgItems = @[@"chipIssue_icon",@"chipCheck_icon",@"chip_descruct_icon",@"chipExchange_icon",@"chipExchange_icon",@"chipExchange_icon",@"chipExchange_icon",@"chipExchange_icon",@"chipExchange_icon"];
    if ([PublicHttpTool shareInstance].isBigPermissions) {//大账房
        leftTitleItems = @[@"  开台申请",@"  柜台加彩",@"  柜台减彩",@"  台桌加彩",@"  台桌减彩"];
        leftImgItems = @[@"chipExchange_icon",@"chipExchange_icon",@"chipExchange_icon",@"chipExchange_icon",@"chipExchange_icon"];
    }
    
    for (int i=0; i<leftTitleItems.count; i++) {
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemBtn setTitle:leftTitleItems[i] forState:UIControlStateNormal];
        itemBtn.tag = 100+i;
        [itemBtn setImage:[UIImage imageNamed:leftImgItems[i]] forState:UIControlStateNormal];
        [itemBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        [itemBtn setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
        itemBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [itemBtn addTarget:self action:@selector(itemBtnsAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemBtn];
        [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.chipManagerlineView.mas_bottom).offset(i*90);
            make.left.equalTo(self);
            make.height.mas_equalTo(80);
            make.right.equalTo(self);
        }];
        if (i==0) {
            itemBtn.selected = YES;
            [itemBtn setBackgroundColor:[UIColor colorWithHexString:@"#b0241b"]];
        }
        [self.btnList addObject:itemBtn];
    }
}

- (void)itemBtnsAction:(UIButton *)btn{
    for (int j=0; j<self.btnList.count; j++) {
        if (btn.tag == 100+j) {
            [btn setBackgroundColor:[UIColor colorWithHexString:@"#b0241b"]];
            if (self.bottomBtnBlock) {
                self.bottomBtnBlock(btn.tag-100);
            }
            continue;
        }
        UIButton *but = (UIButton *)[self viewWithTag:100+j];
        [but setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    }
}

@end
