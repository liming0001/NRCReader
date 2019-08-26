//
//  EPTitleBar.h
//  Ellipal
//
//  Created by cyl on 2018/7/4.
//  Copyright © 2018年 afuiot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EPTitleBarItem;

@interface EPTitleBar : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle; // just for 行情详情, 默认nil, 非nil时与title同时显示
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, strong) EPTitleBarItem *leftItem;
@property (nonatomic, strong) EPTitleBarItem *rightItem;
@property (nonatomic, strong) UIColor *tbTintColor;
@property (nonatomic, assign) BOOL showBottomLine;
@property (nonatomic, assign) BOOL isContainStatuBar;

- (void)setTitle:(NSString *)title;

+ (CGFloat)heightForTitleBarPlusStatuBar;
+ (CGFloat)heightForStatuBar;

@end
