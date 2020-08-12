//
//  ChipBtnFooter.h
//  NFCReader
//
//  Created by 李黎明 on 2020/7/28.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^FooterBtnActionBlock)(NSInteger tag);
@interface ChipBtnFooter : UIView

@property (nonatomic, strong) FooterBtnActionBlock footerBtnBlock;
- (void)_setUpFooterBtnWithType:(int)type;

@end

NS_ASSUME_NONNULL_END
