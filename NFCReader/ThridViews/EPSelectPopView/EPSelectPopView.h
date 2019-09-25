//
//  EPSelectPopView.h
//  Ellipal
//
//  Created by smarter on 2018/8/13.
//  Copyright © 2018年 Ellipal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FuncBlock)(NSInteger index);

@interface EPSelectPopView : UIView
/**
 *  里面存储funcModel对象
 */
@property (nonatomic, strong) NSMutableArray *funcModels;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, copy) FuncBlock myFuncBlock;

// 功能字典数组
+ (instancetype)popViewWithFuncDicts:(NSArray *)funcDicts LeftOffset:(CGFloat)left RightOffset:(CGFloat)right TopOffset:(CGFloat)top CoverColor:(UIColor *)coverColor CellHeight:(CGFloat)rowHeight;
- (void)showInKeyWindow;
- (void)dismissFromKeyWindow;

@end
