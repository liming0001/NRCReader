//
//  ChipNormalReadView.h
//  NFCReader
//
//  Created by 李黎明 on 2020/7/27.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ChipReadBtnActionBlock)(NSInteger tag);
@interface ChipNormalReadView : UIView
@property (nonatomic, strong) ChipReadBtnActionBlock chipReadBtnBlock;

#pragma mark -- 筹码检测
- (void)_setUpChipViewWithTag:(NSInteger)tag;

@end

NS_ASSUME_NONNULL_END
