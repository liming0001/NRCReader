//
//  EPPopAlertShowView.h
//  TestPopView
//
//  Created by smarter on 2018/8/6.
//  Copyright © 2018年 Ellipal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EPHeadInfo;
@interface EPHeadInfoShowView : UIView

@property (nonatomic, strong) UILabel *guestNumberLab;//客人洗码号
@property (nonatomic, strong) UILabel *chumaMoneyLab;//今日出码
@property (nonatomic, strong) UILabel *ximaMoneyLab;//今日洗码
@property (nonatomic, strong) UILabel *shuyingMoneyLab;//今日输赢
@property (nonatomic, strong) UILabel *tableValueLab;//本桌输赢

+ (EPHeadInfoShowView *)showInWindowWithEPHeadInfo:(EPHeadInfo *)headInfo;

- (void)_hide;

@end
