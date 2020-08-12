//
//  ChipManagerLeftItem.h
//  NFCReader
//
//  Created by 李黎明 on 2020/7/27.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^BottomButtonActionBlock)(NSInteger tag);

@interface ChipManagerLeftItem : UIView

@property (nonatomic, strong) BottomButtonActionBlock bottomBtnBlock;

@end

NS_ASSUME_NONNULL_END
