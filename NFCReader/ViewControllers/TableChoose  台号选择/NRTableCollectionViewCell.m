//
//  NRTableCollectionViewCell.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRTableCollectionViewCell.h"

@interface NRTableCollectionViewCell ()

@end

@implementation NRTableCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#1c1c1c"];
    self.contentView.layer.cornerRadius = 2;
    self.contentView.layer.borderColor = [UIColor colorWithHexString:@"#f5f5f5"].CGColor;
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.masksToBounds = YES;
    
//    self.numberLabel = [UILabel new];
//    self.numberLabel.font = [UIFont fontWithName:@"Avenir LT Std" size:16];
//    self.numberLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
//    self.numberLabel.textAlignment = NSTextAlignmentCenter;
//    [self.contentView addSubview:self.numberLabel];
//    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(10);
//        make.left.equalTo(self.contentView).offset(5);
//        make.centerX.equalTo(self.contentView);
//    }];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont fontWithName:@"Avenir LT Std" size:16];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.numberLabel.mas_bottom).offset(5);
//        make.left.equalTo(self.contentView).offset(5);
        make.center.equalTo(self.contentView);
    }];
    
    return self;
}

- (void)configureWithNumberText:(NSString *)numberText
                      titleText:(NSString *)titleText {
    
    self.numberLabel.text = numberText;
    self.titleLabel.text = titleText;
    
}

@end
