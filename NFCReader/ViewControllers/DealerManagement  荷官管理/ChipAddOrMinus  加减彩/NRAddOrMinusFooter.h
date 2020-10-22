//
//  NRAddOrMinusFooter.h
//  NFCReader
//
//  Created by 李黎明 on 2020/9/6.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^FooterAddBtnActionBlock)(NSInteger tag);
@interface NRAddOrMinusFooter : UIView

@property (nonatomic, strong) FooterAddBtnActionBlock footerBtnBlock;
- (void)_setUpFooterBtnWithType:(int)type;

@end

NS_ASSUME_NONNULL_END
