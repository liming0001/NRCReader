//
//  CustomerInfoFooter.h
//  NFCReader
//
//  Created by 李黎明 on 2020/7/28.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^customerBtnActionBlock)(NSInteger tag);
typedef void(^refrashHeadBlock)(BOOL refrash);
@interface CustomerInfoFooter : UIView
@property (nonatomic, strong) customerBtnActionBlock customerBtnBlock;
@property (nonatomic, strong) refrashHeadBlock refrashBlock;
- (void)_setUpCustomerInfoWithType:(int)type;
#pragma mark -- 清除代理信息
- (void)clearCustomerInfo;
- (void)showBottomInfoWithXMH:(NSString *)xmh;

@end

NS_ASSUME_NONNULL_END
