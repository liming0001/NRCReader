//
//  TopBarView.m
//  NFCReader
//
//  Created by 李黎明 on 2020/6/9.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "TopBarView.h"

@interface TopBarView ()

//顶部选项卡
@property (nonatomic, strong) UIImageView *topBarImageV;
@property (nonatomic, strong) NSMutableArray *topBarList;
@property (nonatomic, strong) UIImageView *optionArrowImg;
@property (nonatomic, strong) UIButton *coverBtn;
@property (nonatomic, strong) NSString *resultNameString;

//更多选项
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) NSMutableArray *menuList;

@property (nonatomic, strong) NSArray *title_list;

@end

@implementation TopBarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.menuList = [NSMutableArray array];
    self.topBarList = [NSMutableArray array];
    [self topBarSetUp];
    return self;
}

#pragma mark - 设置顶部top
- (void)topBarSetUp{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.coverBtn];
    [[UIApplication sharedApplication].keyWindow addSubview:self.menuView];
    
    self.topBarImageV = [UIImageView new];
    self.topBarImageV.image = [UIImage imageNamed:@"bar_bg"];
    [self addSubview:self.topBarImageV];
    [self.topBarImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(self.frame.size.height);
    }];
    
    CGFloat button_w = (kScreenWidth -20)/5;
    UIButton *moreOptionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreOptionBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    moreOptionBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [moreOptionBtn setTitle:@"更多选项\nMoreOptions" forState:UIControlStateNormal];
    moreOptionBtn.tag = 1000;
    moreOptionBtn.titleLabel.numberOfLines = 2;
    moreOptionBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [moreOptionBtn setBackgroundImage:[UIImage imageNamed:@"topMenu_selBtn"] forState:UIControlStateSelected];
    [moreOptionBtn setTitleColor:[UIColor colorWithHexString:@"#274560"] forState:UIControlStateSelected];
    [moreOptionBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [self addSubview:moreOptionBtn];
    [moreOptionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(10);
        make.height.mas_equalTo(55);
        make.width.mas_offset(button_w);
    }];
    [moreOptionBtn addTarget:self action:@selector(moreOptionAction:) forControlEvents:UIControlEventTouchUpInside];
    self.optionArrowImg = [UIImageView new];
    self.optionArrowImg.image = [UIImage imageNamed:@"moreOptionsArrow"];
    [moreOptionBtn addSubview:self.optionArrowImg];
    [self.optionArrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(moreOptionBtn).offset(0);
        make.right.equalTo(moreOptionBtn.mas_right).offset(-10);
        make.height.mas_equalTo(11);
        make.width.mas_equalTo(15);
    }];
    
    self.title_list = @[[NSString stringWithFormat:@"新靴\n%@",[EPStr getStr:kEPChangeXueci note:@"新靴"]],[NSString stringWithFormat:@"修改露珠\n%@",@"Update Results"],[NSString stringWithFormat:@"现金版\nCash model"],[NSString stringWithFormat:@"新一局\n%@",[EPStr getStr:kEPNewGame note:@"新一局"]]];
    for (int i=0; i<self.title_list.count; i++) {
        UIButton *barBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [barBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        barBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [barBtn setTitle:self.title_list[i] forState:UIControlStateNormal];
        barBtn.tag = 1001+i;
        barBtn.titleLabel.numberOfLines = 2;
        barBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [barBtn setBackgroundImage:[UIImage imageNamed:@"topMenu_selBtn"] forState:UIControlStateSelected];
        [barBtn setTitleColor:[UIColor colorWithHexString:@"#274560"] forState:UIControlStateSelected];
        [barBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        [barBtn addTarget:self action:@selector(topBarAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:barBtn];
        [barBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(0);
            make.left.equalTo(self).offset(10+(i+1)*button_w);
            make.height.mas_equalTo(55);
            make.width.mas_offset(button_w);
        }];
        [self.topBarList addObject:barBtn];
    }
}

- (UIView *)menuView{
    if (!_menuView) {
        CGFloat button_w = (kScreenWidth -20)/5;
        _menuView = [[UIView alloc]initWithFrame:CGRectMake(10, 75, button_w-10, 0)];
        _menuView.backgroundColor = [UIColor colorWithRed:102/255.0 green:111/255.0 blue:121/255.0 alpha:0.9];
        
        NSArray *title_list = @[@"日结",@"切换柬文界面",@"换班",@"换桌",@"查看注单",@"查看台面数据",@"点码",@"台面加减彩",@"开台和收台",@"修改洗码号"];
        for (int i=0; i<title_list.count; i++) {
            UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [menuBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
            menuBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [menuBtn setTitle:title_list[i] forState:UIControlStateNormal];
            menuBtn.tag = 100+i;
            [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu_selBtn"] forState:UIControlStateHighlighted];
            [menuBtn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
            [_menuView addSubview:menuBtn];
            [menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.menuView).offset(5+i*30);
                make.left.equalTo(self.menuView).offset(5);
                make.centerX.equalTo(self.menuView);
                make.height.mas_equalTo(30);
            }];
            [self.menuList addObject:menuBtn];
            
            UIView *lineV1 = [UIView new];
            lineV1.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.1];
            lineV1.alpha = 0.8;
            [menuBtn addSubview:lineV1];
            [lineV1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(menuBtn).offset(0);
                make.left.equalTo(menuBtn).offset(5);
                make.centerX.equalTo(menuBtn);
                make.height.mas_equalTo(0.5);
            }];
        }
        [self hideOrShowMenuButton:YES];
    }
    return _menuView;
}

