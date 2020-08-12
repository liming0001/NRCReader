//
//  DewInfoView.m
//  NFCReader
//
//  Created by 李黎明 on 2020/6/9.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "DewInfoView.h"
#import "JhPageItemView.h"

@interface DewInfoView ()
//露珠信息
@property (nonatomic, strong) UIImageView *luzhuImgV;
@property (nonatomic, strong) UILabel *luzhuInfoLab;
@property (nonatomic, strong) UIView *luzhuCollectionView;
/** item数组 */
@property (nonatomic, strong) JhPageItemView *solidItemView;
@end

@implementation DewInfoView

-(JhPageItemView *)solidItemView{
    if (!_solidItemView) {
        CGRect femwe =  CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-30);
        JhPageItemView *view =  [[JhPageItemView alloc]initWithFrame:femwe];
        view.backgroundColor = [UIColor whiteColor];
        self.solidItemView = view;
    }
    return _solidItemView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self _setUpView];
    return self;
}

- (void)_setUpView{
    //露珠信息
    self.luzhuImgV = [UIImageView new];
    self.luzhuImgV.image = [UIImage imageNamed:@"customer_luzhu_flag"];
    [self addSubview:self.self.luzhuImgV];
    [self.luzhuImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.right.equalTo(self).offset(0);
        make.height.mas_equalTo(30);
    }];
    
    self.luzhuInfoLab = [UILabel new];
    self.luzhuInfoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.luzhuInfoLab.font = [UIFont systemFontOfSize:14];
    self.luzhuInfoLab.text = @"露珠信息Dew information";
    self.luzhuInfoLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.luzhuInfoLab];
    [self.luzhuInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.luzhuImgV.mas_top).offset(3);
        make.left.right.equalTo(self).offset(0);
        make.height.mas_equalTo(20);
    }];
    
    self.luzhuCollectionView = [UIView new];
    self.luzhuCollectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.luzhuCollectionView];
    [self.luzhuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.luzhuImgV.mas_bottom).offset(0);
        make.left.right.equalTo(self.luzhuImgV).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
    [self.luzhuCollectionView addSubview:self.solidItemView];
}

- (void)updateLuzhuInfoWithLuzhuList:(NSArray *)luzhuList{
    [self.solidItemView fellLuzhuListWithDataList:luzhuList];
}

@end
