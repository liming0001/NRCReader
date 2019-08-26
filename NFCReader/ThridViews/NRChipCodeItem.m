//
//  NRChipCodeItem.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/19.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRChipCodeItem.h"

@implementation NRChipCodeItem

- (instancetype)initWithTitle:(NSString *)title_s {
    self = [super init];
    self.selectSubject = [RACSubject subject];
    self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    
    self.checkIcon = [UIImageView new];
    self.checkIcon.image = [UIImage imageNamed:@"list_icon_unselect"];
    [self addSubview:self.checkIcon];
    [self.checkIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
    }];
    
    self.infoLabel = [UILabel new];
    self.infoLabel.font = [UIFont fontWithName:@"Avenir LT Std" size:16];
    self.infoLabel.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
    self.infoLabel.text = title_s;
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(5);
        make.centerX.equalTo(self).offset(10);
    }];
    
    self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkButton addTarget:self action:@selector(checkButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.checkButton];
    [self.checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    return self;
}

- (void)checkButtonAction:(UIButton *)btn{
//    if (self.isCheck) {
//        return;
//    }
    self.isCheck = YES;
    [self.selectSubject sendNext:nil];
    self.checkIcon.image = [UIImage imageNamed:@"list_icon_select"];
}

- (void)checkSelectUn{
    self.isCheck = NO;
    self.checkIcon.image = [UIImage imageNamed:@"list_icon_unselect"];
}

- (void)checkSelected{
    self.isCheck = YES;
    self.checkIcon.image = [UIImage imageNamed:@"list_icon_select"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