- (UIButton *)coverBtn{
    if (!_coverBtn) {
        _coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _coverBtn.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _coverBtn.hidden = YES;
        [_coverBtn addTarget:self action:@selector(coverAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverBtn;
}

#pragma mark --顶部按钮触发事件
- (void)topBarAction:(UIButton *)btn{
    if (btn.tag == 1003) {
        if (![PublicHttpTool shareInstance].isAutoOrManual) {
            [btn setTitle:[NSString stringWithFormat:@"自动版\nChip model"] forState:UIControlStateNormal];
            if (self.barBtnBlock) {
                self.barBtnBlock(btn.tag-1001, 0,YES);
            }
        }else{
            [btn setTitle:[NSString stringWithFormat:@"现金版\nCash model"] forState:UIControlStateNormal];
            if (self.barBtnBlock) {
                self.barBtnBlock(btn.tag-1001, 0,NO);
            }
        }
        [PublicHttpTool shareInstance].isAutoOrManual = ![PublicHttpTool shareInstance].isAutoOrManual;
    }
    for (int j=0; j<self.topBarList.count; j++) {
        if (btn.tag == 1001+j) {
            btn.selected = YES;
            if (j!=2) {
                if (self.barBtnBlock) {
                    self.barBtnBlock(btn.tag-1001, 0,YES);
                }
            }
            continue;
        }
        UIButton *but = (UIButton *)[self viewWithTag:1001+j];
        but.selected = NO;
    }
}

#pragma mark -顶部top事件
- (void)moreOptionAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.optionArrowImg.image = [UIImage imageNamed:@"moreOptionsArrow_p"];
        [UIView animateWithDuration:0.2 animations:^{
            [self hideOrShowMenuButton:NO];
            self.coverBtn.hidden = NO;
            self.menuView.height = 310;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        self.optionArrowImg.image = [UIImage imageNamed:@"moreOptionsArrow"];
        [UIView animateWithDuration:0.2 animations:^{
            self.coverBtn.hidden = YES;
            self.menuView.height = 0;
        } completion:^(BOOL finished) {
            [self hideOrShowMenuButton:YES];
        }];
    }
    for (UIButton *but in self.topBarList) {
        [but setSelected:NO];
    }
}

#pragma mark - 左侧弹出视图事件
- (void)menuAction:(UIButton *)btn{
    [self coverAction];
    BOOL hasChange = NO;
    if (btn.tag == 101) {
        if ([EPStr sharedInstance].language.languageType==kEPLanguageTypeEn) {
            [btn setTitle:@"切换英文界面" forState:UIControlStateNormal];
        }else{
            hasChange = YES;
            [btn setTitle:@"切换柬文界面" forState:UIControlStateNormal];
        }
        [self refrashTopBarBtnTitle];
    }
    if (self.barBtnBlock) {
        self.barBtnBlock(btn.tag-100, 1,hasChange);
    }
}

#pragma mark --展示或者隐藏菜单
- (void)hideOrShowMenuButton:(BOOL)hide{
    for (UIButton *but in self.menuList) {
        but.hidden = hide;
    }
}

#pragma mark --遮罩
- (void)coverAction{
    self.optionArrowImg.image = [UIImage imageNamed:@"moreOptionsArrow"];
    UIButton *moreBut = (UIButton *)[self viewWithTag:1000];
    moreBut.selected = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.coverBtn.hidden = YES;
        self.menuView.height = 0;
    } completion:^(BOOL finished) {
        [self hideOrShowMenuButton:YES];
    }];
}

- (void)refrashTopBarBtnTitle{
    for (int i=0; i<self.title_list.count; i++) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIButton *btn = self.topBarList[i];
            [btn setTitle:self.title_list[i] forState:UIControlStateNormal];
        });
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
